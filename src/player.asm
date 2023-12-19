proc Player.Constructor uses edi,\
    pPlayer, width, height, pLevel

    mov     edi, [pPlayer]

    mov     eax, [width]
    mov     [edi + Player.camera + Camera.width], eax
    mov     eax, [height]
    mov     [edi + Player.camera + Camera.height], eax

    mov     esi, [pLevel]
    mov     [edi + Player.pLevel], esi

    push    edi
    push    esi
    add     edi, Player.Position
    add     esi, Level.spawnPosition
    stdcall Vector3.Copy, edi, esi 
    pop     esi
    pop     edi

    push    edi
    add     edi, Player.camera
    add     edi, Camera.camPosition
    push    esi
    add     esi, Level.spawnPosition
    stdcall Vector3.Copy, edi, esi 
    pop     esi
    pop     edi

    push    edi
    push    esi
    add     edi, Player.prevPosition
    add     esi, Level.spawnPosition
    stdcall Vector3.Copy, edi, esi
    pop     esi
    pop     edi

    mov     [edi + Player.Acceleration + Vector3.x], 0.0
    mov     [edi + Player.Acceleration + Vector3.y], 0.0098
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    mov     [edi + Player.camera + Camera.pitch], -1.57
    mov     [edi + Player.camera + Camera.yaw], -1.57

    stdcall Camera.Direction, edi
    stdcall Player.Direction, edi

    mov     [edi + Player.camera + Camera.Up + Vector3.x], 0.0
    mov     [edi + Player.camera + Camera.Up + Vector3.y], 1.0
    mov     [edi + Player.camera + Camera.Up + Vector3.z], 0.0

    mov     [edi + Player.speed], 0.01
    mov     [edi + Player.jumpVeloc], 0.055
    mov     [edi + Player.camera + Camera.sensitivity], 0.0005
    mov     [edi + Player.Condition], FALL_STATE

    ; Able to change field of view
    mov     [edi + Player.camera + Camera.fovDeg], 90.0
    mov     [edi + Player.camera + Camera.nearPlane], 0.01
    mov     [edi + Player.camera + Camera.farPlane], 1000.0

    ; chasingRadius of camera
    mov     [edi + Player.chasingRadius], 0.5 

    ; translate coordinates 
    mov     [edi + Player.camera + Camera.radius], 4.5 
    mov     [edi + Player.maxCamRadius], 6.0
    mov     [edi + Player.minCamRadius], 0.2
    mov     [edi + Player.curCamRadius], 4.5
    mov     [edi + Player.camera + Camera.translate + Vector3.x], 0.0
    mov     [edi + Player.camera + Camera.translate + Vector3.y], 0.0
    mov     [edi + Player.camera + Camera.translate + Vector3.z], 0.0 

    ; Camera chasing easing
    mov     [edi + Player.camera + Camera.moving + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.camera + Camera.moving + Easing.duration], 500 
    mov     [edi + Player.camera + Camera.moving + Easing.startTime], 0
    mov     [edi + Player.camera + Camera.moving + Easing.start], false
    mov     [edi + Player.camera + Camera.moving + Easing.done], false
    mov     [edi + Player.camera + Camera.moving + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.camera + Camera.moving + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.camera + Camera.moving + Easing.orinVec + Vector3.z], 0.0

    ; Camera texture easing 
    mov     [edi + Player.camTexture + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.camTexture + Easing.duration], 200 
    mov     [edi + Player.camTexture + Easing.startTime], 0
    mov     [edi + Player.camTexture + Easing.start], false
    mov     [edi + Player.camTexture + Easing.done], false
    mov     [edi + Player.camTexture + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.camTexture + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.camTexture + Easing.orinVec + Vector3.z], 0.0

    ; Animation functions
    ; Forward ani
    mov     [edi + Player.forwAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.forwAni + Easing.duration], 500 
    mov     [edi + Player.forwAni + Easing.startTime], 0
    mov     [edi + Player.forwAni + Easing.start], false
    mov     [edi + Player.forwAni + Easing.done], false
    mov     [edi + Player.forwAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.forwAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.forwAni + Easing.orinVec + Vector3.z], 0.0


    ; Backward ani
    mov     [edi + Player.backAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.backAni + Easing.duration], 500 
    mov     [edi + Player.backAni + Easing.startTime], 0
    mov     [edi + Player.backAni + Easing.start], false
    mov     [edi + Player.backAni + Easing.done], false
    mov     [edi + Player.backAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.backAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.backAni + Easing.orinVec + Vector3.z], 0.0

    ; left  ani
    mov     [edi + Player.leftAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.leftAni + Easing.duration], 500 
    mov     [edi + Player.leftAni + Easing.startTime], 0
    mov     [edi + Player.leftAni + Easing.start], false
    mov     [edi + Player.leftAni + Easing.done], false
    mov     [edi + Player.leftAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.leftAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.leftAni + Easing.orinVec + Vector3.z], 0.0

    ; right  ani
    mov     [edi + Player.rightAni + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.rightAni + Easing.duration], 500 
    mov     [edi + Player.rightAni + Easing.startTime], 0
    mov     [edi + Player.rightAni + Easing.start], false
    mov     [edi + Player.rightAni + Easing.done], false
    mov     [edi + Player.rightAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.rightAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.rightAni + Easing.orinVec + Vector3.z], 0.0

    ; slow Forward ani
    mov     [edi + Player.bforwAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.bforwAni + Easing.duration], 320 
    mov     [edi + Player.bforwAni + Easing.startTime], 0
    mov     [edi + Player.bforwAni + Easing.start], false
    mov     [edi + Player.bforwAni + Easing.done], false
    mov     [edi + Player.bforwAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.bforwAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.bforwAni + Easing.orinVec + Vector3.z], 0.0

    ; slow Backward ani
    mov     [edi + Player.bbackAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.bbackAni + Easing.duration], 320 
    mov     [edi + Player.bbackAni + Easing.startTime], 0
    mov     [edi + Player.bbackAni + Easing.start], false
    mov     [edi + Player.bbackAni + Easing.done], false
    mov     [edi + Player.bbackAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.bbackAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.bbackAni + Easing.orinVec + Vector3.z], 0.0

    ; slow left  ani
    mov     [edi + Player.bleftAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.bleftAni + Easing.duration], 320 
    mov     [edi + Player.bleftAni + Easing.startTime], 0
    mov     [edi + Player.bleftAni + Easing.start], false
    mov     [edi + Player.bleftAni + Easing.done], false
    mov     [edi + Player.bleftAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.bleftAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.bleftAni + Easing.orinVec + Vector3.z], 0.0

    ; slow right  ani
    mov     [edi + Player.brightAni + Easing.ptrEasingFun], dword Easing.easeSlow
    mov     [edi + Player.brightAni + Easing.duration], 320 
    mov     [edi + Player.brightAni + Easing.startTime], 0
    mov     [edi + Player.brightAni + Easing.start], false
    mov     [edi + Player.brightAni + Easing.done], false
    mov     [edi + Player.brightAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.brightAni + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.brightAni + Easing.orinVec + Vector3.z], 0.0

    ; fall ani
    mov     [edi + Player.fallAni + Easing.ptrEasingFun], dword Easing.easeLine
    mov     [edi + Player.fallAni + Easing.duration], 2500 
    mov     [edi + Player.fallAni + Easing.startTime], 0
    mov     [edi + Player.fallAni + Easing.start], false
    mov     [edi + Player.fallAni + Easing.done], false
    mov     [edi + Player.fallAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.fallAni + Easing.orinVec + Vector3.y], -1.0
    mov     [edi + Player.fallAni + Easing.orinVec + Vector3.z], 0.0

    ; jump ani
    mov     [edi + Player.jumpAni + Easing.ptrEasingFun], dword Easing.easeInCos
    mov     [edi + Player.jumpAni + Easing.duration], 250
    mov     [edi + Player.jumpAni + Easing.startTime], 0
    mov     [edi + Player.jumpAni + Easing.start], false
    mov     [edi + Player.jumpAni + Easing.done], false
    mov     [edi + Player.jumpAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.jumpAni + Easing.orinVec + Vector3.y], 1.0
    mov     [edi + Player.jumpAni + Easing.orinVec + Vector3.z], 0.0

    ; Slide ani
    mov     [edi + Player.slideAni + Easing.ptrEasingFun], dword Easing.easeLine
    mov     [edi + Player.slideAni + Easing.duration], 1000
    mov     [edi + Player.slideAni + Easing.startTime], 0
    mov     [edi + Player.slideAni + Easing.start], false
    mov     [edi + Player.slideAni + Easing.done], false
    mov     [edi + Player.slideAni + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.slideAni + Easing.orinVec + Vector3.y], 0.3
    mov     [edi + Player.slideAni + Easing.orinVec + Vector3.z], 0.0

    ; Slide jump ani
    mov     [edi + Player.slideJump + Easing.ptrEasingFun], dword Easing.easeSlideJump
    mov     [edi + Player.slideJump + Easing.duration], 200
    mov     [edi + Player.slideJump + Easing.startTime], 0
    mov     [edi + Player.slideJump + Easing.start], false
    mov     [edi + Player.slideJump + Easing.done], false
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.z], 0.0

    ; Slide
    mov     [edi + Player.slideVec + Vector3.x], 0.0
    mov     [edi + Player.slideVec + Vector3.y], 1.0
    mov     [edi + Player.slideVec + Vector3.z], 0.0

    ; size of player collision
    mov     [edi + Player.sizeBlockCol], 0.70

    ; draw things
    mov     [edi + Player.sizeBlockDraw], 0.44
    mov     [edi + Player.XYZangles + Vector3.x], 0.0
    mov     [edi + Player.XYZangles + Vector3.y], 0.0
    mov     [edi + Player.XYZangles + Vector3.z], 0.0

    mov     [edi + Player.slideNewJump], true
    mov     [edi + Player.slideDirJump], NO_DIR

    ; draw Player structure
    ; create mutex for other thread
    invoke  CreateMutex, NULL, 0, NULL
    mov     [edi + Player.DrawPlayer + DrawData.lock], eax

    ; copy position to draw position
    push    edi
    push    esi
    add     esi, Level.spawnPosition
    add     edi, (Player.DrawPlayer + DrawData.Position)
    stdcall Vector3.Copy, edi, esi
    pop     esi
    pop     edi

    ; angles to zero
    push    edi
    add     edi, (Player.DrawPlayer + DrawData.Angles)
    stdcall memzero, edi, sizeof.Vector3
    pop     edi

    ; draw scale
    mov     eax, [edi + Player.sizeBlockDraw]
    mov     [edi + Player.DrawPlayer + DrawData.Scale + Vector3.x], eax
    mov     [edi + Player.DrawPlayer + DrawData.Scale + Vector3.y], eax
    mov     [edi + Player.DrawPlayer + DrawData.Scale + Vector3.z], eax

    ; draw tex id
    mov     [edi + Player.DrawPlayer + DrawData.AmbientTexId], 12
    mov     [edi + Player.DrawPlayer + DrawData.DiffuseTexId], 12
    mov     [edi + Player.DrawPlayer + DrawData.SpecularTexId], 12
    mov     [edi + Player.DrawPlayer + DrawData.Shininess], 20.0

    ; Chasing light
    ; Constants
    mov     esi, [edi + Player.pLevel]
    mov     [edi + Player.offsetChasingLight], 0
    mov     [edi + Player.lightVelocity + Vector3.x], 0.0
    mov     [edi + Player.lightVelocity + Vector3.y], 0.0
    mov     [edi + Player.lightVelocity + Vector3.z], 0.0
    mov     [edi + Player.offsetColorLight], 0
    
    ; Easing for camera
    mov     [edi + Player.chasingLight + Easing.ptrEasingFun], dword Easing.easeOutQuort
    mov     [edi + Player.chasingLight + Easing.duration], 500 
    mov     [edi + Player.chasingLight + Easing.startTime], 0
    mov     [edi + Player.chasingLight + Easing.start], false
    mov     [edi + Player.chasingLight + Easing.done], false
    mov     [edi + Player.chasingLight + Easing.orinVec + Vector3.x], 0.0
    mov     [edi + Player.chasingLight + Easing.orinVec + Vector3.y], 0.0
    mov     [edi + Player.chasingLight + Easing.orinVec + Vector3.z], 0.0


    invoke SetCursorPos, cursorPosX, cursorPosY
    invoke GetCursorPos, lastCursorPos
    
    ret
