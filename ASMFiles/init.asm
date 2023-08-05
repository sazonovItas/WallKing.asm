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

    ;invoke  gluPerspective, double FOV, double 2.0, double Z_NEAR, double Z_FAR
    stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar]

    invoke  glEnable, GL_DEPTH_TEST
    invoke  glEnable, GL_LIGHTING
    invoke  glEnable, GL_TEXTURE_2D
    invoke  glShadeModel, GL_SMOOTH
    invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

    invoke  glGenTextures, 1, texture
    invoke  glBindTexture, GL_TEXTURE_2D, [texture]

    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    invoke  glTexParameteri, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    stdcall File.LoadContent, fileName
    invoke  glTexImage2D, GL_TEXTURE_2D, ebx,\ 
                    GL_RGB8, 256, 256, ebx, GL_BGR,\
                    GL_UNSIGNED_BYTE, eax
    
    stdcall Mesh.Generate, cubeMesh, drawCubeMesh, true
    stdcall Mesh.Generate, planeMesh, drawPlaneMesh, true
    
    stdcall Mesh.CalculateNormals, drawCubeMesh
    stdcall Mesh.CalculateNormals, drawPlaneMesh

    invoke  glEnable, GL_LIGHT0
    invoke  glEnable, GL_LIGHT1
    invoke  glLightfv, GL_LIGHT0, GL_DIFFUSE, light0Diffuse
    invoke  glLightfv, GL_LIGHT1, GL_DIFFUSE, light1Diffuse

    ret
endp