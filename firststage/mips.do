quit -sim
vcom MIPS-MC_SingleEdge.vhd
vcom MIPS-MC_SingleEdge_tb.vhd
vcom mult_div.vhd
vsim cpu_tb
add wave -r /*
run 1ms
