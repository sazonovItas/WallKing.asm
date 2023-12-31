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
        include         "game.asm"
        include         "levels.asm"

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
        include         "internal/string/string_funcs.asm"
        include         "internal/debug.asm"
        
        mainPlayer              dd              ? 
        lastFrame               dd              ?

        user32Str               db              "user32.dll", 0
        SetProcessDPIAware      dd              ?
        SetProcessDPIAwareFunc  db              "SetProcessDPIAware", 0

proc WinMain

        locals
                msg             MSG             ?
                thread          dd              ? 
                threadId        dd              ?
        endl

        invoke  GetModuleHandleA, user32Str
        invoke  GetProcAddress, eax, SetProcessDPIAwareFunc
        stdcall eax

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

        inc     [fpsCnt]

        stdcall Game.Game, [mainPlayer]
        invoke  SwapBuffers, [hdc]
        jmp     .ReturnZero

.KeysManipulateDown:
        cmp     [wParam], VK_ESCAPE
        je      .Destroy

        stdcall Player.KeyDown, [mainPlayer], [wParam], [lParam]

        jmp     .ReturnZero

.KeysManipulateUp:

        stdcall Player.KeyUp, [mainPlayer], [wParam], [lParam]
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