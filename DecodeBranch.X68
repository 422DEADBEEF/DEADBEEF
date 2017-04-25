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
                    
                    MOVE.L      A6, OPPADDR
                    
                    MOVE.W      (A6), D1                * Save OP-Code in D1
                    AND.W       MASK_HONIBBLE, D1       * Mask out highest-order nibble
                
                    *CMP.W       D1, IMMEDIATE_VALUES
                    *BEQ         JUMP_IMMEDIATE
                    
                    *CMP.W       D1, MOVE_VALUES
                    *BLE         JUMP_MOVE
                    
                    CMP.W       D1, MISC_VALUES
                    BEQ         JUMP_MISC
                    
                    * Add other jump branches
                    
                    
                    
                    
                    
                    
*JUMP_IMMEDIATE      JSR         BRANCH0
*                    BRA         END_DECODE
*JUMP_MOVE           JSR         BRANCH1
*                    BRA         END_DECODE
JUMP_MISC           JSR         BRANCH4
                    BRA         END_DECODE
                
                
END_DECODE          MOVEM.L     (SP)+, D0-D7/A0-A5  * Restore register state
                    RTS

                
                
IMMEDIATE_VALUES    DC.W    $0000
MOVE_VALUES         DC.W    $3000
MISC_VALUES         DC.W    $4000









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
