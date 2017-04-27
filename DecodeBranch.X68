*-----------------------------------------------------------
* Title       : Initial Decoding Branch
* Written by  : Ryan Berge
* Date        : April 25th, 2017
* Description : Reads in a word representing an opcode and
*               attempts to decode it
*-----------------------------------------------------------

                *Register A6 will always have the address
                *of the current word to decode
                
DECODE
                    MOVEM.L     D0-D7/A0-A5, -(SP)      * Save register state
                    
                    MOVE.L      A6, OPADDR
                    
                    MOVE.W      (A6), D1                * Save OP-Code in D1
                    AND.W       MASK_HONIBBLE, D1       * Mask out highest-order nibble
                    
                    LSR.L       #8, D1
                    LSR.L       #4, D1
                
                    CMP.W       #IMMEDIATE_VALUES, D1
                    BEQ         MAIN_DATA
                    *BEQ         JUMP_IMMEDIATE
                    
                    CMP.W       #MOVE_VALUES, D1
                    BLE         JUMP_MOVE
                    
                    CMP.W       #MISC_VALUES, D1
                    BEQ         JUMP_MISC
                    
                    *CMP.W       D1, ADDQ_VALUE
                    *BEQ         JUMP_ADDQ
                    
                    *CMP.W       D1, BRANCH_VALUES
                    *BEQ         JUMP_BRANCH
                    
                    *CMP.W       D1, MOVEQ_VALUE
                    *BEQ         JUMP_MOVEQ
                    
                    
                    * Add other jump branches
                    
MAIN_DATA                    
                    JSR         PREP_DATA
                    JSR         PRINTOP
                    
                    ADDQ.W      #2, A6
                    BRA         END_DECODE
                    
*JUMP_IMMEDIATE      JSR         BRANCH0
*                    BRA         END_DECODE

JUMP_MOVE           JSR         BRANCH1
                    BRA         END_DECODE

JUMP_MISC           JSR         BRANCH4
                    BRA         END_DECODE
                    
*JUMP_ADDQ           JSR         BRANCH5
*                    BRA         END_DECODE

*JUMP_BRANCH         JSR         BRANCH6
*                    BRA         END_DECODE

*JUMP_MOVEQ          JSR         BRANCH7
*                    BRA         END_DECODE

*JUMP_DIVOR          JSR         BRANCH8
*                    BRA         END_DECODE

*JUMP_SUB            JSR         BRANCH9
*                    BRA         END_DECODE

*JUMP_MULAND         JSR         BRANCH12
*                    BRA         END_DECODE

*JUMP_ADD            JSR         BRANCH13
*                    BRA         END_DECODE

*JUMP_SHIFT          JSR         BRANCH14
*                    BRA         END_DECODE

                
                
END_DECODE          MOVEM.L     (SP)+, D0-D7/A0-A5  * Restore register state
                    RTS

                
                
IMMEDIATE_VALUES    EQU     $0000
MOVE_VALUES         EQU     $0003
MISC_VALUES         EQU     $0004
ADDQ_VALUE          EQU     $0005
BRANCH_VALUES       EQU     $0006
MOVEQ_VALUE         EQU     $0007
DIVOR_VALUES        EQU     $0008
SUB_VALUE           EQU     $0009
MULAND              EQU     $000C
ADD_VALUES          EQU     $000D
SHIFT_VALUES        EQU     $000E



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
