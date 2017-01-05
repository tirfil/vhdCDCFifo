set FLAG=-v -PALL_LIB --syn-binding --ieee=synopsys --std=93c -fexplicit
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\TEST\tb_cdcfifo8.vhd
ghdl -e --work=WORK --workdir=ALL_LIB %FLAG% tb_cdcfifo8
ghdl -r --work=WORK --workdir=ALL_LIB %FLAG% tb_cdcfifo8 --vcd=wave.vcd


