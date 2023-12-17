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

    stdcall Game.Help, [pPlayer]

    @@:

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

    stdcall Draw.Text, -35.0, 34.0, 1.0, 1.0, 1.0, Help.FPS, Help.FPSLen
    stdcall Draw.Text, -33.8, 34.0, 0.0, 1.0, 0.0, Help.FPSCnt, Help.FPSCntLen

.Ret:
    ret
endp

proc Game.Help uses edi esi ebx,\
    pPlayer

    locals 
        tmp     Vector3     ?
    endl

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
    stdcall Draw.Text, -34.0, 28.0, 1.0, 1.0, 1.0, Help.ClientConPlayers, Help.ClientConPlayersLen

    stdcall memzero, Client.CntPlayersStr, Client.CntPlayersStrLen
    stdcall Debug.IntToDecString, Client.CntPlayersStr, [Client.CntPlayers]
    stdcall Draw.Text, -29.2, 28.0, 1.0, 1.0, 0.0, Client.CntPlayersStr, Client.CntPlayersStrLen

    ; Keymap
    stdcall Draw.Text, -34.0, 27.0, 1.0, 1.0, 1.0, Help.Keymap, Help.KeymapLen
    stdcall Draw.Text, -33.5, 26.0, 1.0, 1.0, 1.0, Help.ClientConnectKey, Help.ClientConnectKeyLen
    stdcall Draw.Text, -33.5, 25.0, 1.0, 1.0, 1.0, Help.ClientDisconnectKey, Help.ClientDisconnectKeyLen

    ; ============ Client =============

    ; ============ Player =============
    
    ; Player Info
    stdcall Draw.Text, -34.5, 24.0, 0.2, 1.0, 0.4, Help.PlayerInfo, Help.PlayerInfoLen

    ; Keymap
    stdcall Draw.Text, -34.0, 23.0, 1.0, 1.0, 1.0, Help.Keymap, Help.KeymapLen

    stdcall Draw.Text, -33.5, 22.0, 1.0, 1.0, 1.0, Help.PlayerBasicMove, Help.PlayerBasicMoveLen
    stdcall Draw.Text, -33.5, 21.0, 1.0, 1.0, 1.0, Help.PlayerJump, Help.PlayerJumpLen
    stdcall Draw.Text, -33.5, 20.0, 1.0, 1.0, 1.0, Help.PlayerStopCameraChasing, Help.PlayerStopCameraChasingLen
    stdcall Draw.Text, -33.5, 19.0, 1.0, 1.0, 1.0, Help.PlayerStopCameraTex, Help.PlayerStopCameraTexLen
    stdcall Draw.Text, -33.5, 18.0, 1.0, 1.0, 1.0, Help.PlayerHelp, Help.PlayerHelpLen
    stdcall Draw.Text, -33.5, 17.0, 1.0, 1.0, 1.0, Help.PlayerRespawn, Help.PlayerRespawnLen
    stdcall Draw.Text, -33.5, 16.0, 1.0, 1.0, 1.0, Help.PlayerChasingLight, Help.PlayerChasingLightLen
    stdcall Draw.Text, -33.5, 15.0, 1.0, 1.0, 1.0, Help.PlayerNextLight, Help.PlayerNextLightLen
    stdcall Draw.Text, -33.5, 14.0, 1.0, 1.0, 1.0, Help.PlayerPrevLight, Help.PlayerPrevLightLen
    stdcall Draw.Text, -33.5, 13.0, 1.0, 1.0, 1.0, Help.PlayerTeleportToLight, Help.PlayerTeleportToLightLen
    stdcall Draw.Text, -33.5, 12.0, 1.0, 1.0, 1.0, Help.ChooseLightColor, Help.ChooseLightColorLen
    stdcall Draw.Text, -33.5, 11.0, 1.0, 1.0, 1.0, Help.ChangeLightIntensity, Help.ChangeLightIntensityLen
    stdcall Draw.Text, -33.5, 10.0, 1.0, 1.0, 1.0, Help.SaveLevel, Help.SaveLevelLen

    ; Chasing Light
    stdcall Draw.Text, -34.0, 9.0, 1.0, 1.0, 1.0, Help.ChasingLight, Help.ChasingLightLen
    stdcall Draw.Text, -33.5, 8.0, 1.0, 1.0, 1.0, Help.ChasingLightRGB, Help.ChasingLightRGBLen

    lea     ebx, [tmp]
    mov     edi, [pPlayer]
    mov     esi, [edi + Player.pLevel]
    mov     eax, [edi + Player.offsetChasingLight]
    mov     edx, sizeLight
    mul     edx
    add     eax, [esi + Level.pLightsMap]
    add     eax, colorLightOffset
    stdcall Vector3.Copy, ebx, eax
    stdcall Vector3.Normalize, ebx
    stdcall Draw.Text, -32.0, 8.0, dword [ebx], dword [ebx + 4],\
                                dword [ebx + 8], Help.RGBColor, Help.RGBColorLen

    ; ============ Player =============
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