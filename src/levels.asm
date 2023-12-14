proc Level.Save uses edi esi ebx,\
    pLevel

    locals 
        sizeLightsMap       dd      ?
        sizeBlocksMap       dd      ?
        sizeLevel           dd      20
        pBuffer             dd      ?
    endl

    mov     edi, [pLevel]

    mov     eax, sizeBlock
    mul     [edi + Level.sizeBlocksMap]
    mov     [sizeBlocksMap], eax
    add     [sizeLevel], eax

    mov     eax, sizeLight
    mul     [edi + Level.sizeLightsMap]
    mov     [sizeLightsMap], eax
    add     [sizeLevel], eax

    stdcall malloc, [sizeLevel]
    mov     esi, eax 
    mov     [pBuffer], eax

    mov     eax, [edi + Level.sizeBlocksMap]
    mov     dword [esi], eax
    add     esi, 4

    push    edi
    mov     edi, [edi + Level.pBlocksMap]
    stdcall memcpy, esi, edi, [sizeBlocksMap]
    pop     edi
    add     esi, [sizeBlocksMap]

    mov     eax, [edi + Level.sizeLightsMap]
    mov     dword [esi], eax
    add     esi, 4

    push    edi
    mov     edi, [edi + Level.pLightsMap]
    stdcall memcpy, esi, edi, [sizeLightsMap]
    pop     edi
    add     esi, [sizeLightsMap]

    push    edi
    lea     edi, [edi + Level.spawnPosition]
    stdcall memcpy, esi, edi, 12 
    pop     edi

    stdcall File.WriteContent, [edi + Level.FileName], [pBuffer], [sizeLevel]
    stdcall free, [pBuffer]

.Ret:
    ret
endp

proc Level.Load uses edi esi ebx,\
    pLevel, FileName

    locals 
        sizeLightsMap       dd      ?
        sizeBlocksMap       dd      ?
        sizeLevel           dd      20
        pBuffer             dd      ?
    endl

    mov     edi, [pLevel]
    
    mov     eax, [FileName]
    mov     [edi + Level.FileName], eax

    stdcall File.LoadContent, eax
    mov     [pBuffer], eax
    mov     esi, eax

    ; copy Blocks map
    mov     eax, [esi] 
    mov     [edi + Level.sizeBlocksMap], eax
    add     esi, 4
    mov     edx, sizeBlock
    mul     edx
    mov     [sizeBlocksMap], eax
    stdcall malloc, eax
    mov     [edi + Level.pBlocksMap], eax
    stdcall memcpy, eax, esi, [sizeBlocksMap]
    add     esi, [sizeBlocksMap]

    ; copy Blocks map
    mov     eax, [esi] 
    mov     [edi + Level.sizeLightsMap], eax
    add     esi, 4
    mov     edx, sizeLight
    mul     edx
    mov     [sizeLightsMap], eax
    stdcall malloc, eax
    mov     [edi + Level.pLightsMap], eax
    stdcall memcpy, eax, esi, [sizeLightsMap]
    add     esi, [sizeLightsMap]

    stdcall free, [pBuffer]

.Ret:
    ret
endp