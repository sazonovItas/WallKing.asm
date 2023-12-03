        sizeBlock               =       56
        scaleOffset             =       0     
        rotateOffset            =       12
        translateOffset         =       24
        texOffset               =       36
        ambientOffset           =       40
        diffuseOffset           =       44
        specularOffset          =       48
        shininessOffset         =       52


        sizeBlocksMapTry        dd      23

;                               // Scale                // Rotate               // Translate            // Texture offset       // ambient offset      // diffuse offset  // specular offset    // shinennes
blocksMapTry:
                GLfloat         1.0, 1.0, 1.0,          0.0, 0.0, 0.0,          0.0, 2.0, 0.0,          0,                      0,                      0,                0,                    32.0      
                GLfloat         1.0, 1.0, 1.0,          0.0, 0.0, 0.0,          1.0, 1.0, 0.0,          0,                      0,                      0,                0,                    32.0
                GLfloat         1.0, 1.0, 1.0,          0.0, 0.0, 0.0,          -1.0, 3.0, 1.0,         0,                      0,                      0,                0,                    32.0
                GLfloat         100.0, 1.0, 100.0,      0.0, 0.0, 0.0,          0.0, 0.0, 0.0,          0,                      0,                      0,                0,                    32.0
                GLfloat         2.0, 1.5, 1.0,          0.0, 0.0, 0.0,          -2.0, 4.0, 0.0,         0,                      0,                      0,                0,                    32.0

                GLfloat         5.0, 2.0, 5.0,          0.0, 0.0, 0.0,          -6.0, 5.0, -4.0,        0,                      0,                      0,                0,                    32.0
                GLfloat         2.0, 1.0, 3.0,          0.0, 0.0, 0.0,          -2.0, 3.0, 8.0,         0,                      0,                      0,                0,                    32.0 
                GLfloat         3.0, 1.0, 3.0,          0.0, 0.0, 0.0,          -6.0, 7.0, 4.0,         0,                      0,                      0,                0,                    32.0 
                GLfloat         4.0, 1.0, 4.0,          0.0, 0.0, 0.0,          -6.0, 5.0, 14.0,        0,                      0,                      0,                0,                    32.0 
                GLfloat         6.0, 1.0, 6.0,          0.0, 0.0, 0.0,          -8.0, 8.0, -13.0,       0,                      0,                     0,                0,                    32.0 

                GLfloat         3.0, 1.0, 3.0,          0.0, 0.0, 0.0,          0.0, 11.0, -15.0,       0,                      0,                     0,                0,                    32.0 
                GLfloat         3.0, 1.0, 5.0,          0.0, 0.0, 0.0,          6.0, 13.0, -13.0,       0,                      0,                     0,                0,                    32.0 
                GLfloat         2.0, 1.0, 2.0,          0.0, 0.0, 0.0,          10.0, 9.0, -10.0,       0,                      0,                     0,                0,                    32.0 
                GLfloat         5.0, 1.0, 3.0,          0.0, 0.0, 0.0,          12.0, 16.0, -7.0,       0,                      0,                     0,                0,                    32.0 
                GLfloat         3.0, 1.0, 4.0,          0.0, 0.0, 0.0,          17.0, 19.0, -9.0,       0,                      0,                     0,                0,                   32.0 

                GLfloat         3.0, 1.0, 8.0,          0.0, 0.0, 0.0,          10.0, 11.0, 0.0,        0,                      0,                     0,                0,                    32.0 
                GLfloat         3.0, 1.0, 3.0,          0.0, 0.0, 0.0,          12.0, 14.0, 5.0,        0,                      0,                     0,                0,                    32.0 
                GLfloat         4.0, 0.5, 4.0,          0.0, 0.0, 0.0,          15.0, 17.0, 9.0,        0,                      0,                     0,                0,                    32.0 
                GLfloat         5.0, 1.0, 6.0,          0.0, 0.0, 0.0,          7.0, 19.0, 14.0,        0,                      0,                     0,                0,                    32.0 
                GLfloat         8.0, 0.5, 8.0,          0.0, 0.0, 0.0,          -4.0, 16.0, 20.0,       0,                      0,                     0,                0,                    32.0 

                GLfloat         8.0, 8.0, 1.0,          0.0, 0.0, 0.0,          4.0, 4.0, -12.0,       0,                      0,                     0,                0,                    32.0 
                GLfloat         8.0, 8.0, 1.0,          0.0, 0.0, 0.0,          4.0, 8.0, -6.0,       0,                      0,                     0,                0,                    32.0 
                GLfloat         8.0, 8.0, 1.0,          0.0, 0.0, 0.0,          4.0, 12.0, 2.0,       0,                      0,                     0,                0,                    32.0 


        sizeLight                       =       60
        posLightOffset                  =       0   
        constantLightOffset             =       12            
        linearLightOffset               =       16            
        quadraticLightOffset            =       20            
        ambientLightOffset              =       24
        diffuseLightOffset              =       36
        specularLightOffset             =       48

        sizeLightsMapTry        dd      2

;                               // position          // constant, linear, quadric    // ambient              // diffuse              // specular
lightsMapTry:
               GLfloat          1.0, 3.0, 1.0,         1.0, 0.09, 0.032,                0.2, 0.2, 0.2,       1.0, 1.0, 1.0,         0.9, 0.9, 0.9  
               GLfloat          -10.0, 8.0, 1.0,        1.0, 0.09, 0.032,               0.4, 0.2, 0.5,       0.5, 0.5, 0.5,         0.6, 0.6, 0.6  
