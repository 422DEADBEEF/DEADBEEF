*-----------------------------------------------------------
* Title      : DEADBEEF Dissasembler
* Written by : AddressModes
* Date       : 04/27/2017
* Description: Subroutines for decoding an addressing mode
*              and building address mode strings
*-----------------------------------------------------------

*******************************************
*** FUNCTION: DecodeAddressMode
***     Args: param1 (BYTE): Register Code
***           param2 (BYTE): Mode Code
***           param3 (LONG): Address buffer to build string
*******************************************

*** EQUATES ***
LETTER_OFFSET_DC    EQU     $41
NUMBER_OFFSET_DC    EQU     $30
AM_An               EQU     $04
AM_Indir            EQU     $46
AM_IndirPost        EQU     $C6
AM_INdirPre         EQU     $47
AM_Num              EQU     $38

DECODE_ADDRESS_MODE_AM
        MOVEM.L     A0-A1/D0-D1, -(SP)
        MOVE.B      param1, D0
        LSL.B       #3, D0
        MOVE.B      param2, D1
        MOVEA.L     param3, A0
        
        MULS.W      #6, D1
        LEA         JUMP_TABLE_AM, A1
        JMP         0(A1, D1)
        
        
JUMP_TABLE_AM
        JMP     DATA_REG_DIRECT_DC.L
        JMP     ADDR_REG_DIRECT_DC.L
        JMP     ADDR_REG_INDIRECT_DC.L
        JMP     ADDR_REG_INDIRECTwPOST_DC.L
        JMP     ADDR_REG_INDIRECTwPRE_DC.L
        JMP     INVALID_DC.L
        JMP     INVALID_DC.L
        JMP     ABSIM_DC.L
        
DATA_REG_DIRECT_DC
        BRA     END_AM_DC
        
ADDR_REG_DIRECT_DC
        ADD.B   #AM_An, D0
        BRA     END_AM_DC

ADDR_REG_INDIRECT_DC
        ADD.B   #AM_Indir, D0
        BRA     END_AM_DC

ADDR_REG_INDIRECTwPOST_DC
        ADD.B   #AM_IndirPost, D0
        BRA     END_AM_DC

ADDR_REG_INDIRECTwPRE_DC
        ADD.B   #AM_IndirPre, D0
        BRA     END_AM_DC
        
ABSIM_DC
        LSR.B   #3, D0
        CMP.B   #2, D0
        BEQ     INVALID_DC
        CMP.B   #3, D0
        BEQ     INVALID_DC
        CMP.B   #4, D0
        BGT     INVALID_DC
        BNE     NOT_4_DC
        
        MOVE.B  #2, D0
        
NOT_4_DC
        MOVE.B  D0, ret
        BRA     NO_BUILD_DC
        
INVALID_DC       *** CATCH CRASH? ***
        MOVE.B  #4, ret
        MOVE.L  $1001, D0   ; CRASH PROGRAM, KEEP?        
        BRA     NO_BUILD_DC

END_AM_DC
        MOVE.L  param3, param1
        MOVE.B  D0, param2
        JSR     BUILD_AM_STRING

NO_BUILD_DC
        MOVEM.L (SP)+, A0-A1/D0-D1
        RTS

******************************************
*** FUNCTION: Build AddressMode String ***
***     Args: Param1 (LONG): Address of the buffer to build the string in
***           Param2 (BYTE): [+][)][#][#][#][X][(][-]    (It's my special Byte)
******************************************

BUILD_AM_STRING
        MOVEM.L     A0/D0-D2, -(SP)
        CLR.L       D2
        MOVEA.L     Param1, A0
        MOVE.B      Param2, D0
        
        MOVE.L      D0, D1
        AND.B       #AM_Num, D1
        LSR.B       #3, D1
        ADD.B       #NUMBER_OFFSET_DC, D1
        
        LSR.B       #1, D0
        BCC         NO_MINUS_DC
        
        MOVE.B      #$2D, (A0)+
        
NO_MINUS_DC
        LSR.B       #1, D0
        BCC         NO_OPPAREN_DC
        
        MOVE.B      #$28, (A0)+
        
NO_OPPAREN_DC
        LSR.B       #1, D0
        BCS         IS_An_DC
        
        ADDQ.B      #3, D2
        
IS_An_DC
        ADD.B       #LETTER_OFFSET_DC, D2
        MOVE.B      D2, (A0)+
        
        MOVE.B      D1, (A0)+                           ; ADD THE REGISTER NUMBER
        
        LSR.B       #4, D0
        BCC         NO_CLPAREN_DC
        
        MOVE.B      #$29, (A0)+
        
NO_CLPAREN_DC
        LSR.B       #1, D0
        BCC         NO_PLUS_DC
        
        MOVE.B      #$2B, (A0)+
        
NO_PLUS_DC
        MOVE.B      #0, (A0)+
        
        MOVEM.L     (SP)+, A0/D0-D2
        RTS
        
        
        






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
