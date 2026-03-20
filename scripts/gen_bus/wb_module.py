from dataclasses import dataclass, field
from typing import Optional


MASTER_SIGNALS = [
  'wb_rst_i',
  'wb_clk_i',
  'wbm_adr_o',
  'wbm_dat_o',
  'wbm_dat_i',
  'wbm_sel_o',
  'wbm_we_o',
  'wbm_stb_o',
  'wbm_cyc_o',
  'wbm_ack_i',
]

SLAVE_SIGNALS = [
  'wb_rst_i',
  'wb_clk_i',
  'wbs_adr_i',
  'wbs_dat_i',
  'wbs_dat_o',
  'wbs_sel_i',
  'wbs_we_i',
  'wbs_stb_i',
  'wbs_cyc_i',
  'wbs_ack_o',
]

@dataclass
class WishboneModule:
  name: str
  module: str
  bus: Optional[bool] = True
  master: Optional[bool] = False
  params: Optional[dict[str, str]] = field(default_factory=dict)
  address: Optional[int] = None
  words: Optional[int] = 1
  ports: Optional[dict[str, str]] = field(default_factory=dict)

  # map wishbone conventional signal names (keys) to non-conventional
  # module port names (values)
  wishbone_map: Optional[dict[str, str]] = field(default_factory=dict)

  def __post_init__(self):
    if self.bus:
      if not self.wishbone_map: self.wishbone_map = {}
      for signal in (MASTER_SIGNALS if self.master else SLAVE_SIGNALS):
        if signal not in self.wishbone_map:
          self.wishbone_map[signal] = signal
