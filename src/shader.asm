    vertexShaderStr             dd          ?
    fragmentShaderStr           dd          ?
proc Shader.Constructor uses esi,\
    ptrShaderID, vertFile, fragFile

    locals 
        vertexShader            GLuint      ?
        fragmentShader          GLuint      ?  
    endl

    stdcall File.LoadContent, [vertFile]
    mov     [vertexShaderStr], eax

    ; Create Vertex Shader Object and get its reference
    invoke  glCreateShader, GL_VERTEX_SHADER 
    mov     [vertexShader], eax
    ; Attach Vertex Shader source to the Vertex Shader Object and 
    ; compile it into machine code
    invoke  glShaderSource, [vertexShader], 1, vertexShaderStr, 0
    invoke  glCompileShader, [vertexShader]

    invoke  HeapFree, [hHeap], ebx, [vertexShaderStr]

    stdcall File.LoadContent, [fragFile]
    mov     [fragmentShaderStr], eax
    ; Create Fragment Shader Object and get its reference
    invoke  glCreateShader, GL_FRAGMENT_SHADER
    mov     [fragmentShader], eax
    ; Attach Fragment Shader source to the Vertex Shader Object and 
    ; compile it into machine code
    invoke  glShaderSource, [fragmentShader], 1, fragmentShaderStr, 0
    invoke  glCompileShader, [fragmentShader]

    invoke  HeapFree, [hHeap], ebx, [fragmentShaderStr]

    ; Crate shader Program Object and get its reference
    mov     esi, [ptrShaderID]
    invoke  glCreateProgram
    mov     dword [esi], eax
    
    ; Attach Vertex and Fragment Shaders to the Shader Program
    invoke  glAttachShader, dword [esi], [vertexShader]
    invoke  glAttachShader, dword [esi], [fragmentShader]

    ; Link all shaders together into the Shader Program
    invoke  glLinkProgram, dword [esi]

    ; Delete the now useless Vertex and Fragment Shaders
    invoke  glDeleteShader, [vertexShader]
    invoke  glDeleteShader, [fragmentShader]

    ret
endp

proc Shader.Activate uses esi,\
    ShaderID

    invoke  glUseProgram, [ShaderID]

    ret
endp

proc Shader.Delete uses esi,\
    ShaderID

    invoke  glDeleteProgram, [ShaderID]

    ret
endp