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
                MOVEM.L     D0-D7/A0-A5, -(SP)  * Save register state
                
                MOVE.W      (A6), D1            * Save OP-Code in D1
                
                
                
                
                
                
                
END_DECODE      MOVEM.L     (SP)+, D0-D7/A0-A5  * Restore register state
                RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
