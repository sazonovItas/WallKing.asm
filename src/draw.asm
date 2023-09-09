proc Draw.Scene uses esi edi

        locals 
                currentFrame            dd     ?
                testAngle               dd     180.0
                colDetected             dd     ?
        endl

        invoke  GetTickCount
        mov     [currentFrame], eax

        sub     eax, [time]
        cmp     eax, 18 
        jle     .Skip

        mov     eax, [currentFrame]
        mov     [time], eax

        fld     [angle]                 ; angle
        fsub    [step]                  ; angle + step
        fstp    [angle]                 ;

        mov     eax, [currentFrame]
        sub     eax, [lastFrame]
        mov     [deltaTime], eax
        mov     eax, [currentFrame]
        mov     [lastFrame], eax
        xor     ebx, ebx

.Skip: 

        ; lea     eax, [colDetected]
        ; stdcall Collision.MapDetection, freeCamera, [sizeBlocksMapTry], blocksMapTry, eax

        stdcall Player.Move, mainPlayer, [deltaTime]

        stdcall Camera.Matrix, mainPlayer, [fovY], [zNear], [zFar]

        invoke  glViewport, 0, 0, [mainPlayer.width], [mainPlayer.height]
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

        cmp     dword [edi + 44], 1
        je      .Ret

        ; block drawing
        stdcall Shader.Activate, [exampleShader.ID]

        stdcall Camera.UniformBind, mainPlayer, [exampleShader.ID], uniProjName, uniViewName

        lea     esi, [arrTextures]
        add     esi, [edi + 36]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [exampleShader.ID], uniTex0Name, GL_TEXTURE0

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, dword [edi + 24], dword [edi + 28], dword [edi + 32]
                invoke  glRotatef, dword [edi + 12], 1.0, 0.0, 0.0
                invoke  glRotatef, dword [edi + 16], 0.0, 1.0, 0.0
                invoke  glRotatef, dword [edi + 20], 0.0, 0.0, 1.0 
                invoke  glScalef, dword [edi], dword [edi + 4], dword [edi + 8] 
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
        invoke  glUniform3f, eax, [edi + Camera.Position + Vector3.x], [edi + Camera.Position + Vector3.y], [edi + Camera.Position + Vector3.z]

        stdcall VAO.Bind, [VAO1.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

        .Ret:

        ret
endp