        
        ; Uni for shaders
        ; FOR ALL SHADERS
        ; Matrices
        uniProjName             db              "proj", 0
        uniViewName             db              "view", 0
        uniModelName            db              "model", 0

        ; BLOCK SHADER
        ; Texture
        uniTex0Name             db              "tex0", 0
        uniTex1Name             db              "tex1", 0
        uniTex2Name             db              "tex2", 0
        uniTex3Name             db              "tex3", 0

        ; CamPos
        uniCamPosName           db              "camPos", 0

        ; Material
        uniMatAmbientName       db              "material.ambient", 0
        uniMatDiffuseName       db              "material.diffuse", 0
        uniMatSpecularName      db              "material.specular", 0
        uniMatShininessName     db              "material.shininess", 0

        ; PointLight            
        pointLightIndexOffset   =               12
        uniPLCnt                db              "CntPointLights", 0
        uniPLPositionName       db              "pointLights[0].position", 0
        uniPLColorName          db              "pointLights[0].color", 0
        uniPLConstantName       db              "pointLights[0].constant", 0
        uniPLLinearName         db              "pointLights[0].linear", 0
        uniPLQuadraticName      db              "pointLights[0].quadratic", 0
        uniPLAmbientName        db              "pointLights[0].ambient", 0
        uniPLDiffuseName        db              "pointLights[0].diffuse", 0
        uniPLSpecularName       db              "pointLights[0].specular", 0

        ; LIGHT SHADER
        uniLightPosName         db              "lightPos", 0
        uniLightColorName       db              "lightColor", 0

        ; SHADOW SHADER


        ; INTERFACE SHADER
        uniTimeName             db              "time", 0
        uniStateName            db              "state", 0