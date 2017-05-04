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
                    
                    AND.W       #B0_ERROR_CHECK, D1
                    CMP.W       #%0000010000000000, D1
                    BNE         B0_DATA
                    
                    MOVE.W      D0, D1
                    AND.W       #B0_SUBI_MASK, D1
                    CMP.W       #B0_SUBI_MASK, D1
                    BNE         SUBI_OPCODE
                    
ADDI_OPCODE
                    MOVE.W      D0, D1
                    AND.W       #B0_SIZE_MASK, D1
                    LSR.L       #6, D1
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
                    LSR.L       #6, D1
                    CMP.W       #0, D1
                    BEQ         B0_SUBI_B
                    CMP.W       #1, D1
                    BEQ         B0_SUBI_W
                    CMP.W       #2, D1
                    BEQ         B0_SUBI_L
                    BEQ         B0_DATA
                    
B0_ADDI_B           MOVE.L      #ADDIB_OP, OPSTRING
                    MOVEQ       #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_ADDI_W           MOVE.L      #ADDIW_OP, OPSTRING
                    MOVEQ       #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_ADDI_L           MOVE.L      #ADDIL_OP, OPSTRING
                    MOVEQ       #2, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS


B0_SUBI_B           MOVE.L      #SUBIB_OP, OPSTRING
                    MOVEQ       #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_SUBI_W           MOVE.L      #SUBIW_OP, OPSTRING
                    MOVEQ       #1, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS
B0_SUBI_L           MOVE.L      #SUBIL_OP, OPSTRING
                    MOVEQ       #2, D6                  * Number of words to read
                    BRA         B0_DETERMINE_OPERANDS


B0_DETERMINE_OPERANDS
                    MOVE.B      #4, param1      * register code for immediate addressing
                    MOVE.B      #7, param2      * mode code for immediate addressing
                    LEA         O1STRING, A1
                    MOVE.L      A1, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    MOVE.B      ret, D3         * op1 mode
                    
                    
                    MOVE.W      D0, D1
                    AND.W       MASK_DSTREG, D1     * register
                    MOVE.W      D0, D2              
                    AND.W       MASK_DSTMODE, D2    * mode
                    LSR.L       #3, D2
                    
                    MOVE.B      D1, param1          * register code
                    MOVE.B      D2, param2          * mode code
                    LEA         O2STRING, A1
                    MOVE.L      A1, param3
                    JSR         DECODE_ADDRESS_MODE_AM
                    
                    MOVE.B      D3, param1
                    MOVE.B      ret, param2
                    MOVE.B      D6, param3
                    MOVE.B      #1, param4
                    
                    JSR         PREP_OPERANDS

                    JSR         PRINTOP
                    BRA         END_BRANCH0
  
                    
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
