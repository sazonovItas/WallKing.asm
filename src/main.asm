        include "../headers/main.inc"

        include         "init.asm"
        include         "mesh.asm"
        include         "vector.asm"
        include         "matrix.asm"
        include         "draw.asm"
        include         "file.asm"
        include         "glext.asm"
        include         "shader.asm"
        include         "VAO.asm"
        include         "VBO.asm"
        include         "EBO.asm"
        include         "texture.asm"
        include         "camera.asm"
        
        className       db      "OpenGLDemo", 0
        clientRect      RECT
        hHeap           dd      ?
        hdcBack         dd      ?
        time            dd      ?
        hdc             dd      ?
        angle           dd      0.0
        step            dd      1.0
        cameraStep      dd      0.2
        radian          dd      57.32

        cubeMesh        PackedMesh      cubeVertices, cubeColors, cubeIndices, CUBE_TRIANGLES_COUNT
        drawCubeMesh    Mesh            NULL, NULL, NULL, NULL, NULL, cubeTextures
        planeMesh       PackedMesh      planeVertices, planeColors, planeIndices, PLANE_TRIANGLES_COUNT
        drawPlaneMesh   Mesh            NULL, NULL, NULL, NULL, NULL, planeTextures

        fovY            dd      60.0
        zNear           dd      0.001
        zFar            dd      1000.0

        cameraPosition  Vector3         0.0, 0.0, 5.0
        targetPosition  Vector3         0.0, 0.0, 0.0
        upVector        Vector3         0.0, 1.0, 0.0

        light0Diffuse   ColorRGBA       1.0, 1.0, 1.0, 1.0
        light0Ambient   ColorRGBA       1.0, 0.0, 0.0, 1.0
        light0Position  Vector4         2.0, 3.0, 1.0, 1.0

        light1Diffuse   ColorRGBA       1.0, 0.8, 0.2, 1.0
        light1Position  Vector4         2.0, 1.0, 1.0, 0.5


        stringOut               db              "Hello, World!", 0

        fileBoxTexture          db              "resources/textures/m_a_brickwall02.bmp", 0
        fileLightTexture        db              "resources/textures/m_c_pattern09.bmp", 0
        blockTexture            Texture         ?
        lightTexture            Texture         ?        
        m_shadowMap             dd              ?
        m_fbo                   dd              ?

        fragmentShader          GLuint          0
        program                 GLint           0

        timeLocation            GLint           0
        sizeLocation            GLint           0

        fragmentShaderFile      db              "resources/shaders/default.frag", 0
        vertexShaderFile        db              "resources/shaders/default.vert", 0
        timeName                db              "time", 0
        sizeName                db              "size", 0

        VAO1                    VAO             
        VBO1                    VBO             
        EBO1                    EBO             

        exampleShader           Shader          ?
        ProjectionMatrix        Matrix4x4       ?
        ViewMatrix              Matrix4x4       ?
        ModelMatrix             Matrix4x4       ?

        uniScale.ID             GLuint          ?
        uniScaleName            db              "scale", 0
        scale                   GLfloat         1.0 

        uniTex0.ID              GLuint          ?
        uniTex0Name             db              "tex0", 0

        uniModel                GLuint          ?
        uniModelName            db              "model", 0

        uniView                 GLuint          ?
        uniViewName             db              "view", 0

        uniProj                 GLuint          ?
        uniProjName             db              "proj", 0

        freeCamera              Camera 

proc WinMain

        locals
                msg     MSG
        endl

        xor     ebx, ebx

        stdcall Init

        lea     esi, [msg]

.cycle:
        invoke  GetMessage, esi, ebx, ebx, ebx
        invoke  DispatchMessage, esi
        jmp     .cycle

endp

proc WindowProc uses ebx,\
     hWnd, uMsg, wParam, lParam

        xor     ebx, ebx

        mov     eax, [uMsg]
        JumpIf  WM_PAINT,       .Paint
        JumpIf  WM_DESTROY,     .Destroy
        JumpIf  WM_KEYDOWN,     .KeyDown

        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return

.Paint:

        stdcall Draw.Scene

        invoke  SwapBuffers, [hdc]
        
        jmp     .ReturnZero
.KeyDown:
        cmp     [wParam], VK_ESCAPE
        je      .Destroy

        cmp     [wParam], VK_DOWN 
        jne     @F     

        fld     [cameraPosition.z]
        fsub    [cameraStep]
        fstp    [cameraPosition.z]

        ; fld     [targetPosition.z]
        ; fsub    [cameraStep]
        ; fstp    [targetPosition.z]
        jmp     .MegJump

        @@:

        cmp     [wParam], VK_UP 
        jne     @F

        fld     [cameraPosition.z]
        fadd    [cameraStep]
        fstp    [cameraPosition.z]

        ; fld     [targetPosition.z]
        ; fadd    [cameraStep]
        ; fstp    [targetPosition.z]
        jmp     .MegJump

        @@:

        cmp     [wParam], VK_LEFT
        jne     @F     

        fld     [cameraPosition.x]
        fsub    [cameraStep]
        fstp    [cameraPosition.x]

        ; fld     [targetPosition.x]
        ; fsub    [cameraStep]
        ; fstp    [targetPosition.x]
        jmp     .MegJump

        @@:

        cmp     [wParam], VK_RIGHT
        jne     @F

        fld     [cameraPosition.x]
        fadd    [cameraStep]
        fstp    [cameraPosition.x]

        ; fld     [targetPosition.x]
        ; fadd    [cameraStep]
        ; fstp    [targetPosition.x]
        jmp     .MegJump

        @@:

        cmp     [wParam], 'S'
        jne     @F     

        fld     [cameraPosition.y]
        fsub    [cameraStep]
        fstp    [cameraPosition.y]

        ; fld     [targetPosition.y]
        ; fsub    [cameraStep]
        ; fstp    [targetPosition.y]
        jmp     .MegJump

        @@:

        cmp     [wParam], 'W'
        jne     @F

        fld     [cameraPosition.y]
        fadd    [cameraStep]
        fstp    [cameraPosition.y]

        ; fld     [targetPosition.y]
        ; fadd    [cameraStep]
        ; fstp    [targetPosition.y]
        jmp     .MegJump

        @@:

        .MegJump:
                jmp     .ReturnZero

.Destroy:
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp