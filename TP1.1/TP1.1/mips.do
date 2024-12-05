if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom mult_div.vhd
vcom MIPS-MC_SingleEdge.vhd
vcom cache_l1.vhd
vcom MIPS-MC_SingleEdge_tb.vhd


vsim -voptargs=+acc=lprn -t ps work.CPU_tb

do wave2.do

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

run 500 us

wave zoom full

