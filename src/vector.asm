proc Vector3.Normalize uses edi,\
     vector

        locals
                l       dd      ?
        endl

        mov     edi, [vector]

        stdcall Vector3.Length, [vector]
        mov     [l], eax

        fld     [edi + Vector3.x]
        fdiv    [l]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fdiv    [l]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fdiv    [l]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.Distance uses esi edi,\
     v1, v2

        locals
                result  dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]

        fld     [esi + Vector3.x]
        fsub    [edi + Vector3.x]
        fmul    st0, st0

        fld     [esi + Vector3.y]
        fsub    [edi + Vector3.y]
        fmul    st0, st0

        fld     [esi + Vector3.z]
        fsub    [edi + Vector3.z]
        fmul    st0, st0

        faddp
        faddp
        fsqrt
        fstp    [result]

        mov     eax, [result]

        ret
endp

proc Vector3.Cross uses esi edi ebx,\
     v1, v2, result

        locals
                temp    dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]
        mov     ebx, [result]

        fld     [esi + Vector3.z]
        fmul    [edi + Vector3.y]
        fstp    [temp]
        fld     [esi + Vector3.y]
        fmul    [edi + Vector3.z]
        fsub    [temp]
        fstp    [ebx + Vector3.x]

        fld     [esi + Vector3.x]
        fmul    [edi + Vector3.z]
        fstp    [temp]
        fld     [esi + Vector3.z]
        fmul    [edi + Vector3.x]
        fsub    [temp]
        fstp    [ebx + Vector3.y]

        fld     [esi + Vector3.y]
        fmul    [edi + Vector3.x]
        fstp    [temp]
        fld     [esi + Vector3.x]
        fmul    [edi + Vector3.y]
        fsub    [temp]
        fstp    [ebx + Vector3.z]

        ret
endp

proc Vector3.Length uses esi,\
     vector

        locals
                result  dd      ?
        endl

        mov     esi, [vector]

        fld     [esi + Vector3.x]
        fmul    [esi + Vector3.x]

        fld     [esi + Vector3.y]
        fmul    [esi + Vector3.y]

        fld     [esi + Vector3.z]
        fmul    [esi + Vector3.z]

        faddp
        faddp
        fsqrt
        fstp    [result]

        mov     eax, [result]

        ret
endp

proc Vector3.Copy uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]
        mov     ecx, 3
        rep     movsd

        ret
endp

proc Vector3.Sub uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.Add uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]

        fld     [edi + Vector3.x]
        fadd    [esi + Vector3.x]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fadd    [esi + Vector3.y]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fadd    [esi + Vector3.z]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.MultOnNumber uses edi,\
        dest, number

        mov     edi, [dest]

        fld     [edi + Vector3.x]   
        fmul    [number]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]   
        fmul    [number]
        fstp    [edi + Vector3.y]
        
        fld     [edi + Vector3.z]   
        fmul    [number]
        fstp    [edi + Vector3.z]
        
        ret
endp