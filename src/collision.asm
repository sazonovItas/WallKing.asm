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

        mov     [detected], 0

        lea     eax, [esi + Camera.Position]
        lea     ebx, [detected]
        stdcall Collision.BlockDetection, eax, edi, ebx

        mov     eax, [detected]
        or      [allDetected], eax

    .Skip:
        pop     ecx
        add     edi, sizeBlock 
        loop    .CheckLoop
    
    mov     edi, [result]
    mov     eax, [allDetected]
    mov     [edi], eax
    ret

endp

    halfPlayer      = 0.05
    halfBlock       = 0.5

proc Collision.BlockDetection uses edi esi ebx,\
    pPlayerPosition, pBlockPosition, pResult

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
    endl

    mov     esi, [pPlayerPosition]
    mov     edi, [pBlockPosition]
    invoke  glMatrixMode, GL_MODELVIEW

    lea     ebx, [modelBlockMat]
    invoke  glPushMatrix
        invoke  glLoadIdentity
        invoke  glTranslatef, [edi + translateOffset + Vector3.x], [edi + translateOffset + Vector3.y], [edi + translateOffset + Vector3.z]
        invoke  glScalef, [edi + scaleOffset + Vector3.x], [edi + scaleOffset + Vector3.y], [edi + scaleOffset + Vector3.z] 
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ebx
    invoke  glPopMatrix

    lea     ebx, [modelPlayerMat]
    invoke  glPushMatrix
        invoke  glLoadIdentity
        invoke  glTranslatef, dword [esi + Vector3.x], dword [esi + Vector3.y], dword [esi + Vector3.z]
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

    lea     esi, [minResultPlayer]
    lea     ebx, [maxResultPlayer]

    fld     [esi + Vector4.x]
    fcomp   [maxResultBlock.x]
    fstsw   ax
    sahf
    ja      .Ret

    fld     [ebx + Vector4.x]
    fcomp   [minResultBlock.x]
    fstsw   ax
    sahf
    jb      .Ret

    fld     [esi + Vector4.y]
    fcomp   [maxResultBlock.y]
    fstsw   ax
    sahf
    ja      .Ret

    fld     [ebx + Vector4.y]
    fcomp   [minResultBlock.y]
    fstsw   ax
    sahf
    jb      .Ret

    fld     [esi + Vector4.z]
    fcomp   [maxResultBlock.z]
    fstsw   ax
    sahf
    ja      .Ret

    fld     [ebx + Vector4.z]
    fcomp   [minResultBlock.z]
    fstsw   ax
    sahf
    jb      .Ret
    
    mov     edi, [pResult]
    mov     dword [edi], 1

    .Ret:

    ret
endp