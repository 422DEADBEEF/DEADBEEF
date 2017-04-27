*-----------------------------------------------------------
* Title       : Decode Move and MoveA
* Written by  : Ryan Berge
* Date        : April 25th, 2017
* Description : Decodes Move and MoveA
*-----------------------------------------------------------



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
                        * figure out O1String
                        * figure out O2String
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVE_W                  MOVE.L      #MOVEW_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        * figure out O1String
                        * figure out O2String
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVE_L                  MOVE.L      #MOVEL_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        * figure out O1String
                        * figure out O2String
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVEA_W                 MOVE.L      #MOVEAW_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        * figure out O1String
                        * figure out O2String
                        BRA         B1_DETERMINE_OPERANDS
                        
MOVEA_L                 MOVE.L      #MOVEAL_OP, OPSTRING
                        MOVE.B      #2, NUMOPERANDS
                        * figure out O1String
                        * figure out O2String
                        BRA         B1_DETERMINE_OPERANDS
                        
                        
B1_DETERMINE_OPERANDS
                        
                        MOVE.W      D0, D1
                        AND.W       MASK_DSTREG, D1
                        MOVE.W      D0, D2
                        AND.W       MASK_DSTMODE, D2
                        LSR.L       #3, D2
                        * Lower 3 bits of D1 = source register
                        * Lower 3 bits of D2 = source mode
                        MOVE.W      D0, param1
                        MOVE.W      D1, param2
                        MOVE.W      D2, param3
                        JSR         WRITE_OPERAND * Writes to TMPSTRING
                        
                        LEA         TMPSTRING, A0
                        LEA         O1STRING, A1
                        
                        MOVE.L      (A0)+, (A1)+
                        MOVE.L      (A0)+, (A1)+
                        MOVE.W      (A0)+, (A1)+
                        
                        
                        MOVE.W      D0, D1
                        AND.W       MASK_SRCREG, D1
                        LSR.L       #8, D1
                        LSR.L       #1, D1
                        MOVE.W      D0, D2
                        AND.W       MASK_SRCMODE, D2
                        LSR.L       #6, D2
                        * Lower 3 bits of D1 = source register
                        * Lower 3 bits of D2 = source mode
                        MOVE.W      D0, param1
                        MOVE.W      D1, param2
                        MOVE.W      D2, param3
                        JSR         WRITE_OPERAND * Writes to TMPSTRING
                        
                        LEA         TMPSTRING, A0
                        LEA         O2STRING, A1
                        
                        MOVE.L      (A0)+, (A1)+
                        MOVE.L      (A0)+, (A1)+
                        MOVE.W      (A0)+, (A1)+
                        
                        
                        
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
