*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

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
