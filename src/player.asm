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
    mov     [edi + Player.Acceleration + Vector3.y], -0.000001
    mov     [edi + Player.Acceleration + Vector3.z], 0.0

    mov     [edi + Player.pitch], 0.0
    mov     [edi + Player.yaw], -1.57

    stdcall Camera.Direction, edi

    mov     [edi + Player.Up + Vector3.x], 0.0
    mov     [edi + Player.Up + Vector3.y], 1.0
    mov     [edi + Player.Up + Vector3.z], 0.0

    mov     [edi + Player.Accelr], 0.002
    mov     [edi + Player.speed], 0.002
    mov     [edi + Player.jumpAccelr], 0.01 
    mov     [edi + Player.sensitivity], 0.0005
    mov     [edi + Player.Condition], AIR_CONDITION

    invoke SetCursorPos, cursorPosX, cursorPosY
    invoke GetCursorPos, lastCursorPos
    
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
        example         dd          -0.5
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

    ; X    
    mov     [colDet], 0
    
    push    edi

    lea     ebx, [delta]

    fld     [edi + Player.Position + Vector3.x]
    fadd    [ebx + Vector3.x]
    fld     [edi + Player.Acceleration + Vector3.x]
    fimul   [dt]
    fimul   [dt]
    faddp
    fstp    [edi + Player.Position + Vector3.x]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.x]
    mov     [edi + Player.Position + Vector3.x], eax

    @@:

    pop     edi

    ; Z
    mov     [colDet], 0
    
    push    edi

    lea     ebx, [delta]

    fld     [edi + Player.Position + Vector3.z]
    fadd    [ebx + Vector3.z]
    fld     [edi + Player.Acceleration + Vector3.z]
    fimul   [dt]
    fimul   [dt]
    faddp
    fstp    [edi + Player.Position + Vector3.z]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.z]
    mov     [edi + Player.Position + Vector3.z], eax

    @@:

    pop     edi

    nop 
    ; Y
    mov     [colDet], 0
    
    push    edi

    lea     ebx, [delta]

    fld     [edi + Player.Position + Vector3.y]
    fadd    [ebx + Vector3.y]
    fld     [edi + Player.Acceleration + Vector3.y]
    fimul   [dt]
    fimul   [dt]
    fdiv    [div_2]
    faddp
    fstp    [edi + Player.Position + Vector3.y]

    lea     eax, [colDet]
    stdcall Collision.MapDetection, [pPlayer], [sizeBlocksMapTry], blocksMapTry, eax

    cmp     [colDet], true
    jne     @F
    
    mov     eax, [edi + Player.prevPosition + Vector3.y]
    mov     [edi + Player.Position + Vector3.y], eax

    mov     [edi + Player.Condition], WALK_CONDITION

    @@:

    mov     [edi + Player.Condition], AIR_CONDITION

    pop     edi

    ret
endp