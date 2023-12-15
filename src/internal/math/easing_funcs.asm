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
        divNorm     dd      1.5
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
    fdiv    [divNorm]   
    fstp    [ans]

    mov     eax, [ans]
    ret
endp

proc Easing.ease dt

    locals 
        ans         dd      ?
    endl

    ret
endp

proc Easing.easeLine dt

    locals
        ans         dd      ?
        normDiv     dd      150.0
    endl

    fild    [dt]
    fdiv    [normDiv]
    fstp    [ans]

    mov     eax, [ans]
    ret
endp

proc Easing.easeBackLine dt

    locals
        one         dd      1.0
        ans         dd      ?
        normDiv     dd      150.0
    endl

    fild    [dt]
    fdiv    [normDiv]
    fstp    [ans]
    fld     [one]
    fdiv    [ans]
    fstp    [ans]

    mov     eax, [ans]
    ret
endp

proc Easing.easeInCos dt

    locals 
        div2        dd      2.0
        div1000     dd      1000.0
        ans         dd      ?
    endl

    fldpi
    fimul   [dt]
    fdiv    [div1000]
    fcos
    fdiv    [div2]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp

proc Easing.easeSlow dt

    locals 
        div2        dd      10.0
        div1000     dd      1000.0
        normDiv     dd      1.5
        ans         dd      ?
    endl

    fldpi
    fimul   [dt]
    fdiv    [div1000]
    fmul    [normDiv]
    fcos
    fdiv    [div2]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp

proc Easing.easeSlowSlide dt

    locals 
        div2        dd      1.0 
        div1000     dd      1000.0
        normDiv     dd      1.0
        ans         dd      ?
    endl

    fldpi
    fimul   [dt]
    fdiv    [div1000]
    fmul    [normDiv]
    fcos
    fdiv    [div2]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp

proc Easing.easeCamera dt

    locals 
        normDiv     dd      1.0
        div1000     dd      1000.0
        ans         dd      ?
    endl

    fldpi
    fimul    [dt]
    fdiv    [div1000]
    fsin
    fdiv    [normDiv]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp

proc Easing.easeSlideJump dt

    locals 
        div2        dd      2.0
        div1000     dd      1000.0
        ans         dd      ?
    endl

    fldpi
    fimul   [dt]
    fdiv    [div1000]
    fcos
    fdiv    [div2]
    fstp    [ans] 

    mov     eax, [ans]
    ret
endp
