*-----------------------------------------------------------
* Title      : Branch 5 Decode Subroutines
* Written by : Jeremy DeHaan
* Date       : 05/29/2017
* Description: ADDQ
*-----------------------------------------------------------

BRANCH5     MOVEM.L     D0-D7/A0-A5, -(SP)
            MOVE.W      (A6)+, D0

            MOVE.W      D0, D1
            AND.W       #B5_ADDQ_MASK, D1
            CMP.W       #B5_ADDQ_VAL, D1
            BEQ         DC_ADDQ

B5_DATA     JSR         PREP_DATA
B5_PRINT    JSR         PRINTOP
            BRA         BRANCH4EXIT



DC_ADDQ     MOVE.W      D0, D1
            CLR         D2
            AND.W       #B5_DATA_MASK, D1
            ROL.W       #7, D1
            MOVE.B      D1, D2              ; D2 is data
            CMP.B       #0, D2
            BNE         B5_DATA_H
            ADDQ.B      #8, D2


B5_DATA_H   ADD.B       #$30, D2            ;create hex representation of the number


            MOVE.W      D0, D1
            CLR         D3
            AND.W       #B5_SIZE_MASK, D1
            ROR.W       #6, D1
            MOVE.B      D1, D3              ; D3 is size

            MOVE.W      D0, D1
            CLR         D4
            AND.W       #B5_DEST_MODE_MASK, D1
            ROR.W       #3, D1
            MOVE.B      D1, D4              ; D4 is mode

            MOVE.W      D0, D1
            CLR         D5
            AND.W       #B5_DEST_REG_MASK, D1
            MOVE.B      D1, D5              ; D5 is register

            MOVE.B      #2, NUMOPERANDS

            ;if we have a size code of 11, this is not a valid opcode
            CMP.B       #%11, D3
            BEQ         B5_DATA

            CMP.B       #1, D4              ; check if we're accessing an address register
            BNE         B5_DECODE
            CMP.B       #0, D3              ; and we have a size of byte
            BEQ         B5_DATA             ; then we have an invalid opcode

B5_DECODE   JSR         DC_ADDQ_SZ

            ; put the data into O1String
            MOVEA.L     #O1String, A0
            MOVE.B      #$23, (A0)+
            MOVE.B      D2, (A0)+
            MOVE.B      #0, (A0)

            ; put the ea into O2String
            MOVE.B      D5, param1
            MOVE.B      D4, param2
            MOVE.L      #O2String, param3
            JSR         DECODE_ADDRESS_MODE_AM

            MOVE.B      ret, D1
            ASL.W       #2, D1
            LEA         B5_JMPTBL, A0
            JMP         0(A0, D1)


B5_JMPTBL   BRA DC_ADDQ_AM
            BRA DC_ADDQ_WA
            BRA DC_ADDQ_LA
            BRA B5_DATA
            BRA B5_DATA

DC_ADDQ_AM  BRA B5_PRINT


DC_ADDQ_WA  MOVE.B      #4, param1
            CLR         D6
            MOVE.W      (A6)+, D6
            MOVE.L      D6, param2
            MOVE.L      #O2STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B5_PRINT


DC_ADDQ_LA  MOVE.B      #8, param1
            CLR         D6
            MOVE.L      (A6)+, D6
            MOVE.L      D6, param2
            MOVE.L      #O2STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B5_PRINT


DC_ADDQ_SZ  CMP.B       #0, D3
            BEQ         ADDQ_B
            CMP.B       #1, D3
            BEQ         ADDQ_W

            MOVE.L      #ADDQL_OP, OPSTRING
            RTS

ADDQ_B      MOVE.L      #ADDQB_OP, OPSTRING
            RTS

ADDQ_W      MOVE.L      #ADDQW_OP, OPSTRING
            RTS



B5_ADDQ_MASK            EQU     %1111000100000000
B5_ADDQ_VAL             EQU     %0101000000000000


B5_DATA_MASK            EQU     %0000111000000000
B5_SIZE_MASK            EQU     %0000000011000000

B5_DEST_MODE_MASK       EQU     %0000000000111000
B5_DEST_REG_MASK        EQU     %0000000000000111






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
