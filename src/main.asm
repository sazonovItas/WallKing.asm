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

        ; Include client
        include         "client/client.asm"

        ; Include some internal functionality
        include         "internal/math/number.asm"
        include         "internal/memory/mem_funcs.asm"
        include         "internal/files/file.asm"
        include         "internal/memory/glext.asm"
        include         "internal/math/mesh.asm"
        include         "internal/math/vector.asm"
        include         "internal/math/matrix.asm"
        include         "internal/math/easing_funcs.asm"
        include         "internal/debug.asm"
        
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

        fileBoxTexture          db              "resources/textures/container2.bmp", 0
        filePlayerTex           db              "resources/textures/wall_player.bmp", 0
        fileLightTexture        db              "resources/textures/test.bmp", 0
        blockTexture            Texture         ?
        lightTexture            Texture         ?        
        m_shadowMap             dd              ?
        m_fbo                   dd              ?

        mainPlayer              dd              ? 

        lastFrame               dd              ?
        deltaTime               dd              ?

proc WinMain

        locals
                msg             MSG             ?
                thread          dd              ? 
                threadId        dd              ?
        endl

        finit
        xor     ebx, ebx
        stdcall Init

        invoke  GetTickCount
        mov     [time], eax 
        mov     [debugTime], eax
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

        ; Keys
        JumpIf  WM_KEYDOWN,     .KeysManipulateDown
        JumpIf  WM_KEYUP,       .KeysManipulateUp

        ; Mouse
        JumpIf  WM_MOUSEMOVE,   .MouseManipulate
        JumpIf  WM_MOUSEWHEEL,  .MouseManipulate
        JumpIf  WM_RBUTTONDOWN, .MouseManipulate
        JumpIf  WM_RBUTTONUP,   .MouseManipulate

        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return

.Paint:

        stdcall Draw.Scene

        invoke  SwapBuffers, [hdc]
        
        jmp     .ReturnZero

.KeysManipulateDown:
        cmp     [wParam], VK_ESCAPE
        je      .Destroy

        stdcall Player.KeyDown, [wParam], [lParam]

        jmp     .ReturnZero

.KeysManipulateUp:

        stdcall Player.KeyUp, [wParam], [lParam]
        stdcall Client.KeyUp, [wParam], [lParam]

        jmp     .ReturnZero

.MouseManipulate:

        stdcall Player.InputsMouse, [mainPlayer], [uMsg], [wParam], [lParam]

        .SkipMouse:
                jmp     .ReturnZero

.Destroy:
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp