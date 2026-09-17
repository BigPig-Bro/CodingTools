module uart_top #(
    parameter P_CLK_FRE       = 27_000_000,
    parameter P_UART_RATE     = 115200,
    parameter P_SEND_FRE      = 1
    )(
    input         i_sys_clk,    //系统时钟
    input         i_rst_n,     //系统复位
    
    input         i_uart_rx,
    output        o_uart_tx
);

typedef enum logic [1:0] {IDLE, SEND, LOOP}STATE_TOP;
STATE_TOP state;

logic [31:0] wait_cnt;
logic [ 7:0] send_cnt;
logic [ 7:0] send_data;
logic        send_en;
logic        send_busy;

logic [ 7:0] recv_data;
logic        recv_en;

//发送寄存器
localparam P_ENG_NUM  = 9;  //非中文字符数
localparam P_CHE_NUM  = 2;  //中文字符数
localparam P_DATA_NUM = P_CHE_NUM * 3 + P_ENG_NUM;  //中文字符使用UTF8，占用3个字节
logic [ P_DATA_NUM * 8 - 1:0] char_data = {"你好  World","\r\n"};
    
//仲裁机制
always@(posedge i_sys_clk)begin
    if(!i_rst_n)begin
        wait_cnt    <= 'd0;
        send_cnt    <= 'd0;
        send_en     <= 'b0;
        send_data   <= 'b0;

        state       <= IDLE;
    end else begin
        case(state)
            IDLE:begin // 空闲状态
                if(recv_en)begin // 接收数据
                    send_en     <= 'b1;
                    send_data   <= recv_data;

                    state       <= LOOP;
               end else if(wait_cnt >= P_CLK_FRE / P_SEND_FRE)begin 
                   wait_cnt    <= 'd0;

                   state       <= SEND;
                end else begin
                    wait_cnt    <= wait_cnt + 'd1;
                end
            end

            LOOP:begin // 回环测试
                if(!send_busy)begin
                    send_en     <= 'b0;
                    
                    state       <= IDLE;
                end
            end

            SEND:begin // 主动发送
                if(send_cnt >= P_DATA_NUM + 1)begin 
                    send_en     <= 'b0;
                    send_cnt    <= 'd0;

                    state       <= IDLE;
                end
                else if(!send_busy)begin
                    send_en     <= 'b1;
                    send_data   <= char_data[ (P_DATA_NUM - 1 - send_cnt) * 8 +: 8];
                    send_cnt    <= send_cnt + 'd1;
                end
            end

            default:begin // 默认状态
                state       <= IDLE;
            end
        endcase
    end
end

//发送模块
uart_tx #(
    .P_CLK_FRE          (P_CLK_FRE         ),
    .P_UART_RATE        (P_UART_RATE       )
)uart_tx_m0(
    .i_sys_clk          (i_sys_clk         ),
    .i_rst_n            (i_rst_n           ),

    .i_send_en          (send_en           ),
    .o_send_busy        (send_busy         ),
    .i_send_data        (send_data         ),

    .o_tx_pin           (o_uart_tx         )
);

//接收模块
uart_rx #(
    .P_CLK_FRE          (P_CLK_FRE          ),
    .P_UART_RATE        (P_UART_RATE        )
)uart_rx_m0(
    .i_sys_clk          (i_sys_clk          ),
    .i_rst_n            (i_rst_n            ),

    .o_recv_en          (recv_en            ),
    .o_recv_data        (recv_data          ),

    .i_rx_pin           (i_uart_rx          )
);

endmodule