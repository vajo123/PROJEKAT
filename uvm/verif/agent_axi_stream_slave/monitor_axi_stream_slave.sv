`ifndef MONITOR_AXI_STREAM_SLAVE_SV
`define MONITOR_AXI_STREAM_SLAVE_SV

class monitor_axi_stream_slave extends uvm_monitor;

    `uvm_component_utils(monitor_axi_stream_slave)

    title_config cfg;
    seq_item_slave item;
    virtual interface title_interface vif;
    uvm_analysis_port #(seq_item_slave) port_axis; //sends items to scoreboard

    function new(string name = "monitor_axi_stream_slave", uvm_component parent = null);
        super.new(name,parent);  
        port_axis = new("port_axis", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (!uvm_config_db#(virtual title_interface)::get(this, "", "title_interface", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
        
        if(!uvm_config_db#(title_config)::get(this, "", "title_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    endfunction : connect_phase

    task main_phase(uvm_phase phase);
        forever begin
            @(negedge vif.clk) begin
                @(negedge vif.clk iff vif.axis_s_last) begin
                    //`uvm_info(get_name(), $sformatf("Dogodila se prva provera"),UVM_LOW)
                end
            end
        end    
    endtask : main_phase


endclass : monitor_axi_stream_slave

`endif