*-----------------------------------------------------------
* Title      : Hex to String Converter
* Written by : 0xDEADBEEF
* Date       : 4/18/2017
* Description: Converts a hex value in memory to a string
*-----------------------------------------------------------


LETTER_START_SC     EQU     $41
LETTER_OFFSET_SC    EQU     $37
NUMBER_OFFSET_SC    EQU     $30
       
*** FUNCTION: HEX TO STRING ***
*** ARGS:   param1 (BYTE): NUMBER OF HEX DIGITS TO CONVERT (MAX 8)
***         param2 (LONG): NUMBER TO CONVERT
***         param3 (LONG): Address of the byte array to build the string into
HEX_TO_STRING_SC
    MOVEM.L     A1/D0-D2, -(SP)         ; Save register states

    MOVE.B      param1, D0              ; Load Parameters into registers
    MOVE.L      param2, D1
    MOVEA.L     param3, A1
    CLR         D2
    
    MOVE.B      #$24, (A1)+
    
    CMP.B       #4, D0
    BNE         CONVERSION_LOOP_SC
    
    SWAP        D1
    
CONVERSION_LOOP_SC
    CMP.B       #0, D0                  ; For each hex value to convert
    BEQ         RETURN_SC
    
    ROL.L       #4, D1                  ; Put HO nibble into LO nibble
    MOVE.B      D1, D2                  ; Copy lower byte of hex value into D2
    AND.L       #$FFFFFFF0, D1          ; Remove lower 4 bits of hex value (these are now being converted)
    AND.B       #$0F, D2                ; Remove higher order nibble
    
    CMP.B       #$A, D2                 ; Does the lower order nibble correspond to a letter or a number?
    BGE         HEX_TO_LETTER_SC
    
    ADD.B       #NUMBER_OFFSET_SC, D2   ; Convert nibble to ASCII value (0-9)
    BRA         FUNC_BODY_SC
    
HEX_TO_LETTER_SC
    ADD.B       #LETTER_OFFSET_SC, D2   ; Convert nibble to ASCII value (A-F)

FUNC_BODY_SC
    MOVE.B      D2, (A1)+               ; Add value to the unwritten end of the current string
    SUBQ.B      #1, D0                  ; Decrement counter
    BRA         CONVERSION_LOOP_SC      ; Loop
    
RETURN_SC
    MOVE.B      #0, (A1)+
    
    MOVEM.L     (SP)+, D0-D2/A1         ; Restore registers
    RTS
*** END FUNCTION ***





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
