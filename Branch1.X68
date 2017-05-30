*-----------------------------------------------------------
* Title       : Decode Move and MoveA
* Written by  : Ryan Berge
* Date        : April 25th, 2017
* Description : Decodes Move and MoveA
*-----------------------------------------------------------

*asdasdasdasd

BRANCH1             
                        MOVEM.L     D0-D7/A0-A5, -(SP)
                        MOVE.W      (A6)+, D0
                        MOVE.W      D0, D1
                        
                         * Determine Move vs MoveA

                    
                        AND.W       #B1_MOVEA_MASK, D1
                        CMP.W       #B1_MOVEA_IDENTIFIER, D1
                        BEQ         MOVEA_OPCODE

MOVE_OPCODE             MOVE.B      #1, D7          * D7 = 1 means this is MOVE
                        MOVE.W      D0, D1
                        AND.W       MASK_OPSIZE, D1
                        LSR.L       #8, D1
                        LSR.L       #4, D1
                        CMP.W       #1, D1
                        BEQ         MOVE_B
                        CMP.W       #3, D1
                        BEQ         MOVE_W
                        CMP.W       #2, D1
                        BEQ         MOVE_L
                        BRA         END_BRANCH1



MOVEA_OPCODE            MOVE.B      #2, D7          * D7 = 2 means this is MOVEA
                        MOVE.W      D0, D1
                        AND.W       MASK_OPSIZE, D1
                        LSR.L       #8, D1
                        LSR.L       #4, D1
                        
                        CMP.W       #1, D1
                        BEQ         B1_DATA
                        CMP.W       #3, D1
                        BEQ         MOVEA_W
                        CMP.W       #2, D1
                        BEQ         MOVEA_L
                        BRA         END_BRANCH1
                    

MOVE_B                  MOVE.L      #MOVEB_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        MOVE.B      #1, D6
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVE_W                  MOVE.L      #MOVEW_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        MOVE.B      #1, D6
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVE_L                  MOVE.L      #MOVEL_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        MOVE.B      #2, D6
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVEA_W                 MOVE.L      #MOVEAW_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        MOVE.B      #1, D6
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVEA_L                 MOVE.L      #MOVEAL_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        MOVE.B      #2, D6
                        BRA         B1_DETERMINE_OPERANDS
                        
                        
B1_DETERMINE_OPERANDS
                        
                        
                        MOVE.W      D0, D1
                        AND.W       #SRCREG_MASK, D1
                        MOVE.W      D0, D2
                        AND.W       #SRCMODE_MASK, D2
                        LSR.L       #3, D2
                        * Lower 3 bits of D1 = source register
                        * Lower 3 bits of D2 = source mode
                        MOVE.B      D1, param1
                        MOVE.B      D2, param2
                        LEA         O1STRING, A1
                        MOVE.L      A1, param3
                        JSR         DECODE_ADDRESS_MODE_AM
                        MOVE.B      ret, D3                  * ret, param1
                        
                        CMP.B       #4, ret
                        BRA         B1_DATA
                              
                        MOVE.W      D0, D1
                        AND.W       #DSTREG_MASK, D1
                        LSR.L       #8, D1
                        LSR.L       #1, D1
                        MOVE.W      D0, D2
                        AND.W       #DSTMODE_MASK, D2
                        LSR.L       #6, D2
                        * Lower 3 bits of D1 = source register
                        * Lower 3 bits of D2 = source mode
                        MOVE.B      D1, param1
                        MOVE.B      D2, param2
                        LEA         O2STRING, A1
                        MOVE.L      A1, param3
                        JSR         DECODE_ADDRESS_MODE_AM
                        
                        CMP.B       #4, ret
                        BRA         B1_DATA
                        
                        MOVE.B      D3, param1
                        MOVE.B      ret, param2
                        MOVE.B      D6, param3
                        MOVE.B      #1, param4
                        
                        CMP.B       #3, param2
                        BEQ         B1_DATA
                        
                        
                        JSR         PREP_OPERANDS
                        
                        JSR         PRINTOP
                        BRA         END_BRANCH1

       
B1_DATA                 JSR         PREP_DATA
                        BRA         B1_PRINT


B1_CONTINUE
                        CLR         D0
                        MOVE.B      #8, param1
                        MOVE.L      OPADDR, param2
                        MOVE.L      #OPASTRING, param3
                        JSR         HEX_TO_STRING_SC    ; build opcode address as a string

                        
B1_PRINT                JSR         PRINTOP
                    
END_BRANCH1             MOVEM.L     (SP)+, D0-D7/A0-A5
                        RTS


B1_MOVEA_MASK           EQU     %0000000111000000
B1_MOVEA_IDENTIFIER     EQU     %0000000001000000
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
