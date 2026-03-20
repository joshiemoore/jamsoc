{%- macro portspec(direction, name, width, depth=1) -%}
  {{- direction }} {% if width > 1 %}[{{ width|int - 1 }}:0] {% endif %}{%if depth > 1 %}[{{ depth - 1 }}:0] {% endif %}{{ name -}}
{%- endmacro -%}

{%- macro params(param_dict) -%}
{%- if param_dict -%}
{{ '#(' }}
{%- for param_key, param_val in param_dict.items() %}
    .{{ param_key }} ({{ param_val }})
    {{- ',' if not loop.last }}
{%- endfor %}
  )
{%- endif -%}
{%- endmacro -%}

{%- macro non_bus_ports(module) -%}
{%- for port_name, port in module.ports.items() %}
    .{{ port_name }} ({{ port['constant'] if 'constant' in port else port['wire'] }}){{ ',' if not loop.last }}
{%- endfor %}
{%- endmacro %}

{%- macro hexfmt(val, len_bits) -%}
  {{ len_bits }}'h{{ ('%0' + ((len_bits // 4) | string) + 'x') | format(val) }}
{%- endmacro -%}

{%- macro master_agg(prefix='', postfix='') -%}
{{ '{' }} {% for m in MASTER_SORT|reverse %}{{ (prefix + '_') if prefix != '' }}{{ m }}{{ ('_' + postfix) if postfix != '' }}{{ ', ' if not loop.last }}{% endfor %} {{ '}' }}
{%- endmacro -%}

{%- macro master_input_mux(slave_name, master_input, gate_req=False) -%}
assign wbs_{{ slave_name }}_{{ master_input }}_o = {% for i in range(NUM_MASTERS) %}({{ slave_name }}_grant == {{ i }}{% if gate_req %} && {{ MASTER_SORT[i] }}_req_{{ slave_name }}{% endif %}) ? wbm_{{ MASTER_SORT[i] }}_{{ master_input }}_i : {% if loop.last %}0{% endif %}{% endfor %}  
{%- endmacro -%}

{{- '' -}}
module {{ NAME }}_top (
{%- for pname, pwidth in INPUTS.items() %}
  {{ portspec('input', pname, pwidth) }}{{ ',' if not loop.last or OUTPUTS or INOUTS -}}
{% endfor %}
{% for pname, pwidth in OUTPUTS.items() %}
  {{ portspec('output', pname, pwidth) }}{{ ',' if not loop.last or INOUTS -}}
{% endfor %}
{% for pname, pwidth in INOUTS.items() %}
  {{ portspec('inout', pname, pwidth) }}{{ ',' if not loop.last -}}
{% endfor %}
);

{% for wire_name, wire_width in WIRES.items() %}
  {{ portspec('wire', wire_name, wire_width) }};
{%- endfor %}

{%- for master_name in MASTERS %}

  {{ portspec('wire', master_name + '_adr_o', WIDTH_ADDR) }};
  {{ portspec('wire', master_name + '_dat_o', WIDTH_DATA) }};
  {{ portspec('wire', master_name + '_dat_i', WIDTH_DATA) }};
  {{ portspec('wire', master_name + '_sel_o', WIDTH_DATA/8) }};
  {{ portspec('wire', master_name + '_we_o', 1) }};
  {{ portspec('wire', master_name + '_stb_o', 1) }};
  {{ portspec('wire', master_name + '_cyc_o', 1) }};
  {{ portspec('wire', master_name + '_ack_i', 1) }};
{%- endfor %}

{%- for slave_name in SLAVES %}

  {{ portspec('wire', slave_name + '_adr_i', WIDTH_ADDR) }};
  {{ portspec('wire', slave_name + '_dat_i', WIDTH_DATA) }};
  {{ portspec('wire', slave_name + '_dat_o', WIDTH_DATA) }};
  {{ portspec('wire', slave_name + '_sel_i', WIDTH_DATA/8) }};
  {{ portspec('wire', slave_name + '_we_i', 1) }};
  {{ portspec('wire', slave_name + '_stb_i', 1) }};
  {{ portspec('wire', slave_name + '_cyc_i', 1) }};
  {{ portspec('wire', slave_name + '_ack_o', 1) }};
{%- endfor %}
{% for assign_to, assign_from in ASSIGNMENTS.items() %}
  assign {{ assign_to }} = {{ assign_from }};
{%- endfor %}

  {{ NAME }}_wb_intercon wb_intercon (
    .wb_rst_i (wb_rst),
    .wb_clk_i (wb_clk),
    {%- for master_name in MASTERS %}

    .wbm_{{ master_name }}_adr_i ({{ master_name }}_adr_o),
    .wbm_{{ master_name }}_dat_i ({{ master_name }}_dat_o),
    .wbm_{{ master_name }}_dat_o ({{ master_name }}_dat_i),
    .wbm_{{ master_name }}_sel_i ({{ master_name }}_sel_o),
    .wbm_{{ master_name }}_we_i ({{ master_name }}_we_o),
    .wbm_{{ master_name }}_stb_i ({{ master_name }}_stb_o),
    .wbm_{{ master_name }}_cyc_i ({{ master_name }}_cyc_o),
    .wbm_{{ master_name }}_ack_o ({{ master_name }}_ack_i)
    {{- ',' if not loop.last or SLAVES -}}
    {% endfor -%}
    {% for slave_name in SLAVES %}

    .wbs_{{ slave_name }}_adr_o ({{ slave_name }}_adr_i),
    .wbs_{{ slave_name }}_dat_o ({{ slave_name }}_dat_i),
    .wbs_{{ slave_name }}_dat_i ({{ slave_name }}_dat_o),
    .wbs_{{ slave_name }}_sel_o ({{ slave_name }}_sel_i),
    .wbs_{{ slave_name }}_we_o ({{ slave_name }}_we_i),
    .wbs_{{ slave_name }}_stb_o ({{ slave_name }}_stb_i),
    .wbs_{{ slave_name }}_cyc_o ({{ slave_name }}_cyc_i),
    .wbs_{{ slave_name }}_ack_i ({{ slave_name }}_ack_o)
    {{- ',' if not loop.last -}}
    {% endfor %}
  );

{%- for master_name, module in MASTERS.items() %}

  {{ module.module }} {{ params(module.params) }} {{ master_name }} (
    .{{ module.wishbone_map['wb_rst_i'] }} (wb_rst),
    .{{ module.wishbone_map['wb_clk_i'] }} (wb_clk),
    .{{ module.wishbone_map['wbm_adr_o'] }} ({{ master_name }}_adr_o),
    .{{ module.wishbone_map['wbm_dat_o'] }} ({{ master_name }}_dat_o),
    .{{ module.wishbone_map['wbm_dat_i'] }} ({{ master_name }}_dat_i),
    .{{ module.wishbone_map['wbm_sel_o'] }} ({{ master_name }}_sel_o),
    .{{ module.wishbone_map['wbm_we_o'] }} ({{ master_name }}_we_o),
    .{{ module.wishbone_map['wbm_stb_o'] }} ({{ master_name }}_stb_o),
    .{{ module.wishbone_map['wbm_cyc_o'] }} ({{ master_name }}_cyc_o),
    .{{ module.wishbone_map['wbm_ack_i'] }} ({{ master_name }}_ack_i){{ ',' if module.ports }}
    {{- non_bus_ports(module) }}
  );
{%- endfor %}

{%- for slave_name, module in SLAVES.items() %}

  {{ module.module }} {{ params(module.params) }} {{ slave_name }} (
    .{{ module.wishbone_map['wb_rst_i'] }} (wb_rst),
    .{{ module.wishbone_map['wb_clk_i'] }} (wb_clk),
    .{{ module.wishbone_map['wbs_adr_i'] }} ({{ slave_name }}_adr_i),
    .{{ module.wishbone_map['wbs_dat_i'] }} ({{ slave_name }}_dat_i),
    .{{ module.wishbone_map['wbs_dat_o'] }} ({{ slave_name }}_dat_o),
    .{{ module.wishbone_map['wbs_sel_i'] }} ({{ slave_name }}_sel_i),
    .{{ module.wishbone_map['wbs_we_i'] }} ({{ slave_name }}_we_i),
    .{{ module.wishbone_map['wbs_stb_i'] }} ({{ slave_name }}_stb_i),
    .{{ module.wishbone_map['wbs_cyc_i'] }} ({{ slave_name }}_cyc_i),
    .{{ module.wishbone_map['wbs_ack_o'] }} ({{ slave_name }}_ack_o){{ ',' if module.ports }}
    {{- non_bus_ports(module) }}
  );
{%- endfor %}

{%- for mod_name, module in NON_BUS.items() %}

  {{ module.module }} {{ params(module.params) }} {{ mod_name }} (
    {{- non_bus_ports(module) }}
  );
{%- endfor %}
endmodule


