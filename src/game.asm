proc Game.Game uses edi,\ 
    pPlayer

    stdcall Game.MoveObject, [pPlayer]

    mov     edi, [pPlayer]

    ; invoke  glViewport, 0, 0, [edi + Player.camera + Camera.width], [edi + Player.camera + Camera.height]
    ; invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
    ; stdcall Draw.Scene, [pPlayer], [blockShader.ID]

    ; invoke  glViewport, 0, 0, SHADOW_MAP_WIDTH, SHADOW_MAP_HEIGHT
    ; invoke  glClear, GL_DEPTH_BUFFER_BIT
    ; invoke  glBindFramebuffer, GL_FRAMEBUFFER, [shadowMapFBO]

    ; stdcall Draw.Shadow, [mainPlayer], [shadowShader.ID]

    ; invoke  glBindFramebuffer, GL_FRAMEBUFFER, NULL

    invoke  glViewport, 0, 0, [edi + Player.camera + Camera.width], [edi + Player.camera + Camera.height]
    invoke  glClear, GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT
    stdcall Draw.Scene, [pPlayer], [blockShader.ID]


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

    stdcall Player.Update, [pPlayer], eax, [sizeBlocksMapTry], blocksMapTry, [sizeLightsMapTry], lightsMapTry

    mov     eax, [currentFrame]
    mov     [time], eax

.Skip:

.Ret:
    ret
endp