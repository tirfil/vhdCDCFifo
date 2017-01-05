set FLAG=-v -PALL_LIB --syn-binding --ieee=synopsys --std=93c -fexplicit
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\VHDL\dp8x8.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\VHDL\syncreset.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\VHDL\wrfifo8.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\VHDL\rdfifo8.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\VHDL\cdcfifo8.vhd
