novas = "/opt/Synopsys/Verdi2015/share/PLI/VCS/LINUXAMD64/novas.tab"
pli = "/opt/Synopsys/Verdi2015/share/PLI/VCS/LINUXAMD64/pli.a"
sim:
	vcs 	\
		-full64			\
		-sverilog		\
		+v2k	\
		-f filelist	\
		-debug_all	\
		-sverilog		\
		-R			
dve:
	dve -vpd *.vpd&
fsdb:
	vcs 	\
		-full64			\
		+v2k	\
		-f filelist	\
		-sverilog		\
		-R					\
	 	-debug_access+all -kdb -lca \
		-P $(novas) $(pli) 
verdi:
	#verdi -sv -f filelist -ssh *.fsdb -arch32  &
	verdi -f filelist& 
	
clean:
	rm -rf *.log *.mr *.svl
	rm -rf csrc DVEfiles *.daidir simv *.vpd *.key
	rm -rf *.dump 
	rm -rf novas* *.fsdb *.dat verdiLog