endp

proc Player.Respawn uses edi esi,\
    pPlayer, pPosition

    mov     edi, [pPlayer]

    mov     [edi + Player.fallAni + Easing.start], false
    mov     [edi + Player.fallAni + Easing.done], false

    mov     [edi + Player.jumpAni + Easing.startTime], eax

    mov     [edi + Player.jumpAni + Easing.start], true
    mov     [edi + Player.jumpAni + Easing.done], false

    mov     [edi + Player.slideAni + Easing.start], false
    mov     [edi + Player.slideAni + Easing.done], false

    mov     esi, [pPosition]
    lea     edi, [edi + Player.Position]
    stdcall Vector3.Copy, edi, esi

    ret
endp

proc Player.Update uses edi esi ebx,\
    pPlayer, dt

    locals 
        deltaTime           dd          ?
        minTimeUpdatePlayer dd          15
        tmp                 dd          ?
    endl

    mov     edi, [pPlayer]
    mov     esi, [edi + Player.pLevel]

    fild    [dt]
    fstp    [deltaTime]

    mov     ecx, 1

    mov     eax, [dt]
    cmp     eax, [minTimeUpdatePlayer]
    jb      @F

    xor     edx, edx
    div     [dt]
    inc     eax
    mov     ecx, eax
    mov     [tmp], eax

    fld     [deltaTime]
    fidiv   [tmp]
    fstp    [deltaTime]

    @@:

        
    .UpdatePlayer:

        push    ecx
        stdcall Player.UpdateVelocity, edi, [esi + Level.sizeBlocksMap], [esi + Level.pBlocksMap]
        stdcall Player.UpdatePosition, edi, [deltaTime], [esi + Level.sizeBlocksMap], [esi + Level.pBlocksMap]
        stdcall Player.UpdateChasingLight, edi, [deltaTime], [esi + Level.sizeLightsMap], [esi + Level.pLightsMap]
        pop     ecx

    loop    .UpdatePlayer

    ret
