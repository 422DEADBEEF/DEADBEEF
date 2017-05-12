*-----------------------------------------------------------
* Title      : 
* Written by : DEAFBEEF
* Date       : 
* Description: 
*-----------------------------------------------------------

* For this, use 010000 as the start address and 010400 as the end address
* in the program prompt.

    MOVEM.L             A0-A5/D0-D7, -(SP)        
    MOVEA.L             #$10000, A0
    MOVE.W              #0, D0
    MOVE.W              #512, D1
    MOVE.W              #%1000101000000000, D2  *Set min value to branch8 with register set to 5
    
LOOP                    * Generate permutations of bits 0-8 (512 distinct values)
    CMP.W               D1, D0
    BEQ                 LOOP_END
    
    MOVE.W              D2, (A0)+       *put them in memory beginning at $10000
    ADDQ.L              #1, D2
    ADDQ.W              #1, D0
    BRA                 LOOP
LOOP_END         
            MOVEM.L     (SP)+, A0-A5/D0-D7



































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
