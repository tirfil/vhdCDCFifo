
ghdl -a ..\vhdl\wctl_logic.vhd
ghdl -a ..\vhdl\rctl_logic.vhd
ghdl -a ..\vhdl\cdcfifo.vhd
ghdl -a ..\test\tb_cdcfifo_fs.vhd
ghdl -e tb_cdcfifo_fs
ghdl -r tb_cdcfifo_fs --vcd=cdcfifo_fs.vcd
