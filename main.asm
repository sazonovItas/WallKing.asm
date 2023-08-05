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

        cubeMesh        Mesh    cubeVertices, cubeColors, cubeIndices, CUBE_TRIANGLES_COUNT
        mesh            Mesh    ?, ?, ?, ?

        fovY            dd      60.0
        zNear           dd      0.001
        zFar            dd      1000.0

        cameraPosition  Vector3 3.0, 3.0, 3.0
        targetPosition  Vector3 0.0, 0.0, 0.0
        upVector        Vector3 0.0, 1.0, 0.0

        include         "ASMFiles/init.asm"
        include         "ASMFiles/mesh.asm"
        include         "ASMFiles/vector.asm"
        include         "ASMFiles/matrix.asm"

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

proc Draw

        locals
                currentTime     dd      ?
                verticesCount   dd      ?
                coord           dd      3.0
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        cmp     eax, 10
        jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax

        fld     [angle]                 ; angle
        fsub    [step]                  ; angle + step
        fstp    [angle]                 ;

.Skip:
        xor     edx, edx
        mov     eax, [mesh.trianglesCount]
        mov     ecx, 3
        mul     ecx
        mov     [verticesCount], eax

        invoke  glClearColor, 0.1, 0.1, 0.6, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector

        invoke  glRotatef, [angle], ebx, 1.0, ebx

        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [mesh.colors]
        invoke  glDrawArrays, GL_TRIANGLES, ebx, [verticesCount]

        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY

        invoke  SwapBuffers, [hdc]

        ret
endp