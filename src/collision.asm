;       offsets         scale = 12, rotate = 12, traslate = 12, texture = 4, material = 4, collision = 4
proc Collision.MapDetection uses edi esi ebx,\
    pPlayer, sizeBlocksMap, blocksMap, result, dir

    locals 
        detected        dd      ?
        allDetected     dd      0
    endl

    mov     edi, [blocksMap]
    mov     esi, [pPlayer]
    mov     ecx, [sizeBlocksMap]

    .CheckLoop:
        push    ecx

        stdcall Collision.BlockDetection, esi, edi, [dir]
        or      [allDetected], eax

    .Skip:
        pop     ecx
        add     edi, sizeBlock 
        loop    .CheckLoop

    .Go_out:
    
    mov     edi, [result]
    mov     eax, [allDetected]
    mov     [edi], eax
    ret

endp

; Just for more easier fall
proc Collision.BinSearch uses edi esi ebx,\
    pPlayer, sizeMap, pMap, dir, offsetPositionDir, offsetPrevPositionDir, deltaPosDir 

    locals 
        div2            dd          2.0
        constCmp        dd          0.0001
        left            dd          0
        right           dd          ?
        mid             dd          ?
        collision       dd          ?
        tmp             dd          ?
    endl

    ; Player pointer
    mov     edi, [pPlayer]

    ; Pointer to Position and prevPosition dir
    mov     esi, edi
    add     esi, [offsetPositionDir]

    mov     ebx, edi
    add     ebx, [offsetPrevPositionDir]

    ; Initial assignment
    mov     eax, [deltaPosDir]
    mov     [right], eax

    ; Loop for binsearch position for player in order to 
    ; player do not touch block's collision 
    .BinLoop: 

        ; Comparing to out of the cycle
        fld     [right]
        fsub    [left]
        fabs
        fcomp   [constCmp]
        fstsw   ax
        sahf
        jb      .OutBinLoop

        ; New mid
        fld     [right]
        fadd    [left]
        fdiv    [div2]
        fstp    [mid]

        fld     dword [esi]
        fadd    [mid]
        fstp    dword [esi]

        lea     edx, [collision]
        stdcall Collision.MapDetection, [pPlayer], [sizeMap], [pMap], edx, [dir]

        ; Update position of the player
        cmp     eax, NO_COLLISION
        je      .NoCollisionDetected
        
        .CollisionDetected:

            stdcall Number.DoubleSign, [mid]
            mov     [tmp], eax
            fld     [tmp]
            fmul    [constCmp]
            fstp    [tmp]
            
            fld     [mid]
            fsub    [tmp]
            fstp    [right]

            jmp     @F

        .NoCollisionDetected:

            mov     eax, [mid]
            mov     [left], eax

        @@:

        mov     eax, dword [ebx]
        mov     dword [esi], eax

        jmp     .BinLoop
    
    .OutBinLoop:

    fld     dword [esi]
    fadd    [left]
    fstp    dword [esi]

    ret
endp

proc Collision.BlockDetection uses edi esi ebx,\
    pPlayer, pBlockPosition, dir

    locals 
        minResultPlayer         Vector4     ?
        maxResultPlayer         Vector4     ?
        minResultBlock          Vector4     ?
        maxResultBlock          Vector4     ?
        tmp                     Vector3     0.0, 0.0, 0.0
        scale                   Vector3     0.0, 0.0, 0.0
        rotate                  Vector3     0.0, 0.0, 0.0
        translate               Vector3     0.0, 0.0, 0.0
    endl

    mov     esi, [pPlayer]
    mov     edi, [pBlockPosition]

    lea     edx, [scale]
    mov     ecx, [esi + Player.sizeBlockCol]
    mov     [edx + Vector3.x], ecx
    mov     [edx + Vector3.y], ecx
    mov     [edx + Vector3.z], ecx

    lea     ecx, [rotate]
    fld     [esi + Player.camera + Camera.yaw]
    fmul    [radian]
    fchs
    fstp    [ecx + Vector3.y]

    ; Calculate Player max and min vertices
    lea     ebx, [minResultPlayer]
    lea     eax, [maxResultPlayer]
    push    esi
    push    edi
    add     esi, Player.Position
    lea     edx, [scale]
    lea     edi, [rotate]
    stdcall Collision.minMaxOptimizeBlockVerts, ebx, eax, edx, edi, esi;, vertices, 24, 44
    pop     edi
    pop     esi

    ; Calculate Block max and min vertices
    lea     ebx, [minResultBlock]
    lea     eax, [maxResultBlock]
    push    esi
    push    edi
    mov     esi, edi
    add     edi, translateOffset
    add     esi, scaleOffset
    lea     ecx, [tmp]
    stdcall Collision.minMaxOptimizeBlockVerts, ebx, eax, esi, ecx, edi 
    pop     edi
    pop     esi

    lea     esi, [minResultPlayer]
    lea     ebx, [maxResultPlayer]

    fld     [esi + Vector4.x]
    fcomp   [maxResultBlock.x]
    fstsw   ax
    sahf
    ja      .NoCollision

    fld     [ebx + Vector4.x]
    fcomp   [minResultBlock.x]
    fstsw   ax
    sahf
    jb      .NoCollision

    fld     [esi + Vector4.y]
    fcomp   [maxResultBlock.y]
    fstsw   ax
    sahf
    ja      .NoCollision

    fld     [ebx + Vector4.y]
    fcomp   [minResultBlock.y]
    fstsw   ax
    sahf
    jb      .NoCollision

    fld     [esi + Vector4.z]
    fcomp   [maxResultBlock.z]
    fstsw   ax
    sahf
    ja      .NoCollision

    fld     [ebx + Vector4.z]
    fcomp   [minResultBlock.z]
    fstsw   ax
    sahf
    jb      .NoCollision
    
    lea     edi, [minResultPlayer]
    lea     esi, [minResultBlock]
    stdcall [dir], edi, esi
    jmp     .Ret

    .NoCollision:

    mov     eax, NO_COLLISION

    .Ret:   

    ret
endp

proc Collision.XCollision uses edi esi,\
    pMinPlayerVrt, pMinBlockVrt

    mov     esi, [pMinPlayerVrt]
    mov     edi, [pMinBlockVrt]

    fld     [esi + Vector3.x]
    fcomp   [edi + Vector3.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, dword DIR_X_MIN
    jmp     .Ret

    @@:
    
    mov     eax, dword DIR_X_MAX 

.Ret:

    ret
endp

proc Collision.YCollision uses edi esi,\
    pMinPlayerVrt, pMinBlockVrt

    mov     esi, [pMinPlayerVrt]
    mov     edi, [pMinBlockVrt]

    fld     [esi + Vector3.y]
    fcomp   [edi + Vector3.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, dword DIR_Y_MIN
    jmp     .Ret

    @@:
    
    mov     eax, dword DIR_Y_MAX 

.Ret:

    ret
endp

proc Collision.ZCollision uses edi esi,\
    pMinPlayerVrt, pMinBlockVrt

    mov     esi, [pMinPlayerVrt]
    mov     edi, [pMinBlockVrt]

    fld     [esi + Vector3.z]
    fcomp   [edi + Vector3.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, dword DIR_Z_MIN
    jmp     .Ret

    @@:
    
    mov     eax, dword DIR_Z_MAX 

.Ret:

    ret
endp

proc Collision.AllCollision\
    pMinPlayerVrt, pMinBlockVrt

    mov     eax, dword DIR_XYZ_BTH 

    ret
endp

proc Collision.minMaxOptimizeBlockVerts uses edi esi ebx,\
    pMinVrt, pMaxVrt, pScl, pRot, pTrl

    locals 
        ; Bottom vertecies
        vrt0        Vector4          0.5,  0.5,  0.5, 1.0
        vrt1        Vector4         -0.5, -0.5, -0.5, 1.0

        ; Model matrix
        model       Matrix4x4       ?
    endl

    mov     edi, [pScl]
    mov     ebx, [pTrl]

    invoke  glPushMatrix
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        invoke  glTranslatef, [ebx + Vector3.x], [ebx + Vector3.y], [ebx + Vector3.z]
        invoke  glScalef, [edi + Vector3.x], [edi + Vector3.y], [edi + Vector3.z] 
        lea     eax, [model]
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, eax
    invoke  glPopMatrix

    lea     ebx, [model] 

    lea     esi, [vrt0]
    mov     edi, [pMaxVrt]
    stdcall Matrix.MultVec4OnMat4x4, esi, ebx, edi 

    lea     esi, [vrt1]
    mov     edi, [pMinVrt]
    stdcall Matrix.MultVec4OnMat4x4, esi, ebx, edi 

.Ret:

    ret
endp
proc Collision.minMaxBlockVerts uses edi esi ebx,\
    pMinVrt, pMaxVrt, pScl, pRot, pTrl, pObject, cntVertecies, sizeVertex

    locals 
        ; Bottom vertecies
        vrtTmp        Vector4         0.0, 0.0, 0.0, 1.0

        ; Model matrix
        model       Matrix4x4       ?
    endl

    mov     edi, [pScl]
    mov     esi, [pRot]
    mov     ebx, [pTrl]

    invoke  glPushMatrix
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        invoke  glTranslatef, [ebx + Vector3.x], [ebx + Vector3.y], [ebx + Vector3.z]
        invoke  glRotatef, [esi + Vector3.x], 1.0, 0.0, 0.0
        invoke  glRotatef, [esi + Vector3.y], 0.0, 1.0, 0.0
        invoke  glRotatef, [esi + Vector3.z], 0.0, 0.0, 1.0
        invoke  glScalef, [edi + Vector3.x], [edi + Vector3.y], [edi + Vector3.z] 
        lea     ebx, [model]
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ebx
    invoke  glPopMatrix

    mov     esi, [pObject]

    ; 0 Vertice
    lea     edi, [vrtTmp]
    stdcall Vector3.Copy, edi, esi
    ; Max and Min vrt's X, Y and Z
    mov     edx, [pMinVrt]
    push    edx
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, edx 
    pop     edx
    mov     edi, [pMaxVrt]
    stdcall Vector4.Copy, edi, edx

    mov     ecx, [cntVertecies]
    dec     ecx

    cmp     ecx, 0
    jbe     .SkipMinMaxLoop

    add     esi, [sizeVertex]
    .loopMinMax:
        push    ecx

        lea     edi, [vrtTmp]
        stdcall Matrix.MultVec4OnMat4x4, esi, ebx, edi

        mov     edx, [pMinVrt]
        stdcall Number.DoubleMin, [edi + Vector3.x], [edx + Vector3.x]
        mov     [edx + Vector3.x], eax
        stdcall Number.DoubleMin, [edi + Vector3.y], [edx + Vector3.y]
        mov     [edx + Vector3.y], eax
        stdcall Number.DoubleMin, [edi + Vector3.z], [edx + Vector3.z]
        mov     [edx + Vector3.z], eax

        mov     edx, [pMaxVrt]
        stdcall Number.DoubleMax, [edi + Vector3.x], [edx + Vector3.x]
        mov     [edx + Vector3.x], eax
        stdcall Number.DoubleMax, [edi + Vector3.y], [edx + Vector3.y]
        mov     [edx + Vector3.y], eax
        stdcall Number.DoubleMax, [edi + Vector3.z], [edx + Vector3.z]
        mov     [edx + Vector3.z], eax

    .Countinue:
        add     esi, [sizeVertex]
        pop     ecx
        loop    .loopMinMax

    .SkipMinMaxLoop:

.Ret:

    ret
endp

; Return maxFar distance for ray 
proc Collision.RayDetection uses edi esi ebx,\
    pPlayer, sizeBlocksMap, blocksMap

    locals 
        detected        dd              ?
        null            dd              0.0 
        norm            dd              0.2
        allDetected     dd              -1.0
        dir             Vector3         ?
        origin          Vector3         ?
    endl

    mov     edi, [pPlayer]
    
    push    [edi + Player.camera + Camera.radius]
    fld     [edi + Player.maxCamRadius]
    fstp    [edi + Player.camera + Camera.radius]
    stdcall Camera.ViewPosition, [pPlayer]
    pop     [edi + Player.camera + Camera.radius]

    ; Calculate camera ray dir 
    mov     edi, [pPlayer]

    lea     esi, [origin]
    push    edi
    add     edi, (Player.camera + Camera.camPosition)
    stdcall Vector3.Add, esi, edi
    pop     edi
    push    edi
    add     edi, (Player.camera + Camera.translate)
    stdcall Vector3.Sub, esi, edi
    pop     edi

    lea     ebx, [dir]
    push    edi
    add     edi, (Player.camera + Camera.Orientation)
    stdcall Vector3.Copy, ebx, edi
    pop     edi

    ; loop for intersect
    mov     esi, [blocksMap]
    mov     ecx, [sizeBlocksMap]

    .CheckLoop:
        push    ecx

        lea     edx, [dir]
        lea     eax, [origin]
        stdcall Collision.RayBlockIntersect, edi, esi, edx, eax
        mov     [detected], eax

        ; Start checking ray distance for collisions
        ; If ray is not intersect with block
        fld     [detected]
        fcomp   [null]
        fstsw   ax
        sahf    
        jb      .SkipWrongRadius

        ; If ray intersect with block after player
        fld     [detected]
        fcomp   [edi + Player.maxCamRadius]
        fstsw   ax
        sahf
        ja      .SkipWrongRadius

        ; Checking for maximum intersection
        fld     [allDetected]
        fcomp   [detected]
        fstsw   ax
        sahf
        ja  @F

        fld     [detected]
        fadd    [norm]
        fstp    [allDetected]

        @@:

        .SkipWrongRadius:
        
    .Skip:
        pop     ecx
        add     esi, sizeBlock 
        loop    .CheckLoop

    .Go_out:

    ; convert to distance of ray to radius
    fld     [allDetected]
    fcomp   [null]
    fstsw   ax
    sahf    
    ja      @F

    fld     [null]
    fstp    [allDetected]

    @@:

    fld     [edi + Player.maxCamRadius]
    fsub    [allDetected]
    fstp    [allDetected]

    mov     eax, [allDetected]
    ret

endp

proc Collision.RayBlockIntersect uses edi esi ebx,\
    pPlayer, pBlockPosition, dir, origin

    locals 
        minBlockVrt         Vector4         0.0, 0.0, 0.0, 1.0
        maxBlockVrt         Vector4         0.0, 0.0, 0.0, 1.0
        tmp                 Vector3         0.0, 0.0, 0.0
        null                GLfloat         0.0
        tFar                GLfloat         ? 
        tNear               GLfloat         ?
        t1                  Vector3         ?
        t2                  Vector3         ?
    endl   

    mov     edi, [pBlockPosition]

    ; Calculate Block max and min vertices
    lea     ebx, [minBlockVrt]
    lea     eax, [maxBlockVrt]
    push    edi
    mov     esi, edi
    add     edi, translateOffset
    add     esi, scaleOffset
    lea     ecx, [tmp]
    stdcall Collision.minMaxOptimizeBlockVerts, ebx, eax, esi, ecx, edi 
    pop     edi

    lea     edi, [minBlockVrt]
    mov     edx, [origin]
    mov     ebx, [dir]
    lea     eax, [t1]

    ; X min
    fld     [edi + Vector3.x]
    fsub    [edx + Vector3.x]
    fdiv    [ebx + Vector3.x]
    fstp    [eax + Vector3.x]

    ; Y min
    fld     [edi + Vector3.y]
    fsub    [edx + Vector3.y]
    fdiv    [ebx + Vector3.y]
    fstp    [eax + Vector3.y]

    ; Z min
    fld     [edi + Vector3.z]
    fsub    [edx + Vector3.z]
    fdiv    [ebx + Vector3.z]
    fstp    [eax + Vector3.z]

    lea     edi, [maxBlockVrt]
    lea     eax, [t2]
    ; X max
    fld     [edi + Vector3.x]
    fsub    [edx + Vector3.x]
    fdiv    [ebx + Vector3.x]
    fstp    [eax + Vector3.x]

    ; Y max
    fld     [edi + Vector3.y]
    fsub    [edx + Vector3.y]
    fdiv    [ebx + Vector3.y]
    fstp    [eax + Vector3.y]

    ; Z max
    fld     [edi + Vector3.z]
    fsub    [edx + Vector3.z]
    fdiv    [ebx + Vector3.z]
    fstp    [eax + Vector3.z]


    lea     esi, [t1]
    lea     edi, [t2]

    ; tNear
    stdcall Number.DoubleMin, [esi + Vector3.x], [edi + Vector3.x]
    mov     [tNear], eax
    stdcall Number.DoubleMin, [esi + Vector3.y], [edi + Vector3.y]
    stdcall Number.DoubleMax, [tNear], eax
    mov     [tNear], eax
    stdcall Number.DoubleMin, [esi + Vector3.z], [edi + Vector3.z]
    stdcall Number.DoubleMax, [tNear], eax
    mov     [tNear], eax

    ; tFar
    stdcall Number.DoubleMax, [esi + Vector3.x], [edi + Vector3.x]
    mov     [tFar], eax
    stdcall Number.DoubleMax, [esi + Vector3.y], [edi + Vector3.y]
    stdcall Number.DoubleMin, [tFar], eax
    mov     [tFar], eax
    stdcall Number.DoubleMax, [esi + Vector3.z], [edi + Vector3.z]
    stdcall Number.DoubleMin, [tFar], eax
    mov     [tFar], eax

    ; check for collision
    mov     edx, [tFar]

    fld     [tNear]
    fcomp   [tFar]
    fstsw   ax
    sahf
    jb      @F

    mov     edx, -1.0

    @@:

    fld     [tFar]
    fcomp   [null]
    fstsw   ax
    sahf
    ja      @F

    mov     edx, -1.0

    @@:

    
.Ret:

    mov     eax, edx

    ret
endp