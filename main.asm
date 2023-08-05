        include "main.inc"

        className       db      "OpenGLDemo", 0
        clientRect      RECT
        hHeap           dd      ?
        hdcBack         dd      ?
        time            dd      ?
        hdc             dd      ?
        angle           dd      0.0
        step            dd      3.14
        radian          dd      57.32

        cubeMesh        PackedMesh      cubeVertices, cubeColors, cubeIndices, CUBE_TRIANGLES_COUNT
        drawCubeMesh    Mesh            NULL, NULL, NULL, NULL
        planeMesh       PackedMesh      planeVertices, planeColors, planeIndices, PLANE_TRIANGLES_COUNT
        drawPlaneMesh   Mesh            NULL, NULL, NULL, NULL

        fovY            dd      60.0
        zNear           dd      0.001
        zFar            dd      1000.0

        cameraPosition  Vector3 5.0, 5.0, 5.0
        targetPosition  Vector3 0.0, 0.0, 0.0
        upVector        Vector3 0.0, 1.0, 0.0

        light0Diffuse   ColorRGBA       0.0, 0.0, 1.0, 1.0
        light0Ambient   ColorRGBA       1.0, 0.0, 0.0, 1.0
        light0Position  Vector4         10.0, 10.0, 0.0, 1.0

        light1Diffuse   ColorRGBA       0.0, 1.0, 0.0, 1.0
        light1Position  Vector4         2.0, 4.0, 3.0, 1.0

        include         "ASMFiles/init.asm"
        include         "ASMFiles/mesh.asm"
        include         "ASMFiles/vector.asm"
        include         "ASMFiles/matrix.asm"
        include         "ASMFiles/draw.asm"

        fileTexture     file    "texture.bmp"
        texture         dd      ?

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
        stdcall Draw
        jmp     .ReturnZero
.KeyDown:
        cmp     [wParam], VK_ESCAPE
        jne     .ReturnZero

.Destroy:
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp