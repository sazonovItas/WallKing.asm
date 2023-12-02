proc Draw.Scene uses esi edi

        locals 
                currentFrame            dd              ?
                testAngle               dd              180.0
                rotAngle                dd              0.0
                colDetected             dd              ?
                timeBetweenChecking     dd              ?
                normDiv                 dd              2.5
                tmp                     Vector3         ?
        endl

        invoke  GetTickCount
        mov     [currentFrame], eax

        sub     eax, [time]
        cmp     eax, 1
        jb      .Skip

        stdcall Player.Update, [mainPlayer], eax, [sizeBlocksMapTry], blocksMapTry

        mov     eax, [currentFrame]
        mov     [time], eax

.Skip: 

        stdcall Camera.Matrix, [mainPlayer]

        mov     edi, [mainPlayer]
        invoke  glViewport, 0, 0, [edi + Player.camera + Camera.width], [edi + Player.camera + Camera.height]
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        invoke  glClearColor, 0.22, 0.22, 0.22

        stdcall Draw.BlocksMap, [sizeBlocksMapTry], blocksMapTry

        ; light draw
        stdcall Shader.Activate, [lightShader.ID]

        stdcall Camera.UniformBind, [mainPlayer], [lightShader.ID], uniProjName, uniViewName

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, 1.0, 1.0, 1.0
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [lightShader.ID], uniModelName
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [lightShader.ID], uniLightColorName
        invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        stdcall VAO.Bind, [lightVAO.ID]
        invoke  glDrawElements, GL_TRIANGLES, countLightIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind


        mov     edi, [mainPlayer]
        mov     esi, edi 
        add     esi, Player.DrawPlayer
        stdcall Player.Draw, edi, esi, [blockShader.ID]

        stdcall Draw.ConPlayers, [Client.BufferDraw]

        ret
endp

proc Draw.ConPlayers uses edi esi ebx,\
        buf

        locals
                bufToDraw               db              MESSAGE_SIZE dup(0)
        endl

        ; Lock mutex go draw players
        invoke WaitForSingleObject, [Client.MutexDrawBuf], INFINITY
        lea     ebx, [bufToDraw]
        stdcall memcpy, ebx, [buf], MESSAGE_SIZE
        invoke  ReleaseMutex, [Client.MutexDrawBuf]

        mov     edi, ebx
        add     edi, 14
        mov     ecx, dword [edi]
        jcxz    .Ret

        add     edi, 4

        .drawCycle:

                push    ecx

                stdcall Draw.ConPlayer, edi

                add     edi, sizeof.DrawData
                pop     ecx
                loop    .drawCycle

.Ret:
        ret
endp

proc Draw.ConPlayer uses edi esi ebx,\
        offset

        locals 
                rotAngle                dd              0.0
                tmp                     dd              0.4
        endl

        stdcall Shader.Activate, [blockShader.ID]

        stdcall Camera.UniformBind, [mainPlayer], [blockShader.ID], uniProjName, uniViewName
        lea     esi, [arrTextures]
        add     esi, 8
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [blockShader.ID], uniTex0Name, GL_TEXTURE0

        mov     edi, [offset]

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, dword [edi], dword [edi + 4], dword [edi + 8]
                fld     dword [edi + 12]
                fmul    [radian]
                fstp    [rotAngle]
                invoke  glRotatef, dword [rotAngle], 1.0, 0.0, 0.0
                fld     dword [edi + 16]
                fmul    [radian]
                fstp    [rotAngle]
                invoke  glRotatef, [rotAngle], 0.0, 1.0, 0.0
                fld     dword [edi + 20]
                fmul    [radian]
                fstp    [rotAngle]
                invoke  glRotatef, [rotAngle], 0.0, 0.0, 1.0
                invoke  glScalef, dword [edi + 24], dword [edi + 28], dword [edi + 32]
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [blockShader.ID], uniModelName
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [blockShader.ID], uniLightColorName
        invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        invoke  glGetUniformLocation, [blockShader.ID], uniLightPosName
        invoke  glUniform3f, eax, [lightPos.x], [lightPos.y], [lightPos.z]

        mov     edi, [mainPlayer]
        invoke  glGetUniformLocation, [blockShader.ID], uniCamPosName
        invoke  glUniform3f, eax, [edi + Camera.camPosition + Vector3.x], [edi + Camera.camPosition + Vector3.y], [edi + Camera.camPosition + Vector3.z]

        stdcall VAO.Bind, [blockVAO.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

.Ret:
        ret
endp

;       offsets         scale = 12, rotate = 12, traslate = 12, texture = 4, material = 4, collision = 4
proc Draw.BlocksMap uses esi edi,\
        sizeBlocksMap, blocksMap 

        mov     edi, [blocksMap]
        mov     ecx, [sizeBlocksMap]

        .TryLoop:

        push    ecx

        stdcall Draw.Block, edi

        add     edi, sizeBlock
        pop     ecx 
        loop    .TryLoop

        ret
endp

proc Draw.Block uses edi esi,\
        offsetBlock

        mov     edi, [offsetBlock]

        ; block drawing
        stdcall Shader.Activate, [blockShader.ID]

        stdcall Camera.UniformBind, [mainPlayer], [blockShader.ID], uniProjName, uniViewName

        lea     esi, [arrTextures]
        add     esi, [edi + texOffset]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [blockShader.ID], uniTex0Name, GL_TEXTURE0

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, [edi + translateOffset + Vector3.x], [edi + translateOffset + Vector3.y], [edi + translateOffset + Vector3.z]
                invoke  glRotatef, [edi + rotateOffset + Vector3.x], 1.0, 0.0, 0.0
                invoke  glRotatef, [edi + rotateOffset + Vector3.y], 0.0, 1.0, 0.0
                invoke  glRotatef, [edi + rotateOffset + Vector3.z], 0.0, 0.0, 1.0
                invoke  glScalef, [edi + scaleOffset + Vector3.x], [edi + scaleOffset + Vector3.y], [edi + scaleOffset + Vector3.z] 
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [blockShader.ID], uniModelName
        ; mov     [uniModel], eax
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [blockShader.ID], uniLightColorName
        invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        invoke  glGetUniformLocation, [blockShader.ID], uniLightPosName
        invoke  glUniform3f, eax, [lightPos.x], [lightPos.y], [lightPos.z]

        mov     edi, [mainPlayer]
        add     edi, Player.camera
        invoke  glGetUniformLocation, [blockShader.ID], uniCamPosName
        invoke  glUniform3f, eax, [edi + Camera.camPosition + Vector3.x], [edi + Camera.camPosition + Vector3.y], [edi + Camera.camPosition + Vector3.z]

        stdcall VAO.Bind, [blockVAO.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

        .Ret:

        ret
endp