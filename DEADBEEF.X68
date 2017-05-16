*-----------------------------------------------------------
* Title      : DEADBEEF Dissasembler
* Written by : DEAFBEEF
* Date       : 04/20/2017
* Description: This will dissasemble the shit out of your binary.
*-----------------------------------------------------------
            ORG         $1000
START:                  ; first instruction of program
            
            MOVE.W      #$FF00, D1
            MOVE.B      #11, D0
            TRAP        #15
            
            JMP         PRGM_START

MAIN_CONTINUE
            MOVEA.L     STARTADDR, A6
            
            *----------PageSize=30-----------*
            MOVE.B      #3, D1      * counter
            MOVE.B      #30, D2     

MAIN_LOOP   CMPA.L      ENDADDR, A6
            BGE         PRGM_END
            CMP.B       D1, D2
            BLE         PAGE_BREAK
MAIN_C      JSR         DECODE
            ADDQ.B      #1, D1
            BRA         MAIN_LOOP

PAGE_BREAK
            LEA         BREAKMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            MOVE.B      #5, D0
            TRAP        #15
            MOVE.W      #$FF00, D1
            MOVE.B      #11, D0
            TRAP        #15
            MOVE.B      #0, D1
            BRA         MAIN_C
PRGM_END

            LEA         RESTMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            
            MOVE.B      #5, D0
            TRAP        #15
            
            CMP.B       #$79, D1
            BEQ         START
            
            SIMHALT                         ; halt simulator
            
            
            
PRGM_START  
            LEA         MSSG, A1            ; load the first message into A1
            MOVE.B      #14,D0              ;
            TRAP        #15                 ; display it
                        
ADDRESS_LOOP
            LEA         STARTMSSG, A1       ; load the start message into A1
            MOVE.B      #14,D0              ;
            TRAP        #15                 ; display it

            LEA         HEXINPUT, A1
            MOVE.B      #2, D0              ; set up to read a string from user
            TRAP        #15                 ; Execute Task

            MOVE.L      #STARTADDR, param1
            MOVE.B      D1, param2
            JSR         CNVFRMASCII


            LEA         ENDMSSG, A1         ; load the end message into A1
            MOVE.B      #14,D0              ;
            TRAP        #15                 ; display it

            LEA         HEXINPUT, A1
            MOVE.B      #2, D0              ; set up to read a string from user
            TRAP        #15                 ; Execute Task

            MOVE.L      #ENDADDR, param1
            MOVE.B      D1, param2
            JSR         CNVFRMASCII
            
END_ADDRESS_LOOP

            MOVE.L      STARTADDR, D3
            MOVE.L      ENDADDR, D4
            CMP.L       D3, D4
            BLE         RANGE_ERROR
            CMP.L       #$00FFFFFE, D3
            BGT         START_RANGE_ERROR
            CMP.L       #$00FFFFFE, D4
            BGT         END_RANGE_ERROR
            AND.L       #$0000FFFF, D3
            DIVU.W      #2, D3
            SWAP        D3
            CMP.W       #0, D3
            BNE         START_WORD_ALIGN_ERROR
            AND.L       #$0000FFFF, D4
            DIVU.W      #2, D4
            SWAP        D4
            CMP.W       #0, D4
            BNE         END_WORD_ALIGN_ERROR
            BRA         MAIN_CONTINUE

RANGE_ERROR 
            LEA         RANGE_ERRMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            BRA         PRINT_RESTART_MESSAGE
START_RANGE_ERROR
            LEA         START_RANGE_ERRMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            BRA         PRINT_RESTART_MESSAGE
END_RANGE_ERROR
            LEA         END_RANGE_ERRMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            BRA         PRINT_RESTART_MESSAGE
START_WORD_ALIGN_ERROR
            LEA         START_WORD_ERRMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            BRA         PRINT_RESTART_MESSAGE
END_WORD_ALIGN_ERROR
            LEA         END_WORD_ERRMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            BRA         PRINT_RESTART_MESSAGE

PRINT_RESTART_MESSAGE
            LEA         ERRMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            MOVE.B      #5, D0
            TRAP        #15
            MOVE.W      #$FF00, D1
            MOVE.B      #11, D0
            TRAP        #15
            BRA         START


