proc Player.Constructor uses edi,\
    pPlayer, width, height, pPosition

    mov     edi, [pPlayer]

    mov     eax, [width]
    mov     [edi + Player.width], eax
    mov     eax, [height]
    mov     [edi + Player.height], eax

    push    edi
    add     edi, Player.Position
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    push    edi
    add     edi, Player.prevPosition
    stdcall Vector3.Copy, edi, [pPosition] 
    pop     edi

    mov     [edi + Player.Acceleration + Vector3.x], 0.0
    fld     [EARTH_GRAVITY]
    fstp    [edi + Player.Acceleration + Vector3.y]
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

    mov     [edi + Player.speed], 0.035
    mov     [edi + Player.jumpVeloc], 0.25
    mov     [edi + Player.sensitivity], 0.0005
    mov     [edi + Player.Condition], JUMP_CONDITION

    ; Able to change field of view
    mov     [edi + Player.fovDeg], 90.0
    mov     [edi + Player.nearPlane], 0.001
    mov     [edi + Player.farPlane], 1000.0

    ; translate camera for the player
    mov     [edi + Player.translate + Vector3.x], 0.0
    mov     [edi + Player.translate + Vector3.y], 0.0
    mov     [edi + Player.translate + Vector3.z], 0.0

    ; Animation functions
    mov     [edi + Player.forwAni], dword Easing.easeInQuad

    ; size of player collision
    mov     [edi + Player.sizeBlockCol], 0.5 

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


proc Player.EasingMove uses edi esi ebx,\
    pPlayer, dt, fixDt

.Ret:

    ret
endp

proc Player.EasingInputsKeys uses edi esi ebx,\
    pPlayer


.Ret:

    ret
endp

proc Player.EasingHandler uses edi esi ebx,\
    pPlayer

.Ret:
    ret
endp

proc Player.Move uses edi esi ebx,\
    pPlayer, dt, fixDt

    locals 
        delta           Vector3 
        colDet          dd          ?    
        curPlayerPos    Vector3     
        div_2           dd          2.0
        example         dd          0.2

    endl

    mov     edi, [pPlayer]

    fild    [dt]
    fidiv   [fixDt]
    fstp    [dt]

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


    ; X    
    mov     [colDet], 0
    
    push    edi

    fld     [edi + Player.Position + Vector3.x]
    fld     [edi + Player.Velocity + Vector3.x]
    fmul    [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.x]
    fmul    [dt]
    fmul    [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.x]

    fld     [edi + Player.Velocity + Vector3.x]
    fld     [edi + Player.Acceleration + Vector3.x]
    fmul    [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.x]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.x]
    mov     [edi + Player.Position + Vector3.x], eax

    fld     [edi + Player.Velocity + Vector3.x]
    fdiv    [div_2]
    fstp    [edi + Player.Velocity + Vector3.x]
    mov     [edi + Player.Acceleration + Vector3.x], 0.0

    mov     [edi + Player.Condition], SLIDE_CONDITION

    jmp     .SkipSlideConditionX

    @@:
        
    .SkipSlideConditionX:

    pop     edi

    ; Z
    mov     [colDet], 0
    
    push    edi

    fld     [edi + Player.Position + Vector3.z]
    fld     [edi + Player.Velocity + Vector3.z]
    fmul    [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.z]
    fmul    [dt]
    fmul    [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.z]

    fld     [edi + Player.Velocity + Vector3.z]
    fld     [edi + Player.Acceleration + Vector3.z]
    fmul    [dt]
    faddp   
    fstp    [edi + Player.Velocity + Vector3.z]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.z]
    mov     [edi + Player.Position + Vector3.z], eax

    fld     [edi + Player.Velocity + Vector3.z]
    fdiv    [div_2]
    fstp    [edi + Player.Velocity + Vector3.z]
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    mov     [edi + Player.Condition], SLIDE_CONDITION

    jmp     .SkipSlideConditionZ

    @@:

    .SkipSlideConditionZ:

    pop     edi

    ; Y
    mov     [colDet], 0
    
    push    edi

    ; Position
    fld     [edi + Player.Position + Vector3.y]
    fld     [edi + Player.Velocity + Vector3.y]
    fmul    [dt]
    faddp
    fld     [edi + Player.Acceleration + Vector3.y]
    fmul    [dt]
    fmul    [dt]
    
    
    cmp     [edi + Player.Condition], SLIDE_CONDITION
    jne     .SkipPositionSlide    

    fdiv    [div_2]
    fdiv    [div_2]
    fdiv    [div_2]

    .SkipPositionSlide:

    faddp
    fstp    [edi + Player.Position + Vector3.y]

    ; Velocity
    fld     [edi + Player.Velocity + Vector3.y]
    fld     [edi + Player.Acceleration + Vector3.y]
    fmul    [dt]

    cmp     [edi + Player.Condition], SLIDE_CONDITION
    jne     .SkipVelocitySlide    

    fdiv    [div_2]
    fdiv    [div_2]

    .SkipVelocitySlide:

    faddp   
    fstp    [edi + Player.Velocity + Vector3.y]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax
    
    fld     [edi + Player.Velocity + Vector3.y]
    fdiv    [div_2]
    fstp    [edi + Player.Velocity + Vector3.y]

    mov     [edi + Player.Condition], WALK_CONDITION

    jmp     .SkipOtherConditions

    @@:

    .SkipOtherConditions:

    pop     edi

    ret
