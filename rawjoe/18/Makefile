all:
	~/ghdl/bin/ghdl -a sol.vhdl
	~/ghdl/bin/ghdl -a sol_tb.vhdl
	~/ghdl/bin/ghdl -e sol_tb
	~/ghdl/bin/ghdl -r sol_tb

clean:
	rm *.o
	rm sol_tb
	rm work-obj93.cf
