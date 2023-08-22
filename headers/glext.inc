extensionAddresses:
        glGenerateMipmap        dd      ?
        glGenFramebuffers       dd      ?
        glBindFramebuffer       dd      ?
        glFramebufferTexture2D  dd      ?
        gluBuild2DMipmaps       dd      ?
        glUseProgram            dd      ?
        glDetachShader          dd      ?
        glDeleteShader          dd      ?
        glDeleteProgram         dd      ?
        glCreateShader          dd      ?
        glShaderSource          dd      ?
        glCompileShader         dd      ?
        glGetShaderiv           dd      ?
        glCreateProgram         dd      ?
        glAttachShader          dd      ?
        glLinkProgram           dd      ?
        glGetProgramiv          dd      ?
        glGetUniformLocation    dd      ?
        glUniform1f             dd      ?
        glUniform2f             dd      ?

        glGenBuffers            dd      ?
        glBindBuffer            dd      ?  
        glBufferData            dd      ?
        glGenVertexArrays       dd      ?
        glBindVertexArray       dd      ?
        glVertexAttribPointer   dd      ?
        glEnableVertexAttribArray dd    ?

extensionNames:
                        db      "glGenerateMipmap", 0
                        db      "glGenFramebuffers", 0
                        db      "glBindFramebuffer", 0
                        db      "glFramebufferTexture2D", 0
                        db      "gluBuild2DMipmaps", 0
                        db      "glUseProgram", 0
                        db      "glDetachShader", 0
                        db      "glDeleteShader", 0
                        db      "glDeleteProgram", 0
                        db      "glCreateShader", 0
                        db      "glShaderSource", 0
                        db      "glCompileShader", 0
                        db      "glGetShaderiv", 0
                        db      "glCreateProgram", 0
                        db      "glAttachShader", 0
                        db      "glLinkProgram", 0
                        db      "glGetProgramiv", 0
                        db      "glGetUniformLocation", 0
                        db      "glUniform1f", 0
                        db      "glUniform2f", 0

                        db      "glGenBuffers", 0
                        db      "glBindBuffer",      0
                        db      "glBufferData",      0
                        db      "glGenVertexArrays", 0
                        db      "glBindVertexArray", 0
                        db      "glVertexAttribPointer", 0
                        db      "glEnableVertexAttribArray", 0

                        db      0 

                        GL_DEPTH_ATTACHMENT             = 0x8D00
			GL_FRAMEBUFFER                  = 0x8D40
                        GL_VERTEX_SHADER                = 0x8B31
                        GL_FRAGMENT_SHADER              = 0x8B30
                        GL_COMPILE_STATUS               = 0x8B81
                        GL_LINK_STATUS                  = 0x8B82

                        GL_ARRAY_BUFFER                 = 0x8892
                        GL_ELEMENT_ARRAY_BUFFER         = 0x8893
                        
                        
                        GL_STATIC_DRAW                  = 0x88E4
                        GL_STATIC_READ                  = 0x88E5
                        GL_STATIC_COPY                  = 0x88E6
                        GL_DYNAMIC_DRAW                 = 0x88E8
                        GL_DYNAMIC_READ                 = 0x88E9
                        GL_DYNAMIC_COPY                 = 0x88EA