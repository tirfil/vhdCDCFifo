
ghdl -a ..\vhdl\wctl_logic.vhd
ghdl -a ..\vhdl\rctl_logic.vhd
ghdl -a ..\vhdl\cdcfifo.vhd
ghdl -a ..\test\tb_cdcfifo_sf.vhd
ghdl -e tb_cdcfifo_sf
ghdl -r tb_cdcfifo_sf --vcd=cdcfifo_sf.vcd
