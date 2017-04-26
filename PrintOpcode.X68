*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

**============Print Opcode===========**

PRINTOP     MOVEM.L     D0/A1, -(SP)
            MOVE.B      #14, D0

            MOVEA.L     #OPASTRING, A1
            TRAP        #15

            MOVEA.L     #SPACE, A1
            TRAP        #15

            MOVEA.L     OPSTRING, A1
            TRAP        #15

            MOVEA.L     #SPACE, A1
            TRAP        #15

            CMP.B       #0, NUMOPERANDS
            BEQ         PRINTEXIT

            MOVEA.L     #O1STRING, A1
            TRAP        #15

            MOVEA.L     #SPACE, A1
            TRAP        #15
            CMP.B       #1, NUMOPERANDS
            BEQ         PRINTEXIT

            MOVEA.L     #OPERANDSEP, A1
            TRAP        #15

            MOVEA.L     #O2STRING, A1
            TRAP        #15

PRINTEXIT   MOVEA.L     #NEWLINE, A1
            TRAP        #15
            MOVEM.L     (SP)+, D0/A1
            RTS


PREP_DATA   MOVEM.L     A0, -(SP)
            MOVE.B      #8, param1
            MOVE.L      OPADDR, param2
            MOVE.L      #OPASTRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string

            MOVE.B      #4, param1
            MOVEA.L     OPADDR, A0
            MOVE.L      (A0), param2
            MOVE.L      #O1STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string

            MOVE.L      #NO_OP, OPSTRING    ; put 'DATA' into OPSTRING
            MOVE.B      #1, NUMOPERANDS     ; set number of operands as 1
            MOVEM.L     (SP)+, A0
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
