
.MODEL SMALL
.STACK 100H
.DATA

MESSAGE1 DB 'ENTER UP TO 10 ELEMENTS : $' 
MESSAGE2 DB 'AFTER SORTING : $'
MESSAGE3 DB 'PRESS : 1-FOR DESCENDING ORDER  2-FOR ASCENDING ORDER  $'
MESSAGE4 DB 'INVALID NUMBER $'
MESSAGE5 DB 'PRESS : 1-FOR BUBBLE SORTING  2-FOR SELECTION SORTING $'
MESSAGE6 DB 'YOU MUST ENTER ELEMENTS FIRST $'
 
ARR DB 10 dup (0) 
 
 


.CODE  
  
 
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX 
       
    CALL NEW_LINE   
    
    MOV AH,9       ;DISPLAY MESSAGE
    lea DX,MESSAGE1
    INT 21H 
    
    MOV CX,0
     
    ;FILLING ARRAY
    MOV AH,1 ;FIRST INPUT
    INT 21H
    
    MOV SI,0
    WHILE_:
        CMP AL,0DH      ;COMPARE INPUT WITH CR ;ENTER BUTTON
        JE END_WHILE    ;IF EQUAL JMP TO END_WHILE
        MOV ARR[SI],AL  ;MOVE INPUT INTO ARRAY
        INC SI          ;SI+=1
        INC CX
        CMP CX,10
        JE END_WHILE
        CALL PRINT_SPACE
        MOV AH,1
        INT 21H
                
    JMP WHILE_          ;JMP WHILE_ TO CONTINUE ENTER THE INPUTS
    END_WHILE:
    CALL NEW_LINE  
    
    JCXZ NO_INPUTS_MESSAGE ;IF CX == 0 JMP NO_INPUTS_MESSAGE LABLE (THIS CONDITION IF NO INPUTS ENTERED) 
    
    LEA SI,ARR ;OFFSET OF ARRAY INTO SI
    MOV BX,CX 

    
    PUSH CX ;push number of elements
 ;==================================================   
    
    ;CHOOSE THE TYPE OF SORTING
    CALL NEW_LINE
    MOV AH,9
    LEA DX,MESSAGE5     ;print message5
    INT 21H
    CALL NEW_LINE 
    
    MOV AH,1
    INT 21H       ;enter a number
    SUB AL,30H 
    CMP AL,1      ;COMPARE INPUT WITH 1
    JB INVALID 
    JE T1    ;IF EQUAL JMP TO T1 WHICH CONTAIN THE CODE OF THE BUBBLE SORT 
    CMP AL,2
    JA INVALID      ;COMPARE INPUT WITH 2
    JE T2    ;IF EQUAL JMP TO T2 WHICH CONTAIN THE CODE OF THE SELECTION SORT
    
 ;======================================================= 
  
 ;==================================================   
    T1: ;BUBBLE TYPE
    ;CHOOSE THE TYPE OF ORDER ASCENDING OR DESCENDING
    CALL NEW_LINE 
    MOV AH,9
    LEA DX,MESSAGE3     ;print message3
    INT 21H
    CALL NEW_LINE 
    
    MOV AH,1
    INT 21H          ;enter a number
    SUB AL,30H 
    CMP AL,1      ;COMPARE INPUT WITH 1
    JB INVALID 
    JE P1    ;IF EQUAL JMP TO P1 AND THEN CALL DESCENDING SORT
    CMP AL,2      ;COMPARE INPUT WITH 2
    JA INVALID
    JE P2    ;IF EQUAL JMP TO P2 AND THEN CALL ASCENDING SORT 
    
    
    P1: CALL BUBBLE_DESCENDING_SORT
    JMP PRINT_ARRAY     ;AFTER THE CALL OF THE PROCEDURE JMP TO PRINT_ARRAY 
    
    P2: CALL BUBBLE_ASCENDING_SORT  
    JMP PRINT_ARRAY     ;AFTER THE CALL OF THE PROCEDURE JMP TO PRINT_ARRAY
                        
    
 ;==================================================   
    T2: ;SELECTION TYPE
    ;CHOOSE THE TYPE OF ORDER ASCENDING OR DESCENDING
    CALL NEW_LINE
    MOV AH,9
    LEA DX,MESSAGE3
    INT 21H
    CALL NEW_LINE
    
    MOV AH,1
    INT 21H         ;enter a number
    SUB AL,30H 
    CMP AL,1      ;COMPARE INPUT WITH 1
    JB INVALID 
    JE P3    ;IF EQUAL JMP TO P3 AND THEN CALL DESCENDING SORT
    CMP AL,2      ;COMPARE INPUT WITH 2
    JA INVALID
    JE P4    ;IF EQUAL JMP TO P4 AND THEN CALL ASCENDING SORT 
    
    
    P3: CALL SELECTION_DESCENDING_SORT
    JMP PRINT_ARRAY    ;AFTER THE CALL OF THE PROCEDURE JMP TO PRINT_ARRAY
    
    P4: CALL SELECTION_ASCENDING_SORT  
    JMP PRINT_ARRAY    ;AFTER THE CALL OF THE PROCEDURE JMP TO PRINT_ARRAY


 
    
    
 ;=======================================================
      
    ;PRINT AFTER SORTING
    PRINT_ARRAY:
    POP CX         ;POP THE NUMBER OF ELEMENTS FROM THE STACK INTO CX THAT U PUSHED IT ABOVE
    CALL NEW_LINE 
        
    MOV AH,9
    LEA DX,MESSAGE2     ;print message3
    INT 21H 
    
    
    MOV SI,0              ;START FROM INDEX 0
    PRINT_SORTED_ARRAY:
        MOV AH,2
        MOV DL,ARR[SI]   ;PRINT ARR[SI]
        INT 21H
        MOV DL,' '       ;PRINT SPACE
        INT 21H
        INC SI           ;INC SI FOR THE NEXT ELEMENT
        LOOP PRINT_SORTED_ARRAY
    JMP EXIT
;====================================        
    NO_INPUTS_MESSAGE:
        MOV AH,9
        LEA DX,MESSAGE6     ;print message6
        INT 21H
        CALL MAIN         ;CALL MAIN AGAIN 
        
;====================================         
    EXIT:
        MOV AH,4CH   ;END PROGRAM
        INT 21H
        MAIN ENDP


;==========================================================

BUBBLE_ASCENDING_SORT PROC
   ;THIS PROCEDURE WILL SORT THE ARRAY IN ASCENDING ORDER
   ;INPUT : SI=OFFSET ADDRESS OF THE ARRAY
   ;      : BX=ARRAY SIZE
   PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   PUSH DI
   PUSH SI
   
   MOV AX,SI
   MOV DX,CX    ; NUMBER OF ELEMENTS INTO DX

  DEC CX       ;CUZ THE BUBBLE LOOP THE NUMBER OF ELEMENTS-1 ; for i = 0; i < n-1; i++         
  JCXZ BUBBLESORT_END     ;IF THERE IS ONE ELEMENT IN THE ARRAY EXIT THE PROCEDURE 
                      
  @OUTER_LOOP1:
 
      MOV BX,CX           ;THE COUNTER OF INNER LOOP IS THE SAME AS OUTER LOOP         
      MOV SI,AX           ;SET SI=AX (IN EACH LOOP IN OUTER LOOP SET SI THE BEGINNIG OFFSET OF THE AARAY)
      MOV DI,AX           ;SET DI=AX
      INC DI              ;SET DI=DI+1 TO GET THE NEXT ELEMENT
      @INNER_LOOP1:        
          MOV DL,[SI]       
          CMP DL,[DI]     ;COMPARE DL WITH [DI]
          JNG @NOT_SWAP1   ;JMP IF DL<=[DI] ([DI] IS GREATER THAN [SI] )
          XCHG DL,[DI]    ;IF DL > [DI] EXCHANGE THE VALUE OF DL AND [DI]
          MOV [SI],DL
          @NOT_SWAP1:
          INC SI 
          INC DI    ;INC SI AND DI TO GET THE NEXT ELEMENTS
          DEC BX    ;DEC THE INNER COUNTRT TILL IT EQUAL 0
      JNZ @INNER_LOOP1 ;JMP IF BX!=0  
      ;IF BX==0 THIS MEANS THE INNER LOOP HAS ENDED 
      ;======================================

        ;====================================       
      LOOP @OUTER_LOOP1  ;IF CX !=0 LOOP THE OUTER LOOP AGAIN TILL IT EQUAL 0
  
       
  BUBBLESORT_END:
  POP SI
  POP DI
  POP DX
  POP CX                 ;END OF PROCEDURE
  POP BX
  POP AX
  RET   ;RETURN TO RHE CALLING PROCEDURE
  BUBBLE_ASCENDING_SORT ENDP

   
    
;======================================================    
   

