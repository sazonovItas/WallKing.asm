proc Init uses esi

    locals
            hMainWindow     dd      ?
            aspect          dd      ? 
    endl 

    invoke  GetProcessHeap
    mov     [hHeap], eax

    invoke  RegisterClass, wndClass
    invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                    ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx 
    mov     [hMainWindow], eax   

    invoke  GetClientRect, eax, clientRect
    invoke  ShowCursor, ebx 
    invoke  GetTickCount
    mov     [time], eax 

    invoke  GetDC, [hMainWindow]
    mov     [hdc], eax 

    invoke  ChoosePixelFormat, [hdc], pfd 
    invoke  SetPixelFormat, [hdc], eax, pfd 

    invoke  wglCreateContext, [hdc]
    invoke  wglMakeCurrent, [hdc], eax 

    invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]

    fild    [clientRect.right]      ; width
    fidiv   [clientRect.bottom]     ; width / height
    fstp    [aspect]                ;

    invoke  glMatrixMode, GL_PROJECTION
    invoke  glLoadIdentity

    stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar]

    invoke  glEnable, GL_DEPTH_TEST
    invoke  glShadeModel, GL_SMOOTH
    invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

    stdcall GenerateMesh, cubeMesh, mesh, true

    ret
endp