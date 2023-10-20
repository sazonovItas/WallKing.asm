proc Easing.easeInQuad dt

    locals 
        div2        dd      2.0
        ans         dd      ?
    endl

    fldpi
    fmul    [dt]
    fsin
    fdiv    [div2]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp