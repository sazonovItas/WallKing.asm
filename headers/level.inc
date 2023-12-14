struct Level 
    FileName            dd          ?
    sizeBlocksMap       dd          ?
    pBlocksMap          dd          ?
    sizeLightsMap       dd          ?
    pLightsMap          dd          ?
    spawnPosition       Vector3     ?
ends

struct Levels
    curLevel            dd          ?
    sizeLevels          dd          ?
    arrLevels           dd          ?
ends

    TestLevel       Level    level1File, 23, blocksMapTry, 10, lightsMapTry, <4.0, 200.0, 4.0> 


    level1File              db              "resources/levels/level1.bin", 0
    level2File              db              "resources/levels/level2.bin", 0
    level3File              db              "resources/levels/level3.bin", 0

        sizeLight                       =       72
        posLightOffset                  =       0   
        colorLightOffset                =       12
        constantLightOffset             =       24            
        linearLightOffset               =       28            
        quadraticLightOffset            =       32            
        ambientLightOffset              =       36
        diffuseLightOffset              =       48
        specularLightOffset             =       60

        sizeBlock               =       56
        scaleOffset             =       0     
        rotateOffset            =       12
        translateOffset         =       24
        texOffset               =       36
        ambientOffset           =       40
        diffuseOffset           =       44
        specularOffset          =       48
        shininessOffset         =       52

sizeLightsMapTry                dd      10

;                               // position             // Color                // constant, linear, quadric    // ambient              // diffuse              // specular
lightsMapTry:
               GLfloat          1.0, 3.0, 1.0,          1.0, 1.0, 1.0,          1.0, 0.09, 0.032,               0.2, 0.2, 0.2,       1.0, 1.0, 1.0,         0.9, 0.9, 0.9  
               GLfloat          -10.0, 8.0, 1.0,        1.0, 1.0, 1.0,          1.0, 0.09, 0.032,               0.4, 0.2, 0.5,       0.5, 0.5, 0.5,         0.6, 0.6, 0.6  
               GLfloat          10.0, 20.0, 1.0,        0.8, 1.6, 1.2,          1.0, 0.09, 0.032,               0.2, 0.2, 0.2,       1.0, 1.0, 1.0,         0.9, 0.9, 0.9  
               GLfloat          0.0, 30.0, -12.0,       1.0, 0.1, 0.1,          1.0, 0.09, 0.032,               0.4, 0.2, 0.5,       0.5, 0.5, 0.5,         0.6, 0.6, 0.6  
               GLfloat          1.0, 8.0, -9.0,         0.0, 1.0, 0.0,          1.0, 0.09, 0.032,               0.2, 0.2, 0.2,       1.0, 1.0, 1.0,         0.9, 0.9, 0.9  
               GLfloat          -15.0, 10.0, 1.0,       0.0, 0.0, 1.0,          1.0, 0.09, 0.032,               0.4, 0.2, 0.5,       0.5, 0.5, 0.5,         0.6, 0.6, 0.6  
               GLfloat          -10.0, 10.0, -10.0,     0.8, 2.6, 1.2,          1.0, 0.09, 0.032,               0.2, 0.2, 0.2,       1.0, 1.0, 1.0,         0.9, 0.9, 0.9  
               GLfloat          5.0, 22.0, -12.0,       3.0, 0.1, 0.1,          1.0, 0.09, 0.032,               0.4, 0.2, 0.5,       0.5, 0.5, 0.5,         0.6, 0.6, 0.6  
               GLfloat          -12.0, 15.0, 1.0,       0.8, 1.6, 2.2,          1.0, 0.09, 0.032,               0.2, 0.2, 0.2,       1.0, 1.0, 1.0,         0.9, 0.9, 0.9  
               GLfloat          19.0, 13.0, -12.0,      1.0, 1.1, 0.1,          1.0, 0.09, 0.032,               0.4, 0.2, 0.5,       0.5, 0.5, 0.5,         0.6, 0.6, 0.6  



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
