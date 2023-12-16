proc Game.Game uses edi ebx,\ 
    pPlayer

    stdcall Game.MoveObject, [pPlayer]

    mov     edi, [pPlayer]

    invoke  glViewport, 0, 0, [edi + Player.camera + Camera.width], [edi + Player.camera + Camera.height]
    invoke  glClear, GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT
    stdcall Draw.Scene, [pPlayer]

    stdcall Draw.Interface, [pPlayer], [interfaceShader.ID]

    ; Print help and some info
    cmp     [pl_help], true
    jne     @F

    stdcall Game.Help

    @@:

.Ret:
    ret
endp

proc Game.Help

    stdcall Draw.Text, -35.0, 34.0, 1.0, 1.0, 1.0, Help.FPS, Help.FPSLen

    invoke  GetTickCount
    mov     edx, eax
    sub     eax, [fpsTimer]
    cmp     eax, 1000
    jl      .SkipTimerUpdate

    mov     [fpsTimer], edx
    stdcall memzero, Help.FPSCnt, 8
    stdcall Debug.IntToDecString, Help.FPSCnt, [fpsCnt]
    mov     [fpsCnt], 0

    .SkipTimerUpdate:

    stdcall Draw.Text, -33.8, 34.0, 0.0, 1.0, 0.0, Help.FPSCnt, Help.FPSCntLen

    ; Wallking debug info
    stdcall Draw.Text, -35.0, 33.0, 0.2, 0.4, 1.0, Help.DebugInfo, Help.DebugInfoLen

    ; ============ Client =============
    ; Client Info
    stdcall Draw.Text, -34.5, 32.0, 0.2, 1.0, 0.4, Help.ClientInfo, Help.ClientInfoLen

    ; Client state
    stdcall Draw.Text, -34.0, 31.0, 1.0, 1.0, 1.0, Help.ClientState, Help.ClientStateLen

    mov     eax, [Client.State]
    JumpIf  CLIENT_STATE_OFFLINE,   .Offline
    JumpIf  CLIENT_STATE_ONLINE,    .Online
    JumpIf  CLIENT_STATE_REQUEST,   .Request
    JumpIf  CLIENT_STATE_ACCEPT,    .Accept

    .Offline:

        stdcall Draw.Text, -32.5, 31.0, 1.0, 0.0, 0.0, Client.StateOffline, Client.StateOfflineLen

        jmp     .SkipClientState

    .Online:

        stdcall Draw.Text, -32.5, 31.0, 1.0, 1.0, 0.0, Client.StateOnline, Client.StateOnlineLen

        jmp     .SkipClientState

    .Request:

        stdcall Draw.Text, -32.5, 31.0, 0.2, 0.0, 1.0, Client.StateRequest, Client.StateRequestLen

        jmp     .SkipClientState

    .Accept:

        stdcall Draw.Text, -32.5, 31.0, 0.0, 1.0, 0.0, Client.StateAccept, Client.StateAcceptLen
        stdcall strlen, [Client.ServerIpStr]
        stdcall Draw.Text, -31.5, 30.0, 1.0, 1.0, 0.0, [Client.ServerIpStr], eax


    .SkipClientState:

    ; Server Ip and port
    stdcall Draw.Text, -34.0, 30.0, 1.0, 1.0, 1.0, Help.ServerIp, Help.ServerIpLen
    stdcall Draw.Text, -34.0, 29.0, 1.0, 1.0, 1.0, Help.ServerPort, Help.ServerPortLen
    stdcall Draw.Text, -32.8, 29.0, 1.0, 1.0, 0.0, Client.ServerPortStr, Client.ServerPortStrLen

    ; Connected players
    stdcall strlen, Help.ClientConPlayers
    stdcall Draw.Text, -34.0, 28.0, 1.0, 1.0, 1.0, Help.ClientConPlayers, 19

    stdcall memzero, Client.CntPlayersStr, Client.CntPlayersStrLen
    stdcall Debug.IntToDecString, Client.CntPlayersStr, [Client.CntPlayers]
    stdcall Draw.Text, -29.2, 28.0, 1.0, 1.0, 0.0, Client.CntPlayersStr, Client.CntPlayersStrLen

    ; Keymap
    stdcall Draw.Text, -34.0, 27.0, 1.0, 1.0, 1.0, Help.Keymap, Help.KeymapLen
    stdcall Draw.Text, -33.5, 26.0, 1.0, 1.0, 1.0, Help.ClientConnectKey, Help.ClientConnectKeyLen
    stdcall Draw.Text, -33.5, 25.0, 1.0, 1.0, 1.0, Help.ClientDisconnectKey, Help.ClientDisconnectKeyLen

    ; ============ Client =============

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

    stdcall Player.Update, [pPlayer], eax

    mov     eax, [currentFrame]
    mov     [time], eax

.Ret:
    ret
endp