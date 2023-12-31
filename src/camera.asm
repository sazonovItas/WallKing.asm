    orinVec         Vector3     ?
    crossVec        Vector3     ?
    upVec           Vector3     ?

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
    add     edi, Camera.camPosition
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

    ; Able to change field of view
    mov     [edi + Camera.fovDeg], 90.0
    mov     [edi + Camera.nearPlane], 0.001
    mov     [edi + Camera.farPlane], 1000.0

    ; translate camera for the player
    mov     [edi + Camera.translate + Vector3.x], 0.0
    mov     [edi + Camera.translate + Vector3.y], 0.0
    mov     [edi + Camera.translate + Vector3.z], 0.0

    mov     [edi + Camera.radius], 2.24

    invoke SetCursorPos, cursorPosX, cursorPosY
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

proc Camera.Matrix uses edi esi ebx,\
    pCamera

    locals 
        aspect      dd          ?
        tmp         Vector3     ?
        div2        dd          4.0
    endl

    mov     edi, [pCamera]
    fild    [edi + Camera.width]    ; width
    fidiv   [edi + Camera.height]   ; width / height
    fstp    [aspect]                ;

    push    edi 
    mov     esi, edi
    add     edi, Camera.proj
    stdcall Matrix.Projection, [esi + Camera.fovDeg], [aspect], [esi + Camera.nearPlane], [esi + Camera.farPlane], edi
    pop     edi

    push    edi
    add     edi, Camera.camPosition
    stdcall Vector3.Copy, target, edi 
    pop     edi

    push    edi
    add     edi, Camera.Orientation
    stdcall Vector3.Add, target, edi 
    pop     edi

    push    edi 
    mov     esi, edi
    add     edi, Camera.camPosition
    add     esi, Camera.Up
    mov     ebx, [pCamera] 
    add     ebx, Camera.view

    stdcall Matrix.LookAt, edi, target, esi, ebx

    pop     edi

    ; Translate camera to the right place
    stdcall Camera.ViewPosition, [pCamera]
    invoke  glMatrixMode, GL_MODELVIEW
    invoke  glPushMatrix
        invoke  glLoadIdentity
        invoke  glMultMatrixf, ebx
        invoke  glTranslatef, [edi + Camera.translate + Vector3.x], [edi + Camera.translate + Vector3.y], [edi + Camera.translate + Vector3.z]
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ebx
    invoke  glPopMatrix

    ret
endp

proc Shadow.Matrix uses edi esi ebx,\ 
    pLightPos, pViewMat, pProjMat

    locals 
        tmp         Vector3     0.0, 0.0, 0.0
        vecUp       Vector3     0.0, 1.0, 0.0
        div2        dd          4.0
    endl

    lea     edx, [tmp]
    lea     edi, [vecUp]
    stdcall Matrix.LookAt, [pLightPos], edx, edi, [pViewMat]

    invoke  glMatrixMode, GL_PROJECTION
    invoke  glPushMatrix
        invoke  glLoadIdentity
        invoke  glOrtho, double SHADOW_LEFT_PLANE, double SHADOW_RIGHT_PLANE,\
                double SHADOW_BOTTOM_PLANE, double SHADOW_TOP_PLANE,\ 
                double SHADOW_NEAR_PLANE, double SHADOW_FAR_PLANE 
        invoke  glGetFloatv, GL_PROJECTION_MATRIX, [pProjMat]
    invoke  glPopMatrix

.Ret:
    ret
endp

proc Shadow.UniformBind\
    ShaderID, pStrUniView, pStrUniProj, pView, pProj

    invoke  glGetUniformLocation, [ShaderID], [pStrUniView]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, [pView] 

    invoke  glGetUniformLocation, [ShaderID], [pStrUniProj]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, [pProj]

    ret
endp
proc Camera.ViewPosition uses edi,\
    pCamera

    mov     edi, [pCamera]

    ; Y
    fld     [edi + Camera.pitch]
    fsin
    fmul    [edi + Camera.radius]
    fstp    [edi + Camera.translate + Vector3.y]

    ; X
    fld     [edi + Camera.pitch]
    fcos
    fstp    [edi + Camera.translate + Vector3.x]
    fld     [edi + Camera.yaw]
    fcos    
    fmul    [edi + Camera.radius]
    fmul    [edi + Camera.translate + Vector3.x]
    fstp    [edi + Camera.translate + Vector3.x]

    ; Z
    fld     [edi + Camera.pitch]
    fcos
    fstp    [edi + Camera.translate + Vector3.z]
    fld     [edi + Camera.yaw]
    fsin    
    fmul    [edi + Camera.radius]
    fmul    [edi + Camera.translate + Vector3.z]
    fstp    [edi + Camera.translate + Vector3.z]

    ret
endp

proc Camera.UniformBind uses edi,\
    pCamera, ShaderID, pStrUniProj, pStrUniView

    mov     edi, [pCamera]

    push    edi
    add     edi, Camera.view
    invoke  glGetUniformLocation, [ShaderID], [pStrUniView]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, edi 
    pop     edi

    add     edi, Camera.proj
    invoke  glGetUniformLocation, [ShaderID], [pStrUniProj]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, edi


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

    maxCursorY      =       700
    minCursorY      =       500
    maxCursorX      =       1200
    minCursorX      =       800

    cursorPosX      =       960
    cursorPosY      =       540