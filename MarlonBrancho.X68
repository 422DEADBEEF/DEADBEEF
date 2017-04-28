*-----------------------------------------------------------
* Title       : Marlon Branch0
* Written by  : Ryan Berge
* Date        : April 27th, 2017
* Description : Decodes SUBI and ADDI
*-----------------------------------------------------------

BRANCH0
                    MOVEM.L     D0-D7/A0-A5, -(SP)
                    MOVE.W      (A6)+, D0
                    MOVE.W      D0, D1
                    
                    
                    AND.W       #B0_SUBI_MASK, D1
                    CMP.W       #B0_SUBI_MASK, D1
                    BEQ         ADDI_OPCODE
                    
                    
END_BRANCH0         MOVEM.L     (SP)+, D0-D7/A0-A5
                    RTS
                    
B0_SUBI_MASK        EQU     %0000001000000000















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
