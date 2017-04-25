*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: Covers:
* NOP, RTS, JSR, MOVEM, and LEA (possibly ERROR)
*-----------------------------------------------------------

OPADDR      DS.L    1                       ; The address the current opcode starts at
OPSTRING    DS.L    1                       ; The address of the string to output
NUMOPERANDS DC.B    0                       ; The number of operands the current opcode has
O1STRING    DS.B    10                      ; The string for the first operand
O2STRING    DS.B    10                      ; The string for the second operand

BRANCH4     MOVEM.L     D0-D7/A0-A5, -(SP)
            CMP.W       %0100111001110001, (A6)
            BEQ         DC_NOP
            CMP.W       %0100111001110101, (A6)+
            BEQ         DC_RTS

            JSR         PREP_DATA

PRINT4      JSR         PRINTOP
            BRANCH4     BRANCH4EXIT

DC_NOP

DC_RTS

BRANCH4EXIT MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS
