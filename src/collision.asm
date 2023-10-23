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

    ; Calculate Player max and min vertices
    lea     ebx, [minResultPlayer]
    lea     eax, [maxResultPlayer]
    push    esi
    push    edi
    add     esi, Player.Position
    lea     edx, [scale]
    lea     edi, [tmp]
    stdcall Collision.minMaxOptimizeBlockVerts, ebx, eax, edx, esi 
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
    stdcall Collision.minMaxOptimizeBlockVerts, ebx, eax, esi, edi 
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
    pMinVrt, pMaxVrt, pScl, pTrl

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
    pMinVrt, pMaxVrt, pScl, pRot, pTrl

    locals 
        ; Bottom vertecies
        vrt0        Vector4         -0.5, -0.5,  0.5, 1.0
        vrt1        Vector4         -0.5, -0.5, -0.5, 1.0
        vrt2        Vector4          0.5, -0.5, -0.5, 1.0
        vrt3        Vector4          0.5, -0.5,  0.5, 1.0

        ; Top vertecies
        vrt4        Vector4         -0.5,  0.5,  0.5, 1.0
        vrt5        Vector4         -0.5,  0.5, -0.5, 1.0
        vrt6        Vector4          0.5,  0.5, -0.5, 1.0
        vrt7        Vector4          0.5,  0.5,  0.5, 1.0

        vrt8        Vector4         ?

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
        lea     eax, [model]
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, eax
    invoke  glPopMatrix

    lea     ebx, [model] 

    ; 0 Vertice
    lea     esi, [vrt0]
    ; Max and Min vrt's X, Y and Z
    mov     edi, [pMinVrt]
    stdcall Matrix.MultVec4OnMat4x4, esi, ebx, edi 
    mov     esi, [pMaxVrt]
    stdcall Vector4.Copy, esi, edi

    ; 1 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt1]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; 2 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt2]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; 3 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt3]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; 4 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt4]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; 5 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt5]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; 6 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt6]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; 7 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt7]
    stdcall Vector4.Copy, edi, esi
    stdcall Matrix.MultVec4OnMat4x4, edi, ebx, esi

    ; Calculate min max vertecies
    ; vertices 1
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt1]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

    ; Calculate min max vertecies
    ; vertices 2
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt2]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

    ; Calculate min max vertecies
    ; vertices 3
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt3]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

    ; Calculate min max vertecies
    ; vertices 4
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt4]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

    ; Calculate min max vertecies
    ; vertices 5
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt5]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

    ; Calculate min max vertecies
    ; vertices 6
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt6]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

    ; Calculate min max vertecies
    ; vertices 7
    mov     edi, [pMinVrt]
    mov     esi, [pMaxVrt]
    lea     ebx, [vrt7]

    ; X
    fld     [edi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.x]
    mov     [edi + Vector4.x], eax

    @@:

    fld     [esi + Vector4.x]
    fcomp   [ebx + Vector4.x]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.x]
    mov     [esi + Vector4.x], eax

    @@:

    ; Y
    fld     [edi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.y]
    mov     [edi + Vector4.y], eax

    @@:

    fld     [esi + Vector4.y]
    fcomp   [ebx + Vector4.y]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.y]
    mov     [esi + Vector4.y], eax

    @@:

    ; Z
    fld     [edi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    jb      @F

    mov     eax, [ebx + Vector4.z]
    mov     [edi + Vector4.z], eax

    @@:

    fld     [esi + Vector4.z]
    fcomp   [ebx + Vector4.z]
    fstsw   ax
    sahf
    ja      @F

    mov     eax, [ebx + Vector4.z]
    mov     [esi + Vector4.z], eax

    @@:

.Ret:

    ret
endp