endp

proc Player.UpdateChasingLight uses edi esi ebx,\
    pPlayer, dt, sizeLightMap, pLigthMap

    locals
        lightChasingRadius      dd          ?
        trigger                 dd          false
        velocity                dd          0.0
        deltaPos                Vector3     ?
        divNorm                 dd          0.1
    endl

    mov     edi, [pPlayer]
    mov     esi, [edi + Player.pLevel]

    movzx   eax, [pl_stop_light]
    cmp     eax, false
    je      .Ret

    ; Get pointer to position light
    xor     edx, edx
    mov     eax, [edi + Player.offsetChasingLight]
    mov     ecx, sizeLight

    mul     ecx
    add     eax, [pLigthMap]
    mov     ebx, eax

    ; EBX, EDI are using
    ; Zeroing Velocity
    push    edi
    add     edi, Player.lightVelocity
    stdcall memzero, edi, 3 * 4
    pop     edi

    push    edi
    add     edi, Player.Position
    stdcall Vector3.Distance, edi, ebx
    pop     edi

    push    edi
    add     edi, Player.Position
    stdcall Vector3.Copy, orinVec, edi
    stdcall Vector3.Sub, orinVec, ebx
    stdcall Vector3.MultOnNumber, orinVec, [divNorm]
    pop     edi

    mov     esi, edi
    add     esi, Player.chasingLight

    cmp     [esi + Easing.done], true
    je     .SkipDoneChasingAni

    cmp     [esi + Easing.start], true
    je      .SkipStartChasingAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartChasingAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneChasingAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.lightVelocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.lightVelocity + Vector3.x]
    fld     [edi + Player.lightVelocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.lightVelocity + Vector3.y]
    fld     [edi + Player.lightVelocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.lightVelocity + Vector3.z]

    jmp     .SkipChasingAni

    .SkipDoneChasingAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.lightVelocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.lightVelocity + Vector3.x]
    fld     [edi + Player.lightVelocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.lightVelocity + Vector3.y]
    fld     [edi + Player.lightVelocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.lightVelocity + Vector3.z]

    jmp     .SkipChasingAni

    .SkipUpdateChasingAni:

    cmp     [esi + Easing.start], false
    je      .SkipChasingAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipChasingAni:

    ; EBX - position of light
    lea     esi, [deltaPos]
    push    edi
    add     edi, Player.lightVelocity
    stdcall Vector3.Copy, esi, edi
    pop     edi

    stdcall Vector3.MultOnNumber, esi, [dt]
    stdcall Vector3.Add, ebx, esi

    .SkipLightChasing:

.Ret:
    ret
endp

proc Player.ChangeNextLight uses edi esi ebx,\
    pPlayer

    mov     edi, [pPlayer]
    mov     esi, [edi + Player.pLevel]

    inc     [edi + Player.offsetChasingLight]
    mov     eax, [esi + Level.sizeLightsMap]
    cmp     [edi + Player.offsetChasingLight], eax
    jb      @F

    mov     [edi + Player.offsetChasingLight], 0

    @@:


.Ret:
    ret
endp
proc Player.ChangePrevLight uses edi esi ebx,\
    pPlayer

    mov     edi, [pPlayer]
    mov     esi, [edi + Player.pLevel]

    dec     [edi + Player.offsetChasingLight]
    cmp     [edi + Player.offsetChasingLight], 0
    jge     @F

    mov     eax, [esi + Level.sizeLightsMap]
    mov     [edi + Player.offsetChasingLight], eax
    dec     [edi + Player.offsetChasingLight]
    jmp     .Ret

    @@:


.Ret:
    ret
endp

; New player functions
proc Player.UpdatePosition uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap

    locals 
        deltaPos        Vector3         ?
        collisionX      dd              0
        collisionY      dd              0
        collisionZ      dd              0
    endl

    mov     edi, [pPlayer]

    push    edi
    mov     esi, edi
    add     edi, Player.Position
    add     esi, Player.prevPosition
    stdcall Vector3.Copy, esi, edi
    pop     edi

    lea     ebx, [deltaPos]
        
    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    stdcall Vector3.MultOnNumber, ebx, [dt]

    ; start of update
    stdcall Player.UpdatePosX, [pPlayer], [dt], [sizeMap], [pMap], ebx
    mov     [collisionX], eax
    stdcall Player.UpdatePosY, [pPlayer], [dt], [sizeMap], [pMap], ebx
    mov     [collisionY], eax
    stdcall Player.UpdatePosZ, [pPlayer], [dt], [sizeMap], [pMap], ebx
    mov     [collisionZ], eax

    ; update state of the player
    stdcall Player.UpdateState, [pPlayer], [pMap], [sizeMap], [collisionX], [collisionY], [collisionZ]

    ; update camera position
    stdcall Player.UpdateCamera, [pPlayer], [dt], [sizeMap], [pMap]

    ; update draw angles
    stdcall Player.UpdateDrawAngles, [pPlayer], [dt]

    stdcall Player.UpdateDrawData, [pPlayer]

    ret
endp

proc Player.UpdateDrawData uses edi esi ebx,\
    pPlayer

    mov     edi, [pPlayer]
    mov     esi, edi
    add     esi, Player.DrawPlayer

    invoke  WaitForSingleObject, [esi + DrawData.lock], INFINITY

    push    edi
    push    esi
    add     edi, Player.Position
    add     esi, DrawData.Position
    stdcall Vector3.Copy, esi, edi
    pop     esi
    pop     edi

    push    edi
    push    esi
    add     edi, Player.XYZangles
    add     esi, DrawData.Angles
    stdcall Vector3.Copy, esi, edi
    pop     esi
    pop     edi

    invoke  ReleaseMutex, [esi + DrawData.lock]

    ret
endp

