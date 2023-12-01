        
        ; parametrs for the camera
        fovY                    dd              90.0 
        zNear                   dd              0.001
        zFar                    dd              10000.0

        ProjMatrix              Matrix4x4       ?
        ViewMatrix              Matrix4x4       ?
        ModelMatrix             Matrix4x4       ?

        ; Do not touch this 
        time            dd      ?
        debugTime       dd      ?
        radian          dd      57.32
        pi4             dd      90.0

        ; Description of vertices: size of vertice and amount of vertices
        sizeVertice     =       4 * 11
        countVertices   =       24

        ; Description of indices: size of index  and amount of indices
        sizeIndex       =       4
        countIndices    =       3 * 12  

        ; Offset of each attribute
        offsetVertice   =       0
        offsetColor     =       3 * 4
        offsetTexture   =       6 * 4
        offsetNormal    =       8 * 4

;                               VerticeCoordinate               Color                   Textcoordinates          Normal coordinates
vertices        GLfloat         -0.5, -0.5,  0.5,               1.0, 0.0, 0.0,		1.0, 0.0,		 0.0, -1.0, 0.0,\ ; Bottom side
	                        -0.5, -0.5, -0.5,  		0.0, 1.0, 0.0,		1.0, 1.0,		 0.0, -1.0, 0.0,\
	                         0.5, -0.5, -0.5,               0.0, 0.0, 1.0,		0.0, 1.0,		 0.0, -1.0, 0.0,\
	                         0.5, -0.5,  0.5, 		1.0, 1.0, 1.0,		0.0, 0.0,	         0.0, -1.0, 0.0,\ 
                                                                                                                                \
                                -0.5,  0.5,  0.5,               1.0, 0.0, 0.0,		1.0, 0.0,		 0.0,  1.0, 0.0,\ ; Top side
	                        -0.5,  0.5, -0.5,  		0.0, 1.0, 0.0,		1.0, 1.0,		 0.0,  1.0, 0.0,\
	                         0.5,  0.5, -0.5,               0.0, 0.0, 1.0,		0.0, 1.0,		 0.0,  1.0, 0.0,\
	                         0.5,  0.5,  0.5, 		1.0, 1.0, 1.0,		0.0, 0.0,	         0.0,  1.0, 0.0,\                                                                                               
                                                                                                                                \
                                -0.5, -0.5,  0.5,               1.0, 0.0, 0.0,		1.0, 0.0,		 0.0,  0.0, 1.0,\ ; Front side
	                        -0.5,  0.5,  0.5,  		0.0, 1.0, 0.0,		1.0, 1.0,		 0.0,  0.0, 1.0,\
	                         0.5,  0.5,  0.5,               0.0, 0.0, 1.0,		0.0, 1.0,		 0.0,  0.0, 1.0,\
	                         0.5, -0.5,  0.5, 		1.0, 1.0, 1.0,		0.0, 0.0,	         0.0,  0.0, 1.0,\                                                                                               
                                                                                                                                \
                                -0.5, -0.5, -0.5,               1.0, 0.0, 0.0,		1.0, 0.0,		 0.0,  0.0, -1.0,\ ; Backward side
	                        -0.5,  0.5, -0.5,  		0.0, 1.0, 0.0,		1.0, 1.0,		 0.0,  0.0, -1.0,\
	                         0.5,  0.5, -0.5,               0.0, 0.0, 1.0,		0.0, 1.0,		 0.0,  0.0, -1.0,\
	                         0.5, -0.5, -0.5, 		1.0, 1.0, 1.0,		0.0, 0.0,	         0.0,  0.0, -1.0,\                                                                                               
                                                                                                                                \
                                -0.5, -0.5, -0.5,               1.0, 0.0, 0.0,		1.0, 0.0,		-1.0,  0.0, 0.0,\ ; Left side
	                        -0.5,  0.5, -0.5,  		0.0, 1.0, 0.0,		1.0, 1.0,		-1.0,  0.0, 0.0,\
	                        -0.5,  0.5,  0.5,               0.0, 0.0, 1.0,		0.0, 1.0,		-1.0,  0.0, 0.0,\
	                        -0.5, -0.5,  0.5, 		1.0, 1.0, 1.0,		0.0, 0.0,	        -1.0,  0.0, 0.0,\                                                                                               
                                                                                                                                \
                                 0.5, -0.5, -0.5,               1.0, 0.0, 0.0,		1.0, 0.0,		 1.0,  0.0, 0.0,\ ; Right side
	                         0.5,  0.5, -0.5,  		0.0, 1.0, 0.0,		1.0, 1.0,		 1.0,  0.0, 0.0,\
	                         0.5,  0.5,  0.5,               0.0, 0.0, 1.0,		0.0, 1.0,		 1.0,  0.0, 0.0,\
	                         0.5, -0.5,  0.5, 		1.0, 1.0, 1.0,		0.0, 0.0,	         1.0,  0.0, 0.0                                                                                          

indices         GLuint          0, 1, 2,\
	                        0, 2, 3,\
                                4, 5, 6,\
                                4, 6, 7,\
                                8, 9, 10,\
                                8, 10, 11,\
                                12, 13, 14,\
                                12, 14, 15,\
                                16, 17, 18,\
                                16, 18, 19,\
                                20, 21, 22,\
                                20, 22, 23



        ; Description of vertices: size of vertice and amount of vertices
        sizeLightVertice     =       4 * 3
        countLightVertices   =       8 

        ; Description of indices: size of index  and amount of indices
        sizeLightIndex       =       4
        countLightIndices    =       3 * 12 

lightVertices   GLfloat         -0.1, -0.1,  0.1,\
                                -0.1, -0.1, -0.1,\
                                 0.1, -0.1, -0.1,\
                                 0.1, -0.1,  0.1,\
                                -0.1,  0.1,  0.1,\
                                -0.1,  0.1, -0.1,\
                                 0.1,  0.1, -0.1,\
                                 0.1,  0.1,  0.1  

lightIndices    GLuint          0, 1, 2,\
                                0, 2, 3,\
                                0, 4, 7,\
                                0, 7, 3,\
                                3, 7, 6,\
                                3, 6, 2,\
                                2, 6, 5,\
                                2, 5, 1,\
                                1, 5, 4,\
                                1, 4, 0,\
                                4, 5, 6,\
                                4, 6, 7
