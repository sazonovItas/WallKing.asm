struct Shader 
    ID              GLuint      ?
ends

        ; light shaders
        lightFragmentFile       db              "resources/shaders/light.frag", 0
        lightVertexFile         db              "resources/shaders/light.vert", 0
        lightShader             Shader          ?


        ; block shaders
        blockFragmentFile       db              "resources/shaders/default.frag", 0
        blockVertexFile         db              "resources/shaders/default.vert", 0
        blockShader             Shader          ?
