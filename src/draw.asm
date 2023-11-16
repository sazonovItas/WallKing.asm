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
        jle     .Skip

        mov     [timeBetweenChecking], eax
        fild    [timeBetweenChecking]
        fstp    [timeBetweenChecking]

        stdcall Player.Update, mainPlayer, [timeBetweenChecking], [sizeBlocksMapTry], blocksMapTry
        stdcall Player.UpdateVelocity, mainPlayer, [sizeBlocksMapTry], blocksMapTry

        mov     eax, [currentFrame]
        mov     [time], eax

.Skip: 

        stdcall Camera.Matrix, mainPlayer

        invoke  glViewport, 0, 0, [mainPlayer.camera + Camera.width], [mainPlayer.camera + Camera.height]
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        invoke  glClearColor, 0.22, 0.22, 0.22

        stdcall Draw.BlocksMap, [sizeBlocksMapTry], blocksMapTry

        ; light draw
        stdcall Shader.Activate, [lightShader.ID]

        stdcall Camera.UniformBind, mainPlayer, [lightShader.ID], uniProjName, uniViewName

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, 1.0, 1.0, 1.0
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [lightShader.ID], uniModelName
        ; mov     [uniModel], eax
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [lightShader.ID], uniLightColorName
        invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        stdcall VAO.Bind, [lightVAO.ID]
        invoke  glDrawElements, GL_TRIANGLES, countLightIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

        ; ; camera draw
        ; mov     edi, mainPlayer
        ; stdcall Shader.Activate, [lightShader.ID]

        ; stdcall Camera.UniformBind, mainPlayer, [lightShader.ID], uniProjName, uniViewName

        ; invoke  glPushMatrix
        ;         invoke  glLoadIdentity
        ;         invoke  glTranslatef, [edi + Player.camera + Camera.camPosition + Vector3.x],\
        ;                          [edi + Player.camera + Camera.camPosition + Vector3.y], [edi + Player.camera + Camera.camPosition + Vector3.z]
        ;         invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        ; invoke  glPopMatrix
        ; invoke  glGetUniformLocation, [lightShader.ID], uniModelName
        ; ; mov     [uniModel], eax
        ; invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        ; invoke  glGetUniformLocation, [lightShader.ID], uniLightColorName
        ; invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        ; stdcall VAO.Bind, [lightVAO.ID]
        ; invoke  glDrawElements, GL_TRIANGLES, countLightIndices, GL_UNSIGNED_INT, 0
        ; stdcall VAO.Unbind

        ; draw player
        stdcall Shader.Activate, [exampleShader.ID]

        stdcall Camera.UniformBind, mainPlayer, [exampleShader.ID], uniProjName, uniViewName
        lea     esi, [arrTextures]
        add     esi, 8
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [exampleShader.ID], uniTex0Name, GL_TEXTURE0

        lea     edi, [mainPlayer]

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, [edi + Player.Position + Vector3.x], [edi + Player.Position + Vector3.y], [edi + Player.Position + Vector3.z]
                fld     [edi + Player.x_angle]
                fmul    [radian]
                fstp    [rotAngle]
                invoke  glRotatef, [rotAngle], 1.0, 0.0, 0.0
                fld     [edi + Player.y_angle]
                fmul    [radian]
                fstp    [rotAngle]
                invoke  glRotatef, [rotAngle], 0.0, 1.0, 0.0
                fld     [edi + Player.z_angle]
                fmul    [radian]
                fstp    [rotAngle]
                invoke  glRotatef, [rotAngle], 0.0, 0.0, 1.0
                invoke  glScalef, [edi + Player.sizeBlockDraw], [edi + Player.sizeBlockDraw], [edi + Player.sizeBlockDraw]
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [exampleShader.ID], uniModelName
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [exampleShader.ID], uniLightColorName
        invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        invoke  glGetUniformLocation, [exampleShader.ID], uniLightPosName
        invoke  glUniform3f, eax, [lightPos.x], [lightPos.y], [lightPos.z]

        lea     edi, [mainPlayer]
        invoke  glGetUniformLocation, [exampleShader.ID], uniCamPosName
        invoke  glUniform3f, eax, [edi + Camera.camPosition + Vector3.x], [edi + Camera.camPosition + Vector3.y], [edi + Camera.camPosition + Vector3.z]

        stdcall VAO.Bind, [VAO1.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

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

        cmp     dword [edi + colisionOffset], 1
        je      .Ret

        ; block drawing
        stdcall Shader.Activate, [exampleShader.ID]

        stdcall Camera.UniformBind, mainPlayer, [exampleShader.ID], uniProjName, uniViewName

        lea     esi, [arrTextures]
        add     esi, [edi + texOffset]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [exampleShader.ID], uniTex0Name, GL_TEXTURE0

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, [edi + translateOffset + Vector3.x], [edi + translateOffset + Vector3.y], [edi + translateOffset + Vector3.z]
                invoke  glRotatef, [edi + rotateOffset + Vector3.x], 1.0, 0.0, 0.0
                invoke  glRotatef, [edi + rotateOffset + Vector3.y], 0.0, 1.0, 0.0
                invoke  glRotatef, [edi + rotateOffset + Vector3.z], 0.0, 0.0, 1.0
                invoke  glScalef, [edi + scaleOffset + Vector3.x], [edi + scaleOffset + Vector3.y], [edi + scaleOffset + Vector3.z] 
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [exampleShader.ID], uniModelName
        ; mov     [uniModel], eax
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [exampleShader.ID], uniLightColorName
        invoke  glUniform4f, eax, [lightColor.r], [lightColor.g], [lightColor.b], [lightColor.a]

        invoke  glGetUniformLocation, [exampleShader.ID], uniLightPosName
        invoke  glUniform3f, eax, [lightPos.x], [lightPos.y], [lightPos.z]

        mov     edi, freeCamera
        invoke  glGetUniformLocation, [exampleShader.ID], uniCamPosName
        invoke  glUniform3f, eax, [edi + Camera.camPosition + Vector3.x], [edi + Camera.camPosition + Vector3.y], [edi + Camera.camPosition + Vector3.z]

        stdcall VAO.Bind, [VAO1.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

        .Ret:

        ret
endp