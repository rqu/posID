#!/bin/bash -e

# temporary files

# -f can be safely passed to rm instead of file names, if something
# goes wrong too early.
tmp_acc="-f"
tmp_la="-f"
tmp_ra="-f"

cleanup() {
	rm -f "$tmp_acc" "$tmp_la" "$tmp_ra"
}

trap cleanup EXIT

tmp_acc="`mktemp`"
tmp_la="`mktemp`"
tmp_ra="`mktemp`"

# see below
force=false

# merge_two <FILE1> <FILE2>
# merges two files and writes them to output
merge_two() {
	diff --speed-large-files --minimal --old-line-format="%L"\
	--new-line-format="%L" --unchanged-line-format="%L" "$1" "$2" ||
		[[ $? == 1 ]]
	# diff returns 1 if files differ. this is fine. that is why
	# we are merging them. but code 2 means something went wrong.
	# cases:
	# - files are same, diff returns 0 ("success"):
	#   the or (||) short-circuits and succeeds
	# - files are different, diff returns 1 ("error"):
	#   [[ $? == 1 ]] is evaluated and succeeds
	# - files are inaccessible, diff returns 2 ("error"):
	#   [[ $? == 1 ]] is evaluated and fails
}

# merge_list [FILE...]
# merges all FILEs with the current accumulator.
# only prints the log. output is saved to accumulator.
merge_list() {
	count="$#"
	
	# loop over arguments. note that arguments added inside loop
	# using `set --` are not iterated over.
	for file
	do
		echo "Adding '$file' to the merge..."
		
		merge_two "$tmp_acc" "$file" > "$tmp_la"
		merge_two "$file" "$tmp_acc" > "$tmp_ra"
		
		# we want primarily unambiguous merges.
		# if the merge was ambiguous, skip it and try
		# it again after processing rest of the files.
		# sometimes, even this doesn't help.
		# then we set $force to true elsewhere and when we
		# are here again, we ignore ambiguities.
		
		# cmp returns 0 if same, 1 if different
		
		if $force || cmp --quiet "$tmp_la" "$tmp_ra"
		then
			# only one merge should be forcible.
			# set $force to false and if problems arise
			# again, $force will be set to true again.
			force=false
			# pick one of the results and put it to acc.
			cat "$tmp_la" > "$tmp_acc"
		else
			echo "Merge would be ambiguous, deferring"
			set -- "$@" "$file" # push argument
		fi
	done
	
	# remove all arguments that were present before the loop.
	# keep only those added during the loop using `set --`.
	shift $count
	
	echo
	
	case $# in
		($count)
			echo "# Some files are unmergeable:"
			printf "#  - %s\n" "$@"
			echo "# The first of them will be merged forcibly."
			echo
			force=true
			merge_list "$@"
			;;
		(0)
			echo "Success"
			echo
			;;
		(*)
			echo "# There are some deferred files:"
			printf "#  - %s\n" "$@"
			echo "# Will retry to merge them."
			echo
			merge_list "$@"
			;;
	esac
}

# pass all arguments to merge_list.
# accumulator is empty file, which is a neutral element.
# log is printed to stderr (>&2) and merge is in acc file
merge_list "$@" >&2

# print out the accumulator file
cat "$tmp_acc"
