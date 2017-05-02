*-----------------------------------------------------------
* Title       :
* Written by  :
* Date        :
* Description :
*-----------------------------------------------------------
START           ORG         $7000

                NOP
                RTS
                NOP
                NOP
                RTS
                ADDI.B      #64, D2
                ADDI.W      #524, D4
                ADDI.L      #587, D1
                SUBI.B      #98, D2
                SUBI.W      #154, D4
                SUBI.L      #165, D1
                MOVE.B      D1, D2
                MOVE.W      D1, D3
                ADD.B       D3, D5
                MOVEA.W     D1, A1
                MOVEA.L     D6, A2
                NOP
                RTS


                SIMHALT
                
                END         START













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
