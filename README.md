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

Has time complexity `O(n³·m²·c)`, where `n` is the length of the output, `m` is
number of inputs, and `c` is the shell overhead, equal to `max ℝ` (the greatest
finite real number).

Uses `rmloops` on each file on input before merging.


## rmloops

Removes repeated blocks from a list of strings. Can kill even a medium-sized mammoth.

Arguments: none

Input: list of strings on stdin, one string per line

Output: list of strings on stdout, one string per line

Example:
```sh
./rmloops.py
egg
bacon
sausage
spam
egg
bacon
sausage
spam
and
spam
spam
spam
egg
spam

# Output:
# egg
# bacon
# sausage
# spam
# and
# spam
# egg
# spam
```
