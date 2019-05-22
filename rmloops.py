#!/usr/bin/python3

# WARNING: this implementation is so naive, it believes that Graal is FOSS

from sys import stdin, stdout

def rm_sized_loops(phases, size):
	# for (phases=[0,1,2,3,4,5], size=3), `slices` will contain:
	# [0,1,2]
	#   [1,2,3]
	#     [2,3,4]
	#       [3,4,5]
	slices = [phases[start_idx : start_idx+size] for start_idx in range(len(phases) - size)]
	
	# compare pairs of `size`-sized slices that are adjacent
	# (i.e. their starting indices differ by `size`)
	first_idx = 0
	while first_idx < len(slices) - size:
		second_idx = first_idx + size
		if slices[first_idx] == slices[second_idx]:
			# `size` elements from `first_idx` are the
			# same as `size` elements from `second_idx`
			phases[first_idx : second_idx] = []
			# edit `slices` accordingly
			slices[first_idx : second_idx] = []
		else:
			first_idx += 1

def rm_loops(phases):
	# blocks of size > len/2 definitely aren't repeated
	for size in range(len(phases)//2, 0, -1):
		rm_sized_loops(phases, size)

def main():
	# this is beautiful
	phases = stdin.readlines()
	rm_loops(phases)
	stdout.writelines(phases)

main()