BUBBLE_DESCENDING_SORT PROC
   ;THIS PROCEDURE WILL SORT THE ARRAY IN DESCENDING ORDER
   ;INPUT : SI=OFFSET ADDRESS OF THE ARRAY
   ;      : BX=ARRAY SIZE
   PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   PUSH DI
   PUSH SI
   
   MOV AX,SI
  ; MOV DX,CX
   

  DEC CX
  JCXZ BUBBLESORT2_END                         
  @OUTER_LOOP2:

      MOV BX,CX          
      MOV SI,AX          
      MOV DI,AX          
      INC DI             
      @INNER_LOOP2:      
          MOV DL,[SI]    
          CMP [DI],DL    
          JNG @NOT_SWAP2 
          XCHG DL,[DI]   
          MOV [SI],DL
          @NOT_SWAP2:
          INC SI 
          INC DI
          DEC BX
      JNZ @INNER_LOOP2   
       
      LOOP @OUTER_LOOP2

  BUBBLESORT2_END:
  POP SI
  POP DI
  POP DX
  POP CX
  POP BX
  POP AX
  RET   ;RETURN TO RHE CALLING PROCEDURE
  BUBBLE_DESCENDING_SORT ENDP
;==============================================================================


SELECTION_ASCENDING_SORT PROC
   ;THIS PROCEDURE WILL SORT THE ARRAY IN ASCENDING ORDER

   PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   PUSH DI
   PUSH SI
   MOV BX,CX
   DEC CX
   JCXZ SELECTION_END      ;JMP IF CX == 0, THIS FOR CONDITION IF THERE IS ONLY 1 ELEMENT IN ARRAY THEN END SORT                  
   @OUTER_LOOP3:
       MOV BX,CX           ;SET BX=CX
       MOV DI,SI
       INC DI              ;ADDRESS OF THE NEXT ELEMENT
       MOV DX,0            ;INDEX OF MINMUM ELEMENT INITIALLY = 0
 
       @INNER_LOOP3:      
          MOV AL,[DI]       ; AL= [DI]
          PUSH DI          ;PUSH DI & SI CUZ WE WILL CHANGE THIM 
          PUSH SI            
          ADD SI,DX        ;ADD THE INDEX OF MINUMUM ELEMENT TO SI TO GET THE ADDRESS OF MINMUM ELEMENT
          CMP [SI],AL      ;COMPARE THE MINMUM ELEMENT TO  THE CURRENT ELEMENT
          JNG @NOT_SWAP___   ;IF THE MINMUM ELEMENT IS STILL SMALLER JUMP TO @NOT_SWAP___ 
          
          POP SI           ;RETURN THE ORIGNAL SI FROM STACK
          SUB DI,SI        ;SUBTRACT THE ADDRESS OF THE CURRENT ELEMENT FROM THE SI ADDRESS TO GET THE CURRENT ELEMENT INDEX 
          MOV DX,DI        ;PUT THE INDEX OF THE MINIMUM ADDRESS INTO DX
          POP DI           ;RETURN THE ORIGNAL DI FROM STACK
          JMP @NOT_SWAP3   ;JMP TO @NOT_SWAP3          
          
          @NOT_SWAP___:      ;THIS LABLE IF THE MINMUM ELEMENT IS STILL SMALLER
          POP SI           ;THEN REURN THE OERIGNAL SI & DI
          POP DI 
          
          @NOT_SWAP3:
          INC DI           ;INCREMENT DI TO COMPARE THE NEXT ELEMENT
          DEC BX           ;DECREMENT THE COUNTER
       JNZ @INNER_LOOP3    ;JMP IF BX!=0 
       
       
       MOV DI,SI            ;SAVE THE ADDRESS OF THE OUTER LOOP ELEMENT FOR LATER USAGE
       
       ADD  SI,DX
       MOV  AL,[SI]         ;AL=ARR[DX] 
       XCHG [DI],AL        ;THIS BLOCK OF CODE IS TO PUT THE MINIMUM VALUE TO THE CORRECT INDEX
       MOV  [SI],AL
       MOV  SI,DI          ;GET BACK THE ADDRESS OF SI 
       INC  SI             ;INC SI TO GET THE NEXT RLEMENT IN OUTER LOOP
      ;====================================== 
      
     
       
       LOOP @OUTER_LOOP3  ;LOOP THE OUTER LOOP IF CX !=0 
   
        
   SELECTION_END:
   POP SI
   POP DI
   POP DX
   POP CX
   POP BX
   POP AX
   RET   ;RETURN TO RHE CALLING PROCEDURE
   SELECTION_ASCENDING_SORT ENDP
  
;=====================================================    
   
