create_clock -name clk -period 37.037 [get_ports {clk}]

set_false_path -from [get_ports {reset}]

set_false_path -to [get_ports {led[0]}]
set_false_path -to [get_ports {led[1]}]
set_false_path -to [get_ports {led[2]}]
set_false_path -to [get_ports {led[3]}]
set_false_path -to [get_ports {led[4]}]

set_false_path -to [get_ports {uart_bit_tx}]