proc Player.Draw uses edi esi ebx,\
    shaderId, pPlayer, pDrawData

    locals
        rotAngle        dd          0.0
        tmp             Vector3     ?
    endl

    mov     esi, [pPlayer]
    mov     esi, [esi + Player.pLevel]

    ; block drawing
    stdcall Shader.Activate, [shaderId]
    stdcall Draw.BindLightsForShader, [shaderId], [esi + Level.pLightsMap], [esi + Level.sizeLightsMap]
    stdcall Camera.UniformBind, [pPlayer], [shaderId], uniProjName, uniViewName

    mov     edi, [pDrawData]

        ; ambient
        lea     esi, [ambientTexs]
        add     esi, [edi + DrawData.AmbientTexId]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [shaderId], uniMatAmbientName, 0

        ; diffuse
        lea     esi, [diffuseTexs]
        add     esi, [edi + DrawData.DiffuseTexId]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE1
        stdcall Texture.texUnit, [shaderId], uniMatDiffuseName, 1

        ; specular
        lea     esi, [specularTexs]
        add     esi, [edi + DrawData.SpecularTexId]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE2
        stdcall Texture.texUnit, [shaderId], uniMatSpecularName, 2

        invoke  glGetUniformLocation, [shaderId], uniMatShininessName
        invoke  glUniform1f, eax, dword [edi + DrawData.Shininess]

    invoke  glPushMatrix
            invoke  glLoadIdentity
            invoke  glTranslatef, [edi + DrawData.Position + Vector3.x], [edi + DrawData.Position + Vector3.y], [edi + DrawData.Position + Vector3.z]
            fld     [edi + DrawData.Angles + Vector3.x]
            fmul    [radian]
            fstp    [rotAngle]
            invoke  glRotatef, dword [rotAngle], 1.0, 0.0, 0.0
            fld     [edi + DrawData.Angles + Vector3.y]
            fmul    [radian]
            fstp    [rotAngle]
            invoke  glRotatef, [rotAngle], 0.0, 1.0, 0.0
            fld     [edi + DrawData.Angles + Vector3.z]
            fmul    [radian]
            fstp    [rotAngle]
            invoke  glRotatef, [rotAngle], 0.0, 0.0, 1.0
            invoke  glScalef, [edi + DrawData.Scale + Vector3.x], [edi + DrawData.Scale + Vector3.y], [edi + DrawData.Scale + Vector3.z]
            invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
    invoke  glPopMatrix
    invoke  glGetUniformLocation, [shaderId], uniModelName
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

    lea     ebx, [tmp]
    mov     edi, [pPlayer]
    add     edi, Player.camera + Camera.camPosition
    stdcall Vector3.Copy, ebx, edi
    add     edi, (Camera.translate - Camera.camPosition)
    stdcall Vector3.Sub, ebx, edi
    invoke  glGetUniformLocation, [shaderId], uniCamPosName
    invoke  glUniform3f, eax, [ebx + Vector3.x], [ebx + Vector3.y], [ebx + Vector3.z]

    stdcall VAO.Bind, [blockVAO.ID]       
    invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
    stdcall VAO.Unbind


    ret
endp

proc Player.UpdateVelocity uses edi esi ebx,\
    pPlayer, sizeMap, pMap

    locals 
        null    dd      0.0
    endl

    mov     edi, [pPlayer]

    stdcall Player.UpdateAniOrinVecs, edi

    ; Zeroing Velocity
    push    edi
    add     edi, Player.Velocity
    stdcall memzero, edi, 3 * 4
    pop     edi

    stdcall Player.UpdateMovingVelocity, [pPlayer]
    stdcall Player.UpdateFJSVelocity, [pPlayer]
    stdcall Player.UpdateCameraVelocity, [pPlayer], [sizeMap], [pMap]

    ret
endp

proc Player.UpdateState uses edi esi ebx,\
    pPlayer, pMap, sizeMap, colX, colY, colZ

    locals 
        constSl         dd          0.01
        collision       dd          0
    endl

    mov     edi, [pPlayer]

    ; check positive X collision
    push    [edi + Player.Position + Vector3.x]
    fld     [edi + Player.Position + Vector3.x]
    fadd    [constSl]
    fstp    [edi + Player.Position + Vector3.x]

    ; check collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, X_COLLISION
    cmp     eax, NO_COLLISION
    je      @F

    mov     [edi + Player.Condition], SLIDE_STATE
    mov     [edi + Player.slideDirJump], X_DIR_MINUS

    mov     [edi + Player.slideVec + Vector3.x], -0.32
    mov     [edi + Player.slideVec + Vector3.y], 1.0
    mov     [edi + Player.slideVec + Vector3.z], 0.0
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.x], 0.0

    pop     [edi + Player.Position + Vector3.x]

    jmp     .SkipSlideState

    @@:

    pop     [edi + Player.Position + Vector3.x]

    ; check negative X collision
    push    [edi + Player.Position + Vector3.x]
    fld     [edi + Player.Position + Vector3.x]
    fsub    [constSl]
    fstp    [edi + Player.Position + Vector3.x]

    ; check collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, X_COLLISION
    cmp     eax, NO_COLLISION
    je      @F

    mov     [edi + Player.Condition], SLIDE_STATE
    mov     [edi + Player.slideDirJump], X_DIR_PLUS

    mov     [edi + Player.slideVec + Vector3.x], 0.32
    mov     [edi + Player.slideVec + Vector3.y], 1.0
    mov     [edi + Player.slideVec + Vector3.z], 0.0  
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.x], 0.0

    pop     [edi + Player.Position + Vector3.x]

    jmp     .SkipSlideState

    @@:

    pop     [edi + Player.Position + Vector3.x]

    ; check positive Z collision
    push    [edi + Player.Position + Vector3.z]
    fld     [edi + Player.Position + Vector3.z]
    fadd    [constSl]
    fstp    [edi + Player.Position + Vector3.z]

    ; check collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Z_COLLISION
    cmp     eax, NO_COLLISION
    je      @F

    mov     [edi + Player.Condition], SLIDE_STATE
    mov     [edi + Player.slideDirJump], Z_DIR_MINUS

    mov     [edi + Player.slideVec + Vector3.z], -0.32
    mov     [edi + Player.slideVec + Vector3.y], 1.0
    mov     [edi + Player.slideVec + Vector3.x], 0.0
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.z], 0.0

    pop     [edi + Player.Position + Vector3.z]

    jmp     .SkipSlideState

    @@:

    pop     [edi + Player.Position + Vector3.z]

    ; check negative Z collision
    push    [edi + Player.Position + Vector3.z]
    fld     [edi + Player.Position + Vector3.z]
    fsub    [constSl]
    fstp    [edi + Player.Position + Vector3.z]

    ; check collision
    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Z_COLLISION
    cmp     eax, NO_COLLISION
    je      @F

    mov     [edi + Player.Condition], SLIDE_STATE
    mov     [edi + Player.slideDirJump], Z_DIR_PLUS

    mov     [edi + Player.slideVec + Vector3.z], 0.32
    mov     [edi + Player.slideVec + Vector3.y], 1.0
    mov     [edi + Player.slideVec + Vector3.x], 0.0
    mov     [edi + Player.slideJump + Easing.orinVec + Vector3.z], 0.0

    pop     [edi + Player.Position + Vector3.z]

    jmp     .SkipSlideState

    @@:

    pop     [edi + Player.Position + Vector3.z]

    mov     [edi + Player.Condition], FALL_STATE

    mov     [edi + Player.slideAni + Easing.start], false
    mov     [edi + Player.slideAni + Easing.done], false

    mov     [edi + Player.slideNewJump], true

    .SkipSlideState:

    ; check Y collision
    cmp     [colY], DIR_Y_MAX
    je      .DownY

    cmp     [colY], DIR_Y_MIN
    je      .UpY

    cmp     [colY], NO_COLLISION
    je      .NoY

    jmp     .BothY

    .DownY:

        mov     [edi + Player.Condition], WALK_STATE
    
        mov     [edi + Player.fallAni + Easing.start], false
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false

        mov     [edi + Player.slideAni + Easing.start], false
        mov     [edi + Player.slideAni + Easing.done], false

        mov     [edi + Player.slideJump + Easing.start], false
        mov     [edi + Player.slideJump + Easing.done], false

        mov     [edi + Player.slideVec + Vector3.x], 0.0
        mov     [edi + Player.slideVec + Vector3.y], 1.0
        mov     [edi + Player.slideVec + Vector3.z], 0.0

        jmp     .SkipY

    .UpY:

        test    [edi + Player.Condition], SLIDE_STATE
        jnz      @F

        mov     [edi + Player.Condition], FALL_STATE

        @@:

        mov     [edi + Player.fallAni + Easing.start], false
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false
        
        mov     [edi + Player.slideAni + Easing.start], false
        mov     [edi + Player.slideAni + Easing.done], false

        mov     [edi + Player.slideJump + Easing.start], false
        mov     [edi + Player.slideJump + Easing.done], false

        jmp     .SkipY

    .BothY:

        mov     [edi + Player.Condition], WALK_STATE
        
        mov     [edi + Player.fallAni + Easing.done], false

        mov     [edi + Player.jumpAni + Easing.start], false
        mov     [edi + Player.jumpAni + Easing.done], false

        mov     [edi + Player.slideAni + Easing.start], false
        mov     [edi + Player.slideAni + Easing.done], false

        mov     [edi + Player.slideJump + Easing.start], false
        mov     [edi + Player.slideJump + Easing.done], false

        mov     [edi + Player.slideVec + Vector3.x], 0.0
        mov     [edi + Player.slideVec + Vector3.y], 1.0
        mov     [edi + Player.slideVec + Vector3.z], 0.0

        jmp     .SkipY

    .NoY:

        cmp     [edi + Player.Condition], SLIDE_STATE
        je      @F

        mov     [edi + Player.Condition], FALL_STATE

        @@:

        jmp     .SkipY

    .SkipY:

    ret
