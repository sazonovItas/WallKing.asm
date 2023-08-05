format  PE GUI 5.0
entry   WinMain

        include         "include/win32ax.inc"

        include         "include/api/kernel32.inc"
        include         "include/api/user32.inc"
        include         "include/api/gdi32.inc"
        include         "include/api/opengl.inc"

        include         "INCFiles/mesh.inc"
        include         "INCFiles/vector.inc"
        include         "INCFiles/matrix.inc"
        include         "INCFiles/color.inc"

macro JumpIf value, label
{
        cmp     eax, value
        je      label
}

        include         "INCFiles/objects.inc"

        true            =       1
        false           =       0

        COLOR_DEPTH     =       24
        PFD_FLAGS       =       PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW
        WINDOW_STYLE    =       WS_VISIBLE or WS_MAXIMIZE or WS_POPUP
        FOV             =       60.0
        Z_NEAR          =       0.0001
        Z_FAR           =       10000.0

        wndClass        WNDCLASS                0, WindowProc, 0, 0, 0, 0, 0, 0, 0, className
        pfd             PIXELFORMATDESCRIPTOR   sizeof.PIXELFORMATDESCRIPTOR, 1, PFD_FLAGS, PFD_TYPE_RGBA, COLOR_DEPTH,\
                                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
                                                COLOR_DEPTH, 0, 0, PFD_MAIN_PLANE, 0, PFD_MAIN_PLANE

data import

        library kernel32,       "KERNEL32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                glu32,          "GLU32.DLL"

end data