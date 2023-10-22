proc Init uses esi edi

    locals
            hMainWindow     dd      ?
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

    invoke  glEnable, GL_DEPTH_TEST
    invoke  glEnable, GL_LIGHTING
    invoke  glEnable, GL_TEXTURE_2D
    invoke  glShadeModel, GL_SMOOTH
    invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

    stdcall Glext.LoadFunctions

    lea     edi, [arrTextures]
    stdcall Texture.Constructor, edi, fileBoxTexture,\
                            GL_TEXTURE_2D, GL_TEXTURE0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [arrTextures + 4]
    stdcall Texture.Constructor, edi, fileLightTexture,\
                            GL_TEXTURE_2D, GL_TEXTURE0, GL_BGRA, GL_UNSIGNED_BYTE

    lea     edi, [arrTextures + 8]
    stdcall Texture.Constructor, edi, filePlayerTex,\
                            GL_TEXTURE_2D, GL_TEXTURE0, GL_BGRA, GL_UNSIGNED_BYTE

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

    invoke  glEnable, GL_LIGHT0
    ;invoke  glEnable, GL_LIGHT1
    invoke  glLightfv, GL_LIGHT0, GL_AMBIENT, light0Ambient
    ;invoke  glLightfv, GL_LIGHT1, GL_DIFFUSE, light1Diffuse

    ; TEST Shaders block
    stdcall Shader.Constructor, exampleShader.ID, vertexShaderFile, fragmentShaderFile

    ;TEST EBO, VBO, VAO
    ;Generate the VAO, EBO and VBO with only 1 object each
    stdcall VAO.Constructor, VAO1.ID
    stdcall VAO.Bind, [VAO1.ID]
    stdcall VBO.Constructor, VBO1.ID, sizeVertice * countVertices, vertices 
    stdcall EBO.Constructor, EBO1.ID, sizeIndex * countIndices, indices

    ; Configure the Vertex Attribute so that OpenGL knows how to read the VBO
    stdcall VAO.LinkAttribVBO, [VBO1.ID], 0, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetVertice
    stdcall VAO.LinkAttribVBO, [VBO1.ID], 1, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetColor
    stdcall VAO.LinkAttribVBO, [VBO1.ID], 2, 2, GL_FLOAT, GL_FALSE, sizeVertice, offsetTexture
    stdcall VAO.LinkAttribVBO, [VBO1.ID], 3, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetNormal

    ; Unbind VAO, VBO and EBO so that accidentlly to change it
    stdcall VBO.Unbind
    stdcall VAO.Unbind
    stdcall EBO.Unbind
    
    ; Light shader
    stdcall Shader.Constructor, lightShader.ID, lightVertexFile, lightFragmentFile

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

    stdcall Camera.Constructor, freeCamera, [clientRect.right], [clientRect.bottom], cameraPosition
    stdcall Player.Constructor, mainPlayer, [clientRect.right], [clientRect.bottom], cameraPosition

    ret
endp


        lightFragmentFile       db              "resources/shaders/light.frag", 0
        lightVertexFile         db              "resources/shaders/light.vert", 0
        lightVAO                VAO             
        lightVBO                VBO 
        lightEBO                EBO