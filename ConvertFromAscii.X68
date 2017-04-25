*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*---Convert from ascii----------------------
* This subroutine will convert up to 8 ASCII
* characters stored at A1 and puts the
* numerical value in memory specified by
* param1.
*
* Assumes that param1 is a memory location
* and that the ASCII letters are capitals.
CNVFRMASCII MOVEM.L     D0-D2/A2, -(SP)
            CLR D0
            MOVEA.L     param1, A2
            MOVE.L      #0, (A2)
            MOVE.B      param2,D1
            MOVE.L      #8, -(SP)

            SUB.L       D1, (SP)

            MOVE.L      (SP)+, D1

            LSR.B       #1,D1               ; quick divide by two

            ADDA.L      D1,A2



CONVERTFRM  MOVE.B      (A1),D1             ; copy the first hex character to D3
            CMP.B       #0, D1              ; check if we found the null terminator
            BEQ         CFAEXIT             ; If we do, return from subroutine
            MOVE.B      (A1)+,D2            ; copy the first hex character to D4
            LSR.B       #4, D1              ; shift D3 to just get the top 4 bits
            LSL.B       #4, D2              ; shift D4 twice get just the bottom 4 bits
            LSR.B       #4, D2
            CMP.B       #3,D1               ; if D3 is equal to 3, the hex value is a number
            BEQ         CNVNUM              ; convert to a number
            BRA         CNVLET

CFAEXIT     MOVEM.L     (SP)+,D0-D2/A2
            RTS                             ; exit the from ascii conversion subroutine


CNVNUM      CMP.B       #0, D0              ; check if D0 == 0
            BEQ         SHIFT               ; if equal, these are the top bits (do a shift)
            CLR         D0                  ; if not, clear D0 so we shift next time
            ADD.B       D2, (A2)+           ; add the lower bits with the current upper bits
            BRA         CONVERTFRM          ; go to convert the next value

CNVLET      ADD.B       #9, D2              ; add 9 to the bits (this gives correct value)
            CMP.B       #0, D0              ; check if D0 == 0
            BEQ         SHIFT               ; if equal, these are the top bits (do a shift)
            CLR         D0                  ; if not, clear D0 so we shift next time
            ADD.B       D2, (A2)+           ; add the lower bits with the current upper bits
            BRA         CONVERTFRM          ; go to convert the next value

SHIFT       LSL.B       #4, D2              ; do a logic shift to get lower bits into upper
            MOVE.B      D2, (A2)            ; put this into the position in memory
            MOVE.B      #1, D0              ; copy 1 into D1 (will skip the shift next time)
            BRA         CONVERTFRM          ; go to convert the next value