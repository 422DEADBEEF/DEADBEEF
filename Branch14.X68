*-----------------------------------------------------------
* Title      : Branch 14 Decode Subroutines
* Written by : Jeremy DeHaan
* Date       : 05/22/2017
* Description: ASd, LSd, ROd, and possibly data
*-----------------------------------------------------------

BRANCH14    MOVEM.L     D0-D7/A0-A5, -(SP)
            MOVE.W      (A6)+, D0


DC_DR_OR_EA CLR         D1
            MOVE.W      D0, D1
            AND.W       #B14_DATA_OR_EA_MASK, D1
            CMP.W       #B14_DATA_OR_EA_MASK, D1
            BEQ         DC_SR_TYPE_EA
            BRA         DC_SR_TYPE_DR


B14_DATA    JSR         PREP_DATA
B14_PRINT   JSR         PRINTOP
            MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS

*Decode shift or rotate type for ones working on a data register
DC_SR_TYPE_DR
            MOVE.B      #2, NUMOPERANDS         ; do this here now, if it is data, it will be reset
            MOVE.W      D0, D1
            AND.W       #B14_SHIFT_ROT_DR_MASK, D1
            CMP.W       #B14_LS_DR_MASK, D1
            BEQ         B14_LS_DR
            CMP.W       #B14_RO_DR_MASK, D1
            BEQ         B14_RO_DR
            CMP.W       #B14_AS_DR_MASK, D1
            BEQ         B14_AS_DR
            BRA         B14_DATA                    ;if it's nothing, print data


;get size for Logial Shift on a data register
B14_LS_DR   MOVE.W      D0, D1
            AND.W       #B14_SIZE_DR_MASK, D1
            CMP.W       #B14_WSIZE_DR_MASK, D1
            BEQ         B14_LS_DR_W
            CMP.W       #B14_LSIZE_DR_MASK, D1
            BEQ         B14_LS_DR_L
            CMP.W       #B14_BSIZE_DR_MASK, D1
            BEQ         B14_LS_DR_B
            BRA         B14_DATA

;get the direction for a logical shift on a byte
B14_LS_DR_B MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_LSL_DR_B

;set the string for the LSR.B opcode working on a data register
B14_LSR_DR_B
            MOVE.L      #LSRB_OP, OPSTRING
            BRA         B14_DR_DC
;set the string for the LSL.B opcode working on a data register
B14_LSL_DR_B
            MOVE.L      #LSLB_OP, OPSTRING
            BRA         B14_DR_DC

;get the direction for a logical shift on a word
B14_LS_DR_W MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_LSL_DR_W

;set the string for the LSR.W opcode working on a data register
B14_LSR_DR_W
            MOVE.L      #LSRW_OP, OPSTRING
            BRA         B14_DR_DC

;set the string for the LSL.W opcode working on a data register
B14_LSL_DR_W
            MOVE.L      #LSLW_OP, OPSTRING
            BRA         B14_DR_DC


;get the direction for a logical shift on a long
B14_LS_DR_L MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_LSL_DR_L

;set the string for the LSR.W opcode working on a data register
B14_LSR_DR_L
            MOVE.L      #LSRL_OP, OPSTRING
            BRA         B14_DR_DC

;set the string for the LSL.W opcode working on a data register
B14_LSL_DR_L
            MOVE.L      #LSLL_OP, OPSTRING
            BRA         B14_DR_DC


;get size for Rotate on a Data Register
B14_RO_DR   MOVE.W      D0, D1
            AND.W       #B14_SIZE_DR_MASK, D1
            CMP.W       #B14_WSIZE_DR_MASK, D1
            BEQ         B14_RO_DR_W
            CMP.W       #B14_LSIZE_DR_MASK, D1
            BEQ         B14_RO_DR_L
            CMP.W       #B14_BSIZE_DR_MASK, D1
            BEQ         B14_RO_DR_B
            BRA         B14_DATA

