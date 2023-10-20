;       offsets         scale = 12, rotate = 12, traslate = 12, texture = 4, material = 4, collision = 4
proc Collision.MapDetection uses edi esi ebx,\
    pPlayer, sizeBlocksMap, blocksMap, result

    locals 
        detected        dd      ?
        allDetected     dd      0
    endl

    mov     edi, [blocksMap]
    mov     esi, [pPlayer]
    mov     ecx, [sizeBlocksMap]

    .CheckLoop:
        push    ecx

        stdcall Collision.BlockDetection, esi, edi

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


proc Collision.BlockDetection uses edi esi ebx,\
    pPlayer, pBlockPosition

    locals 
        minXYZplayer            Vector4     -0.5, -0.5, -0.5, 1.0
        maxXYZplayer            Vector4     0.5, 0.5, 0.5, 1.0
        minXYZblock             Vector4     -0.5, -0.5, -0.5, 1.0
        maxXYZblock             Vector4     0.5, 0.5, 0.5, 1.0
        modelBlockMat           Matrix4x4   ?             
        modelPlayerMat          Matrix4x4   ?
        minResultPlayer         Vector4     ?
        maxResultPlayer         Vector4     ?
        minResultBlock          Vector4     ?
        maxResultBlock          Vector4     ?
        tmp                     Vector3     0.0, 0.0, 0.0
        scale                   Vector3     0.0, 0.0, 0.0
    endl

    mov     esi, [pPlayer]
    mov     edi, [pBlockPosition]

    lea     ebx, [modelBlockMat]
    invoke  glPushMatrix
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        invoke  glTranslatef, [edi + translateOffset + Vector3.x], [edi + translateOffset + Vector3.y], [edi + translateOffset + Vector3.z]
        invoke  glScalef, [edi + scaleOffset + Vector3.x], [edi + scaleOffset + Vector3.y], [edi + scaleOffset + Vector3.z] 
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ebx
    invoke  glPopMatrix

    lea     ebx, [modelPlayerMat]
    invoke  glPushMatrix
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        invoke  glTranslatef, [esi + Player.Position + Vector3.x], [esi + Player.Position + Vector3.y], [esi + Player.Position + Vector3.z]
        invoke  glScalef, [esi + Player.sizeBlockCol], [esi + Player.sizeBlockCol], [esi + Player.sizeBlockCol]
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ebx
    invoke  glPopMatrix
    
    lea     eax, [modelBlockMat]
    lea     ebx, [minResultBlock]
    lea     esi, [maxResultBlock]
    lea     edi, [minXYZblock]
    stdcall Matrix.MultVec4OnMat4x4, edi, eax, ebx 
    lea     edi, [maxXYZblock]
    stdcall Matrix.MultVec4OnMat4x4, edi, eax, esi

    lea     eax, [modelPlayerMat]
    lea     ebx, [minResultPlayer]
    lea     esi, [maxResultPlayer]
    lea     edi, [minXYZplayer]
    stdcall Matrix.MultVec4OnMat4x4, edi, eax, ebx
    lea     edi, [maxXYZplayer]
    stdcall Matrix.MultVec4OnMat4x4, edi, eax, esi


    ; ; Calculate Player max and min vertices
    ; lea     ebx, [minResultPlayer]
    ; lea     eax, [maxResultPlayer]
    ; mov     ecx, [esi + Player.sizeBlockCol]
    ; push    esi
    ; push    edi
    ; add     esi, Player.Position
    ; lea     edx, [scale]
    ; mov     [edx + Vector3.x], ecx
    ; mov     [edx + Vector3.y], ecx
    ; mov     [edx + Vector3.z], ecx
    ; lea     edi, [tmp]
    ; stdcall Collision.minMaxBlockVerts, ebx, eax, edx, edi, esi 
    ; pop     edi
    ; pop     esi

    ; ; Calculate Block max and min vertices
    ; lea     ebx, [minResultBlock]
    ; lea     eax, [maxResultBlock]
    ; push    esi
    ; push    edi
    ; mov     esi, edi
    ; add     edi, translateOffset
    ; add     esi, scaleOffset
    ; lea     edx, [tmp]
    ; stdcall Collision.minMaxBlockVerts, ebx, eax, esi, edx, edi 
    ; pop     edi
    ; pop     esi

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
    
    mov     eax, 1
    jmp     .Ret

    .NoCollision:

    mov     eax, 0

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

    lea     eax, [model]
    mov     edi, [pScl]
    mov     esi, [pRot]
    mov     ebx, [pTrl]

    invoke  glPushMatrix
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        invoke  glTranslatef, [ebx + Vector3.x], [ebx + Vector3.y], [ebx + Vector3.z]
        invoke  glScalef, [edi + Vector3.x], [edi + Vector3.y], [edi + Vector3.z] 
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, eax
    invoke  glPopMatrix

    lea     ebx, [model] 

    ; 0 Vertice
    lea     edi, [vrt8]
    lea     esi, [vrt0]
    stdcall Vector4.Copy, edi, esi

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