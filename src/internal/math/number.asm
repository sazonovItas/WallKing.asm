proc Number.DoubleSign num

    locals 
        null        dd      0.0
    endl

    fld     [num]
    fcomp   [null]
    fstsw   ax
    sahf
    jb      @F 

    mov     eax, 1.0
    jmp     .Ret

    @@:

    mov     eax, -1.0

.Ret:
    ret
endp

proc Number.DoubleMax num1, num2

    fld     [num1]
    fcomp   [num2]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [num2]
    jmp     .Ret

    @@:

    mov     eax, [num1]

.Ret:

    ret
endp

proc Number.DoubleMin num1, num2

    fld     [num1]
    fcomp   [num2]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [num2]
    jmp     .Ret

    @@:

    mov     eax, [num1]

.Ret:

    ret
endp