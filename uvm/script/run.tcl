# ===================================================================================
# Definisanje direktorijuma u kojem ce biti projekat
# ===================================================================================
cd ..
set root_dir [pwd]
cd script
set resultDir ../vivado_project

file mkdir $resultDir

create_project title_verification $resultDir -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo-z7-10:part0:1.1 [current_project]

# ===================================================================================
# Ukljucivanje svih izvornih i simulacionih fajlova u projekat
# ===================================================================================
add_files -norecurse ../../rtl/adder.vhd
add_files -norecurse ../../rtl/BRAM.vhd
add_files -norecurse ../../rtl/BRAM_2READ_PORTS.vhd
add_files -norecurse ../../rtl/BRAM_LOGIC.vhd
add_files -norecurse ../../rtl/DATA_BRAM.vhd
add_files -norecurse ../../rtl/multiplier.vhd
add_files -norecurse ../../rtl/neg_adder.vhd
add_files -norecurse ../../rtl/TITLE_IP_v2_0.vhd
add_files -norecurse ../../rtl/TITLE_IP_v2_0_S00_AXI.vhd
add_files -norecurse ../../rtl/TOP.vhd

update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/agent_axi_lite/agent_axi_lite_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/agent_axi_stream_master/agent_axi_stream_master_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/agent_axi_stream_slave/agent_axi_stream_slave_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/configuration/configuration_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/sequences/seq_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/test_pkg.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/interface.sv
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/top.sv

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# ===================================================================================
# Ukljucivanje uvm biblioteke
# ===================================================================================
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.xsim.more_options} -value {-testplusarg UVM_TESTNAME=test_simple3 -testplusarg UVM_VERBOSITY=UVM_LOW -sv_seed 5} -objects [get_filesets sim_1]