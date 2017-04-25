*-----------------------------------------------------------
* Title      : HW2Q3
* Written by : Cameron Dillon
* Date       : 4/18/2017
* Description: HW2Q3
*-----------------------------------------------------------


LETTER_START_SC     EQU     $41
LETTER_OFFSET_SC    EQU     $37
NUMBER_OFFSET_SC    EQU     $30
   
*** LEGACY TEST CODE ***
    MOVE.B      D3, TARGET_VALUE        ; Store the hex value in $A200
    
    MOVE.L      #$6000, Addr1           ; Set initial value of Addr1
    MOVEA.L     #$6001, A0              ; Set starting address for search (checking $6000 is redundant as it is already set to that, inclusive
    MOVEA.L     #$8000, A1              ; Set ending address for search (inclusive)
    CLR.L       D0
    

    MOVE.L      #8, D0                  ; Number of hex digits in value for function call
    MOVE.L      **YOUR VALUE HERE**, D1               ; Store value of Addr1 in D1 for function call
    LEA         HEXADDRESS_STRING, A0   
    LEA         0(A0, D0), A1           ; Set A1 to last element of the array
    MOVE.B      #0, (A1)                ; Null terminate the string that will be created
    JSR         HEX_TO_STRING           ; Convert hex value to string starting at HEXADDRESS_STRING
    
    LEA         HEXADDRESS_STRING, A1   ; Print hex string (of Addr1)
    MOVE.B      #13, D0
    TRAP        #15    

*** LEGACY TEST CODE ***
    
    
*** FUNCTION: HEX TO STRING ***
*** ARGS:   D0: NUMBER OF HEX DIGITS TO CONVERT (MAX 8)
***         D1: NUMBER TO CONVERT
***         A1: Address of the one past the end of the byte array (ARRAY_START + D0 + 1) to write the string into
HEX_TO_STRING
    MOVEM.L     D0-D2/A1, -(SP)         ; Save used registers
    CLR         D2
    
CONVERSION_LOOP
    CMP.B       #0, D0                  ; For each hex value to convert
    BEQ         RETURN
    
    MOVE.B      D1, D2                  ; Copy lower byte of hex value into D2
    LSR         #4, D1                  ; Remove lower 4 bits of hex value (these are now being converted)
    AND.B       #$0F, D2                ; Remove higher order nibble
    
    CMP.B       #$A, D2                 ; Does the lower order nibble correspond to a letter or a number?
    BGE         HEX_TO_LETTER
    
    ADD.B       #NUMBER_OFFSET, D2      ; Convert nibble to ASCII value (0-9)
    BRA         FUNC_BODY
    
HEX_TO_LETTER
    ADD.B       #LETTER_OFFSET, D2      ; Convert nibble to ASCII value (A-F)

FUNC_BODY
    MOVE.B      D2, -(A1)               ; Add value to the unwritten end of the current string
    SUBQ.B      #1, D0                  ; Decrement counter
    BRA         CONVERSION_LOOP         ; Loop
    
RETURN
    MOVEM.L     (SP)+, D0-D2/A1         ; Restore registers
    RTS
*** END FUNCTION ***

*** VARIABLES AND CONSTANTS ***
HEX_STRING          DS.B    3       ; Storage for 2 hex digits and the null terminator
HEXADDRESS_STRING   DS.B    9       ; Storage for the hex string of Addr1 to print ou


    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
