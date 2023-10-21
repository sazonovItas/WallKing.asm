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

proc Easing.easeOutQuort dt

    locals 
        sub1        dd      1.0
        div1000     dd      1000.0
        ans         dd      ?
    endl

    fld     [sub1]
    fild    [dt]
    fdiv    [div1000]
    fsubp   st1, st0
    fst     [ans]

    fmul    [ans]
    fmul    [ans]
    fmul    [ans]
    fstp    [ans]
    fld     [sub1]
    fsub    [ans]
    fstp    [ans]

    mov     eax, [ans]
    ret
endp