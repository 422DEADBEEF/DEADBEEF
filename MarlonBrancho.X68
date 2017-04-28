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
                    
                    MOVE.B      #2, NUMOPERANDS
                    
                    AND.W       #B0_ERROR_CHECK
                    CMP.W       #%0000010000000000
                    BEQ         B0_DATA
                    
                    MOVE.W      D0, D1
                    AND.W       #B0_SUBI_MASK, D1
                    CMP.W       #B0_SUBI_MASK, D1
                    BEQ         ADDI_OPCODE
                    
ADDI_OPCODE
                    MOVE.W      D0, D1
                    AND.W       #B0_SIZE_MASK, D1
                    LSL.L       #6, D1
                    CMP.W       #0, D1
                    BEQ         B0_ADDI_B
                    CMP.W       #1, D1
                    BEQ         B0_ADDI_W
                    CMP.W       #2, D1
                    BEQ         B0_ADDI_L
                    BEQ         B0_DATA

SUBI_OPCODE
                    MOVE.W      D0, D1
                    AND.W       #B0_SIZE_MASK, D1
                    LSL.L       #6, D1
                    CMP.W       #0, D1
                    BEQ         B0_SUBI_B
                    CMP.W       #1, D1
                    BEQ         B0_SUBI_W
                    CMP.W       #2, D1
                    BEQ         B0_SUBI_L
                    BEQ         B0_DATA
                    
B0_ADDI_B           MOVE.L      #ADDIB_OP, OPSTRING
                    MOVEQ.B     #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_ADDI_W           MOVE.L      #ADDIW_OP, OPSTRING
                    MOVEQ.B     #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_ADDI_L           MOVE.L      #ADDIL_OP, OPSTRING
                    MOVEQ.B     #2, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS


B0_SUBI_B           MOVE.L      #ADDIB_OP, OPSTRING
                    MOVEQ.B     #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_SUBI_W           MOVE.L      #ADDIW_OP, OPSTRING
                    MOVEQ.B     #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_SUBI_L           MOVE.L      #ADDIL_OP, OPSTRING
                    MOVEQ.B     #2, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS


B0_DETERMINE_OPERANDS
                    *******************
                    
                    
B0_DATA             JSR         PREP_DATA
                    BRA         B0_PRINT
                    
B0_CONTINUE
                    *******************
                    
B0_PRINT            JSR         PRINTOP                    
                    
END_BRANCH0         MOVEM.L     (SP)+, D0-D7/A0-A5
                    RTS
                    
B0_SUBI_MASK        EQU     %0000001000000000
B0_SIZE_MASK        EQU     %0000000011000000
B0_ERROR_CHECK      EQU     %1111110100000000















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
