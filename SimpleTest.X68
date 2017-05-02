*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
START           ORG         $7000

                NOP
                RTS
                NOP
                NOP
                RTS
                ADDI.B      #3, D2
                ADDI.W      #2, D4
                ADDI.L      #1, D1
                SUBI.B      #5, D2
                SUBI.W      #2, D4
                SUBI.L      #7, D1
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