endp

; Return collision X at eax
proc Player.UpdatePosX uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap, deltaPos

    locals 
        collision       dd          NO_COLLISION
    endl

    mov     edi, [pPlayer]

    mov     esi, [deltaPos]
    fld     [edi + Player.Position + Vector3.x]
    fadd    [esi + Vector3.x]
    fstp    [edi + Player.Position + Vector3.x]

    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, X_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipUpdatePos

    mov     eax, [edi + Player.prevPosition + Vector3.x]
    mov     [edi + Player.Position + Vector3.x], eax

    mov     ebx, [deltaPos]
    stdcall Collision.BinSearch, [pPlayer], [sizeMap], [pMap], X_COLLISION, (Player.Position + Vector3.x),\
                (Player.prevPosition + Vector3.x), [ebx + Vector3.x]

    .SkipUpdatePos:

    mov     eax, [collision]

    ret
endp

; Return collision Z at eax
proc Player.UpdatePosZ uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap, deltaPos

    locals 
        collision       dd          NO_COLLISION
    endl

    mov     edi, [pPlayer]

    mov     esi, [deltaPos]
    fld     [edi + Player.Position + Vector3.z]
    fadd    [esi + Vector3.z]
    fstp    [edi + Player.Position + Vector3.z]

    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Z_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipUpdatePos

    mov     eax, [edi + Player.prevPosition + Vector3.z]
    mov     [edi + Player.Position + Vector3.z], eax

    mov     ebx, [deltaPos]
    stdcall Collision.BinSearch, [pPlayer], [sizeMap], [pMap], Z_COLLISION, (Player.Position + Vector3.z),\
                (Player.prevPosition + Vector3.z), [ebx + Vector3.z]

    .SkipUpdatePos:

    mov     eax, [collision]

    ret
endp

; Return collision Y at eax
proc Player.UpdatePosY uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap, deltaPos

    locals 
        collision       dd          NO_COLLISION
    endl

    mov     edi, [pPlayer]

    mov     esi, [deltaPos]
    fld     [edi + Player.Position + Vector3.y]
    fadd    [esi + Vector3.y]
    fstp    [edi + Player.Position + Vector3.y]

    lea     ebx, [collision]
    stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], ebx, Y_COLLISION
    cmp     eax, NO_COLLISION
    je      .SkipUpdatePos

    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax

    mov     ebx, [deltaPos]
    stdcall Collision.BinSearch, [pPlayer], [sizeMap], [pMap], Y_COLLISION, (Player.Position + Vector3.y),\
                (Player.prevPosition + Vector3.y), [ebx + Vector3.y]

    .SkipUpdatePos:

    mov     eax, [collision]

    ret
endp

proc Player.UpdateDrawAngles uses edi,\
    pPlayer, dt

    locals
        minAngle        dd      ?
        maxAngle        dd      ?
        testAngle       dd      0.3
    endl

    mov     edi, [pPlayer]

    fldpi
    fldpi
    faddp
    fst     [maxAngle]
    fchs
    fstp    [minAngle]

    ; X
    fld     [edi + Player.Velocity + Vector3.x]
    fmul    [dt]
    fmul    [testAngle]
    fadd    [edi + Player.XYZangles + Vector3.x]

    fcom    [minAngle]
    fstsw   ax
    sahf
    ja      @F

    fadd    [maxAngle]

    @@:

    fcom    [maxAngle]
    fstsw   ax
    sahf
    jb      @F

    fadd    [minAngle]

    @@:

    fstp    [edi + Player.XYZangles + Vector3.x]

    ; Y
    fld     [edi + Player.Velocity + Vector3.y]
    fmul    [dt]
    fmul    [testAngle]
    fadd    [edi + Player.XYZangles + Vector3.y]

    fcom    [minAngle]
    fstsw   ax
    sahf
    ja      @F

    fadd    [maxAngle]

    @@:

    fcom    [maxAngle]
    fstsw   ax
    sahf
    jb      @F

    fadd    [minAngle]

    @@:

    fstp    [edi + Player.XYZangles + Vector3.y]

    ; Z
    fld     [edi + Player.Velocity + Vector3.z]
    fmul    [dt]
    fmul    [testAngle]
    fadd    [edi + Player.XYZangles + Vector3.z]

    fcom    [minAngle]
    fstsw   ax
    sahf
    ja      @F

    fadd    [maxAngle]

    @@:

    fcom    [maxAngle]
    fstsw   ax
    sahf
    jb      @F

    fadd    [minAngle]

    @@:

    fstp    [edi + Player.XYZangles + Vector3.z]

    ret
endp

proc Player.UpdateAniOrinVecs uses edi esi ebx,\
    pPlayer

    locals
        negConst        dd          -1.0
        tmp             Vector3     ?
    endl

    mov     edi, [pPlayer]    

    ; forwAni 
    mov     esi, edi
    add     esi, (Player.forwAni + Easing.orinVec)
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, esi, edi
    pop     edi

    ; backAni 
    mov     esi, edi
    add     esi, (Player.backAni + Easing.orinVec)
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, esi, edi
    stdcall Vector3.MultOnNumber, esi, [negConst]
    pop     edi

    ; leftAni
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    mov     esi, edi
    add     esi, (Player.leftAni + Easing.orinVec)
    stdcall Vector3.Cross, upVec, ebx, esi

    ; rightAni
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    mov     esi, edi
    add     esi, (Player.rightAni + Easing.orinVec)
    stdcall Vector3.Cross, ebx, upVec, esi

    ; bforwAni 
    mov     esi, edi
    add     esi, (Player.bforwAni + Easing.orinVec)
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, esi, edi
    pop     edi

    ; bbackAni 
    mov     esi, edi
    add     esi, (Player.bbackAni + Easing.orinVec)
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, esi, edi
    stdcall Vector3.MultOnNumber, esi, [negConst]
    pop     edi

    ; bleftAni
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    mov     esi, edi
    add     esi, (Player.bleftAni + Easing.orinVec)
    stdcall Vector3.Cross, upVec, ebx, esi

    ; brightAni
    lea     ebx, [tmp]
    push    edi
    add     edi, Player.Dir
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    push    edi
    add     edi, (Player.camera + Camera.Up)
    stdcall Vector3.Copy, upVec, edi
    pop     edi

    mov     esi, edi
    add     esi, (Player.brightAni + Easing.orinVec)
    stdcall Vector3.Cross, ebx, upVec, esi

    ret
endp

proc Player.UpdateMovingVelocity uses edi esi ebx,\
    pPlayer

    mov     edi, [pPlayer]

    ; Calculate Velocity that depends on animations
    ; Forward animation
    push    edi
    mov     esi, edi
    add     edi, Player.forwAni
    movzx   eax, [pl_forward]
    stdcall Player.HandlerContinueAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; Backward animation
    push    edi
    mov     esi, edi
    add     edi, Player.backAni
    movzx   eax, [pl_backward]
    stdcall Player.HandlerContinueAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; Left animation
    push    edi
    mov     esi, edi
    add     edi, Player.leftAni
    movzx   eax, [pl_left]
    stdcall Player.HandlerContinueAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; right animation
    push    edi
    mov     esi, edi
    add     edi, Player.rightAni
    movzx   eax, [pl_right]
    stdcall Player.HandlerContinueAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; Slowing animation
    ; Forward animation
    push    edi
    mov     esi, edi
    add     edi, Player.bforwAni
    movzx   eax, [pl_forward]
    xor     eax, 1
    stdcall Player.HandlerStopAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; Backward animation
    push    edi
    mov     esi, edi
    add     edi, Player.bbackAni
    movzx   eax, [pl_backward]
    xor     eax, 1
    stdcall Player.HandlerStopAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; Left animation
    push    edi
    mov     esi, edi
    add     edi, Player.bleftAni
    movzx   eax, [pl_left]
    xor     eax, 1
    stdcall Player.HandlerStopAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; right animation
    push    edi
    mov     esi, edi
    add     edi, Player.brightAni
    movzx   eax, [pl_right]
    xor     eax, 1
    stdcall Player.HandlerStopAni, [pPlayer], edi, eax, [esi + Player.speed]
    pop     edi

    ; Shift -> boost to speed
    cmp     [pl_run], false
    je      @F
    
    mov     [edi + Player.speed], 0.015

    jmp     .SkipRun

    @@:

    mov    [edi + Player.speed], 0.015

    .SkipRun:


    ret
endp

proc Player.HandlerStopAni uses edi esi,\
    pPlayer, pAni, trigger, vel

    locals 
        velocity        dd      0.0
    endl

    mov     edi, [pPlayer]
    mov     esi, [pAni]

    ; Forward animation
    cmp     [trigger], false
    je      .SkipUpdateAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneAni

    cmp     [esi + Easing.start], true
    je      .SkipStartAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [vel]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipAni

    .SkipDoneAni:

    mov     [esi + Easing.done], true

    jmp     .SkipAni

    .SkipUpdateAni:

    cmp     [esi + Easing.start], false
    je      .SkipAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipAni:

    .Ret: 
    ret
endp
proc Player.HandlerContinueAni uses edi esi,\
    pPlayer, pAni, trigger, vel

    locals 
        velocity        dd      0.0
    endl

    mov     edi, [pPlayer]
    mov     esi, [pAni]

    ; Forward animation
    cmp     [trigger], false
    je      .SkipUpdateAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneAni

    cmp     [esi + Easing.start], true
    je      .SkipStartAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [vel]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipAni

    .SkipDoneAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [vel]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipAni

    .SkipUpdateAni:

    cmp     [esi + Easing.start], false
    je      .SkipAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipAni:

    .Ret: 
    ret
endp

proc Player.UpdateFJSVelocity uses edi esi ebx,\
    pPlayer

    locals 
        velocity        dd          0.0
    endl

    mov     edi, [pPlayer]

    ; Fall animation
    mov     eax, FALL_STATE
    or      eax, SLIDE_STATE

    and    eax, [edi + Player.Condition]
    jz      @F

    mov     eax, true

    @@:

    mov     esi, edi
    add     esi, Player.fallAni
    stdcall Player.HandlerContinueAni, edi, esi, eax, [edi + Player.Acceleration + Vector3.y]

    ; Jump animation
    mov     esi, edi 
    add     esi, Player.jumpAni

    cmp     [esi + Easing.done], true
    je      .SkipDoneJumpAni

    cmp     [esi + Easing.start], true
    je      .SkipStartJumpAni

    cmp     [pl_jump], false
    je      .SkipUpdateJumpAni

    cmp     [edi + Player.Condition], WALK_STATE
    jne      .SkipUpdateJumpAni

    mov     [edi + Player.Condition], FALL_STATE
    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    mov     [edi + Player.fallAni + Easing.start], false
    mov     [edi + Player.fallAni + Easing.done], false

    mov     [edi + Player.slideJump + Easing.start], false
    mov     [edi + Player.slideJump + Easing.done], false
    
    .SkipStartJumpAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneJumpAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipJumpAni

    .SkipDoneJumpAni:

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration] 
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipJumpAni

    .SkipUpdateJumpAni:

    cmp     [esi + Easing.start], false
    je      .SkipJumpAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipJumpAni:
   
    ; Slide animation
    mov     eax, SLIDE_STATE

    and    eax, [edi + Player.Condition]
    jz     @F

    mov     eax, true

    @@:

    push    eax
    mov     esi, edi
    add     esi, Player.slideAni
    stdcall Player.HandlerContinueAni, edi, esi, eax, [edi + Player.Acceleration + Vector3.y]
    pop     eax    

    ; Slide jump animation
    mov     esi, edi 
    add     esi, Player.slideJump

    cmp     eax, true
    jne     @F 

    cmp     [pl_jump], true
    jne     @F

    cmp     [edi + Player.slideNewJump], true
    je      .SkipNewSlideJump

    @@:

    cmp     [esi + Easing.done], true
    je      .SkipDoneSlideJumpAni

    cmp     [esi + Easing.start], true
    je      .SkipStartSlideJumpAni

    cmp     [pl_jump], false
    je      .SkipUpdateSlideJumpAni

    .SkipNewSlideJump:

    cmp     [edi + Player.Condition], SLIDE_STATE
    jne      .SkipUpdateSlideJumpAni

    invoke  GetTickCount

    mov     [edi + Player.slideNewJump], false
    mov     [edi + Player.Condition], FALL_STATE
    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    mov     [edi + Player.fallAni + Easing.start], false
    mov     [edi + Player.fallAni + Easing.done], false

    mov     [edi + Player.jumpAni + Easing.start], false
    mov     [edi + Player.jumpAni + Easing.done], false

    push    edi
    push    esi
    add     edi, Player.slideVec
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, esi, edi
    pop     esi
    pop     edi
    
    .SkipStartSlideJumpAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneSlideJumpAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipSlideJumpAni

    .SkipDoneSlideJumpAni:

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration] 
    mov     [velocity], eax 

    fld     [edi + Player.jumpVeloc]
    fmul    [velocity]
    fstp    [velocity]

    push    esi
    add     esi, Easing.orinVec
    stdcall Vector3.Copy, orinVec, esi
    stdcall Vector3.MultOnNumber, orinVec, [velocity]
    pop     esi

    push    edi
    add     edi, Player.Velocity
    stdcall Vector3.Add, edi, orinVec
    pop     edi

    jmp     .SkipSlideJumpAni

    .SkipUpdateSlideJumpAni:

    cmp     [esi + Easing.start], false
    je      .SkipSlideJumpAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipSlideJumpAni:

