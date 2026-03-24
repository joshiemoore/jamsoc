#!/usr/bin/env python3

import sys


WIDTH_BYTES = 4

with open(sys.argv[1], 'rb') as f:
  bin_data = f.read()

DEPTH = len(bin_data) // WIDTH_BYTES

print('memory_initialization_radix=16;')
print('memory_initialization_vector=')

for i in range(DEPTH):
  t = bin_data[i*WIDTH_BYTES : i*WIDTH_BYTES + WIDTH_BYTES][::-1].hex()
  print(t + (',' if i < DEPTH - 1 else ';'))
