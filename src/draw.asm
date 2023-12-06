proc Draw.Scene uses esi edi,\
        pPlayer, pBlocksMap, sizeBlocksMap, pLightsMap, sizeLightsMap

        stdcall Camera.Matrix, [pPlayer]

        mov     edi, [pPlayer]

        stdcall Draw.BlocksMap, [blockShader.ID], [pPlayer], [pBlocksMap], [sizeBlocksMap]
        stdcall Draw.LightsMap, [ligthShader.ID], [pPlayer], [pLightsMap], [sizeLightsMap]

        mov     edi, [pPlayer]
        mov     esi, edi 
        add     esi, Player.DrawPlayer
        stdcall Player.Draw, [blockShader.ID], edi, esi

        ; Draw other players
        stdcall Draw.ConPlayers, [pPlayer], [blockShader.ID], [Client.BufferDraw]

        ret
endp

proc Draw.ConPlayers uses edi esi ebx,\
        pPlayer, shaderId, buf

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

                stdcall Draw.ConPlayer, [pPlayer], [shaderId], edi

                add     edi, Client.SizeofPlayer
                pop     ecx
                loop    .drawCycle

.Ret:
        ret
endp

proc Draw.ConPlayer uses edi esi ebx,\
        pPlayer, shaderId, offset

        locals 
                rotAngle                dd              0.0
                tmp                     Vector3         ? 
        endl

        stdcall Shader.Activate, [shaderId]
        stdcall Camera.UniformBind, [pPlayer], [shaderId], uniProjName, uniViewName

        mov     edi, [offset]

        ; ambient
        lea     esi, [ambientTexs]
        add     esi, [edi + Client.plAmbientTex]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [shaderId], uniMatAmbientName, 0

        ; diffuse
        lea     esi, [diffuseTexs]
        add     esi, [edi + Client.plDiffuseTex]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE1
        stdcall Texture.texUnit, [shaderId], uniMatDiffuseName, 1

        ; specular
        lea     esi, [specularTexs]
        add     esi, [edi + Client.plSpecularTex]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE2
        stdcall Texture.texUnit, [shaderId], uniMatSpecularName, 2

        invoke  glGetUniformLocation, [shaderId], uniMatShininessName
        invoke  glUniform1f, eax, dword [edi + Client.plShininess]

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
        invoke  glGetUniformLocation, [shaderId], uniModelName
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        stdcall Draw.BindLightsForShader, [shaderId], lightsMapTry, [sizeLightsMapTry]

        lea     ebx, [tmp]
        mov     edi, [pPlayer]
        add     edi, Player.camera + Camera.camPosition
        stdcall Vector3.Copy, ebx, edi
        add     edi, (Camera.translate - Camera.camPosition)
        stdcall Vector3.Sub, ebx, edi
        invoke  glGetUniformLocation, [shaderId], uniCamPosName
        invoke  glUniform3f, eax, [ebx + Vector3.x], [ebx + Vector3.y], [ebx + Vector3.z]

        stdcall VAO.Bind, [blockVAO.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

.Ret:
        ret
endp

;       offsets         scale = 12, rotate = 12, traslate = 12, texture = 4, material = 4, collision = 4
proc Draw.BlocksMap uses esi edi ebx,\
        shaderId, pPlayer, blocksMap, sizeBlocksMap

        mov     edi, [blocksMap]
        mov     ecx, [sizeBlocksMap]
        jcxz    .Ret
        
        .DrawBlock:
        push    ecx

        stdcall Draw.Block, [shaderId], [pPlayer], edi

        add     edi, sizeBlock
        pop     ecx 
        loop    .DrawBlock

.Ret:
        ret
endp

proc Draw.Block uses edi esi ebx,\
        shaderId, pPlayer, offsetBlock

        locals
                tmp             Vector3         ?
        endl

        mov     edi, [offsetBlock]

        ; block drawing
        stdcall Shader.Activate, [shaderId]

        stdcall Camera.UniformBind, [pPlayer], [shaderId], uniProjName, uniViewName

        ; ambient
        lea     esi, [ambientTexs]
        add     esi, [edi + ambientOffset]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE0
        stdcall Texture.texUnit, [shaderId], uniMatAmbientName, 0

        ; diffuse
        lea     esi, [diffuseTexs]
        add     esi, [edi + diffuseOffset]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE1
        stdcall Texture.texUnit, [shaderId], uniMatDiffuseName, 1

        ; specular
        lea     esi, [specularTexs]
        add     esi, [edi + specularOffset]
        stdcall Texture.Bind, GL_TEXTURE_2D, dword [esi], GL_TEXTURE2
        stdcall Texture.texUnit, [shaderId], uniMatSpecularName, 2

        invoke  glGetUniformLocation, [shaderId], uniMatShininessName
        invoke  glUniform1f, eax, dword [edi + shininessOffset]


        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, [edi + translateOffset + Vector3.x], [edi + translateOffset + Vector3.y], [edi + translateOffset + Vector3.z]
                invoke  glRotatef, [edi + rotateOffset + Vector3.x], 1.0, 0.0, 0.0
                invoke  glRotatef, [edi + rotateOffset + Vector3.y], 0.0, 1.0, 0.0
                invoke  glRotatef, [edi + rotateOffset + Vector3.z], 0.0, 0.0, 1.0
                invoke  glScalef, [edi + scaleOffset + Vector3.x], [edi + scaleOffset + Vector3.y], [edi + scaleOffset + Vector3.z] 
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [shaderId], uniModelName
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        stdcall Draw.BindLightsForShader, [shaderId], lightsMapTry, [sizeLightsMapTry]

        lea     ebx, [tmp]
        mov     edi, [pPlayer]
        add     edi, Player.camera + Camera.camPosition
        stdcall Vector3.Copy, ebx, edi
        add     edi, (Camera.translate - Camera.camPosition)
        stdcall Vector3.Sub, ebx, edi
        invoke  glGetUniformLocation, [shaderId], uniCamPosName
        invoke  glUniform3f, eax, [ebx + Vector3.x], [ebx + Vector3.y], [ebx + Vector3.z]

        stdcall VAO.Bind, [blockVAO.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

        .Ret:

        ret
endp

proc Draw.BindLightsForShader uses edi esi ebx,\
        shaderId, pLightsMap, sizeLightsMap

        mov     edi, [pLightsMap]

        stdcall Shader.Activate, [shaderId]
        invoke  glGetUniformLocation, [shaderId], uniPLCnt
        invoke  glUniform1i, eax, [sizeLightsMap]

        mov     ecx, [sizeLightsMap]
        jcxz    .Ret

        cmp     ecx, MAX_CNT_LIGHTS
        jbe     @F

        mov     ecx, MAX_CNT_LIGHTS

        @@:

        .BindLight:
        push    ecx
                
                mov     eax, ecx
                dec     eax
                add     eax, '0'    
                lea     esi, [uniPLPositionName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLColorName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLConstantName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLLinearName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLQuadraticName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLAmbientName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLDiffuseName + pointLightIndexOffset]
                mov     byte [esi], al
                lea     esi, [uniPLSpecularName + pointLightIndexOffset]
                mov     byte [esi], al

                stdcall Draw.BindLightForShader, [shaderId], edi

        add     edi, sizeLight
        pop     ecx
        loop    .BindLight

.Ret:
        ret
endp

proc Draw.BindLightForShader uses edi esi ebx,\
        shaderId, lightOffset

        mov     edi, [lightOffset]

        ; Bind all stuffes for light to shader 
        ; Postion of light
        invoke  glGetUniformLocation, [shaderId], uniPLPositionName
        invoke  glUniform3f, eax, dword [edi + posLightOffset], dword [edi + posLightOffset + 4], dword [edi + posLightOffset + 8]
        ; Color of light
        invoke  glGetUniformLocation, [shaderId], uniPLColorName
        invoke  glUniform3f, eax, dword [edi + colorLightOffset], dword [edi + colorLightOffset + 4], dword [edi + colorLightOffset + 8]
        ; Constant
        invoke  glGetUniformLocation, [shaderId], uniPLConstantName
        invoke  glUniform1f, eax, dword [edi + constantLightOffset]
        ; Linear
        invoke  glGetUniformLocation, [shaderId], uniPLLinearName
        invoke  glUniform1f, eax, dword [edi + linearLightOffset]
        ; Quadratic
        invoke  glGetUniformLocation, [shaderId], uniPLQuadraticName
        invoke  glUniform1f, eax, dword [edi + quadraticLightOffset]
        ; Ambient
        invoke  glGetUniformLocation, [shaderId], uniPLAmbientName
        invoke  glUniform3f, eax, dword [edi + ambientLightOffset], dword [edi + ambientLightOffset + 4], dword [edi + ambientLightOffset + 8]
        ; Diffuse
        invoke  glGetUniformLocation, [shaderId], uniPLDiffuseName
        invoke  glUniform3f, eax, dword [edi + diffuseLightOffset], dword [edi + diffuseLightOffset + 4], dword [edi + diffuseLightOffset + 8]
        ; Specular
        invoke  glGetUniformLocation, [shaderId], uniPLSpecularName
        invoke  glUniform3f, eax, dword [edi + specularLightOffset], dword [edi + specularLightOffset + 4], dword [edi + specularLightOffset + 8]

        ret
endp

proc Draw.LightsMap uses edi esi ebx,\
        shaderId, pPlayer, pLightsMap, sizeLigthsMap 

        mov     edi, [pLightsMap]       
        mov     ecx, [sizeLigthsMap]
        jcxz    .Ret

        .DrawLight:
        push    ecx

        stdcall Draw.Light, [shaderId], [pPlayer], edi

        add     edi, sizeLight
        pop     ecx
        loop    .DrawLight

.Ret:
        ret
endp

proc Draw.Light uses edi esi ebx,\
        shaderId, pPlayer, offsetLight

        mov     edi, [offsetLight]

        ; light draw
        stdcall Shader.Activate, [shaderId]

        stdcall Camera.UniformBind, [pPlayer], [shaderId], uniProjName, uniViewName

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glTranslatef, dword [edi + posLightOffset], dword [edi + posLightOffset + 4], dword [edi + posLightOffset + 8]
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [shaderId], uniModelName
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [shaderId], uniLightColorName
        invoke  glUniform3f, eax, dword [edi + colorLightOffset], dword [edi + colorLightOffset + 4], dword [edi + colorLightOffset + 8]

        stdcall VAO.Bind, [lightVAO.ID]
        invoke  glDrawElements, GL_TRIANGLES, countLightIndices, GL_UNSIGNED_INT, 0
        stdcall VAO.Unbind

        ret
endp