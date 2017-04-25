*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
OPADDR      DS.L    1                       ; The address the current opcode starts at
OPSTRING    DS.L    1                       ; The address of the string to output
NUMOPERANDS DC.B    0                       ; The number of operands the current opcode has
O1STRING    DS.B    10                      ; The string for the first operand
O2STRING    DS.B    10                      ; The string for the second operand
OPERANDSEP  DC.B    ', ', 0

NOP_OP      DC.B    'DATA', 0

**============Print Opcode===========**

PRINTOP     MOVEM.L     D0/A1, -(SP)
            MOVE.B      #14, D0

            MOVEA.L     OPADDR, A1
            TRAP        #15

            MOVEA.L     #OPTRING, A1
            TRAP        #15

            CMP.B       #0, NUMOPERANDS
            BEQ         PRINTEXIT

            MOVEA.L     O1STRING, A1
            TRAP        #15
            CMP.B       #1, NUMOPERANDS
            BEQ         PRINTEXIT

            MOVEA.L     #OPERANDSEP, A1
            TRAP        #15

            MOVEA.L     O2STRING, A1
            TRAP        #15

PRINTEXIT   MOVEM.L     (SP)+, D0/A1
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