SELECTION_DESCENDING_SORT PROC
   ;THIS PROCEDURE WILL SORT THE ARRAY IN DESCENDING ORDER
   ;INPUT : SI=OFFSET ADDRESS OF THE ARRAY
   ;      : BX=ARRAY SIZE
   PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   PUSH DI
   PUSH SI
   MOV BX,CX

  DEC CX                    
                            
  JCXZ SELECTION2_END       ;JMP IF CX == 0, THIS FOR CONDITION IF THERE IS ONLY 1 ELEMENT IN ARRAY THEN END SORT              
  @OUTER_LOOP4:                                                                                                              
       MOV BX,CX            ;SET BX=CX                                                                                       
       MOV DI,SI                                                                                                             
       INC DI               ;ADDRESS OF THE NEXT ELEMENT                                                                     
       MOV DX,0             ;DX=0                                                                                            
       @INNER_LOOP4:                                                                                                         
          MOV AL,[DI]        ; AL= [DI]                                                                                      
          CMP AL,[SI]       ;COMPARE [SI] WITH [DI] ; COMPARE THE CURRENT VALUE TO THE NEXT VALUE                            
          JNG @NOT_SWAP4    ;JMP TO @NOT_SWAP1 IF [SI]<=[DI]    CURRENT < NEXT                                               
          PUSH DI           ;IF NOT PUSH DI & SI CUZ WE WILL CHANGE THIM                                                     
          PUSH SI                                                                                                            
          ADD SI,DX           ;ADD THE INDEX OF MINUMUM ELEMENT TO SI TO GET THE ADDRESS OF MINMUM ELEMENT                                                                                                                     
          CMP AL,[SI]       ;COMPARE THE MINMUM ELEMENT TO  THE CURRENT ELEMENT                                                                                                                                                
          JNG @NOT_SWAP____ ;IF THE MINMUM ELEMENT IS STILL SMALLER JUMP TO @NOT_SWAP____                                      
          POP SI            ;RETURN THE ORIGNAL SI FROM STACK                                                                 
          SUB DI,SI         ;SUBTRACT THE ADDRESS OF THE CURRENT ELEMENT FROM THE SI ADDRESS TO GET THE CURRENT ELEMENT INDEX   
          MOV DX,DI         ;PUT THE INDEX OF THE MINIMUM ADDRESS INTO DX                                                     
          POP DI              ;RETURN THE ORIGNAL DI FROM STACK                                                               
          JMP @NOT_SWAP4    ;JMP TO @NOT_SWAP4                                                                                
          @NOT_SWAP____:     
          POP SI            
          POP DI                                                                                                             
          @NOT_SWAP4:                                                                                                        
          INC DI            ;THIS LABLE IF THE MINMUM ELEMENT IS STILL SMALLER                                               
          DEC BX            ;THEN REURN THE OERIGNAL SI & DI                                                                 
       JNZ @INNER_LOOP4     ;JMP IF BX!=0                                                                                                 
       MOV DI,SI                                                                                                             
       ADD SI,DX            ;INCREMENT DI TO COMPARE THE NEXT ELEMENT                                                        
       MOV AL,[SI]          ;THIS BLOCK OF CODE IS TO EXCHANGE THE MINIMUM VALUE TO THE CORRECT INDEX                                                                                                 
       XCHG [DI],AL                                                                                             
       MOV [SI],AL                                                                                                           
       MOV SI,DI                                                                                                             
       INC SI
      ;======================================
                                                                                                                     
      LOOP @OUTER_LOOP4                             

   
  SELECTION2_END:
  POP SI
  POP DI
  POP DX
  POP CX                 ;END OF PROCEDURE
  POP BX
  POP AX
  RET   ;RETURN TO RHE CALLING PROCEDURE
  SELECTION_DESCENDING_SORT ENDP

;====================================  

  



 ;====================================
 
PRINT_SPACE PROC 
 
    MOV AH,2
    MOV DX,' '     ;DISPLAY SPACE
    INT 21H   


RET   ;RETURN TO RHE CALLING PROCEDURE
PRINT_SPACE ENDP 

;===============================
  
;====================================
 
NEW_LINE PROC
 
   MOV AH,2
   MOV DL,0DH  ;CARRIAGE RETURN IN ASCII TABLE
   INT 21H
   MOV DL,0AH  ;LINE FEED IN ASCII TABLE
   INT 21H    
 
RET   ;RETURN TO RHE CALLING PROCEDURE
NEW_LINE ENDP 

;===============================

    INVALID:
    CALL NEW_LINE
    MOV AH,9
    LEA DX,MESSAGE4
    INT 21H
    JMP EXIT
 
END MAIN  

;=============================================================================== 
