*-----------------------------------------------------------
* Title       : Initial Decoding Branch
* Written by  : Ryan Berge
* Date        : April 25th, 2017
* Description : Reads in a word representing an opcode and
*               attempts to decode it
*-----------------------------------------------------------

                *Register A6 will always have the address
                *of the current word to decode
                
DECODE
                    MOVEM.L     D0-D7/A0-A5, -(SP)      * Save register state
                    
                    MOVE.L      A6, OPADDR
                    
                    MOVE.W      (A6), D1                * Save OP-Code in D1
                    AND.W       MASK_HONIBBLE, D1       * Mask out highest-order nibble
                    
                    ROL.W       #4, D1
                    MULS.W      #10, D1
                    
                    LEA         JUMP_TABLE, A0     
                    JMP         0(A0, D1)

JUMP_TABLE          JSR         MAIN_DATA.L   ;BRANCH0
                    BRA         END_DECODE

                    JSR         BRANCH1.L
                    BRA         END_DECODE
                    JSR         BRANCH1.L
                    BRA         END_DECODE
                    JSR         BRANCH1.L
                    BRA         END_DECODE

                    JSR         BRANCH4.L
                    BRA         END_DECODE
                    
                    JSR         MAIN_DATA.L   ;BRANCH5
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L   ;BRANCH6
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L   ;BRANCH7
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L   ;BRANCH8
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L   ;BRANCH9
                    BRA         END_DECODE
                    
                    JSR         MAIN_DATA.L
                    BRA         END_DECODE
                    JSR         MAIN_DATA.L
                    BRA         END_DECODE         

                    JSR         MAIN_DATA.L   ;BRANCH12
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L   ;BRANCH13
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L   ;BRANCH14
                    BRA         END_DECODE

                    JSR         MAIN_DATA.L
                    BRA         END_DECODE                 
                    
MAIN_DATA                    
                    JSR         PREP_DATA
                    JSR         PRINTOP
                    
                    ADDQ.W      #2, A6
                    RTS
                    
                
                
END_DECODE          MOVEM.L     (SP)+, D0-D7/A0-A5  * Restore register state
                    RTS




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
