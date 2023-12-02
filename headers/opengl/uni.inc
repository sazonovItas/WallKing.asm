        
        ; Uni for shaders
        ; FOR ALL SHADERS
        ; Matrices
        uniProjName             db              "proj", 0
        uniViewName             db              "view", 0
        uniModelName            db              "model", 0

        ; BLOCK SHADER
        ; Texture
        uniTex0Name             db              "tex0", 0

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
        uniPLConstantName       db              "pointLights[0].constant", 0
        uniPLLinearName         db              "pointLights[0].linear", 0
        uniPLQuadraticName      db              "pointLights[0].quadratic", 0
        uniPLAmbientName        db              "pointLights[0].ambient", 0
        uniPLDiffuseName        db              "pointLights[0].diffuse", 0
        uniPLSpecularName       db              "pointLights[0].specular", 0

        ; TODO: DELETE THIS STUFF
        uniLightPosName         db      "lightPos", 0

        ; LIGHT SHADER
        uniLightColorName       db      "lightColor", 0