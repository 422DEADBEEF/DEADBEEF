*-----------------------------------------------------------
* Title       : Error Testing
* Written by  : Ryan Berge
* Date        : May 11, 2017
* Description : Compiles a list of decomposed opcodes that
*               should be read in as data because of invalid
*               addressing modes
*-----------------------------------------------------------
START               ORG        $7000

                    * Invalid for both MOVE and MOVEA
MOVE_ERROR          DC.W        $19A1       * MOVE.B    D0, #xxx    **** 1001 11** ****


ADDI_ERROR1         DC.W        $04A0       * ADDI.??   #xxx, D0    **** **** 11** ****
ADDI_ERROR2         DC.W        $043C       * ADDI.B    #xxx, #xxx  **** **** **00 1***
ADDI_ERROR3         DC.W        $0448       * ADDI.W    #xxx, A0    **** **** **11 1100


SUBI_ERROR1         DC.W        $06A0       * SUBI.??   #xxx, D0    **** **** 11** ****
SUBI_ERROR2         DC.W        $063C       * SUBI.B    #xxx, #xxx  **** **** **00 1***
SUBI_ERROR3         DC.W        $0648       * SUBI.W    #xxx, A0    **** **** **11 1100



JSR_ERROR1          DC.W        $4787       * JSR   D7              **** **** **00 0***
JSR_ERROR2          DC.W        $478D       * JSR   A5              **** **** **00 1***
JSR_ERROR3          DC.W        $479B       * JSR   (A3)+           **** **** **01 1***
JSR_ERROR4          DC.W        $47A2       * JSR   -(A2)           **** **** **10 0***
JSR_ERROR5          DC.W        $47BC       * JSR   #xxx            **** **** **11 1100



MOVEM_ERROR1        DC.W        $4880       * MOVEM.W   Dn, D0      **** *0** **00 0***
MOVEM_ERROR2        DC.W        $4C80       * MOVEM.W   D0, Dn      **** *1** **00 0***
MOVEM_ERROR3        DC.W        $4888       * MOVEM.W   Dn, A0      **** *0** **00 1***
MOVEM_ERROR4        DC.W        $4C88       * MOVEM.W   A0, Dn      **** *1** **00 1***
MOVEM_ERROR5        DC.W        $4898       * MOVEM.W   Dn, (A0)+   **** *0** **01 1***
MOVEM_ERROR6        DC.W        $4CA0       * MOVEM.W   -(A0), Dn   **** *1** **10 0***
MOVEM_ERROR7        DC.W        $48BC       * MOVEM.W   #xxx, Dn    **** *0** **11 1100
MOVEM_ERROR8        DC.W        $4CBC       * MOVEM.W   Dn, #xxx    **** *1** **11 1100



LEA_ERROR1          DC.W        $41C0       * LEA       D0, A0      **** **** **00 0***
LEA_ERROR2          DC.W        $41D8       * LEA       A0, A0      **** **** **00 1***
LEA_ERROR3          DC.W        $41D8       * LEA       (A0)+, A0   **** **** **01 1***
LEA_ERROR4          DC.W        $41E0       * LEA       -(A0), A0   **** **** **10 0***
LEA_ERROR5          DC.W        $41FC       * LEA       #xxx, A0    **** **** **11 1100


                    SIMHALT


                    END    START
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
