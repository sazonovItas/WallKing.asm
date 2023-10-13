proc Glext.LoadFunctions uses esi edi

        mov     esi, extensionAddresses
        mov     edi, extensionNames

.Scan:
        movzx   eax, byte [edi]
        cmp     eax, ebx
        je      .Return

        invoke  wglGetProcAddress, edi
        mov     [esi], eax
        add     esi, 4

        mov     al, 0
        mov     ecx, 0xFFFFFFFF
        repne   scasb
        jmp     .Scan

.Return:
        ret
endp

proc Glext.InitShaders

        invoke  glUseProgram, ebx

        cmp     [program], ebx
        je      @F

        invoke  glDetachShader, [program], [fragmentShader]
        invoke  glDeleteShader, [fragmentShader]
        invoke  glDeleteProgram, [program]

@@:
        stdcall Glext.LoadShader, shaderFile, GL_FRAGMENT_SHADER
        mov     [fragmentShader], eax

        cmp     eax, ebx
        jne     @F

        mov     [program], ebx
        jmp     .Return

@@:
        stdcall Glext.CreateProgram, ebx, eax
        mov     [program], eax

        cmp     eax, ebx
        je      .Return

        invoke  glUseProgram, eax

        invoke  glGetUniformLocation, [program], timeName
        mov     [timeLocation], eax
        invoke  glGetUniformLocation, [program], sizeName
        mov     [sizeLocation], eax

.Return:
        ret
endp

proc Glext.CreateProgram,\
     vertexShader, fragmentShader

        locals
                progam  dd      ?
                linked  dd      ?
        endl

        invoke  glCreateProgram
        mov     [program], eax

        cmp     [vertexShader], ebx
        je      @F

        invoke  glAttachShader, [program], [vertexShader]

@@:
        cmp     [fragmentShader], ebx
        je      @F

        invoke  glAttachShader, [program], [fragmentShader]

@@:
        invoke  glLinkProgram, [program]

        lea     eax, [linked]
        invoke  glGetProgramiv, [program], GL_LINK_STATUS, eax

        cmp     [linked], ebx
        je      @F

        mov     eax, [program]
        jmp     .Return

@@:
        cmp     [vertexShader], ebx
        je      @F

        invoke  glDetachShader, [program], [vertexShader]

@@:
        cmp     [fragmentShader], ebx
        je      @F

        invoke  glDetachShader, [program], [fragmentShader]

@@:
        invoke  glDeleteProgram, [program]

.Return:
        ret
endp

proc Glext.LoadShader,\
     fileName, shaderType

        locals
                buffer          dd      ?
                shader          dd      ?
                compiled        dd      ?
        endl

        stdcall File.LoadContent, [fileName]
        mov     [buffer], eax

        invoke  glCreateShader, [shaderType]
        mov     [shader], eax
        lea     eax, [buffer]
        invoke  glShaderSource, [shader], 1, eax, ebx
        invoke  glCompileShader, [shader]

        invoke  HeapFree, [hHeap], ebx, [buffer]

        lea     eax, [compiled]
        invoke  glGetShaderiv, [shader], GL_COMPILE_STATUS, eax

        cmp     [compiled], ebx
        je      @F

        mov     eax, [shader]
        jmp     .Return

@@:
        mov     eax, ebx

.Return:
        ret
endp