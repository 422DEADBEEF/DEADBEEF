*-----------------------------------------------------------
* Title       : WRITE_OPERAND
* Written by  : Ryan Berge
* Date        : April 26th, 2017
* Description : Takes in a Mode and a Register and figures 
*               out what the addressing and thingy are
*-----------------------------------------------------------
                        * param1 = OPCode
                        * param2 = lower 3 bits are register
                        * param3 = lower 3 bits are mode
                        * Writes "answer" to TMPSTRING
WRITE_OPERAND           
                        MOVEM.L     D0-D7/A0-A5, -(SP)
                        MOVE.W      param1, D0
                        MOVE.W      param2, D1
                        MOVE.W      param3, D2
                        
                        LEA         TMPSTRING, A1
                        
                        CMP.B       #0, D2
                        BEQ         WO_DATA_REG
                        CMP.B       #1, D2
                        BEQ         WO_ADDR_REG
                        
                               
                        
WO_DATA_REG             CMP.B       #0, D1
                        BEQ         WODR_0
                        CMP.B       #1, D1
                        BEQ         WODR_1
                        CMP.B       #2, D1
                        BEQ         WODR_2
                        CMP.B       #3, D1
                        BEQ         WODR_3
                        CMP.B       #4, D1
                        BEQ         WODR_4
                        CMP.B       #5, D1
                        BEQ         WODR_5
                        CMP.B       #6, D1
                        BEQ         WODR_6
                        CMP.B       #7, D1
                        BEQ         WODR_7
                        
WO_ADDR_REG             CMP.B       #0, D1
                        BEQ         WOAR_0
                        CMP.B       #1, D1
                        BEQ         WOAR_1
                        CMP.B       #2, D1
                        BEQ         WOAR_2
                        CMP.B       #3, D1
                        BEQ         WOAR_3
                        CMP.B       #4, D1
                        BEQ         WOAR_4
                        CMP.B       #5, D1
                        BEQ         WOAR_5
                        CMP.B       #6, D1
                        BEQ         WOAR_6
                        

WODR_0                  LEA         D0_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_1                  LEA         D1_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_2                  LEA         D2_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_3                  LEA         D3_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_4                  LEA         D4_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_5                  LEA         D5_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_6                  LEA         D6_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WODR_7                  LEA         D7_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND

WOAR_0                  LEA         A0_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WOAR_1                  LEA         A1_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WOAR_2                  LEA         A2_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WOAR_3                  LEA         A3_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WOAR_4                  LEA         A4_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WOAR_5                  LEA         A5_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND
WOAR_6                  LEA         A6_STRING, A0
                        MOVE.L      (A0), (A1)
                        BRA         END_WRITE_OPERAND



END_WRITE_OPERAND       MOVEM.L     (SP)+, D0-D7/A0-A5
                        RTS
                        
                        * Writes to TMPSTRING
                        
                        
                        
                        
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
