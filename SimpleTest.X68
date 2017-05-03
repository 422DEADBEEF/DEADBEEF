*-----------------------------------------------------------
* Title       :
* Written by  :
* Date        :
* Description :
*-----------------------------------------------------------
START           ORG         $7000

                MOVE.B      D1, D2
                MOVE.W      D2, (A1)
                MOVE.L      D3, (A1)+
                MOVE.B      D4, -(A1)
                MOVE.W      D5, $4
                MOVE.L      D6, $00FF1234
                
                NOP
                
                MOVE.B      (A1), D5
                MOVE.W      (A1), (A2)
                MOVE.L      (A1), -(A3)
                MOVE.B      (A1), (A4)+
                MOVE.W      (A1), $4004
                MOVE.L      (A1), $6
                
                NOP
                
                MOVE.B      #$3, D1
                MOVE.W      #$247A, (A5)
                MOVE.L      #$12345678, (A2)+
                MOVE.B      #$8, -(A4)
                MOVE.L      #$AAAAFF, $FF112233
                
                NOP


                MOVEA.W     D1, A1
                MOVEA.W     A1, A2
                MOVEA.W     (A1), A2
                MOVEA.W     (A1)+, A2
                MOVEA.W     -(A1), A2
                MOVEA.W     #$3, A3
                MOVEA.W     $4002, A3
                
                MOVEA.L     D6, A2
                MOVEA.L     A1, A2
                MOVEA.L     (A1), A2
                MOVEA.L     (A1)+, A2
                MOVEA.L     -(A1), A2
                MOVEA.L     #$FF4863, A3
                MOVEA.L     $4A02, A3

                
                
                
                NOP
                RTS


                SIMHALT
                
                END         START


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
