proc Player.Constructor uses edi,\
    pPlayer, width, height, pPosition

    mov     edi, [pPlayer]

    mov     eax, [width]
    mov     dword [edi + Player.width], eax
    mov     eax, [height]
    mov     dword [edi + Player.height], eax

    push    edi
    add     edi, Player.Position
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    push    edi
    add     edi, Player.prevPosition
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    mov     [edi + Player.Acceleration + Vector3.x], 0.0
    mov     [edi + Player.Acceleration + Vector3.y], -0.01
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    mov     [edi + Player.Velocity + Vector3.x], 0.0
    mov     [edi + Player.Velocity + Vector3.y], 0.0
    mov     [edi + Player.Velocity + Vector3.z], 0.0

    mov     [edi + Player.pitch], 0.0
    mov     [edi + Player.yaw], -1.57

    stdcall Camera.Direction, edi
    stdcall Player.OrinDirection, edi

    mov     [edi + Player.Up + Vector3.x], 0.0
    mov     [edi + Player.Up + Vector3.y], 1.0
    mov     [edi + Player.Up + Vector3.z], 0.0

    mov     [edi + Player.speed], 0.05
    mov     [edi + Player.jumpVeloc], 0.20
    mov     [edi + Player.sensitivity], 0.0005
    mov     [edi + Player.Condition], AIR_CONDITION

    invoke SetCursorPos, cursorPosX, cursorPosY
    invoke GetCursorPos, lastCursorPos
    
    ret
endp

proc Player.OrinDirection uses edi,\
    pPlayer 

    locals 
        null        dd      0.0
    endl

    mov     edi, [pPlayer]

    ; Ox camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.yaw]
    fcos 
    fmulp
    fstp    [edi + Player.Direction + Vector3.x]

    ; Oy camera direction
    fld     [null]
    fsin    
    fstp    [edi + Player.Direction + Vector3.y]

    ; Oz camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.yaw]
    fsin 
    fmulp
    fstp    [edi + Player.Direction + Vector3.z]

    ret
endp

proc Player.AssignPrevPosition uses edi, esi,\
    pPlayer

    mov     edi, [pPlayer]
    add     edi, Player.Position

    mov     esi, [pPlayer]
    add     esi, Player.prevPosition

    stdcall Vector3.Copy, edi, esi

    ret
endp

proc Player.Move uses edi esi ebx,\
    pPlayer, dt

    locals 
        delta           Vector3 
        colDet          dd          ?    
        curPlayerPos    Vector3     
        div_2           dd          2.0
        example         dd          0.2
    endl

    mov     edi, [pPlayer]

    push    edi
    add     edi, Player.Position
    lea     ebx, [delta]
    stdcall Vector3.Copy, ebx, edi
    pop     edi
    push    edi
    add     edi, Player.prevPosition
    stdcall Vector3.Sub, ebx, edi
    pop     edi

    mov     esi, edi
    push    edi
    add     edi, Player.prevPosition
    add     esi, Player.Position
    stdcall Vector3.Copy, edi, esi
    pop     edi

    fld     [edi + Player.Velocity + Vector3.x]
    fchs
    ; ; fdiv    [edi + Player.Velocity + Vector3.x]
    fmul    [example]
    fstp    [edi + Player.Acceleration + Vector3.x]

    fld     [edi + Player.Velocity + Vector3.z]
    fchs
    ; ; fdiv    [edi + Player.Velocity + Vector3.y]
    fmul    [example]
    fstp    [edi + Player.Acceleration + Vector3.z]

    ; Y
    mov     [colDet], 0
    mov     [edi + Player.Condition], AIR_CONDITION
    
    push    edi

    fld     [edi + Player.Position + Vector3.y]
    fld     [edi + Player.Velocity + Vector3.y]
    fimul   [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.y]
    fimul   [dt]
    fimul   [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.y]

    fld     [edi + Player.Velocity + Vector3.y]
    fld     [edi + Player.Acceleration + Vector3.y]
    fimul   [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.y]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax
    
    mov     [edi + Player.Velocity + Vector3.y], 0.0

    mov     [edi + Player.Condition], WALK_CONDITION

    @@:

    pop     edi

    ; X    
    mov     [colDet], 0
    
    push    edi

    fld     [edi + Player.Position + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.x]
    fimul   [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.x]
    fimul   [dt]
    fimul   [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.x]

    fld     [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Acceleration + Vector3.x]
    fimul   [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.x]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.x]
    mov     [edi + Player.Position + Vector3.x], eax

    mov     [edi + Player.Velocity + Vector3.x], 0.0
    mov     [edi + Player.Acceleration + Vector3.x], 0.0

    @@:

    pop     edi

    ; Z
    mov     [colDet], 0
    
    push    edi

    fld     [edi + Player.Position + Vector3.z]
    fld     [edi + Player.Velocity + Vector3.z]
    fimul   [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.z]
    fimul   [dt]
    fimul   [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.z]

    fld     [edi + Player.Velocity + Vector3.z]
    fld     [edi + Player.Acceleration + Vector3.z]
    fimul   [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.z]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.z]
    mov     [edi + Player.Position + Vector3.z], eax

    mov     [edi + Player.Velocity + Vector3.z], 0.0
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    @@:

    pop     edi

    ret
