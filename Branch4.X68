*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: Covers:
* NOP, RTS, JSR, MOVEM, and LEA (possibly ERROR)
*-----------------------------------------------------------

BRANCH4     MOVEM.L     D0-D7/A0-A5, -(SP)
            MOVE.W      (A6)+, D0
            CMP.W       #%0100111001110001, D0
            BEQ         DC_NOP
            CMP.W       #%0100111001110101, D0
            BEQ         DC_RTS
            MOVE.W      D0,D1
            AND.W       #B4_JSR_MASK, D1
            CMP.W       #B4_JSR_MASK, D1
            BEQ         DC_JSR




            JSR         PREP_DATA
PRINT4      JSR         PRINTOP
            BRA         BRANCH4EXIT

DC_NOP      MOVE.L      #NOP_OP, OPSTRING    ; put 'NOP' into OPSTRING
            MOVE.B      #0, NUMOPERANDS     ; set number of operands as 0
            BRA         PRINT4

DC_RTS      MOVE.L      #RTS_OP, OPSTRING    ; put 'NOP' into OPSTRING
            MOVE.B      #0, NUMOPERANDS     ; set number of operands as 0
            BRA         PRINT4

DC_JSR      JSR         PREP_DATA
            MOVE.L      #JSR_OP, OPSTRING
            BRA         PRINT4

BRANCH4EXIT MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS


B4_JSR_MASK             EQU     %0100111010000000
B4_MOVEM_MASK           EQU     %0100100010000000
B4_LEA_MASK             EQU     %0100000111000000


B4_MOVEA_IDENTIFIER     EQU     %0000000001000000


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
