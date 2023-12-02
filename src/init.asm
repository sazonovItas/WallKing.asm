proc Init uses esi edi ebx

    locals
            hMainWindow     dd      ?
            text            db      "Hi", 0
    endl 
 
    stdcall memInit

    invoke  RegisterClass, wndClass
    invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                    ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx 
    mov     [hMainWindow], eax   

    invoke  GetClientRect, eax, clientRect
    invoke  ShowCursor, ebx 

    invoke  GetDC, [hMainWindow]
    mov     [hdc], eax 

    invoke  ChoosePixelFormat, [hdc], pfd 
    invoke  SetPixelFormat, [hdc], eax, pfd 

    invoke  wglCreateContext, [hdc]
    invoke  wglMakeCurrent, [hdc], eax 
 
    ; Init opengl
    stdcall Init.OpenGL
    
    ; Init game data
    stdcall Init.GameData

	; Init client for multiplaying
    stdcall Client.Init

    ret
endp

proc Init.GameData

    stdcall malloc, sizeof.Player
    mov  	[mainPlayer], eax
    stdcall Player.Constructor, eax, [clientRect.right], [clientRect.bottom], cameraPosition

    ret
endp

proc Init.OpenGL 

    invoke  glEnable, GL_DEPTH_TEST
    invoke  glEnable, GL_LIGHTING
    invoke  glEnable, GL_TEXTURE_2D
    invoke  glShadeModel, GL_SMOOTH
    invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

    stdcall Glext.LoadFunctions

    ; Ambient
    lea     edi, [ambientTexs]
    stdcall Texture.Constructor, edi, fileContainerAmbientTex,\
                            GL_TEXTURE_2D, GL_TEXTURE1, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [ambientTexs + 4]
    stdcall Texture.Constructor, edi, fileGemBlueAmbientTex,\
                            GL_TEXTURE_2D, GL_TEXTURE1, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [ambientTexs + 8]
    stdcall Texture.Constructor, edi, fileGemRainbowAmbientTex,\
                            GL_TEXTURE_2D, GL_TEXTURE1, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    ; Diffuse
    lea     edi, [diffuseTexs]
    stdcall Texture.Constructor, edi, fileContainerDiffuseTex,\
                            GL_TEXTURE_2D, GL_TEXTURE2, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [diffuseTexs + 4]
    stdcall Texture.Constructor, edi, fileGemBlueDiffuseTex,\
                            GL_TEXTURE_2D, GL_TEXTURE2, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [diffuseTexs + 8]
    stdcall Texture.Constructor, edi, fileGemRainbowDiffuseTex,\
                            GL_TEXTURE_2D, GL_TEXTURE2, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    ; Specular
    lea     edi, [specularTexs]
    stdcall Texture.Constructor, edi, fileContainerSpecularTex,\
                            GL_TEXTURE_2D, GL_TEXTURE3, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [specularTexs + 4]
    stdcall Texture.Constructor, edi, fileGemBlueSpecularTex,\
                            GL_TEXTURE_2D, GL_TEXTURE3, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [specularTexs + 8]
    stdcall Texture.Constructor, edi, fileGemRainbowSpecularTex,\
                            GL_TEXTURE_2D, GL_TEXTURE3, GL_RGB8, 0, GL_BGRA, GL_UNSIGNED_BYTE


    ; Shadow texture settings
    ; Create the FBO
    invoke  glGenFramebuffers, 1, m_fbo

    ; Create the depth buffer
    invoke  glGenTextures, 1, m_shadowMap
    invoke  glBindTexture, GL_TEXTURE_2D, [m_shadowMap]
    invoke  glTexImage2D, GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, 1024, 1024, 0,\ 
                    GL_DEPTH_COMPONENT, GL_FLOAT, NULL
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST

    invoke  glBindFramebuffer, GL_FRAMEBUFFER, [m_fbo]
    invoke  glFramebufferTexture2D, GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, [m_shadowMap], 0
    
    ; Disable writes to the color buffer
    invoke  glDrawBuffer, GL_NONE
    invoke  glReadBuffer, GL_NONE

    invoke  glBindFramebuffer, GL_FRAMEBUFFER, 0

    ; ----------- BLOCK SHADER -----------------
    ; Block shader
    stdcall Shader.Constructor, blockShader.ID, blockVertexFile, blockFragmentFile

    ;Generate the VAO, EBO and VBO with only 1 object each
    stdcall VAO.Constructor, blockVAO.ID
    stdcall VAO.Bind, [blockVAO.ID]
    stdcall VBO.Constructor, blockVBO.ID, sizeVertice * countVertices, vertices 
    stdcall EBO.Constructor, blockEBO.ID, sizeIndex * countIndices, indices

    ; Configure the Vertex Attribute so that OpenGL knows how to read the VBO
    stdcall VAO.LinkAttribVBO, [blockVBO.ID], 0, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetVertice
    stdcall VAO.LinkAttribVBO, [blockVBO.ID], 1, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetColor
    stdcall VAO.LinkAttribVBO, [blockVBO.ID], 2, 2, GL_FLOAT, GL_FALSE, sizeVertice, offsetTexture
    stdcall VAO.LinkAttribVBO, [blockVBO.ID], 3, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetNormal

    ; Unbind VAO, VBO and EBO so that accidentlly to change it
    stdcall VBO.Unbind
    stdcall VAO.Unbind
    stdcall EBO.Unbind

    ; ---------- LIGHT SHADER ----------------------------- 
    ; Light shader
    stdcall Shader.Constructor, ligthShader.ID, lightVertexFile, lightFragmentFile

    ; Generate light VAO, VBO and EBO 
    stdcall VAO.Constructor, lightVAO.ID
    stdcall VAO.Bind, [lightVAO.ID]
    stdcall VBO.Constructor, lightVBO.ID, sizeLightVertice * countLightVertices, lightVertices 
    stdcall EBO.Constructor, lightEBO.ID, sizeLightIndex * countLightIndices, lightIndices

    ; Configure the Vertex Attribute so that OpenGL knows how to read the VBO
    stdcall VAO.LinkAttribVBO, [lightVBO.ID], 0, 3, GL_FLOAT, GL_FALSE, sizeLightVertice, offsetVertice

    ; Unbind VAO, VBO and EBO so that accidentlly to change it
    stdcall VBO.Unbind
    stdcall VAO.Unbind
    stdcall EBO.Unbind

    ret
endp

