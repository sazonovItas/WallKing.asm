proc Init uses esi edi ebx

    locals
            hMainWindow     dd      ?
            hContext        dd      ?
            nPixelFormat    dd      ?
            nNumFormats     dd      ?
    endl 
 
    stdcall memInit

    invoke  RegisterClass, wndClass
    invoke  CreateWindowEx, NULL, className, className, WINDOW_STYLE,\
                    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL 
    mov     [hMainWindow], eax   

    invoke  GetClientRect, eax, clientRect
    invoke  ShowCursor, ebx 

    invoke  GetDC, [hMainWindow]
    mov     [hdc], eax 

    invoke  ChoosePixelFormat, [hdc], pfd 
    invoke  SetPixelFormat, [hdc], eax, pfd 

    invoke  wglCreateContext, [hdc]
    mov     [hContext], eax
    invoke  wglMakeCurrent, [hdc], eax 

    stdcall Glext.LoadFunctions
    lea     edi, [nPixelFormat]
    lea     esi, [nNumFormats]
    invoke  wglChoosePixelFormatARB, [hdc], piAttribIList, pfAttribFList, 1, edi, esi

    cmp     eax, false
    je      @F

    invoke  SetPixelFormat, [hdc], [nPixelFormat], pfd  
    invoke  wglMakeCurrent, [hdc], NULL
    invoke  wglDeleteContext, [hContext]
    invoke  wglCreateContext, [hdc]
    mov     [hglrc], eax
    invoke  wglMakeCurrent, [hdc], eax

    @@:

    ; Init opengl
    stdcall Init.OpenGL
    
    ; Init game data
    stdcall Init.GameData

	; Init client for multiplaying
    stdcall Client.Init

    ret
endp

proc Init.GameData

    ; Font
    invoke  glGenLists, MAX_CHARS
    mov     [fontListId], eax

    invoke  CreateFont, fontHeight, 0, 0, 0, FW_BOLD,\
                    false, false, false, ANSI_CHARSET, OUT_TT_PRECIS,\
                    CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY,\
                    FF_DONTCARE or DEFAULT_PITCH, strFont

    invoke  wglUseFontBitmapsA, [hdc], 0, MAX_CHARS - 1, [fontListId]

    ; stdcall Level.Load, TestLevel, level1File

    stdcall malloc, sizeof.Player
    mov  	[mainPlayer], eax
    stdcall Player.Constructor, eax, [clientRect.right], [clientRect.bottom], TestLevel

    ret
endp

proc Init.OpenGL 

    invoke  glEnable, GL_DEPTH_TEST
    invoke  glEnable, GL_MULTISAMPLE
    invoke  glShadeModel, GL_SMOOTH
    invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

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

    ; interface textures
    lea     edi, [hOfflineTex]
    stdcall Texture.Constructor, edi, fileOfflineTex,\
                            GL_TEXTURE_2D, GL_TEXTURE0, GL_RGB8, 0, GL_BGR, GL_UNSIGNED_BYTE

    lea     edi, [hOnlineTex]
    stdcall Texture.Constructor, edi, fileOnlineTex,\
                            GL_TEXTURE_2D, GL_TEXTURE2, GL_RGB8, 0, GL_BGR, GL_UNSIGNED_BYTE

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
    stdcall VAO.LinkAttribVBO, [blockVBO.ID], 1, 2, GL_FLOAT, GL_FALSE, sizeVertice, offsetTexture
    stdcall VAO.LinkAttribVBO, [blockVBO.ID], 2, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetNormal

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

    ; ========= SHADOWS =========
    ; Generate shadow map fbo
    ; invoke  glGenFramebuffers, 1, shadowMapFBO

    ; ; Generate shadow texture
    ; invoke  glGenTextures, 1, shadowMap
    ; invoke  glBindTexture, GL_TEXTURE_2D, [shadowMap]
    ; invoke  glTexImage2D, GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT,\
    ;         SHADOW_MAP_WIDTH, SHADOW_MAP_HEIGHT, 0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL

    ; ; Texture's settings
    ; invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    ; invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST
    ; invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER
    ; invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER
    ; invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, clampColor

    ; ; Bind and setting up framebuffer
    ; invoke  glBindFramebuffer, GL_FRAMEBUFFER, [shadowMapFBO]
    ; invoke  glFramebufferTexture2D, GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, [shadowMap], NULL
    ; invoke  glDrawBuffer, GL_NONE
    ; invoke  glReadBuffer, GL_NONE
    ; invoke  glBindFramebuffer, GL_FRAMEBUFFER, 0

    ; ; Shadow shader
    ; stdcall Shader.Constructor, shadowShader.ID, shadowVertexFile, shadowFragmentFile

    ; ----------- INTERFACE --------------
    ; Interface shader
    stdcall Shader.Constructor, interfaceShader.ID, interfaceVertexFile, interfaceFragmentFile

    ;Generate the VAO, EBO and VBO with only 1 object each
    stdcall VAO.Constructor, interfaceVAO.ID
    stdcall VAO.Bind, [interfaceVAO.ID]
    stdcall VBO.Constructor, interfaceVBO.ID, sizeVertice * countVertices, vertices 
    stdcall EBO.Constructor, interfaceEBO.ID, sizeIndex * countIndices, indices

    ; Configure the Vertex Attribute so that OpenGL knows how to read the VBO
    stdcall VAO.LinkAttribVBO, [interfaceVBO.ID], 0, 3, GL_FLOAT, GL_FALSE, sizeVertice, offsetVertice
    stdcall VAO.LinkAttribVBO, [interfaceVBO.ID], 1, 2, GL_FLOAT, GL_FALSE, sizeVertice, offsetTexture

    ; Unbind VAO, VBO and EBO so that accidentlly to change it
    stdcall VBO.Unbind
    stdcall VAO.Unbind
    stdcall EBO.Unbind

    ret
endp