endp

proc Player.InputsKeys uses edi esi ebx,\
    pPlayer

    locals 
        speed           dd          ?
        reverseSpeed    dd          ?
        dGrav           dd          0.0001
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
        
        cmp     [edi + Player.Condition], WALK_CONDITION
        jne      .notWalkJumpSkip

        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.Add, edi, upVec
        pop     edi

        mov     [edi + Player.Condition], JUMP_CONDITION

        .notWalkJumpSkip:

        cmp     [edi + Player.Condition], SLIDE_CONDITION
        jne     .notSlideJumpSkip

        push    edi
        add     edi, Player.Velocity
        stdcall Vector3.MultOnNumber, upVec, 0.080
        stdcall Vector3.Add, edi, upVec
        pop     edi

        fld     [edi + Player.Velocity + Vector3.y]
        fcomp   [maxClimbSpeed]
        fstsw   ax
        sahf
        jb      .notMaxVelocity

        fld    [maxClimbSpeed]    
        fstp   [edi + Player.Velocity + Vector3.y]
    
        .notMaxVelocity:

        mov     [edi + Player.Condition], JUMP_CONDITION 

        .notSlideJumpSkip:

        @@:

        cmp     [pl_normal_grav], true
        jne     @F

        fld     [EARTH_GRAVITY]
        fstp    [edi + Player.Acceleration + Vector3.y]

        @@:
        
        cmp     [pl_enhance_grav], true
        jne     @F

        fld     [dGrav]
        fchs
        fadd    [edi + Player.Acceleration + Vector3.y]
        fstp    [edi + Player.Acceleration + Vector3.y]

        @@:

        cmp     [pl_weak_grav], true
        jne     @F

        fld     [dGrav]
        fadd    [edi + Player.Acceleration + Vector3.y]
        fstp    [edi + Player.Acceleration + Vector3.y]

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

        fld     [edi + Player.pitch]
        fcomp   [maxPlayerPitch]
        fstsw   ax
        sahf 
        jb      @F

        mov     eax, [maxPlayerPitch]    
        mov     [edi + Player.pitch], eax

        @@:

        fld     [maxPlayerPitch]
        fchs
        fcomp   [edi + Player.pitch]
        fstsw   ax
        sahf 
        jb      @F

        fld     [maxPlayerPitch]
        fchs
        fstp    [edi + Player.pitch]
        
        @@:

        stdcall Camera.Direction, edi
        stdcall Player.OrinDirection, edi
        stdcall Camera.NormalizeCursor, lastCursorPos

    ret
endp