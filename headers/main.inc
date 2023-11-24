format  PE GUI 5.0

stack   0x100000

entry   WinMain

        include         "include/win32ax.inc"

        include         "include/api/kernel32.inc"
        include         "include/api/wsock32.inc"
        include         "include/api/user32.inc"
        include         "include/api/gdi32.inc"
        include         "include/api/opengl.inc"
        include         "include/api/glut.inc"

        ; Internal functions
        include         "memory.inc"
        include         "string.inc"
        include         "vector.inc"
        include         "easing.inc"
        include         "list.inc"

        include         "client.inc"
        include         "mesh.inc"
        include         "matrix.inc"
        include         "color.inc"
        include         "glext.inc"
        include         "shader.inc"
        include         "VAO.inc"
        include         "VBO.inc"
        include         "EBO.inc"
        include         "texture.inc"
        include         "camera.inc"
        include         "physics.inc"
        include         "player.inc"
        include         "collision.inc"

        include         "objects.inc"

macro JumpIf value, label
{
        cmp     eax, value
        je      label
}

        true            =       1
        false           =       0

        INFINITY        =       -1

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
                wsock32,        "WSOCK32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                ws2_32,         "ws2_32.DLL",\
                AdvApi32,       "AdvApi32.DLL",\
                iphlpapi,       "iphlpapi.DLL"

        import iphlpapi,\
                GetIpAddrTable , 'GetIpAddrTable'
                ; THIS STRUCTURES GOT FROM INTERNET. THEY MAY BE CHANGED!

        struct MIB_IPADDRROW
               dwAddr           dd              ?
               dwIndex          dd              ?
               dwMask           dd              ?
               dwBCastAddr      dd              ?
               dwReasmSize      dd              ?
               unused1          dw              ?
               wType            dw              ?
        ends

        struct MIB_IPADDRTABLE
               dwNumEntries     dd              ?
               table            MIB_IPADDRROW   ?
        ends

end data