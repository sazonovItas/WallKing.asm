        include "../headers/main.inc"

        include         "init.asm"
        include         "draw.asm"
        include         "shader.asm"
        include         "VAO.asm"
        include         "VBO.asm"
        include         "EBO.asm"
        include         "texture.asm"
        include         "camera.asm"
        include         "collision.asm"
        include         "player.asm"

        ; Include some internal functionality
        include         "internal/memory/mem_funcs.asm"
        include         "internal/files/file.asm"
        include         "internal/memory/glext.asm"
        include         "internal/math/mesh.asm"
        include         "internal/math/vector.asm"
        include         "internal/math/matrix.asm"
        include         "internal/math/easing_funcs.asm"
        
        className       db      "OpenGLDemo", 0
        clientRect      RECT
        time            dd      ?
        hdc             dd      ?
        angle           dd      0.0
        step            dd      1.0
        cameraStep      dd      0.2
        radian          dd      57.32
        pi4             dd      90.0

        fovY            dd      90.0 
        zNear           dd      0.001
        zFar            dd      1000.0

        cameraPosition  Vector3         2.0, 10.0, 0.0
        targetPosition  Vector3         0.0, 0.0, 2.0
        upVector        Vector3         0.0, 1.0, 0.0

        light0Diffuse   ColorRGBA       1.0, 1.0, 1.0, 1.0
        light0Ambient   ColorRGBA       1.0, 0.0, 0.0, 1.0
        light0Position  Vector4         2.0, 3.0, 1.0, 1.0

        light1Diffuse   ColorRGBA       1.0, 0.8, 0.2, 1.0
        light1Position  Vector4         1.0, 1.0, 1.0, 0.0

        lightColor      ColorRGBA       1.0, 1.0, 1.0, 1.0
        lightPos        Vector3         1.0, 1.0, 1.0

        uniLightColorName       db      "lightColor", 0
        uniLightPosName         db      "lightPos", 0
        uniCamPosName           db      "camPos", 0


        stringOut               db              "Hello, World!", 0

        fileBoxTexture          db              "resources/textures/container2.bmp", 0
        fileLightTexture        db              "resources/textures/test.bmp", 0
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
        lightShader             Shader          ?
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
        mainPlayer              Player 
        lastFrame               dd              ?
        deltaTime               dd              ?

proc WinMain

        locals
                msg     MSG
        endl

        finit
        xor     ebx, ebx
        stdcall Init

        invoke  GetTickCount
        mov     [time], eax 
        mov     [lastFrame], eax

        lea     esi, [msg]

.cycle:
        invoke  GetMessage, esi, ebx, ebx, ebx
        invoke  DispatchMessage, esi
        jmp     .cycle

endp

proc WindowProc uses ebx,\
     hWnd, uMsg, wParam, lParam

        locals 
                currentFrame            dd      ?
                deltaTime               dd      ?
        endl


        mov     eax, [uMsg]
        JumpIf  WM_PAINT,       .Paint
        JumpIf  WM_DESTROY,     .Destroy
        JumpIf  WM_KEYDOWN,     .KeysManipulateDown
        JumpIf  WM_KEYUP,       .KeysManipulateUp
        JumpIf  WM_MOUSEMOVE,   .MouseManipulate

        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return

.Paint:

        stdcall Draw.Scene

        invoke  SwapBuffers, [hdc]
        
        jmp     .ReturnZero

.KeysManipulateDown:
        cmp     [wParam], VK_ESCAPE
        je      .Destroy


        cmp     [wParam], PL_JUMP
        jne     @F

        mov     [pl_jump], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_FORWARD
        jne     @F

        mov     [pl_forward], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_BACKWARD
        jne     @F

        mov     [pl_backward], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_LEFT
        jne     @F

        mov     [pl_left], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_RIGHT
        jne     @F

        mov     [pl_right], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_SLIDE_JUMP
        jne     @F

        mov     [pl_slide_jump], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_NORMAL_GRAV
        jne     @F

        mov     [pl_normal_grav], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_ENHANCE_GRAV
        jne     @F

        mov     [pl_enhance_grav], true
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_WEAK_GRAV
        jne     @F

        mov     [pl_weak_grav], true
        jmp     .SkipDown

        @@:

        .SkipDown:
                jmp     .ReturnZero

.KeysManipulateUp:

        cmp     [wParam], PL_JUMP
        jne     @F

        mov     [pl_jump], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_FORWARD
        jne     @F

        mov     [pl_forward], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_BACKWARD
        jne     @F

        mov     [pl_backward], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_LEFT
        jne     @F

        mov     [pl_left], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_RIGHT
        jne     @F

        mov     [pl_right], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_SLIDE_JUMP
        jne     @F

        mov     [pl_slide_jump], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_NORMAL_GRAV
        jne     @F

        mov     [pl_normal_grav], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_ENHANCE_GRAV
        jne     @F

        mov     [pl_enhance_grav], false
        jmp     .SkipDown

        @@:

        cmp     [wParam], PL_WEAK_GRAV
        jne     @F

        mov     [pl_weak_grav], false
        jmp     .SkipDown

        @@:

        .SkipUp:
                jmp     .ReturnZero

.MouseManipulate:

        stdcall Player.InputsMouse, mainPlayer, [wParam], [lParam]

        .SkipMouse:
                jmp     .ReturnZero

.Destroy:
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp