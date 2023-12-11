#ifndef DMA_H
#define DMA_H

#include <systemc>
#include "types.hpp"
#include "tlm_utils/tlm_quantumkeeper.h"
#include <string>
#include <iostream>

using namespace std;
using namespace sc_core;

SC_MODULE(DMA)
{
public:
    SC_HAS_PROCESS(DMA);
    DMA(sc_module_name name);
    tlm_utils::simple_target_socket<DMA> s_dma_t;
    tlm_utils::simple_initiator_socket<DMA> s_dma_i0;

    sc_port<sc_fifo_out_if<sc_dt::sc_uint<16>>> p_fifo_out;
    sc_port<sc_fifo_in_if<sc_dt::sc_uint<16>>> p_fifo_in;

protected:
    void b_transport(pl_t&, sc_time&);
    vector<sc_dt::sc_uint<16>> pom_mem;
    void send_to_fifo();
    void read_from_fifo();
    sc_dt::sc_logic sig_send;
    sc_dt::sc_logic sig_read;

    tlm_command cmd;
    sc_dt::uint64 adr;
    unsigned int length;
    unsigned char *buf;
    unsigned int begin;
};

#endif // DMA_H

