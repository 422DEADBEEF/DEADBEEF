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
                
                    *CMP.W       D1, IMMEDIATE_VALUES
                    *BEQ         JUMP_IMMEDIATE
                    
                    *CMP.W       D1, MOVE_VALUES
                    *BLE         JUMP_MOVE
                    
                    CMP.W       D1, MISC_VALUES
                    BEQ         JUMP_MISC
                    
                    *CMP.W       D1, ADDQ_VALUE
                    *BEQ         JUMP_ADDQ
                    
                    *CMP.W       D1, BRANCH_VALUES
                    *BEQ         JUMP_BRANCH
                    
                    *CMP.W       D1, MOVEQ_VALUE
                    *BEQ         JUMP_MOVEQ
                    
                    
                    * Add other jump branches
                    
                    
                    JSR         PREP_DATA
                    JSR         PRINTOP
                    
                    ADDQ.W      #2, A6
                    BRA         END_DECODE
                    
*JUMP_IMMEDIATE      JSR         BRANCH0
*                    BRA         END_DECODE

*JUMP_MOVE           JSR         BRANCH1
*                    BRA         END_DECODE

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

                
                
IMMEDIATE_VALUES    DC.W    $0000
MOVE_VALUES         DC.W    $3000
MISC_VALUES         DC.W    $4000
ADDQ_VALUE          DC.W    $5000
BRANCH_VALUES       DC.W    $6000
MOVEQ_VALUE         DC.W    $7000
DIVOR_VALUES        DC.W    $8000
SUB_VALUE           DC.W    $9000
MULAND              DC.W    $C000
ADD_VALUES          DC.W    $D000
SHIFT_VALUES        DC.W    $E000








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
