proc Easing.easeInQuad dt

    locals 
        div2        dd      2.0
        div1000     dd      1000.0
        ans         dd      ?
    endl

    fldpi
    fimul    [dt]
    fdiv    [div1000]
    fsin
    fdiv    [div2]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp