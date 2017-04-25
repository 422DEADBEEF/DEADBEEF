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

DC_NOP

DC_RTS

BRANCH4EXIT MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
