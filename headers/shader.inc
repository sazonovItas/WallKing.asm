struct Shader 
    ID              GLuint      ?
ends

        ; light shader
        lightFragmentFile       db              "resources/shaders/light.frag", 0
        lightVertexFile         db              "resources/shaders/light.vert", 0
        ligthShader             Shader          ?


        ; block shader
        blockFragmentFile       db              "resources/shaders/default.frag", 0
        blockVertexFile         db              "resources/shaders/default.vert", 0
        blockShader             Shader          ?

        ; shadow shader
        shadowFragmentFile      db              "resources/shaders/shadow.frag", 0
        shadowVertexFile        db              "resources/shaders/shadow.vert", 0
        shadowShader            Shader          ?

        depthMap                dd              ?
        depthMapFBO             dd              ?
        SHADOW_WIDTH            =               1024
        SHADOW_HEIGHT           =               1024