*------------Subroutines---------------

            INCLUDE     "DecodeBranch.X68"
            INCLUDE     "MarlonBrancho.X68"
            INCLUDE     "Branch1.X68"
            INCLUDE     "branch4.X68"
            INCLUDE     "Branch5.X68"
            INCLUDE     "Branch6.X68"
            INCLUDE     "Branch7.X68"
            INCLUDE     "Branch8.X68"
            INCLUDE     "Branch9.X68"
            INCLUDE     "Branch12.X68"
            INCLUDE     "PrepOperands.X68"
            INCLUDE     "StringConverter.X68"
            INCLUDE     "PrintOpcode.X68"
            INCLUDE     "ConvertFromAscii.X68"
            INCLUDE     "AddressModes.X68"


*-------------Variables-----------------

param1      DS.L    1
param2      DS.L    1
param3      DS.L    1
param4      DS.L    1
param5      DS.L    1

ret         DS.L    1

op1_read    DS.B    1   * should be 0-2 (words)
op2_read    DS.B    1   * should be 0-2 (words)


STARTADDR   DS.L    1
ENDADDR     DS.L    1

HEXINPUT    DS.B    9
NUMOPERANDS DC.B    0                       ; The number of operands the current opcode has

OPADDR      DS.L    1                       ; The address the current opcode starts at
OPSTRING    DS.L    1                       ; The address of the string to output
            
OPERAND_SIZE    EQU     36
            
O1STRING    DS.B    OPERAND_SIZE            ; The string for the first operand
O2STRING    DS.B    OPERAND_SIZE            ; The string for the second operand
OPASTRING   DS.B    10                      ; The string with the opcode address
TMPSTRING   DS.B    OPERAND_SIZE

            
*-------------Constants-----------------
CR          EQU     $0D
LF          EQU     $0A
POUND       EQU     $23

MSSG        DC.B    'Please enter start and ending memory addresses.',CR,LF,0
STARTMSSG   DC.B    'Start address: ',0
ENDMSSG     DC.B    'End address: ',0
BREAKMSG    DC.B    'Press any key to continue... ',0
ERRMSG      DC.B    'Press any key to restart...',0
RESTMSG     DC.B    'If you would like to disassemble another program, press y.',CR,LF,'If you would like to exit, press any other key...',CR,LF,0

RANGE_ERRMSG        DC.B    'End address must be greater than start address.',CR,LF,0
START_RANGE_ERRMSG  DC.B    'Start address must fit in addressing space.',CR,LF,0
END_RANGE_ERRMSG    DC.B    'End address must fit in addressing space.',CR,LF,0
START_WORD_ERRMSG   DC.B    'Start address must be word-aligned.',CR,LF,0
END_WORD_ERRMSG     DC.B    'End address must be word-aligned.',CR,LF,0

SPACE       DC.B    ' ', 0
NEWLINE     DC.B    CR,LF,0
OPERANDSEP  DC.B    ', ', 0

NO_OP       DC.B    'DATA    ', 0
NOP_OP      DC.B    'NOP',0

MOVEB_OP    DC.B    'MOVE.B  ',0
MOVEW_OP    DC.B    'MOVE.W  ',0
MOVEL_OP    DC.B    'MOVE.L  ',0
            
MOVEAW_OP   DC.B    'MOVEA.W ',0
MOVEAL_OP   DC.B    'MOVEA.L ',0

MOVEQ_OP    DC.B    'MOVEQ   ',0

MOVEMW_OP   DC.B    'MOVEM.W ',0
MOVEML_OP   DC.B    'MOVEM.L ',0

ADDB_OP     DC.B    'ADD.B   ',0
ADDW_OP     DC.B    'ADD.W   ',0
ADDL_OP     DC.B    'ADD.L   ',0

ADDAW_OP    DC.B    'ADDA.W  ',0
ADDAL_OP    DC.B    'ADDA.L  ',0

ADDIB_OP    DC.B    'ADDI.B  ',0
ADDIW_OP    DC.B    'ADDI.W  ',0
ADDIL_OP    DC.B    'ADDI.L  ',0

ADDQB_OP    DC.B    'ADDQ.B  ',0
ADDQW_OP    DC.B    'ADDQ.W  ',0
ADDQL_OP    DC.B    'ADDQ.L  ',0

