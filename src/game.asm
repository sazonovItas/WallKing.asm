proc Game.Game uses edi ebx,\ 
    pPlayer

    stdcall Game.MoveObject, [pPlayer]

    mov     edi, [pPlayer]

    invoke  glViewport, 0, 0, [edi + Player.camera + Camera.width], [edi + Player.camera + Camera.height]
    invoke  glClear, GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT
    stdcall Draw.Scene, [pPlayer]

    ; Print help and some info
    cmp     [pl_help], true
    jne     @F

    stdcall Draw.Text, -35.0, 32.0, 1.0, 1.0, 1.0, className, 8
    stdcall Draw.Text, -35.0, 34.0, 1.0, 1.0, 1.0, Help.FPS, 4

    invoke  GetTickCount
    mov     edx, eax
    sub     eax, [fpsTimer]
    cmp     eax, 1000
    jl      .SkipTimerUpdate

    mov     [fpsTimer], edx
    stdcall memzero, Help.FPSCnt, 12
    stdcall Debug.IntToDecString, Help.FPSCnt, [fpsCnt]
    mov     [fpsCnt], 0

    .SkipTimerUpdate:

    stdcall Draw.Text, -33.8, 34.0, 1.0, 1.0, 1.0, Help.FPSCnt, 4

    @@:

.Ret:
    ret
endp
proc Game.MoveObject\
    pPlayer

    locals 
            currentFrame            dd              ?
    endl

    invoke  GetTickCount
    mov     [currentFrame], eax

    sub     eax, [time]
    cmp     eax, 1
    jb      .Skip

    stdcall Player.Update, [pPlayer], eax

    mov     eax, [currentFrame]
    mov     [time], eax

.Skip:

.Ret:
    ret
endp