;get the direction for a logical shift on a byte
B14_RO_DR_B MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ROL_DR_B

;set the string for the ROR.B opcode working on a data register
B14_ROR_DR_B
            MOVE.L      #RORB_OP, OPSTRING
            BRA         B14_DR_DC
;set the string for the ROL.B opcode working on a data register
B14_ROL_DR_B
            MOVE.L      #ROLB_OP, OPSTRING
            BRA         B14_DR_DC

;get the direction for a logical shift on a word
B14_RO_DR_W MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ROL_DR_W

;set the string for the ROR.W opcode working on a data register
B14_ROR_DR_W
            MOVE.L      #RORW_OP, OPSTRING
            BRA         B14_DR_DC

;set the string for the ROL.W opcode working on a data register
B14_ROL_DR_W
            MOVE.L      #ROLW_OP, OPSTRING
            BRA         B14_DR_DC


;get the direction for a logical shift on a long
B14_RO_DR_L MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ROL_DR_L

;set the string for the ROR.W opcode working on a data register
B14_ROR_DR_L
            MOVE.L      #RORL_OP, OPSTRING
            BRA         B14_DR_DC

;set the string for the ROL.W opcode working on a data register
B14_ROL_DR_L
            MOVE.L      #ROLL_OP, OPSTRING
            BRA         B14_DR_DC


;get size for Rotate on a Data Register
B14_AS_DR   MOVE.W      D0, D1
            AND.W       #B14_SIZE_DR_MASK, D1
            CMP.W       #B14_WSIZE_DR_MASK, D1
            BEQ         B14_AS_DR_W
            CMP.W       #B14_LSIZE_DR_MASK, D1
            BEQ         B14_AS_DR_L
            CMP.W       #B14_BSIZE_DR_MASK, D1
            BEQ         B14_AS_DR_B
            BRA         B14_DATA

;get the direction for a logical shift on a byte
B14_AS_DR_B MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ASL_DR_B

;set the string for the ASR.B opcode working on a data register
B14_ASR_DR_B
            MOVE.L      #ASRB_OP, OPSTRING
            BRA         B14_DR_DC
;set the string for the ASL.B opcode working on a data register
B14_ASL_DR_B
            MOVE.L      #ASLB_OP, OPSTRING
            BRA         B14_DR_DC

;get the direction for a logical shift on a word
B14_AS_DR_W MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ASL_DR_W

;set the string for the ASR.W opcode working on a data register
B14_ASR_DR_W
            MOVE.L      #ASRW_OP, OPSTRING
            BRA         B14_DR_DC

;set the string for the ASL.W opcode working on a data register
B14_ASL_DR_W
            MOVE.L      #ASLW_OP, OPSTRING
            BRA         B14_DR_DC


;get the direction for a logical shift on a long
B14_AS_DR_L MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ASL_DR_L

;set the string for the ASR.W opcode working on a data register
B14_ASR_DR_L
            MOVE.L      #ASRL_OP, OPSTRING
            BRA         B14_DR_DC

;set the string for the ASL.W opcode working on a data register
B14_ASL_DR_L
            MOVE.L      #ASLL_OP, OPSTRING
            BRA         B14_DR_DC

; Create a string representation of the data register, string representation of
; what is being used for number of rotations, and then print
B14_DR_DC   MOVE.W      D0, D2
            AND.W       #%111, D2                    ; get the register bits
            LEA         O2STRING, A1
            MOVE.B      #$44, (A1)+                 ; put a 'D' in the string
            ADD.B       #$30, D2                    ; convert D2 to a ascii number
            MOVE.B      D2, (A1)+
            MOVE.B      #0, (A1)                    ; null terminate the string

            MOVE.W      D0, D2
            AND.W       #B14_REG_OR_COUNT, D2
            ROL.W       #7, D2
            MOVE.W      D0, D1                       ; check if rotation is ID or a register
            AND.W       #B14_IR_MASK, D1
            CMP.W       #B14_IR_MASK, D1
            BEQ         B14_DR_BY_REG