.Ret:
    ret
endp

proc Player.UpdateCameraVelocity uses edi esi ebx,\
    pPlayer, sizeMap, pMap

    locals 
        camchasingRadius        dd              ?
        velocity                dd              0.0
        tmpDist                 dd              0.05
        trigger                 dd              false
        tmp                     Vector3         ?
        tmpVel                  dd              ?
        conNum                  dd              3.0
        normDiv                 dd              2.0
    endl

    mov     edi, [pPlayer]

    ; texture easing
    mov     [edi + Player.camTextureVel], 0.0

    ; texture radius
    cmp     [pl_stop_cam_tex], true
    je      .SkipCamTex

    stdcall Collision.RayDetection, [pPlayer], [sizeMap], [pMap]
    mov     [edi + Player.curCamRadius], eax

    fld     [edi + Player.curCamRadius]
    fsub    [edi + Player.camera + Camera.radius]
    fmul    [normDiv]
    fstp    [tmpVel]

    mov     esi, edi
    add     esi, Player.camTexture

    cmp     [esi + Easing.done], true
    je     .SkipDoneTextureAni

    cmp     [esi + Easing.start], true
    je      .SkipStartTextureAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartTextureAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneTextureAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    fld     [tmpVel]
    fmul    [velocity]
    fstp    [edi + Player.camTextureVel]

    jmp     .SkipTextureAni

    .SkipDoneTextureAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    fld     [tmpVel]
    fmul    [velocity]
    fstp    [edi + Player.camTextureVel]

    jmp     .SkipTextureAni

    .SkipUpdateTextureAni:

    cmp     [esi + Easing.start], false
    je      .SkipTextureAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipTextureAni:

    .SkipCamTex:

    ; Zeroing Velocity
    push    edi
    add     edi, (Player.camera + Camera.camVelocity)
    stdcall memzero, edi, 3 * 4
    pop     edi

    push    edi
    mov     esi, edi
    add     edi, Player.Position
    add     esi, (Player.camera + Camera.camPosition)
    stdcall Vector3.Distance, edi, esi
    pop     edi

    mov     [camchasingRadius], eax
    fld     [camchasingRadius]
    fcomp   [edi + Player.chasingRadius]
    fstsw   ax
    sahf
    jb      @F

    mov     [trigger], true

    @@: 

    cmp     [pl_stop_cam_chasing], true
    je      .SkipCamChasing

    push    edi
    mov     esi, edi
    add     esi, (Player.camera + Camera.camPosition)
    add     edi, Player.Position
    stdcall Vector3.Copy, orinVec, edi
    stdcall Vector3.Sub, orinVec, esi
    pop     edi

    mov     esi, edi
    add     esi, (Player.camera + Camera.moving)

    ; Cam animation
    cmp     [trigger], false
    je      .SkipUpdateChasingAni

    cmp     [esi + Easing.done], true
    je     .SkipDoneChasingAni

    cmp     [esi + Easing.start], true
    je      .SkipStartChasingAni

    mov     [esi + Easing.start], true
    invoke  GetTickCount
    mov     [esi + Easing.startTime], eax

    .SkipStartChasingAni:

    invoke  GetTickCount
    sub     eax, [esi + Easing.startTime]
    cmp     eax, [esi + Easing.duration]
    ja      .SkipDoneChasingAni

    stdcall [esi + Easing.ptrEasingFun], eax
    mov     [velocity], eax 

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.z]

    jmp     .SkipChasingAni

    .SkipDoneChasingAni:

    mov     [esi + Easing.done], true

    stdcall [esi + Easing.ptrEasingFun], [esi + Easing.duration]
    mov     [velocity], eax

    fld     [edi + Player.speed]
    fmul    [velocity]
    fstp    [velocity]

    stdcall Vector3.MultOnNumber, orinVec, [velocity]

    fld     [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fadd    [orinVec + Vector3.x]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.x]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fadd    [orinVec + Vector3.y]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.y]
    fld     [edi + Player.camera + Camera.camVelocity + Vector3.z]
    fadd    [orinVec + Vector3.z]
    fstp    [edi + Player.camera + Camera.camVelocity + Vector3.z]

    jmp     .SkipChasingAni

    .SkipUpdateChasingAni:

    cmp     [esi + Easing.start], false
    je      .SkipChasingAni

    mov     [esi + Easing.start], false
    mov     [esi + Easing.done], false

    .SkipChasingAni:

    .SkipCamChasing:

    ret
endp

proc Player.UpdateCamera uses edi esi ebx,\
    pPlayer, dt, sizeMap, pMap

    locals 
        deltaPos        Vector3         ?
        deltaRadius     GLfloat         ?
    endl

    mov     edi, [pPlayer]

    fld     [edi + Player.camTextureVel]
    fmul    [dt]
    fstp    [deltaRadius]

    fld     [edi + Player.camera + Camera.radius]
    fadd    [deltaRadius]
    fstp    [edi + Player.camera + Camera.radius]

    push    edi
    lea     ebx, [deltaPos]
    add     edi, (Player.camera + Camera.camVelocity)
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    stdcall Vector3.MultOnNumber, ebx, [dt]

    push    edi
    add     edi, (Player.camera + Camera.camPosition)
    stdcall Vector3.Add, edi, ebx
    pop     edi

    ret
endp

