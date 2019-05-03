# posID

**p**iece **o**f **s**hit: **i**terated **d**iff

Merges list of files into one. Writes the merged file to stdout. Kills kittens.

Usage: don't use it.

Not usage:
```sh
# will print the output and the log to console
./posid.sh [FILE ...]

# will print the output to OUTPUT_FILE
# and the log to console
./posid.sh [FILE ...] > OUTPUT_FILE

# example
./posid.sh list1 list2 list3 > merged_lists
# Adding 'list1' to the merge...
# Adding 'list2' to the merge...
# Adding 'list3' to the merge...
# Success

# useless example
./posid.sh
# Success
```

Has time complexity `O(n²·m²·c)`, where `n` is the length of the output, `m` is
number of inputs, and `c` is the shell overhead, equal to `max ℝ` (the greatest
finite real number).