;Decode the immediate data used in this shift or rotation
B14_DR_BY_ID
            LEA         O1STRING, A1
            MOVE.B      #$23, (A1)+                 ; put a # in the string
            MOVE.B      #$24, (A1)+                 ; put a $ in the string
            MOVE.B      #$30, (A1)+                 ; put a 0 in the string
            ADD.B       #$30, D2                    ; convert D2 to a ascii number
            MOVE.B      D2, (A1)+
            MOVE.B      #0, (A1)                    ; null terminate the string
            BRA         B14_PRINT

;Decode the register used in this shift or rotation
B14_DR_BY_REG
            LEA         O1STRING, A1
            MOVE.B      #$44, (A1)+                 ; put a 'D' in the string
            ADD.B       #$30, D2                    ; convert D2 to a ascii number
            MOVE.B      D2, (A1)+
            MOVE.B      #0, (A1)                    ; null terminate the string
            BRA         B14_PRINT

*Decode shift or rotate type for ones working on an effective address
DC_SR_TYPE_EA
            MOVE.B      #1, NUMOPERANDS         ; do this here now, if it is data, it will be reset
            MOVE.W      D0, D1
            AND.W       #B14_SHIFT_ROT_EA_MASK, D1
            CMP.W       #B14_LS_EA_MASK, D1
            BEQ         B14_LS_EA
            CMP.W       #B14_RO_EA_MASK, D1
            BEQ         B14_RO_EA
            CMP.W       #B14_AS_EA_MASK, D1
            BEQ         B14_AS_EA
            BRA         B14_DATA

;get the direction for a logical shift on some effective address
B14_LS_EA   MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_LSL_EA

B14_LSR_EA  MOVE.L      #LSRW_OP, OPSTRING
            BRA         B14_EA_DC

B14_LSL_EA  MOVE.L      #LSLW_OP, OPSTRING
            BRA         B14_EA_DC

B14_RO_EA   MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ROL_EA

B14_ROR_EA  MOVE.L      #RORW_OP, OPSTRING
            BRA         B14_EA_DC

B14_ROL_EA  MOVE.L      #ROLW_OP, OPSTRING
            BRA         B14_EA_DC

B14_AS_EA   MOVE.W      D0, D1
            AND.W       #B14_DIR_MASK, D1
            CMP.W       #B14_LEFT_DIR, D1
            BEQ         B14_ROL_EA

B14_ASR_EA  MOVE.L      #ASRW_OP, OPSTRING
            BRA         B14_EA_DC

B14_ASL_EA  MOVE.L      #ASLW_OP, OPSTRING
            BRA         B14_EA_DC

; This just uses what ever string was in O1String last
B14_EA_DC   BRA         B14_PRINT


B14_DATA_OR_EA_MASK     EQU     %0000000011000000

B14_SHIFT_ROT_DR_MASK   EQU     %0000000000011000
B14_LS_DR_MASK          EQU     %0000000000001000
B14_RO_DR_MASK          EQU     %0000000000011000
B14_AS_DR_MASK          EQU     %0000000000000000

B14_SHIFT_ROT_EA_MASK   EQU     %0000011100000000
B14_AS_EA_MASK          EQU     %0000000000000000
B14_LS_EA_MASK          EQU     %0000000100000000
B14_RO_EA_MASK          EQU     %0000001100000000

B14_DIR_MASK            EQU     %0000000100000000
B14_LEFT_DIR            EQU     %0000000100000000



B14_SIZE_DR_MASK        EQU     %0000000011000000
B14_BSIZE_DR_MASK       EQU     %0000000000000000
B14_WSIZE_DR_MASK       EQU     %0000000001000000
B14_LSIZE_DR_MASK       EQU     %0000000010000000

B14_IR_MASK             EQU     %0000000000100000

B14_REG_OR_COUNT        EQU     %0000111000000000

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
