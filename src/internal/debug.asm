
proc Debug.IntToDecString uses ebx edi,\
    dest, value

    locals
        isNegative              db      0 
        amntOfCharacters        dd      ?
    endl 

    mov     edi, [dest]
    mov     eax, [value]
    xor     ebx, ebx        

    cmp     eax, 0
    jge      @F
    neg     eax 
    mov     [isNegative], 1
@@:

 .push_chars:
    xor     edx, edx  
    mov     ecx, 10       
    div     ecx               
    add     edx, 0x30         
    push    edx  
    inc     ebx              
    test    eax, eax 
    jnz     .push_chars       

    movzx   eax, [isNegative]
    cmp     eax, 0
    je      .notNegative
    inc     ebx 
    push    '-'
.notNegative:

    mov     [amntOfCharacters], ebx

 .pop_chars:
    pop     eax               
    stosb                 
    dec     ebx               
    cmp     ebx, 0             
    jg  .pop_chars         

    mov     eax, [amntOfCharacters]

    ret                   
endp
