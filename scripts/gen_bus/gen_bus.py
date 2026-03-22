#!/usr/bin/env python3

import argparse
import math
import os
import re
import sys

from jinja2 import Template
import yaml

from wb_module import WishboneModule


def error(msg: str):
  print(msg, file=sys.stderr)
  exit(1)

if __name__ == '__main__':
  parser = argparse.ArgumentParser(
    prog='gen_bus.py',
    description='Generate a Wishbone SoC bus from a YAML spec',
  )
  parser.add_argument('spec')
  parser.add_argument(
    '-t', '--template',
    default=os.path.dirname(os.path.abspath(__file__)) + '/templates/jamsoc.v',
  )
  args = parser.parse_args()

  with open(args.spec, 'r') as f:
    bus_config = yaml.safe_load(f)

  soc_name: str = bus_config.get('name', 'jamsoc')
  width_addr: int = bus_config.get('width_addr', 32)
  width_data: int = bus_config.get('width_data', 32)

  top_ports = bus_config.get('top_ports', {})
  top_inputs = top_ports.get('inputs', {})
  top_outputs = top_ports.get('outputs', {})
  top_inouts = top_ports.get('inouts', {})
  top_assignments = bus_config.get('assignments', {})

  masters: dict[str, WishboneModule] = {}
  slaves: dict[str, WishboneModule] = {}
  non_bus: dict[str, WishboneModule] = {}
  top_wires: dict[str, int] = {}

  # TODO add this to the YAML spec when more buses are supported
  bus_type: str = 'wishbone'

  for module_name, module_dict in bus_config['modules'].items():
    try:
      module = WishboneModule(name=module_name, **module_dict)
      if not module.bus: non_bus[module_name] = module
      elif module.master: masters[module_name] = module
      else: slaves[module_name] = module
      for port_name, port in module.ports.items():
        port_wire = port.get('wire')
        if port.get('constant'):
          if port_wire:
            error(f'wire and constant cannot both be provided for port {port_name} on module {module_name}')
          else: continue
        if (port_wire in top_inputs) or (port_wire in top_outputs) or (port_wire in top_inouts): continue
        port_width = port.get('width')
        port_wire_strip = re.sub(r'\[\d+(:\d+)?\]', '', port_wire)
        if port_wire_strip in top_wires:
          if top_wires[port_wire_strip] is None:
            top_wires[port_wire_strip] = port_width
          else:
            if port_width is not None and top_wires[port_wire_strip] != port_width:
              error(f'width mismatch for wire "{port_wire}": ({port_width}, {top_wires[port_wire]}')
        else:
          top_wires[port_wire] = port_width
    except TypeError as e:
      error(f'Module "{module_name}" is missing a required field:\n  {e}')

  if bus_type == 'wishbone':
    for wire in [ 'wb_clk', 'wb_rst' ]:
      if wire not in top_inputs and wire not in top_wires:
        error(f'input or port wire is required for {wire}')

  for wire in top_wires:
    if top_wires[wire] is None:
      top_wires[wire] = 1

  with open(os.path.dirname(os.path.abspath(__file__)) + f'/templates/{bus_type}.v', 'r') as f:
    template = Template(f.read())
  result = template.render(
    NAME=soc_name,
    WIDTH_ADDR=width_addr,
    WIDTH_DATA=width_data,
    INPUTS=top_inputs,
    OUTPUTS=top_outputs,
    INOUTS=top_inouts,
    ASSIGNMENTS=top_assignments,
    WIRES=top_wires,
    MASTERS=masters,
    NUM_MASTERS=len(masters),
    LOG_NUM_MASTERS=int(math.log2(len(masters))) + 1,
    # for consistent ordering in arbiter
    MASTER_SORT=list(masters.keys()),
    SLAVES=slaves,
    NON_BUS=non_bus,
  )
  print('''
// THIS FILE WAS AUTOMATICALLY GENERATED FROM A YAML SPEC BY gen_bus.py
// IT SHOULD NOT BE MODIFIED DIRECTLY

''')
  print(result)
