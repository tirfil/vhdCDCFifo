
ghdl -a ..\vhdl\wctl_logic.vhd
ghdl -a ..\vhdl\rctl_logic.vhd
ghdl -a ..\vhdl\cdcfifo.vhd
ghdl -a ..\test\tb_cdcfifo.vhd
ghdl -e tb_cdcfifo
ghdl -r tb_cdcfifo --vcd=cdcfifo.vcd
