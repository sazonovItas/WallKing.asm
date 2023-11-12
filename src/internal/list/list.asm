proc ListArr.Init uses edi,\
    pList, cap, objSize

    mov     edi, [pList]

    mov     eax, [objSize]
    mov     [edi + ListArr.objSize], eax
    mov     eax, [cap]
    mov     [edi + ListArr.cap], eax
    mov     [edi + ListArr.len], 0

    mov     eax, [cap]
    mul     [objSize]
    stdcall malloc, eax
    mov     [edi + ListArr.arr], eax

    ret
endp

proc ListArr.Grow uses edi esi,\
    pList

    locals 
        mul2        dd      2
        mul3        dd      3    
        cntBytes    dd      0
        newArr      dd      0
    endl

    mov     edi, [pList]
    mov     eax, [edi + ListArr.cap]
    mul     [edi + ListArr.objSize]
    mov     [cntBytes], eax

    xor     edx, edx
    mov     eax, [edi + ListArr.cap]
    mul     [mul3]
    div     [mul2]
    mul     [edi + ListArr.objSize]

    mov     [edi + ListArr.cap], eax
    stdcall malloc, eax
    mov     [newArr], eax

    cmp     eax, 0
    je      .Ret

    stdcall memcpy, [newArr], [edi + ListArr.arr], [cntBytes]
    stdcall free, [edi + ListArr.arr]

    mov     eax, [newArr]
    mov     [edi + ListArr.arr], eax

.Ret:
    ret
endp