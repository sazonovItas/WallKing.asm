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

        include         "level.inc"

        ; Opengl data and useful variables
        include         "opengl/uni.inc"
        include         "opengl/buffers.inc"
        include         "opengl/data.inc"


macro JumpIf value, label
{
        cmp     eax, value
        je      label
}

        className       db      "WallKing", 0
        clientRect      RECT
        hdc             dd      ?
        hglrc           dd      ?
        fontListId      dd      ?
        MAX_CHARS       =       256
        strFont         db      "Arial", 0

        fpsTimer        dd      ?
        fpsCnt          dd      0

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
        piAttribIList   dd      WGL_DRAW_TO_WINDOW_ARB, GL_TRUE,\
                                WGL_SUPPORT_OPENGL_ARB, GL_TRUE,\
                                WGL_DOUBLE_BUFFER_ARB, GL_TRUE,\
                                WGL_COLOR_BITS_ARB, 32,\
                                WGL_RED_BITS_ARB, 8,\
                                WGL_GREEN_BITS_ARB, 8,\
                                WGL_BLUE_BITS_ARB, 8,\
                                WGL_ALPHA_BITS_ARB, 8,\
                                WGL_DEPTH_BITS_ARB, 16,\
                                WGL_STENCIL_BITS_ARB, 8,\
                                WGL_PIXEL_TYPE_ARB, WGL_TYPE_RGBA_ARB,\
                                WGL_SAMPLE_BUFFERS_ARB, GL_TRUE,\
                                WGL_SAMPLES_ARB, 16,\
                                0
        pfAttribFList   dd      0


        ; Text for output help
        Help.DebugInfo          db              "WallKing Debug Info:", 0
        Help.DebugInfoLen       =               $ - Help.DebugInfo
        Help.FPS                db              "fps:", 0
        Help.FPSLen             =               $ - Help.FPS
        Help.FPSCnt             db              8 dup (0)
        Help.FPSCntLen          =               $ - Help.FPSCnt            
        Help.Keymap             db              "Keymap:", 0
        Help.KeymapLen          =               $ - Help.Keymap

        ; Client help
        Help.Ping               db              "ping:", 0
        Help.PingLen            =               $ - Help.Ping
        Help.ClientInfo         db              "Client Info:", 0
        Help.ClientInfoLen      =               $ - Help.ClientInfo
        Help.ClientState        db              "State:", 0
        Help.ClientStateLen     =               $ - Help.ClientState
        Help.ServerIp           db              "Server IP:", 0
        Help.ServerIpLen        =               $ - Help.ServerIp
        Help.ServerPort         db              "Port:", 0
        Help.ServerPortLen      =               $ - Help.ServerPort
        Help.ClientConnectKey   db              CLIENT_CONNECT_KEY, " - connect to the server", 0
        Help.ClientConnectKeyLen =              $ - Help.ClientConnectKey
        Help.ClientDisconnectKey db             CLIENT_DISCONNECT_KEY, " - disconnect from the server", 0
        Help.ClientDisconnectKeyLen =           $ - Help.ClientDisconnectKey
        Help.ClientConPlayers   db              "Connected players:", 0

data import

        library kernel32,       "KERNEL32.DLL",\
                wsock32,        "WSOCK32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                ws2_32,         "ws2_32.DLL",\
                AdvApi32,       "AdvApi32.DLL",\
                iphlpapi,       "iphlpapi.DLL",\
                glu32,          "glu32.DLL"

        import iphlpapi,\
                GetIpAddrTable , 'GetIpAddrTable'
        
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