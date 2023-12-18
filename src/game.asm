proc Game.Game uses edi ebx esi,\ 
    pPlayer

    locals
        MapCornerX          dd          ?
        MapCornerY          dd          ?
        divScreen           dd          4
        aspect              dd          1.0
        tmp                 Vector3     0.0, 30.0, 0.0
        normVec             Vector3     0.1, 0.0, 0.1
        upVec               Vector3     0.0, 1.0, 0.0
    endl

    stdcall Game.MoveObject, [pPlayer]

    mov     edi, [pPlayer]

    stdcall Camera.Matrix, [pPlayer]

    invoke  glViewport, 0, 0, [edi + Player.camera + Camera.width], [edi + Player.camera + Camera.height]
    invoke  glClear, GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT
    stdcall Draw.Scene, [pPlayer]

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

    stdcall Draw.Text, -34.8, 34.0, 1.0, 1.0, 1.0, Help.FPS, Help.FPSLen
    stdcall Draw.Text, -33.6, 34.0, 0.0, 1.0, 0.0, Help.FPSCnt, Help.FPSCntLen

    ; Map drawing
    cmp     [pl_map], false
    je      .SkipMapDrawing

    push    edi
    mov     esi, edi
    add     edi, Camera.proj
    stdcall Matrix.Projection, [esi + Camera.fovDeg], [aspect], [esi + Camera.nearPlane], [esi + Camera.farPlane], edi
    pop     edi

    push    edi
    mov     esi, edi
    add     edi, (Player.camera + Camera.camPosition)
    lea     ebx, [tmp]
    lea     edx, [normVec]
    stdcall Vector3.Add, ebx, edi
    stdcall Vector3.Add, ebx, edx
    add     esi, Camera.view
    lea     eax, [upVec]
    stdcall Matrix.LookAt, ebx, edi, eax, esi
    pop     edi

    xor     edx, edx
    mov     eax, [edi + Player.camera + Camera.width]
    div     [divScreen]    
    mov     edx, [edi + Player.camera + Camera.width]
    sub     edx, eax

    mov     esi, edx
    mov     ebx, eax

    invoke  glEnable, GL_SCISSOR_TEST
    invoke  glScissor, esi, 0, ebx, ebx
    invoke  glClear, GL_COLOR_BUFFER_BIT
    invoke  glDisable, GL_SCISSOR_TEST
    invoke  glClear, GL_DEPTH_BUFFER_BIT
    invoke  glViewport, esi, 0, ebx, ebx
    stdcall Draw.Scene, [pPlayer]

    .SkipMapDrawing:


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
    stdcall Draw.Text, -34.0, 23.0, 1.0, 0.6, 0.6, Help.Keymap, Help.KeymapLen

    stdcall Draw.Text, -33.5, 22.0, 1.0, 1.0, 1.0, Help.PlayerBasicMove, Help.PlayerBasicMoveLen
    stdcall Draw.Text, -33.5, 21.0, 1.0, 1.0, 1.0, Help.PlayerJump, Help.PlayerJumpLen
    stdcall Draw.Text, -33.5, 20.0, 1.0, 1.0, 1.0, Help.PlayerStopCameraChasing, Help.PlayerStopCameraChasingLen
    stdcall Draw.Text, -33.5, 19.0, 1.0, 1.0, 1.0, Help.PlayerStopCameraTex, Help.PlayerStopCameraTexLen
    stdcall Draw.Text, -33.5, 18.0, 1.0, 1.0, 1.0, Help.PlayerHelp, Help.PlayerHelpLen
    stdcall Draw.Text, -33.5, 17.0, 1.0, 1.0, 1.0, Help.PlayerMap, Help.PlayerMapLen
    stdcall Draw.Text, -33.5, 16.0, 1.0, 1.0, 1.0, Help.PlayerRespawn, Help.PlayerRespawnLen
    stdcall Draw.Text, -33.5, 15.0, 1.0, 1.0, 1.0, Help.PlayerChasingLight, Help.PlayerChasingLightLen
    stdcall Draw.Text, -33.5, 14.0, 1.0, 1.0, 1.0, Help.PlayerNextLight, Help.PlayerNextLightLen
    stdcall Draw.Text, -33.5, 13.0, 1.0, 1.0, 1.0, Help.PlayerPrevLight, Help.PlayerPrevLightLen
    stdcall Draw.Text, -33.5, 12.0, 1.0, 1.0, 1.0, Help.PlayerTeleportToLight, Help.PlayerTeleportToLightLen
    stdcall Draw.Text, -33.5, 11.0, 1.0, 1.0, 1.0, Help.ChooseLightColor, Help.ChooseLightColorLen
    stdcall Draw.Text, -33.5, 10.0, 1.0, 1.0, 1.0, Help.ChangeLightIntensity, Help.ChangeLightIntensityLen
    stdcall Draw.Text, -33.5, 9.0, 1.0, 1.0, 1.0, Help.SaveLevel, Help.SaveLevelLen

    ; Chasing Light
    stdcall Draw.Text, -34.0, 8.0, 1.0, 0.6, 0.6, Help.ChasingLight, Help.ChasingLightLen
    stdcall Draw.Text, -33.5, 7.0, 1.0, 1.0, 1.0, Help.ChasingLightChasing, Help.ChasingLightChasingLen

    cmp     [pl_stop_light], false
    je      .OffChasing

    .OnChasing:

        stdcall Draw.Text, -31.0, 7.0, 0.0, 1.0, 0.0, Help.On, Help.OnLen
        jmp     @F

    .OffChasing:    

        stdcall Draw.Text, -31.0, 7.0, 1.0, 0.0, 0.0, Help.Off, Help.OffLen

    @@:

    ; Color chasing light
    stdcall Draw.Text, -33.5, 6.0, 1.0, 1.0, 1.0, Help.ChasingLightRGB, Help.ChasingLightRGBLen
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
    stdcall Draw.Text, -32.0, 6.0, dword [ebx], dword [ebx + 4],\
                                dword [ebx + 8], Help.RGBColor, Help.RGBColorLen

    ; changing spectrum
    stdcall Draw.Text, -33.5, 5.0, 1.0, 1.0, 1.0, Help.CurChangeColor, Help.CurChangeColorLen

    cmp     [edi + Player.offsetColorLight], 4
    je      .Gspec

    cmp     [edi + Player.offsetColorLight], 8
    je      .Bspec

    .Rspec:

        mov    byte [Help.CurChangeColorRGB], 'R'
        stdcall Draw.Text, -28.5, 5.0, 1.0, 0.0, 0.0, Help.CurChangeColorRGB, 1

        jmp     @F

    .Gspec:

        mov    byte [Help.CurChangeColorRGB], 'G'
        stdcall Draw.Text, -28.5, 5.0, 0.0, 1.0, 0.0, Help.CurChangeColorRGB, 1

        jmp     @F

    .Bspec:

        mov    byte [Help.CurChangeColorRGB], 'B'
        stdcall Draw.Text, -28.5, 5.0, 0.0, 0.0, 1.0, Help.CurChangeColorRGB, 1

    @@:

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