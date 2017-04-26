*-----------------------------------------------------------
* Title       : Decode Move and MoveA
* Written by  : Ryan Berge
* Date        : 
* Description : 
*-----------------------------------------------------------



BRANCH1             
                        MOVEM.L     D0-D7/A0-A5, -(SP)
                        MOVE.W      (A6)+, D0
                        MOVE.W      D0, D1
                        
                         * Determine Move vs MoveA

                    
                        AND.W       #B1_MOVEA_MASK, D1
                        CMP.W       #B1_MOVEA_IDENTIFIER, D1
                        BEQ         MOVEA_OPCODE

MOVE_OPCODE             MOVE.W      D0, D1
                        AND.W       #MASK_OPSIZE, D1
                        CMP.W       #1, D1
                        BEQ         MOVE_B
                        CMP.W       #3, D1
                        BEQ         MOVE_W
                        CMP.W       #2, D1
                        BEQ         MOVE_L
                        BRA         END_BRANCH1



MOVEA_OPCODE            MOVE.W      D0, D1
                        AND.W       #MASK_OPSIZE, D1
                        CMP.W       #1, D1
                        BEQ         MOVEA_B
                        CMP.W       #3, D1
                        BEQ         MOVEA_W
                        CMP.W       #2, D1
                        BEQ         MOVEA_L
                        BRA         END_BRANCH1
                    

MOVE_B                  MOVE.L      #MOVEB_OP, OPSTRING
                        MOVE.B      #0, NUMOPERANDS
                        * figure out O1String
                        * figure out O2String
                        BRA         B1_CONTINUE
MOVE_W
MOVE_L

MOVEA_B
MOVEA_W
MOVEA_L

B1_CONTINUE
                        JSR     PRINTOP
                    
END_BRANCH1             MOVEM.L     (SP)+, D0-D7/A0-A5
                        RTS

B1_MOVEA_MASK           EQU     %0000000111000000
B1_MOVEA_IDENTIFIER     EQU     %0000000001000000





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
