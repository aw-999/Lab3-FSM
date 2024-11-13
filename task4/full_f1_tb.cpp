#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vfull_f1.h"

#include "../vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env)
{
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges
    int lights = 0; // state to toggle LED lights
    int reactionTime = 0;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vfull_f1 *top = new Vfull_f1;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("delay.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("L3T4:Delay");
    vbdSetMode(1); // Flag mode set to one-shot

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->trigger = 0;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        top->trigger = vbdFlag();
        top->rst = simcyc;

        // Display toggle neopixel
        
        vbdBar(top->data_out & 0xFF);
        // set up input signals of testbench
        


        top->rst = (simcyc < 2); // assert reset for 1st cycle
        top->trigger = vbdFlag();

        if(top->cmd_delay == 1){
            vbdInitWatch();
        }

        if(top->trigger == 1){
            reactionTime = vbdElapsed();
        }

        if(reactionTime != 0){
            vbdHex(4, (int(reactionTime) >> 1000) & 0x9);
            vbdHex(3, (int(reactionTime) >> 100) & 0x9);
            vbdHex(2, (int(reactionTime) >> 10) & 0x9);
            vbdHex(1, int(reactionTime) & 0x9);
        }

        vbdCycle(simcyc);
        

        if (Verilated::gotFinish() || vbdGetkey() == 'q')
            exit(0);
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}