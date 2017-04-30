*-----------------------------------------------------------
* Title      : Branch 4 Decode Subroutines
* Written by : 
* Date       :
* Description: Covers:
* NOP, RTS, JSR, MOVEM, and LEA (possibly ERROR)
*-----------------------------------------------------------

BRANCH4     MOVEM.L     D0-D7/A0-A5, -(SP)
            MOVE.W      (A6)+, D0
            CMP.W       #%0100111001110001, D0
            BEQ         DC_NOP

            CMP.W       #%0100111001110101, D0
            BEQ         DC_RTS

            MOVE.W      D0,D1
            AND.W       #B4_JSR_MASK, D1
            CMP.W       #B4_JSR_MASK, D1
            BEQ         DC_JSR
            
            MOVE.W      D0, D1
            AND.W       #B4_MOVEM_MASK, D1
            CMP.W       #B4_MOVEM_MASK, D1
            BEQ         DC_MOVEM

            MOVE.W      D0,D1
            AND.W       #B4_LEA_MASK, D1
            CMP.W       #B4_LEA_MASK, D1
            BEQ         DC_LEA





B4_DATA     JSR         PREP_DATA
PRINT4      JSR         PRINTOP
            BRA         BRANCH4EXIT

DC_NOP      MOVE.L      #NOP_OP, OPSTRING    ; put 'NOP' into OPSTRING
            MOVE.B      #0, NUMOPERANDS     ; set number of operands as 0
            BRA         PRINT4

DC_RTS      MOVE.L      #RTS_OP, OPSTRING    ; put 'NOP' into OPSTRING
            MOVE.B      #0, NUMOPERANDS     ; set number of operands as 0
            BRA         PRINT4

DC_JSR      MOVE.W      D0,D1
            AND.W       #B4_DEST_ADDR, D1
            CMP.W       #B4_DEST_ADDR, D1
            BEQ         B4_JSR_ADDR

            BRA         B4_DATA

B4_JSR_ADDR MOVE.W      D0,D1
            AND.W       #B4_DEST_REG_MASK, D1
            CMP.W       #0, D1
            BEQ         B4_JSR_WA
            CMP.W       #1, D1
            BEQ         B4_JSR_LA
            BRA         B4_DATA

B4_JSR_WA   MOVE.B      #4, param1
            CLR         D3
            MOVE.W      (A6)+, D3
            MOVE.L      D3, param2
            MOVE.L      #O1STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B4_JSR_PRNT

B4_JSR_LA   MOVE.B      #8, param1
            MOVE.L      (A6)+, param2
            MOVE.L      #O1STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B4_JSR_PRNT


B4_JSR_PRNT MOVE.L      #JSR_OP, OPSTRING
            MOVE.B      #1, NUMOPERANDS
            BRA         PRINT4
  
          
******************************************************* WIP
*** HERE BE DRAGONS ************
*** May only the brave enter ***
DC_MOVEM    MOVE.W      D0, D1
            MOVE.W      D0, D2
            MOVE.W      D0, D3
            MOVE.W      D0, D4
            AND.W       #B4_DEST_ADDR, D1
            AND.W       #B4_DEST_REG_MASK, D2
            AND.W       #B4_MOVEM_DIR_MASK, D3
            AND.W       #B4_MOVEM_SIZE_MASK, D4
            
            LSR.W       #8, D3
            LSR.B       #2, D3
            
            LSR.W       #6, D4
            
            LSR.B       #3, D1
            MULS.W      #6, D1
            
            LEA         DC_MOVEM_JMP_TABLE, A0
            JMP         0(A0, D1)
            
DC_MOVEM_JMP_TABLE
            JMP         B4_DATA.L
            JMP         B4_DATA.L
            JMP         B4_AddrIndir.L
            JMP         B4_PostIncr.L
            JMP         B4_PreIncr.L
            JMP         B4_DATA.L
            JMP         B4_DATA.L
            JMP         B4_AddrAbs.L
            

B4_AddrIndir
            BRA         B4_BUILD_OPS
            
B4_PostIncr
            CMP.B       #B4_MOVEM_REGtoMEM, D3
            BEQ         B4_DATA
            BRA         B4_BUILD_OPS
            
B4_PreIncr
            CMP.B       #B4_MOVEM_REGtoMEM, D3
            BNE         B4_DATA
            BRA         B4_BUILD_OPS
            
B4_AddrAbs
            CMP.B       #1, D2
            BGT         B4_DATA
            BRA         B4_BUILD_OPS

B4_BUILD_OPS
            MOVE.L      #MOVEMW_OP, OPSTRING
            CMP.B       #0, D4                                  ; Is size a Word?
            BEQ         B4_MOVEM_ISWORD
            MOVE.L      #MOVEML_OP, OPSTRING
            
B4_MOVEM_ISWORD  
            MOVE.B      #2, NUMOPERANDS
            MOVE.L      #O1STRING, param3
            MOVE.B      #1, param2
            CMP.B       #B4_MOVEM_REGtoMEM, D3
            BEQ         B4_MOVEM_REGfirst
            
            MOVE.L      #O2STRING, param3
            
B4_MOVEM_REGfirst  
            MOVEA.L     param3, A0                              ; keep track of which buffer we used
            MOVEA.L     A0, A1                                  ; keep track of current location in string
            
            MOVE.L      param3, -(SP)
            MOVE.B      param2, -(SP)
          
            MOVE.W      (A6)+, D5

            ROR.W       #8, D5
            MOVE.B      #0, D1
            MOVE.B      #0, D4
            MOVE.B      #0, D6
B4_REG_LOOP
            CMP.B       #16, D6
            BEQ         B4_REGloopEND
            CMP.B       #B4_MOVEM_REGtoMEM, D3
            BEQ         B4_SHIFT_LEFT
            
            LSR.W       #1, D5
            BRA         B4_MOVEM_AFTERSHIFT
            
B4_SHIFT_LEFT
            LSL.W       #1, D5
            
B4_MOVEM_AFTERSHIFT
            BCC         B4_MOVEM_NOREG
            MOVE.B      D1, param1                              ; set the current reg num in preparation for building string
    
            CMP.B       #1, D7                                  ; was there a register immediately preceeding this one?
            BLT         B4_FIRSTREG
            CMP.B       #2, D7                                  ; is this the first subsequent register?
            BLT         B4_ADD_DASH
            
            SUBA.L      #2, A1
            BRA         B4_BUILDREG
            
B4_ADD_DASH
            MOVE.B      #$2D, (A1)+
            BRA         B4_BUILDREG
            
B4_FIRSTREG
            CMP.B       #0, D4
            BEQ         B4_BUILDREG
            MOVE.B      #$2F, (A1)+
            
B4_BUILDREG
            MOVE.B      (SP), param2
            MOVE.L      A1, param3
            JSR         DECODE_ADDRESS_MODE_AM
            ADDQ.B      #1, D7
            ADDQ.B      #1, D4
            BRA         B4_MOVEM_INCREMENTS
            
B4_MOVEM_NOREG
            MOVE.B      #0, D7
            SUBA.L      #2, A1
            
B4_MOVEM_INCREMENTS
            ADDA.L      #2, A1
            ADDQ.B      #1, D6
            ADDQ.B      #1, D1
            CMP.B       #8, D6
            BNE         B4_REG_LOOP
            
            MOVE.B      #0, D1
            ADDI.B      #1, (SP)
            ANDI.B      #$01, (SP)
            MOVE.B      #0, D7
            BRA         B4_REG_LOOP

B4_REGloopEND
            AND.W       #B4_DEST_ADDR, D0
            LSR.B       #3, D0
            MOVE.B      D0, param2
            MOVE.B      D2, param1
            MOVE.L      #O2STRING, param3     
            
            CMP.B       #B4_MOVEM_REGtoMEM, D3
            BEQ         B4_OTHER_OP
            MOVE.L      #O1STRING, param3
            
B4_OTHER_OP
            JSR         DECODE_ADDRESS_MODE_AM
            ADDA.L      #6, A7
            BRA         PRINT4


****************************************************** END WIP


DC_LEA      MOVE.W      D0,D1
            AND.W       #B4_DEST_ADDR, D1
            CMP.W       #B4_DEST_ADDR, D1
            BEQ         B4_LEA_ADDR

            BRA         B4_DATA

B4_LEA_ADDR MOVE.W      D0,D1
            AND.W       #B4_DEST_REG_MASK, D1
            CMP.W       #0, D1
            BEQ         B4_LEA_WA
            CMP.W       #1, D1
            BEQ         B4_LEA_LA
            BRA         B4_DATA

B4_LEA_WA   MOVE.B      #4, param1
            CLR         D3
            MOVE.W      (A6)+, D3
            MOVE.L      D3, param2
            MOVE.L      #O1STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B4_LEA_PRNT

B4_LEA_LA   MOVE.B      #8, param1
            MOVE.L      (A6)+, param2
            MOVE.L      #O1STRING, param3
            JSR         HEX_TO_STRING_SC    ; build opcode address as a string
            BRA         B4_LEA_PRNT


B4_LEA_PRNT MOVE.L      #LEA_OP, OPSTRING
            MOVE.B      #2, NUMOPERANDS

            MOVE.W      D0,D1
            AND.W       #B4_LEA_REG_MASK, D1
            ROL.W       #7, D1
            LEA         O2STRING, A0
            MOVE.B      #$41, (A0)+         ; put a capital A into the string
            ADD.B       #$30, D1            ;create hex representation of the number
            MOVE.B      D1, (A0)+
            MOVE.B      #0, (A0)



            BRA         PRINT4



BRANCH4EXIT MOVEM.L     (SP)+, D0-D7/A0-A5
            RTS


B4_JSR_MASK             EQU     %0100111010000000
B4_MOVEM_MASK           EQU     %0100100010000000
B4_LEA_MASK             EQU     %0100000111000000
B4_MOVEM_MASK           EQU     %0100100010000000

B4_DEST_ADDR            EQU     %0000000000111000
B4_DEST_REG_MASK        EQU     %0000000000000111
B4_LEA_REG_MASK         EQU     %0000111000000000
B4_MOVEM_DIR_MASK       EQU     %0000010000000000
B4_MOVEM_SIZE_MASK      EQU     %0000000001000000

B4_DEST_LADDR           EQU     %0000000000111001

B4_MOVEM_REGtoMEM       EQU     0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
