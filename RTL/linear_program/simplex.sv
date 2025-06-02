module simplex #(
  parameter DATA_WIDTH = 32,
  parameter NCOEFMAX = 512,
  parameter NREQMAX = 512,
  parameter NRLEQMAX = 512,
  parameter NROWS = NREQMAX+NRLEQMAX,
  parameter NCOLS = NCOEFMAX+NRLEQMAX+1
) (
  
  input logic clk_i,
  input logic rstn_i,
  input  logic [DATA_WIDTH-1:0]  f    [0:NCOEFMAX-1],
  input  logic [DATA_WIDTH-1:0]  Aleq [0:NRLEQMAX-1][0:NCOEFMAX-1],
  input  logic [DATA_WIDTH-1:0]  bleq [0:NRLEQMAX-1],
  input  logic [DATA_WIDTH-1:0]  Aeq  [0:NREQMAX-1][0:NCOEFMAX-1],
  input  logic [DATA_WIDTH-1:0]  beq  [0:NREQMAX-1],
  input  logic [$clog2(NCOEFMAX):0] ncoef,
  input  logic [$clog2(NREQMAX):0] nreq,
  input  logic [$clog2(NRLEQMAX):0] nrleq,
  input  logic [DATA_WIDTH-1:0]  LB   [0:NCOEFMAX-1],
  input  logic [DATA_WIDTH-1:0]  UB   [0:NCOEFMAX-1],
  output logic done,
  output logic [DATA_WIDTH-1:0]  sol  [0:NCOEFMAX-1]
);

  // Estado do algoritmo
  typedef enum logic [2:0] {
    INIT, FIND_PIVOT, PIVOT_OPERATION, CHECK_OPTIMAL, DONE
  } state_t;

  state_t state;
  logic r_done;

  logic [DATA_WIDTH-1:0] tableau [0:NROWS][0:NCOLS];

  logic [DATA_WIDTH-1:0] min_col_value;
  logic [$clog2(NCOLS):0] s_pivot_col;
  logic [$clog2(NCOLS):0] r_pivot_col;
  logic no_negative_found;

  logic s_search_row_en;
  logic s_pivot_found;
  logic r_pivot_found;
  logic s_update_en;
  logic r_pivot_en;
  logic s_update_finished;
  logic r_update_finished;

  logic [$clog2(NROWS):0] s_pivot_row;
  logic [$clog2(NROWS):0] r_pivot_row;
  logic [$clog2(NROWS):0] s_next_row;
  logic [$clog2(NROWS):0] r_curr_row;
  logic [DATA_WIDTH-1:0] s_curr_row_value;
  logic [DATA_WIDTH-1:0] r_curr_row_value;
  logic [DATA_WIDTH-1:0] s_min_row_value;
  logic [DATA_WIDTH-1:0] r_min_row_value;

  logic [$clog2(NROWS):0] r_update_row;
  logic [$clog2(NCOLS):0] r_update_col;
  logic [DATA_WIDTH-1:0]  s_update_sub;
  logic [DATA_WIDTH-1:0]  s_update_mult;
  logic [DATA_WIDTH-1:0]  s_update_pivot_div;

  logic [DATA_WIDTH-1:0] r_pivot;
  logic [DATA_WIDTH-1:0] r_factor;
  logic pivoted_pivot_row;

  logic [DATA_WIDTH-1:0] dividend;
  logic [DATA_WIDTH-1:0] divisor;

  logic [DATA_WIDTH-1:0] factor_a;
  logic [DATA_WIDTH-1:0] factor_b;

  logic [DATA_WIDTH-1:0] sub_operand_a;
  logic [DATA_WIDTH-1:0] sub_operand_b;

  assign done = (r_done) ? 1'b1 : 1'b0;

  assign dividend = tableau[r_pivot_row][r_update_col];
  assign divisor = tableau[r_pivot_row][r_pivot_col];

  assign factor_a = tableau[r_pivot_row][r_update_col];
  assign factor_b = tableau[r_update_row][r_pivot_col];

  assign sub_operand_a = tableau[r_update_row][r_update_col];
  assign sub_operand_b = s_update_mult;

  
  div i_div_pivot(
    .a(tableau[r_curr_row][ncoef+nrleq+1]),
    .b(tableau[r_curr_row][r_pivot_col]),
    .result(s_curr_row_value)
  );

  div i_mult_update_pivot(
    .a(tableau[r_pivot_row][r_update_col]),
    .b(r_pivot),
    .result(s_update_pivot_div)
  );

  Mult i_mult_update_tableau(
    .a(tableau[r_pivot_row][r_update_col]),
    .b(r_factor),
    .result(s_update_mult)
  );

  Add_Sub i_add_update_tableau(
    .a(tableau[r_update_row][r_update_col]),
    .b(s_update_mult),
    .AddBar_Sub(1'b1),
    .result(s_update_sub)
  );

  assign s_search_row_en = (state == FIND_PIVOT);
  assign s_pivot_found = (s_search_row_en && r_curr_row == (nreq+nrleq));
  assign s_update_en = (state == PIVOT_OPERATION);
  assign s_update_finished = r_update_finished;

  
  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_update_seq
    if(!rstn_i)
    begin
      r_update_row <= '0;
      r_factor <= '0;
      r_update_col <= 1;
      r_update_finished <= 1'b0;
    end
    else if(s_update_en) // se está realizando a operação de pivotagem
    begin
      if(r_update_col == ncoef+nrleq+1 || r_update_col == NCOLS) // se a coluna de update for a ultima, volta para primeira coluna e atualiza a linha de update
      begin
        if(!r_pivot_en)
          r_factor <= tableau[r_update_row][r_pivot_col];
        r_update_col <= 1;
        if(r_pivot_en)
        begin
          if(r_update_row >= NROWS || r_update_row >= nreq+nrleq)
          begin
            r_update_row <= '0;
            r_update_finished <= 1'b1;
          end
          else
            if(r_update_row+1 == r_pivot_row) // se a proxima linha for a linha do pivo
              if(r_update_row+1 == nreq+nrleq) // pula a linha do pivo, retornando para a primeira linha caso ela seja a ultima
              begin
                r_update_row <= '0;
                r_update_finished <= 1'b1;
              end
              else
              begin
                r_factor <= tableau[r_update_row+2][r_pivot_col];
                r_update_row <= r_update_row+2;                
              end
            else
            begin
              r_factor <= tableau[r_update_row+1][r_pivot_col];
              r_update_row <= r_update_row+1;              
            end   
        end     
      end
      else
        r_update_col <= r_update_col+1;
    end
    else
    begin
      r_factor <= '0;
      r_update_row <= '0;
      r_update_col <= 1;
      r_update_finished <= 1'b0;
    end
  end

  always_comb begin : proc_pivot_col
    min_col_value = '0;
    s_pivot_col = r_pivot_col;
    no_negative_found = (s_search_row_en) ? 1'b1 : 1'b0;
    if(s_search_row_en)
    begin
      for (int j = 1; j < NCOLS; j++) begin // pula a coluna do RHS (j=0)
        if(j <= ncoef) // considera apenas colunas dos coeficientes
        begin
          if(tableau[0][j][31] == 1) // verifica se custo é negativo
          begin
            no_negative_found = 1'b0; // sinaliza que encontrou custo negativo
            if(min_col_value == '0)
            begin
              min_col_value = tableau[0][j];
              s_pivot_col = j;
              no_negative_found = 1'b0;    
            end
            else if(tableau[0][j][30:23] != min_col_value[30:23]) // verifica se o expoente do custo é maior (logo mais negativo)
              if(tableau[0][j][30:23] > min_col_value[30:23])
              begin
                min_col_value = tableau[0][j];
                s_pivot_col = j;
                no_negative_found = 1'b0; 
              end
            else if(tableau[0][j][24:0] > min_col_value[24:0]) // verifica se a mantissa do custo é maior (logo, mais negativo)
            begin
              min_col_value = tableau[0][j];
              s_pivot_col = j;
              no_negative_found = 1'b0; 
            end
          end        
        end
      end      
    end
  end
  
  always_comb begin : proc_pivot_row_comb
    s_next_row = (r_curr_row == (nreq+nrleq)) ? 1 : r_curr_row + 1;
    s_min_row_value = r_min_row_value;
    s_pivot_row = r_pivot_row;
    if(s_search_row_en) // se está procurando o pivo
    begin
      if(s_curr_row_value[31] == 1'b0) // se a razão for positiva
      begin
        if(s_curr_row_value[30:23] != r_min_row_value[30:23]) // se o expoente for diferente
        begin
          if(s_curr_row_value[30:23] < r_min_row_value[30:23]) // se o expoente for menor
          begin
            s_min_row_value = s_curr_row_value;
            s_pivot_row = r_curr_row;
          end          
        end
        else if(s_curr_row_value[22:0] < r_min_row_value[22:0]) begin
            s_min_row_value = s_curr_row_value;
            s_pivot_row = r_curr_row;
        end
      end
    end
  end

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_pivot_row_seq
    if(!rstn_i)
    begin
      r_done <= 1'b0;
      r_curr_row <= 1;
      r_pivot_row <= '0;
      r_pivot_col <= '0;
      r_curr_row_value <= {1'b0, {DATA_WIDTH-1{1'b1}}}; // NaN
      r_min_row_value <= {1'b0, {DATA_WIDTH-1{1'b1}}}; // NaN
      r_pivot_found <= 1'b0;
    end
    else if(s_search_row_en) // se está procurando o pivo
    begin
      r_curr_row <= s_next_row;
      r_pivot_row <= s_pivot_row;
      r_pivot_col <= s_pivot_col;
      r_curr_row_value <= s_curr_row_value;
      r_min_row_value <= s_min_row_value;
      r_pivot_found <= s_pivot_found;
    end
    else
    begin
      r_curr_row <= 1;
      r_pivot_col <= s_pivot_col;
      r_curr_row_value <= {1'b0, {DATA_WIDTH-1{1'b1}}}; // NaN
      r_min_row_value <= {1'b0, {DATA_WIDTH-1{1'b1}}};  // NaN 
      r_pivot_found <= 1'b0;   
    end
  end

  always_ff @(posedge clk_i, negedge rstn_i)
  begin : proc_simplex_sm
    if(!rstn_i)
    begin
      r_pivot_en <= 1'b0;
      state <= INIT;
      for(int i = 0; i < NCOEFMAX; i++)
        sol[i] <= '0;
      for(int i = 0; i <= NROWS; i++)
        for(int j = 0; j <= NCOLS; j++)
          tableau[i][j] <= '0;
    end
    else
    begin
      case (state)
        INIT:
        begin
          state <= FIND_PIVOT;

          for(int i = 0; i < NCOEFMAX; i++)
            sol[i] <= '0;

          tableau[0][0] <= 32'h3F800000;
          for(int i = 1; i <= NROWS; i++)
            tableau[i][0] <= '0;
          for(int j = 1; j <= NCOLS; j++)
            if((j-1) < ncoef)
              tableau[0][j] <= {!f[j-1][31], f[j-1][30:0]}; // tableau[0][j] = -f[j-1]
            else
              tableau[0][j] = '0;


          for(int i = 0; i < NROWS; i++) // tableau inicial
          begin
            if(i < nrleq) // restrições de desigualdade
            begin
              for(int j = 0; j <= NCOLS; j++)
              begin
                if(j < ncoef) // coeficientes das restrições
                  tableau[i+1][j+1] <= Aleq[i][j];
                else if((j - ncoef) < nrleq) // coeficientes das variáveis de slack
                  if((j-ncoef) == i)
                    tableau[i+1][j+1] <= 32'h3F800000;
                  else
                    tableau[i+1][j+1] <= '0;
                else if(j == (ncoef+nrleq)) // RHS
                  tableau[i+1][j+1] <= bleq[i];
                else // padding
                  tableau[i+1][j+1] <= '0;
              end      
            end
            else if((i-nrleq) < nreq) // restrições de igualdade
            begin
              for(int j = 0; j < NCOLS; j++)
                if(j < ncoef) // coeficientes das restrições
                  tableau[i+1][j+1] <= Aeq[i-nrleq][j];
                else if((j-ncoef) < nrleq) // coeficientes das variáveis de slack
                  tableau[i+1][j+1] <= '0;
                else if(j == (ncoef+nrleq)) // RHS
                  tableau[i+1][j+1] <= beq[i-nrleq];
                else // padding
                  tableau[i+1][j+1] <= '0;
            end
            else
              for(int j = 0; j < NCOLS; j++)
                tableau[i+1][j+1] <= '0;
          end
        end 
        FIND_PIVOT:
        begin
          if(no_negative_found)
            state <= DONE;
          else if(r_pivot_found)
          begin
            r_pivot <= tableau[r_pivot_row][r_pivot_col];
            state <= PIVOT_OPERATION;            
          end
        end
        PIVOT_OPERATION:
        begin
          if(r_update_finished)
          begin
            state <= FIND_PIVOT;
            r_pivot_en <= 1'b0;            
          end
          else
          begin
            if(r_update_col == ncoef+nrleq+1)
              r_pivot_en <= 1'b1;
            if(!r_pivot_en)
              for(int j = 0; j <= NCOLS; j++)
                tableau[r_pivot_row][j] <= (j == r_update_col) ? ((j == r_pivot_col) ? 32'h3F800000 : s_update_pivot_div) : tableau[r_pivot_row][j];
            else
            begin
              for(int i = 0; i <= NROWS; i++)
                if(i == r_update_row && i != r_pivot_row)
                  for(int j = 0; j <= NCOLS; j++)
                    tableau[i][j] <= (j == r_update_col) ? ((j == r_pivot_col) ? '0 : s_update_sub) : tableau[i][j];            
            end
          end
        end
        DONE:
        begin
          r_done <= 1'b1;
          for(int i = 1; i <= NROWS; i++)
          begin
            for(int j = 1; j <= NCOLS; j++)
            begin
              if(j-1 < ncoef) // verifica apenas coeficientes
              begin
                if(tableau[i][j] == 32'h3F800000)
                  sol[j-1] <= tableau[i][ncoef+nrleq+1];
              end
              else if(j < NCOEFMAX)
                sol[j] <= '0;
            end
          end
              
        end
        default:
        begin
          r_done <= 1'b0;
          r_pivot_en <= 1'b0;
          state <= INIT;
          for(int i = 0; i < NCOEFMAX; i++)
            sol[i] <= '0;
          for(int i = 0; i <= NROWS; i++)
            for(int j = 0; j <= NCOLS; j++)
              tableau[i][j] <= '0;
        end
      endcase
    end
  end

  
endmodule