module {{ NAME }}_wb_intercon (
  input wb_rst_i,
  input wb_clk_i,
{% for master_name in MASTERS %}
  {{ portspec('input', 'wbm_' + master_name + '_adr_i', WIDTH_ADDR) }},
  {{ portspec('input', 'wbm_' + master_name + '_dat_i', WIDTH_DATA) }},
  {{ portspec('output', 'wbm_' + master_name + '_dat_o', WIDTH_DATA) }},
  {{ portspec('input', 'wbm_' + master_name + '_sel_i', WIDTH_DATA/8) }},
  {{ portspec('input', 'wbm_' + master_name + '_we_i', 1) }},
  {{ portspec('input', 'wbm_' + master_name + '_stb_i', 1) }},
  {{ portspec('input', 'wbm_' + master_name + '_cyc_i', 1) }},
  {{ portspec('output', 'wbm_' + master_name + '_ack_o', 1) }}{{ ',' if not loop.last or SLAVES }}
{% endfor -%}
{% for slave_name in SLAVES %}
  {{ portspec('output', 'wbs_' + slave_name + '_adr_o', WIDTH_ADDR) }},
  {{ portspec('output', 'wbs_' + slave_name + '_dat_o', WIDTH_DATA) }},
  {{ portspec('input', 'wbs_' + slave_name + '_dat_i', WIDTH_DATA) }},
  {{ portspec('output', 'wbs_' + slave_name + '_sel_o', WIDTH_DATA/8) }},
  {{ portspec('output', 'wbs_' + slave_name + '_we_o', 1) }},
  {{ portspec('output', 'wbs_' + slave_name + '_stb_o', 1) }},
  {{ portspec('output', 'wbs_' + slave_name + '_cyc_o', 1) }},
  {{ portspec('input', 'wbs_' + slave_name + '_ack_i', 1) }}{{ ',' if not loop.last }}
{% endfor -%}
);
{% for slave_name, module in SLAVES.items() %}
  {{ portspec('localparam', 'ADDR_' + slave_name, WIDTH_ADDR) }} = {{ hexfmt(module.address, WIDTH_ADDR) }};
{%- endfor %}

{% for slave_name, slave_module in SLAVES.items() %}
{% for master_name in MASTER_SORT %}
  {{ portspec('wire', master_name + '_req_' + slave_name, 1) }} = wbm_{{ master_name }}_cyc_i && (wbm_{{ master_name }}_adr_i >= {{ hexfmt(slave_module.address, WIDTH_ADDR) }}) && (wbm_{{ master_name }}_adr_i < {{ hexfmt(slave_module.address + slave_module.words * 4, WIDTH_ADDR) }});
{%- endfor %}
  {{ portspec('wire', slave_name + '_reqs', NUM_MASTERS) }} = {{ master_agg(postfix='req_' + slave_name) }};
  {{ portspec('reg', slave_name + '_grant', LOG_NUM_MASTERS) }} = 0;
  {{ portspec('reg', slave_name + '_busy', 1) }} = 0;
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      {{ slave_name }}_grant <= 0;
      {{ slave_name }}_busy <= 0;
    end else begin
      if ({{ slave_name }}_busy) begin
        if (!{{ slave_name }}_reqs[{{ slave_name }}_grant]) begin
          {{ slave_name }}_busy <= 0;
          {{ slave_name }}_grant <= {{ slave_name }}_grant == {{ NUM_MASTERS - 1 }} ? 0 : ({{ slave_name }}_grant + 1);
        end
      end else begin
        if ({{ slave_name }}_reqs[{{ slave_name }}_grant]) begin
          {{ slave_name }}_busy <= 1;
        end else begin
          {{ slave_name }}_grant <= {{ slave_name }}_grant == {{ NUM_MASTERS - 1}} ? 0 : ({{ slave_name }}_grant + 1);
        end
      end
    end
  end
  {{ master_input_mux(slave_name, 'adr') }};
  {{ master_input_mux(slave_name, 'dat') }};
  {{ master_input_mux(slave_name, 'sel') }};
  {{ master_input_mux(slave_name, 'we') }};
  {{ master_input_mux(slave_name, 'cyc', gate_req=True) }};
  {{ master_input_mux(slave_name, 'stb', gate_req=True) }};
  
{% endfor %}

{% for i in range(NUM_MASTERS) %}
  assign wbm_{{ MASTER_SORT[i] }}_ack_o =
{%- for slave_name in SLAVES %}
    ({{ slave_name }}_grant == {{ i }} && {{ MASTER_SORT[i] }}_req_{{ slave_name }} && wbs_{{ slave_name }}_ack_i){{ ';' if loop.last else ' ||' }}
{%- endfor %}

  assign wbm_{{ MASTER_SORT[i] }}_dat_o =
{%- for slave_name in SLAVES %}
    ({{ slave_name }}_grant == {{ i }} && {{ MASTER_SORT[i] }}_req_{{ slave_name }}) ? wbs_{{ slave_name }}_dat_i :
{%- endfor %}
    {{ WIDTH_DATA }}'b0;
{% endfor %}

endmodule
