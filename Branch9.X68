*-----------------------------------------------------------
* Title      : Branch 9 Decode Subroutines
* Written by : Jeremy DeHaan
* Date       : 05/16/2017
* Description: SUB (possibly DATA)
*-----------------------------------------------------------

BRANCH9     MOVEM.L     D0-D7/A0-A5, -(SP)
            MOVE.W      (A6)+, D0

DC_SUB      MOVE.B      #2, NUMOPERANDS         ; do this here now, if it is data, it will be reset
            CLR         D1
            MOVE.W      D0, D1
            AND.W       #B9_REG_NUM_MASK, D1
            ROL.W       #7, D1                  ; Register Number

            CLR         D2
            MOVE.W      D0, D2
            AND.W       #B9_OPMODE_MASK, D2
            LSR.W       #6, D2                  ; Opmode

            CLR         D3
            MOVE.W      D0, D3
            AND.W       #B9_EA_MODE_MASK, D3
            LSR.W       #3, D3                  ; Effective Address Mode

            CLR         D4
            MOVE.W      D0, D4
            AND.W       #B9_EA_REG_MASK, D4     ; Effective Address Register


            MOVE.B      D2, D5
            AND.B       #B9_DEST_TEST, D5
            CMP.B       #0, D5
            BEQ         D_DEST
            BRA         EA_DEST

B9_DATA     JSR         PREP_DATA
B9_PRINT    JSR         PRINTOP
            MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS

; A1 is the location of the string for the Data Register
; A2 is the location of the string for the Effective Address

D_DEST      LEA         O2STRING, A1
            LEA         O1STRING, A2
            CLR         D7
            BRA         B9_PRINT_PREP

EA_DEST     LEA         O2STRING, A2
            LEA         O1STRING, A1
            MOVE.B      #1, D7

B9_PRINT_PREP
            MOVE.B      D2, D5
            AND.B       #%011, D5
            CMP.B       #%11, D5
            BEQ         B9_DATA
            JSR         DC_SUB_SZ

            ; Decode Data Register
            MOVE.B      #$44, (A1)+             ; put a D into the string
            ADD.B       #$30, D1
            MOVE.B      D1, (A1)+               ; put the register num into the string
            MOVE.B      #0, (A1)

            ; Decode Effective Address
            MOVE.B      D4, param1
            MOVE.B      D3, param2
            MOVE.L      A2, param3
            JSR         DECODE_ADDRESS_MODE_AM

            CLR.L       D0
            MOVE.B      ret, D0
            ASL.W       #2, D0
            LEA         B9_JMPTBL, A0
            JMP         0(A0, D0)

B9_JMPTBL   BRA DC_SUB_AM
            BRA DC_SUB_WA
            BRA DC_SUB_LA
            BRA DC_SUB_ID
            BRA B9_DATA


DC_SUB_AM   BRA B9_PRINT


DC_SUB_WA   MOVE.B      #4, param1
            CLR         D6
            MOVE.W      (A6)+, D6
            MOVE.L      D6, param2
            MOVE.L      A2, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B9_PRINT


DC_SUB_LA   MOVE.B      #8, param1
            CLR         D6
            MOVE.L      (A6)+, D6
            MOVE.L      D6, param2
            MOVE.L      A2, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B9_PRINT


DC_SUB_ID   CMP.B       #1, D7              ; check if 1 is in D7 (it shouldn't be)
            BEQ         B9_DATA

            ;if D6 == 0
            CMP.B       #0, D6
            BEQ         ID_B
            ;else if D6 == 1
            CMP.B       #1, D6
            BEQ         ID_W

            ;else

            ;if long
            MOVE.B      #$23, (A2)+
            BRA         DC_SUB_LA

ID_W        MOVE.B      #$23, (A2)+
            BRA         DC_SUB_WA


ID_B        MOVE.B      #$23, (A2)+
            MOVE.B      #2, param1
            CLR         D6
            MOVE.W      (A6)+, D6
            MOVE.L      D6, param2
            MOVE.L      A2, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B9_PRINT




DC_SUB_SZ   CMP.B       #0, D5
            BEQ         SUB_B
            CMP.B       #1, D5
            BEQ         SUB_W

            MOVE.L      #SUBL_OP, OPSTRING
            MOVE.B      #2, D6
            RTS

SUB_B       MOVE.L      #SUBB_OP, OPSTRING
            CLR         D6
            RTS

SUB_W       MOVE.L      #SUBW_OP, OPSTRING
            MOVE.B      #1, D6
            RTS



B9_REG_NUM_MASK         EQU     %0000111000000000
B9_OPMODE_MASK          EQU     %0000000111000000

B9_EA_MODE_MASK         EQU     %0000000000111000
B9_EA_REG_MASK          EQU     %0000000000000111

B9_DEST_TEST            EQU     %100





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
