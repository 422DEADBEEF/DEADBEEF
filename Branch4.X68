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

            JSR         PREP_DATA

PRINT4      JSR         PRINTOP
            BRA         BRANCH4EXIT

DC_NOP      MOVE.B      #8, param1
            MOVE.L      OPADDR, param2
            MOVE.L      #OPASTRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string

            MOVE.L      #NOP_OP, OPSTRING    ; put 'NOP' into OPSTRING
            MOVE.B      #0, NUMOPERANDS     ; set number of operands as 0
            BRA         PRINT4

DC_RTS      MOVE.B      #8, param1
            MOVE.L      OPADDR, param2
            MOVE.L      #OPASTRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string

            MOVE.L      #RTS_OP, OPSTRING    ; put 'NOP' into OPSTRING
            MOVE.B      #0, NUMOPERANDS     ; set number of operands as 0
            BRA         PRINT4

BRANCH4EXIT MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