SUBB_OP     DC.B    'SUB.B   ',0
SUBW_OP     DC.B    'SUB.W   ',0
SUBL_OP     DC.B    'SUB.L   ',0

SUBIB_OP    DC.B    'SUBI.B  ',0
SUBIW_OP    DC.B    'SUBI.W  ',0
SUBIL_OP    DC.B    'SUBI.L  ',0

MULS_OP     DC.B    'MULS.W  ',0

DIVU_OP     DC.B    'DIVU.W  ',0

LEA_OP      DC.B    'LEA     ',0

ANDB_OP     DC.B    'AND.B   ',0
ANDW_OP     DC.B    'AND.W   ',0
ANDL_OP     DC.B    'AND.L   ',0

ORB_OP      DC.B    'OR.B    ',0
ORW_OP      DC.B    'OR.W    ',0
ORL_OP      DC.B    'OR.L    ',0

LSLB_OP     DC.B    'LSL.B   ',0
LSLW_OP     DC.B    'LSL.W   ',0
LSLL_OP     DC.B    'LSL.L   ',0

LSRB_OP     DC.B    'LSR.B   ',0
LSRW_OP     DC.B    'LSR.W   ',0
LSRL_OP     DC.B    'LSR.L   ',0

ASLB_OP     DC.B    'ASL.B   ',0
ASLW_OP     DC.B    'ASL.W   ',0
ASLL_OP     DC.B    'ASL.L   ',0

ASRB_OP     DC.B    'ASR.B   ',0
ASRW_OP     DC.B    'ASR.W   ',0
ASRL_OP     DC.B    'ASR.L   ',0

ROLB_OP     DC.B    'ROL.B   ',0
ROLW_OP     DC.B    'ROL.W   ',0
ROLL_OP     DC.B    'ROL.L   ',0

RORB_OP     DC.B    'ROR.B   ',0
RORW_OP     DC.B    'ROR.W   ',0
RORL_OP     DC.B    'ROR.L   ',0
                
BCC_OP      DC.B    'BCC     ',0
BLT_OP      DC.B    'BLT     ',0
BGE_OP      DC.B    'BGE     ',0

JSR_OP      DC.B    'JSR     ',0
RTS_OP      DC.B    'RTS',0

BRA_OP      DC.B    'BRA     ',0


D0_STRING   DC.W    'D0',0
D1_STRING   DC.W    'D1',0
D2_STRING   DC.W    'D2',0
D3_STRING   DC.W    'D3',0
D4_STRING   DC.W    'D4',0
D5_STRING   DC.W    'D5',0
D6_STRING   DC.W    'D6',0
D7_STRING   DC.W    'D7',0

A0_STRING   DC.W    'A0',0
A1_STRING   DC.W    'A1',0
A2_STRING   DC.W    'A2',0
A3_STRING   DC.W    'A3',0
A4_STRING   DC.W    'A4',0
A5_STRING   DC.W    'A5',0
A6_STRING   DC.W    'A6',0

SP_STRING   DC.W    'SP',0



*** MASKS AND VALUES ***
                
MASK_NOP        DC.W    $4E71
MASK_RTS        DC.W    $4E75
                
MASK_HONIBBLE   DC.W    $F000
MASK_OPSIZE     DC.W    $3000
MASK_SRCREG     DC.W    $0E00 *misleading name --- deprecated
MASK_SRCMODE    DC.W    $01C0 *misleading name --- deprecated
MASK_DSTMODE    DC.W    $0038 *misleading name --- deprecated
MASK_DSTREG     DC.W    $0007 *misleading name --- deprecated

SRCMODE_MASK    EQU     $0038 *not misleading name --- 21st century code
SRCREG_MASK     EQU     $0007 *not misleading name --- 21st century code
DSTMODE_MASK    EQU     $01C0 *not misleading name --- 21st century code
DSTREG_MASK     EQU     $0E00 *not misleading name --- 21st century code

OPSIZEA_B       DC.W    $0000
OPSIZEA_W       DC.W    $1000
OPSIZEA_L       DC.W    $2000

OPSIZEB_W       DC.W    $0000
OPSIZEB_L       DC.W    $1000

OPSIZEC_B       DC.W    $1000
OPSIZEC_W       DC.W    $3000
OPSIZEC_L       DC.W    $2000


            END     START        ; last line of source



































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
