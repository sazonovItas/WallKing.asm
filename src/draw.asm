proc Draw uses edi

        locals
                currentTime     dd      ?
                verticesCount   dd      ?
                coord           dd      3.0
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 18
        jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax

        fld     [angle]                 ; angle
        fsub    [step]                  ; angle + step
        fstp    [angle]                 ;

.Skip: 
        ;invoke  glClearColor, 0.22, 0.22, 0.22, 1.0
        ;invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        ;invoke  gluLookAt, double 10.0, double 10.0, double 0.0,\
        ;                double 0.0, double 0.0, double 0.0,\
        ;                double 0.0, double 1.0, double 0.0
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector, ViewMatrix 

        ;invoke  glLightfv, GL_LIGHT1, GL_POSITION, light1Position
        invoke  glLightfv, GL_LIGHT0, GL_POSITION, light0Position
    
        invoke  glBindTexture, GL_TEXTURE_2D, [lightTexture.ID]
        invoke  glPushMatrix
                invoke  glTranslatef, [light0Position.x], [light0Position.y], [light0Position.z]
                invoke  glScalef, 0.35, 0.35, 0.35
                stdcall Draw.Mesh, drawCubeMesh
        invoke  glPopMatrix

        ;invoke  glPushMatrix
        ;        invoke  glTranslatef, [light1Position.x], [light1Position.y], [light1Position.z]
        ;        invoke  glScalef, 0.35, 0.35, 0.35
        ;        stdcall Draw.Mesh, drawCubeMesh
        ;invoke  glPopMatrix

        invoke  glBindTexture, GL_TEXTURE_2D, [blockTexture.ID]
        stdcall Draw.Map, myMap, [mapLen]

        ;invoke  SwapBuffers, [hdc]

        ret
endp

proc Draw.Map uses esi ecx,\
        drawMap, drawLen 

        mov     ecx, [drawLen]
        mov     esi, [drawMap]

        .drawLoop:

                push    ecx
                invoke  glPushMatrix
                        invoke  glTranslatef, dword [esi], dword [esi + 4], dword[esi + 8] 
                        stdcall Draw.Mesh, drawCubeMesh
                invoke  glPopMatrix
                pop     ecx
                add     esi, 12

        loop    .drawLoop

        ret
endp

proc Draw.Mesh uses esi,\
        mesh

        mov     esi, [mesh]

        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY
        invoke  glEnableClientState, GL_NORMAL_ARRAY
        invoke  glEnableClientState, GL_TEXTURE_COORD_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
        invoke  glTexCoordPointer, 2, GL_FLOAT, ebx, [esi + Mesh.textures]
        invoke  glDrawArrays, GL_TRIANGLES, ebx, [esi + Mesh.verticesCount]

        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY
        invoke  glDisableClientState, GL_NORMAL_ARRAY
        invoke  glDisableClientState, GL_TEXTURE_COORD_ARRAY

        ret
endp

proc Draw.Scene uses esi edi

        locals 
                currentTime             dd      ?
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 18 
        jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax

        fld     [angle]                 ; angle
        fsub    [step]                  ; angle + step
        fstp    [angle]                 ;

.Skip: 

        ; invoke  glViewport, 0, 0, 1024, 1024
        ; invoke  glBindFramebuffer, GL_FRAMEBUFFER, [m_fbo]
        ;         invoke glClear, GL_DEPTH_BUFFER_BIT
        ;         stdcall Draw
        ; invoke  glBindFramebuffer, GL_FRAMEBUFFER, 0

        ; invoke  glViewport, 0, 0, [clientRect.right], [clientRect.bottom]
        ; invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        ; invoke  glBindTexture, GL_TEXTURE_2D, [m_shadowMap]
        ; stdcall Draw

        
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        ; invoke  gluLookAt, double 10.0, double 10.0, double 0.0,\
                ;       double 0.0, double 0.0, double 0.0,\
                ;       double 0.0, double 1.0, double 0.0
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector, ViewMatrix

        stdcall Camera.Matrix, freeCamera, [fovY], [zNear], [zFar], [exampleShader.ID], uniProjName, uniViewName

        stdcall Shader.Activate, [exampleShader.ID]
        invoke  glUniform1f, [uniScale.ID], [scale]

        stdcall Texture.Bind, GL_TEXTURE_2D, [blockTexture.ID]
        stdcall Texture.texUnit, [exampleShader.ID], uniTex0Name, GL_TEXTURE0

        invoke  glPushMatrix
                invoke  glLoadIdentity
                invoke  glRotatef, [angle], 0.0, 1.0, 0.0
                invoke  glGetFloatv, GL_MODELVIEW_MATRIX, ModelMatrix
        invoke  glPopMatrix
        invoke  glGetUniformLocation, [exampleShader.ID], uniModelName
        ; mov     [uniModel], eax
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ModelMatrix

        invoke  glGetUniformLocation, [exampleShader.ID], uniViewName
        ; mov     [uniView], eax
        invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ViewMatrix

        ; invoke  glGetUniformLocation, [exampleShader.ID], uniProjName
        ; mov     [uniProj]
        ; invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, ProjectionMatrix

        stdcall VAO.Bind, [VAO1.ID]       
        invoke  glDrawElements, GL_TRIANGLES, countIndices, GL_UNSIGNED_INT, 0

        ret
endp