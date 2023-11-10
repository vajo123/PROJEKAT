`ifndef MONITOR_AXI_LITE_SV
`define MONITOR_AXI_LITE_SV

class monitor_axi_lite extends uvm_monitor;

    `uvm_component_utils(monitor_axi_lite)

    title_config cfg;
    seq_item_lite item;
    virtual interface title_interface vif;
    uvm_analysis_port #(seq_item_lite) port_axi_lite; //sends items to scoreboard

    function new(string name = "monitor_axi_lite", uvm_component parent = null);
        super.new(name,parent);  
        port_axi_lite = new("port_axi_lite", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (!uvm_config_db#(virtual title_interface)::get(this, "", "title_interface", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
        
        if(!uvm_config_db#(title_config)::get(this, "", "title_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    endfunction : connect_phase

    task main_phase(uvm_phase phase);
        item = seq_item_lite::type_id::create("item",this);
        
        forever begin
            @(negedge vif.clk iff (vif.s00_axi_awvalid && vif.s00_axi_wvalid)); 
            @(posedge vif.clk iff vif.s00_axi_awready); 
            
            item.COM_OR_POS = vif.s00_axi_wdata;
			
			if (vif.s00_axi_awaddr == 4'b0100) begin
				item.offset = 1;
			end 
			else begin
				item.offset = 0;
			end
			
            port_axi_lite.write(item);
        end
    endtask : main_phase


endclass : monitor_axi_lite

`endif