endp

proc Player.InputsKeys uses edi esi ebx,\
    pPlayer

    locals 
        speed           dd          ?
        reverseSpeed    dd          ?
    endl

    mov     edi, [pPlayer]

    fld     [edi + Player.speed] 
    ; fimul   [deltaTime]
    fst     [speed]
    fchs 
    fstp    [reverseSpeed]

    push    edi
    add     edi, Player.Direction
    stdcall Vector3.Copy, orinVec, edi
    pop     edi

    push    edi
    add     edi, Player.Up
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    .KeyDown:

        cmp     [pl_forward], true
        jne     @F

        stdcall Vector3.MultOnNumber, orinVec, [speed]
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, orinVec
        pop     edi

        @@:

        cmp     [pl_backward], true
        jne     @F

        stdcall Vector3.MultOnNumber, orinVec, [reverseSpeed] 
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, orinVec
        pop     edi

        @@:

        cmp     [pl_right], true
        jne     @F

        stdcall Vector3.Cross, orinVec, upVec, crossVec
        stdcall Vector3.MultOnNumber, crossVec, [speed] 
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, crossVec
        pop     edi

        @@:
        
        cmp     [pl_left], true
        jne     @F

        stdcall Vector3.Cross, orinVec, upVec, crossVec
        stdcall Vector3.MultOnNumber, crossVec, [reverseSpeed] 
        
        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, crossVec
        pop     edi

        @@:
        
        cmp     [pl_jump], true
        jne     @F

        stdcall Vector3.MultOnNumber, upVec, [edi + Player.jumpVeloc] 
        
        cmp     [edi + Player.Condition], AIR_CONDITION
        je      .JumpSkip

        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, upVec
        pop     edi

        .JumpSkip:

        @@:

    ret
endp

proc Player.InputsMouse uses edi esi ebx,\
    pPlayer, wParam, lParam

    locals 
        sensetivity     dd          ?
        xoffset         dd          ?
        yoffset         dd          ?
    endl

    mov     edi, [pPlayer]

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
        fmul    [edi + Player.sensitivity]
        fstp    [xoffset]

        fild    [yoffset]
        fmul    [edi + Player.sensitivity]
        fstp    [yoffset]

        fld     [edi + Player.yaw]
        fadd    [xoffset]
        fstp    [edi + Player.yaw]

        fld     [edi + Player.pitch]
        fadd    [yoffset]
        fstp    [edi + Player.pitch]

        stdcall Camera.Direction, edi
        stdcall Player.OrinDirection, edi
        stdcall Camera.NormalizeCursor, lastCursorPos

    ret
endp
