module atm(input clk, error_i, multiple_i, output correct_o, dismiss_o);
    logic state_s;

    always @(posedge clk) begin
        state_s <= error_i;
    end
    assign correct_o = (~state_s) & error_i & (~multiple_i);
    assign dismiss_o = error_i & multiple_i;
endmodule