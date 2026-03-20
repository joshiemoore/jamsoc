#!/usr/bin/env python3

import sys


WIDTH = 32

with open(sys.argv[1], 'rb') as f:
  bin_data = f.read()

DEPTH = len(bin_data) // (WIDTH // 8)

print(f'WIDTH={WIDTH};')
print(f'DEPTH={DEPTH};')
print('ADDRESS_RADIX=UNS;')
print('DATA_RADIX=HEX;')

print('CONTENT BEGIN')
for i in range(DEPTH):
  t = bin_data[i*4 : i*4 + 4][::-1].hex()
  print(f'\t{i} : {t};')
print('END;')
