`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.vh"

module alu(
    input wire[31:0] a,b,
    input wire[7:0] op,
    input wire[4:0] sa,
    output reg[31:0] y,
    output reg overflow,
    output wire zero
);
    reg[31:0] b_reg;
    /*wire[31:0] s,bout;
    assign bout = op[1] ? ~b : b; //+为0，-和slt为1
    assign s = a + bout + op[1];*/
    
    
    //溢出检测
    wire overflow_add;
    wire overflow_sub;

    always @(*) begin
        case (op)
            //logic op
            `EXE_AND_OP: y <= a & b;
            `EXE_OR_OP: y <= a | b;
            `EXE_XOR_OP:y <= a ^ b;
            `EXE_NOR_OP:y <= ~(a | b);
            `EXE_ANDI_OP: y <= a & b;//符号拓展里做了零拓展
            `EXE_ORI_OP: y <= a | b;
            `EXE_XORI_OP:y <= a ^ b;
            `EXE_LUI_OP:y <= {b[15:0] , {16{1'b0}} };
            // Arithmetic inst
            `EXE_ADD_OP: y <= a + b;
            `EXE_ADDU_OP: y <= a + b;
            `EXE_SUB_OP: y <= a - b;
            `EXE_SUBU_OP: y <= a - b;
            `EXE_SLT_OP: y <= $signed(a)<$signed(b);
            `EXE_SLTU_OP: y <= a < b;
            `EXE_ADDI_OP: y <= a + b;
            `EXE_ADDIU_OP: y <= a + b;
            `EXE_SLTI_OP: y <= $signed(a)<$signed(b);
            `EXE_SLTIU_OP: y <= a < b;
            
            `EXE_LW_OP: y <= a + b;
            `EXE_SW_OP: y <= a + b;
            `EXE_BEQ_OP: y <= a - b;
            
            //shift inst
            `EXE_SLL_OP: y <= b << sa;
            `EXE_SRL_OP: y <= b >> sa;
            `EXE_SRA_OP: y <= ($signed(b)) >>> sa;
            `EXE_SLLV_OP: y <= b << a[4:0];
            `EXE_SRLV_OP: y <= b >> a[4:0];
            `EXE_SRAV_OP: y <= ($signed(b)) >>> a[4:0];
            
            
            default : y <= 32'b0;
        endcase
    end
    assign zero = (y == 32'b0);

    always @(*) begin
        case (op[2:1])
            /*2'b01:overflow <= a[31] & b[31] & ~s[31] |
							~a[31] & ~b[31] & s[31];
			2'b11:overflow <= ~a[31] & b[31] & s[31] |
							a[31] & ~b[31] & ~s[31];*/
            default : overflow <= 1'b0;
        endcase
    end
endmodule
