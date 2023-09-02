    orinVec         Vector3     ?
    crossVec        Vector3     ?
    upVec           Vector3     ?

    proj            Matrix4x4   ?
    view            Matrix4x4   ?
    target          Vector3     ?

    lastCursorPos   Point       ?

proc Camera.Constructor uses edi,\
    pCamera, width, height, pPosition 

    mov     edi, [pCamera]

    mov     eax, [width]
    mov     dword [edi + Camera.width], eax
    mov     eax, [height]
    mov     dword [edi + Camera.height], eax

    push    edi
    add     edi, Camera.Position
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    mov     [edi + Camera.pitch], 0.0
    mov     [edi + Camera.yaw], -1.57

    stdcall Camera.Direction, edi

    mov     [edi + Camera.Up + Vector3.x], 0.0
    mov     [edi + Camera.Up + Vector3.y], 1.0
    mov     [edi + Camera.Up + Vector3.z], 0.0

    mov     [edi + Camera.speed], 0.002
    mov     [edi + Camera.sensitivity], 0.0005

    invoke SetCursorPos, 960, 540
    invoke GetCursorPos, lastCursorPos
    
    ret
endp

proc Camera.Direction uses edi,\
    pCamera 

    mov     edi, [pCamera]

    ; Ox camera direction
    fld     [edi + Camera.pitch]
    fcos    
    fld     [edi + Camera.yaw]
    fcos 
    fmulp
    fstp    [edi + Camera.Orientation + Vector3.x]

    ; Oy camera direction
    fld     [edi + Camera.pitch]
    fsin    
    fstp    [edi + Camera.Orientation + Vector3.y]

    ; Oz camera direction
    fld     [edi + Camera.pitch]
    fcos    
    fld     [edi + Camera.yaw]
    fsin 
    fmulp
    fstp    [edi + Camera.Orientation + Vector3.z]

    ret
endp

proc Camera.Matrix uses edi esi,\
    pCamera, FOVdeg, nearPlane, farPlane, ShaderID, pStrUniProj, pStrUniView

    locals 
        aspect      dd         ?
    endl

    mov     edi, [pCamera]
    fild    dword [edi + Camera.width]    ; width
    fidiv   dword [edi + Camera.height]   ; width / height
    fstp    [aspect]                ;

    invoke  glMatrixMode, GL_PROJECTION
    invoke  glLoadIdentity
    stdcall Matrix.Projection, [FOVdeg], [aspect], [nearPlane], [farPlane], proj

    push    edi
    add     edi, Camera.Position
    stdcall Vector3.Copy, target, edi 
    pop     edi

    push    edi
    add     edi, Camera.Orientation
    stdcall Vector3.Add, target, edi 
    pop     edi

    push    edi 
    mov     esi, edi
    add     edi, Camera.Position
    add     esi, Camera.Up

    invoke  glMatrixMode, GL_MODELVIEW
    invoke  glLoadIdentity
    stdcall Matrix.LookAt, edi, target, esi, view

    pop     edi

    invoke  glGetUniformLocation, [ShaderID], [pStrUniView]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, view 

    invoke  glGetUniformLocation, [ShaderID], [pStrUniProj]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, proj

    ret
endp

