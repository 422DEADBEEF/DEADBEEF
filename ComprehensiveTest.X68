*-----------------------------------------------------------
* Title      : 
* Written by : DEAFBEEF
* Date       : 
* Description: 
*-----------------------------------------------------------
    
* For this, use 010000 as the start address and 010400 as the end address
* in the program prompt.
    MOVEM.L             A0-A5/D0-D7, -(SP)        
    move.l              #$DEADBEEF, d3
    MOVEA.L             #$010000, A0
    MOVE.W              #0, D0
    
    
*    MOVE.W              #512, D1
*    MOVE.W              #%1100101000000000, D2  *Set min value to branch8 with register set to 5

    MOVE.W              #512, D1       ;; values for brancho
    MOVE.W              #$0400, D2

*    MOVE.W              #512, D1       ;; values for add/adda
*    MOVE.W              #$D800, D2

;    MOVE.L              #32768, D1     ;; MOVEM TESTS
 ;   MOVE.W              #%0100100010010110, D2
  ;  MOVE.W              #0, D4
  
    *MOVE.L              #256, D1
    *MOVE.W              #$6000, D2
    *MOVE.W              #$6400, D5
    *MOVE.W              #$6C00, D6
    *MOVE.W              #$6D00, D7
    
    *MOVE.L              #512, D1
    *MOVE.W              #$7E00, D2
    
    
    
LOOP                    * Generate permutations of bits 0-8 (512 distinct values)
    CMP.L               D1, D0
    BEQ                 LOOP_END
    
    
    MOVE.W              D2, (A0)+       *put them in memory beginning at $10000
    *MOVE.L              
    MOVE.W              D2, (A0)+       *put in second value for operands
    MOVE.W              D2, (A0)+
    MOVE.L              D3, (A0)+
    *MOVE.W              
    *MOVE.L              D3, (A0)+
    ADDQ.L              #1, D2
    
    *MOVE.W              D4, (A0)+      ; MOVEM REGISTER LISTS
    *ADDQ.W              #1, D4
    
    ADDQ.W              #1, D0
    BRA                 LOOP
LOOP_END         
            MOVEM.L     (SP)+, A0-A5/D0-D7









































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
