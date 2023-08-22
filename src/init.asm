proc Init uses esi

    locals
            hMainWindow     dd      ?
            aspect          dd      ? 
    endl 

    invoke  GetProcessHeap
    mov     [hHeap], eax

    invoke  RegisterClass, wndClass
    invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                    ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx 
    mov     [hMainWindow], eax   

    invoke  GetClientRect, eax, clientRect
    invoke  ShowCursor, ebx 
    invoke  GetTickCount
    mov     [time], eax 

    invoke  GetDC, [hMainWindow]
    mov     [hdc], eax 

    invoke  ChoosePixelFormat, [hdc], pfd 
    invoke  SetPixelFormat, [hdc], eax, pfd 

    invoke  wglCreateContext, [hdc]
    invoke  wglMakeCurrent, [hdc], eax 

    ;invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]

    fild    [clientRect.right]      ; width
    fidiv   [clientRect.bottom]     ; width / height
    fstp    [aspect]                ;

    invoke  glMatrixMode, GL_PROJECTION
    invoke  glLoadIdentity

    ;invoke  gluPerspective, double FOV, double 2.0, double Z_NEAR, double Z_FAR
    stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar], ProjectionMatrix

    invoke  glEnable, GL_DEPTH_TEST
    invoke  glEnable, GL_LIGHTING
    invoke  glEnable, GL_TEXTURE_2D
    invoke  glShadeModel, GL_SMOOTH
    invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

    stdcall Glext.LoadFunctions

    ; Block textures
    invoke  glGenTextures, 1, blockTexture
    invoke  glBindTexture, GL_TEXTURE_2D, [blockTexture]
    stdcall File.LoadContent, fileBoxTexture
    invoke  glTexImage2D, GL_TEXTURE_2D, ebx,\ 
                    GL_RGB8, 256, 256, ebx, GL_BGR,\
                    GL_UNSIGNED_BYTE, eax
    invoke  glGenerateMipmap, GL_TEXTURE_2D
    ;invoke  gluBuild2DMipmaps, GL_TEXTURE_2D, GL_RGB8, 256, 256, GL_BGR, GL_UNSIGNED_BYTE, eax

     
    ; Box texture settings
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST
    
    invoke  glGenTextures, 1, lightTexture
    invoke  glBindTexture, GL_TEXTURE_2D, [lightTexture]
    stdcall File.LoadContent, fileLightTexture
    invoke  glTexImage2D, GL_TEXTURE_2D, ebx,\ 
                    GL_RGB8, 256, 256, ebx, GL_BGR,\
                    GL_UNSIGNED_BYTE, eax
    invoke  glGenerateMipmap, GL_TEXTURE_2D 
    ;invoke  gluBuild2DMipmaps, GL_TEXTURE_2D, GL_RGB8, 256, 256, GL_BGR, GL_UNSIGNED_BYTE, eax

    ; Box texture settings
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST

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

    ; Mesh generating
    stdcall Mesh.Generate, cubeMesh, drawCubeMesh, true
    stdcall Mesh.Generate, planeMesh, drawPlaneMesh, true
    
    stdcall Mesh.CalculateNormals, drawCubeMesh
    stdcall Mesh.CalculateNormals, drawPlaneMesh

    invoke  glEnable, GL_LIGHT0
    ;invoke  glEnable, GL_LIGHT1
    invoke  glLightfv, GL_LIGHT0, GL_AMBIENT, light0Ambient
    ;invoke  glLightfv, GL_LIGHT1, GL_DIFFUSE, light1Diffuse

    ; TEST Shaders
    stdcall Shader.Constructor, exampleShader.ID, vertexShaderFile, fragmentShaderFile

    ;TEST EBO, VBO, VAO
    ;Generate the VAO, EBO and VBO with only 1 object each
    stdcall VAO.Constructor, VAO1.ID
    stdcall VAO.Bind, [VAO1.ID]
    stdcall VBO.Constructor, VBO1.ID, 3 * 3 * 4, vertices 
    stdcall EBO.Constructor, EBO1.ID, 3 * 4, indices

    ; Configure the Vertex Attribute so that OpenGL knows how to read the VBO
    stdcall VAO.LinkVBO, [VBO1.ID], 0

    ; Unbind VAO, VBO and EBO so that accidentlly to change it
    stdcall VBO.Unbind
    stdcall VAO.Unbind
    stdcall EBO.Unbind

    ret
endp