proc Camera.Inputs uses edi esi ebx,\
    pCamera, uMsg, wParam, lParam

    locals 
        speed           dd          ?
        reverseSpeed    dd          ?
        sensetivity     dd          ?
        xoffset         dd          ?
        yoffset         dd          ?
    endl


    mov     edi, [pCamera]

    fld     [edi + Camera.speed] 
    fimul   [deltaTime]
    fst     [speed]
    fchs 
    fstp    [reverseSpeed]

    push    edi
    add     edi, Camera.Orientation
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    push    edi
    add     edi, Camera.Up
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    mov     eax, [uMsg] 
    JumpIf  WM_KEYDOWN,     .KeyDown 
    JumpIf  WM_MOUSEMOVE,   .MouseMove

    jmp     .Return

    .KeyDown:

        cmp     [wParam], 'W'
        jne     @F

        stdcall Vector3.MultOnNumber, orinVec, [speed]
        
        push    edi
        add     edi, Camera.Position
        stdcall Vector3.Add, edi, orinVec
        pop     edi

        jmp     .Return

        @@:

        cmp     [wParam], 'S'
        jne     @F

        stdcall Vector3.MultOnNumber, orinVec, [reverseSpeed] 
        
        push    edi
        add     edi, Camera.Position
        stdcall Vector3.Add, edi, orinVec
        pop     edi

        jmp     .Return

        @@:

        cmp     [wParam], 'D'
        jne     @F

        stdcall Vector3.Cross, orinVec, upVec, crossVec
        stdcall Vector3.MultOnNumber, crossVec, [speed] 
        
        push    edi
        add     edi, Camera.Position
        stdcall Vector3.Add, edi, crossVec
        pop     edi

        jmp     .Return

        @@:
        
        cmp     [wParam], 'A'
        jne     @F

        stdcall Vector3.Cross, orinVec, upVec, crossVec
        stdcall Vector3.MultOnNumber, crossVec, [reverseSpeed] 
        
        push    edi
        add     edi, Camera.Position
        stdcall Vector3.Add, edi, crossVec
        pop     edi

        jmp     .Return

        @@:
        
        cmp     [wParam], VK_SPACE
        jne     @F

        stdcall Vector3.MultOnNumber, upVec, [speed] 
        
        push    edi
        add     edi, Camera.Position
        stdcall Vector3.Add, edi, upVec
        pop     edi

        jmp     .Return

        @@:

        cmp     [wParam], VK_TAB
        jne     @F

        stdcall Vector3.MultOnNumber, upVec, [reverseSpeed] 
        
        push    edi
        add     edi, Camera.Position
        stdcall Vector3.Add, edi, upVec
        pop     edi

        jmp     .Return

        @@:

        jmp     .Return

    .MouseMove:

        mov     eax, [lastCursorPos.x]
        mov     ebx, [lastCursorPos.y]

        push    eax
        invoke  GetCursorPos, lastCursorPos
        pop     eax
        
        sub     eax, [lastCursorPos.x]
        neg     eax
        sub     ebx, [lastCursorPos.y]

        mov     [xoffset], eax
        mov     [yoffset], ebx

        fild    [xoffset]
        fmul    [edi + Camera.sensitivity]
        fstp    [xoffset]

        fild    [yoffset]
        fmul    [edi + Camera.sensitivity]
        fstp    [yoffset]

        fld     [edi + Camera.yaw]
        fadd    [xoffset]
        fstp    [edi + Camera.yaw]

        fld     [edi + Camera.pitch]
        fadd    [yoffset]
        fstp    [edi + Camera.pitch]

        stdcall Camera.Direction, edi
        stdcall Camera.NormalizeCursor, lastCursorPos

        jmp     .Return

    .Return:

    ret
endp

proc Camera.NormalizeCursor uses edi ebx,\
    pMousePos

    mov     edi, [pMousePos] 
    mov     eax, [edi + Point.x]
    mov     ebx, [edi + Point.y]

    cmp     eax, maxCursorX
    jb      @F

    mov     eax, (maxCursorX + minCursorX) / 2

    @@:

    cmp     eax, minCursorX
    ja      @F 

    mov     eax, (maxCursorX + minCursorX) / 2

    @@:

    cmp     ebx, maxCursorY
    jb      @F

    mov     ebx, (maxCursorY + minCursorY) / 2

    @@:

    cmp     ebx, minCursorY
    ja      @F 

    mov     ebx, (maxCursorY + minCursorY) / 2

    @@:


    mov     [edi + Point.x], eax
    mov     [edi + Point.y], ebx
    invoke  SetCursorPos, eax, ebx

    ret
endp

    maxCursorY      =       900
    minCursorY      =       1080
    maxCursorX      =       1800
    minCursorX      =       120