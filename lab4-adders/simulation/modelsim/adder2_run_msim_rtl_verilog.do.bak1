transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/kg3/ece385/2Bit_Adder {/home/kg3/ece385/2Bit_Adder/full_adder.sv}
vlog -sv -work work +incdir+/home/kg3/ece385/2Bit_Adder {/home/kg3/ece385/2Bit_Adder/adder2.sv}

vlog -sv -work work +incdir+/home/kg3/ece385/2Bit_Adder {/home/kg3/ece385/2Bit_Adder/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
