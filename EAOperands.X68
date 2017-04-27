*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
                        * param1 = OPCode
                        * param2 = lower 3 bits are register
                        * param3 = lower 3 bits are mode
WRITE_OPERAND           
                        MOVEM.L     D0-D7/A0-A5, -(SP)
                        MOVE.W      param1, D0
                        MOVE.W      param2, D1
                        MOVE.W      param2, D2
                        
                        CMP.B       #0, D2
                        BEQ         
                        
                               
                        



END_WRITE_OPERAND       MOVEM.L     (SP)+, D0-D7/A0-A5
                        RTS
                        
                        * Writes to TMPSTRING
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
