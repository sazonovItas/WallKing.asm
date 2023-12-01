        
        ; Uni for shaders
        ; block shaders
        ; Matrices
        uniProjName             db              "proj", 0
        uniViewName             db              "view", 0
        uniModelName            db              "model", 0
        uniBlockModel           GLuint          ?
        uniBlockView            GLuint          ?
        uniBlockProj            GLuint          ?

        ; Texture
        uniTex0Name             db              "tex0", 0
        uniBlockTex0            GLuint          ?     

        ; CamPos
        uniCamPosName           db              "camPos", 0
        uniCamPos               GLuint          ?

        ; PointLight            
        