proc Player.InputsMouse uses edi esi ebx,\
    pPlayer, uMsg, wParam, lParam

    locals 
        sensetivity     dd          ?
        xoffset         dd          ?
        yoffset         dd          ?
        WHEEL_DELTA     dd          0.002
        tmp             dd          ?
        tmpw            dw          ?
    endl

    mov     edi, [pPlayer]

    mov     eax, [uMsg]
    JumpIf  WM_MOUSEMOVE,   .MouseMove
    JumpIf  WM_MOUSEWHEEL,  .MouseWheel
    JumpIf  WM_RBUTTONDOWN, .MouseRButtonDown
    JumpIf  WM_RBUTTONUP,   .MouseRButtonUp

    jmp     .Ret


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
        fmul    [edi + Player.camera + Camera.sensitivity]
        fstp    [xoffset]

        fild    [yoffset]
        fmul    [edi + Player.camera + Camera.sensitivity]
        fstp    [yoffset]

        fld     [edi + Player.camera + Camera.yaw]
        fadd    [xoffset]
        fstp    [edi + Player.camera + Camera.yaw]

        fld     [edi + Player.camera + Camera.pitch]
        fadd    [yoffset]
        fstp    [edi + Player.camera + Camera.pitch]

        fld     [edi + Player.camera + Camera.pitch]
        fcomp   [maxPlayerPitch]
        fstsw   ax
        sahf 
        jb      @F

        mov     eax, [maxPlayerPitch]    
        mov     [edi + Player.camera + Camera.pitch], eax

        @@:

        fld     [maxPlayerPitch]
        fchs
        fcomp   [edi + Player.camera + Camera.pitch]
        fstsw   ax
        sahf 
        jb      @F

        fld     [maxPlayerPitch]
        fchs
        fstp    [edi + Player.camera + Camera.pitch]
        
        @@:

        stdcall Camera.Direction, edi
        stdcall Player.Direction, edi
        stdcall Camera.NormalizeCursor, lastCursorPos

        jmp     .Ret

    .MouseWheel:

        mov     eax, [wParam]
        shr     eax, 16

        mov     [tmpw], ax
        fild    word [tmpw]
        fmul    [WHEEL_DELTA]
        fchs
        fstp    [tmp]   

        fld     [edi + Player.maxCamRadius]
        fadd    [tmp]
        fstp    [edi + Player.maxCamRadius]

        stdcall Number.DoubleMax, [edi + Player.maxCamRadius], [edi + Player.minCamRadius]
        mov     [edi + Player.maxCamRadius], eax
        mov     eax, 150.0
        stdcall Number.DoubleMin, [edi + Player.maxCamRadius], eax
        mov     [edi + Player.maxCamRadius], eax

        jmp     .Ret

    .MouseRButtonDown:

        mov     [pl_jump], true

        jmp     .Ret

    .MouseRButtonUp:

        mov     [pl_jump], false

        jmp     .Ret

.Ret:

    ret
endp

proc Player.KeyDown\
    pPlayer, wParam, lParam

    cmp     [wParam], PL_JUMP
    jne     @F

    mov     [pl_jump], true
    jmp     .SkipDown

    @@:

    cmp     [wParam], PL_FORWARD
    jne     @F

    mov     [pl_forward], true
    jmp     .SkipDown

    @@:

    cmp     [wParam], PL_BACKWARD
    jne     @F

    mov     [pl_backward], true
    jmp     .SkipDown

    @@:

    cmp     [wParam], PL_LEFT
    jne     @F

    mov     [pl_left], true
    jmp     .SkipDown

    @@:

    cmp     [wParam], PL_RIGHT
    jne     @F

    mov     [pl_right], true
    jmp     .SkipDown

    @@:

    cmp     [wParam], PL_WEAK_COLOR
    jne     @F

    jmp     .SkipDown

    @@:

    .SkipDown:

    ret
endp

proc Player.ChangeColorLight uses edi,\
    pPlayer, offsetColorLight

    mov     edi, [pPlayer]

    mov     eax, [offsetColorLight]    
    mov     [edi + Player.offsetColorLight], eax

    ret
endp

proc Player.EnhanceLightIntensity uses edi esi ebx,\
    pPlayer

    mov     edi, [pPlayer]

    mov     eax, [edi + Player.offsetChasingLight]
    mov     esi, eax
    mov     ecx, sizeLight
    mul     ecx

    mov     ebx, [edi + Player.pLevel]

    cmp     esi, [ebx + Level.sizeLightsMap]
    je      .Ret

    mov     esi, eax
    add     esi, [ebx + Level.pLightsMap]
    add     esi, colorLightOffset
    add     esi, [edi + Player.offsetColorLight]


    fld     dword [esi]
    fadd    [colorStep]
    fstp    dword [esi]

.Ret:
    ret
endp

proc Player.DecreaseLightIntensity uses edi esi ebx,\
    pPlayer

    mov     edi, [pPlayer]

    mov     eax, [edi + Player.offsetChasingLight]
    mov     esi, eax
    mov     ecx, sizeLight
    mul     ecx

    mov     ebx, [edi + Player.pLevel]

    cmp     esi, [ebx + Level.sizeLightsMap]
    je      .Ret

    mov     esi, eax
    add     esi, [ebx + Level.pLightsMap]
    add     esi, colorLightOffset
    add     esi, [edi + Player.offsetColorLight]

    fld     dword [esi]
    fsub    [colorStep]
    fstp    dword [esi]

.Ret:
    ret
endp

proc Player.KeyUp uses edi esi,\
    pPlayer, wParam, lParam

    cmp     [wParam], PL_JUMP
    jne     @F

    mov     [pl_jump], false
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_FORWARD
    jne     @F

    mov     [pl_forward], false
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_BACKWARD
    jne     @F

    mov     [pl_backward], false
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_LEFT
    jne     @F

    mov     [pl_left], false
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_RIGHT
    jne     @F

    mov     [pl_right], false
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_ENHANCE_COLOR
    jne     @F

    stdcall Player.EnhanceLightIntensity, [pPlayer]
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_WEAK_COLOR
    jne     @F

    stdcall Player.DecreaseLightIntensity, [pPlayer]
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_STOP_CAM_CHASING
    jne     @F

    xor     [pl_stop_cam_chasing], true
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_STOP_CAM_TEX
    jne     @F

    xor     [pl_stop_cam_tex], true
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_NEXT_LIGHT
    jne     @F

    stdcall Player.ChangeNextLight, [pPlayer]
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_PREV_LIGHT
    jne     @F

    stdcall Player.ChangePrevLight, [pPlayer]
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_RESPAWN 
    jne     @F
    
    mov     edi, [pPlayer]
    mov     edi, [edi + Player.pLevel]
    add     edi, Level.spawnPosition
    stdcall Player.Respawn, [pPlayer], edi
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_LIGHT_R 
    jne     @F

    stdcall Player.ChangeColorLight, [pPlayer], 0
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_LIGHT_G 
    jne     @F

    stdcall Player.ChangeColorLight, [pPlayer], 4
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_LIGHT_B 
    jne     @F

    stdcall Player.ChangeColorLight, [pPlayer], 8
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_LEVEL_SAVE_KEY
    jne     @F

    mov     edi, [pPlayer]
    stdcall Level.Save, [edi + Player.pLevel]
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_STOP_LIGHT
    jne     @F

    xor     [pl_stop_light], true
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_HELP
    jne     @F

    xor     [pl_help], true
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_MAP
    jne     @F

    xor     [pl_map], true
    jmp     .SkipUp

    @@:

    cmp     [wParam], PL_TELEPORT
    jne     @F

    mov     edi, [pPlayer]
    mov     esi, [edi + Player.pLevel]
    mov     eax, sizeLight
    mul     [edi + Player.offsetChasingLight]
    add     eax, [esi + Level.pLightsMap]
    stdcall Player.Respawn, [pPlayer], eax
    jmp     .SkipUp

    @@:

    .SkipUp:

    ret
endp

proc Player.Direction uses edi,\
    pPlayer 

    locals 
        null        dd      0.0
    endl

    mov     edi, [pPlayer]

    ; Ox camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.camera + Camera.yaw]
    fcos 
    fmulp
    fstp    [edi + Player.Dir + Vector3.x]

    ; Oy camera direction
    fld     [null]
    fsin    
    fstp    [edi + Player.Dir + Vector3.y]

    ; Oz camera direction
    fld     [null]
    fcos    
    fld     [edi + Player.camera + Camera.yaw]
    fsin 
    fmulp
    fstp    [edi + Player.Dir + Vector3.z]

    ret
endp