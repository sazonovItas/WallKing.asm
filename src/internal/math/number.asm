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
