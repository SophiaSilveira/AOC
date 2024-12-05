onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color White /cpu_tb/ck
add wave -noupdate -color White /cpu_tb/rst


add wave -noupdate -divider instruction
add wave -radix hexa /cpu_tb/Iadress
add wave -radix hexa /cpu_tb/Idata
add wave -radix hexa /cpu_tb/i_cpu_address
add wave /cpu_tb/Ice_n
add wave /cpu_tb/Iwe_n
add wave /cpu_tb/Ioe_n
add wave /cpu_tb/hold
add wave /cpu_tb/readInst
add wave /cpu_tb/miss
add wave /cpu_tb/cpu/uins.i

add wave -noupdate -divider cache
add wave -radix hexa /cpu_tb/Cache_Mem/addressCPU
add wave -radix hexa /cpu_tb/Cache_Mem/instCPU
add wave -radix hexa /cpu_tb/Cache_Mem/addressMem
add wave -radix hexa /cpu_tb/Cache_Mem/instMem
add wave -radix hexa /cpu_tb/Cache_Mem/data_cache

add wave -noupdate -divider data
add wave -radix hexa /cpu_tb/Dadress
add wave -radix hexa /cpu_tb/Ddata
add wave -radix hexa /cpu_tb/d_cpu_address
add wave -radix hexa /cpu_tb/data_cpu
add wave /cpu_tb/Dce_n
add wave /cpu_tb/Dwe_n
add wave /cpu_tb/Doe_n
add wave /cpu_tb/ce
add wave /cpu_tb/rw
add wave /cpu_tb/bw

add wave -noupdate -divider boot
add wave -radix hexa /cpu_tb/tb_add
add wave -radix hexa /cpu_tb/tb_data
add wave /cpu_tb/rstCPU
add wave /cpu_tb/go_i
add wave /cpu_tb/go_d

