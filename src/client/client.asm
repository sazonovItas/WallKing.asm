proc Client.Start uses edi esi ebx,\
    data

    locals 
        text            db              "WallKing", 0
        name            db              "Alex", 0
        ; server_ip       db              "192.168.1.255", 0
        ; server_ip       db              "192.168.115.255", 0
        server_ip       db              "127.0.0.1", 0
        iResult         dd              ?
        wsaData         WSADATA         ?
        SendSocket      dd              -1
        SendAddr        sockaddr_in     ?
        SendAddrLen     dd              ?
        RecvAddr        sockaddr_in     ?
        RecvAddrLen     dd              ?
        ServerAddr      sockaddr_in     ?
        ServerAddrLen   dd              ?
        buf             db              256 dup(0)
        recvBuf         db              256 dup(0)
    endl

    lea     edi, [buf]
    mov     dword [edi], 256
    add     edi, 4

    lea     ebx, [text]
    stdcall memcpy, edi, ebx, 8
    add     edi, 8

    mov     dword [edi], 1
    add     edi, 4

    lea     ebx, [name]
    stdcall memcpy, edi, ebx, 4

    lea     ebx, [wsaData]
    invoke  WSAStartup, 0x0101, ebx

    invoke  socket, AF_INET, SOCK_DGRAM, IPPROTO_UDP
    mov     [SendSocket], eax

    lea     edi, [RecvAddr]
    mov     [edi + sockaddr_in.sin_family], AF_INET

    invoke  htons, 8829
    mov     [edi + sockaddr_in.sin_port], ax

    lea     ebx, [server_ip]
    invoke  inet_addr, ebx
    mov     [edi + sockaddr_in.sin_addr], eax

    lea     edi, [buf]
    lea     ebx, [RecvAddr]
    invoke  sendto, [SendSocket], edi, 256, 0, ebx, sizeof.sockaddr_in

    lea     edi, [recvBuf]
    lea     esi, [ServerAddr]
    lea     ebx, [ServerAddrLen]
    mov     dword [ebx], sizeof.sockaddr_in
    invoke  recvfrom, [SendSocket], edi, 256, 0, esi, ebx
    cmp     eax, -1
    je     .Ret

    .cycle:

        lea     edi, [buf]
        add     edi, 12
        mov     dword [edi], 0
        add     edi, 4
        mov     dword [edi], 1000
        add     edi, 4

        lea     edi, [buf]
        add     edi, 20
        mov     esi, mainPlayer

        ; Copy Position
        push    esi
        add     esi, Player.Position
        stdcall Vector3.Copy, edi, esi
        pop     esi
        add     edi, sizeof.Vector3

        ; Copy angles
        push    esi
        add     esi, Player.x_angle
        stdcall Vector3.Copy, edi, esi
        pop     esi
        add     edi, sizeof.Vector3

        push    esi
        add     esi, Player.sizeBlockDraw
        mov     edx, dword [esi]
        mov     dword [edi], edx
        mov     dword [edi + 4], edx
        mov     dword [edi + 8], edx
        pop     esi
        add     edi, sizeof.Vector3

        mov     dword [edi], 8

        lea     edi, [buf]
        lea     ebx, [ServerAddr]
        invoke  sendto, [SendSocket], edi, 256, 0, ebx, sizeof.sockaddr_in
        cmp     eax, -1
        je      .cycle


        lea     edi, [recvBuf]
        lea     esi, [ServerAddr]
        lea     ebx, [ServerAddrLen]
        mov     dword [ebx], sizeof.sockaddr_in
        invoke  recvfrom, [SendSocket], edi, 256, 0, esi, ebx
        cmp     eax, -1
        je     .cycle

        .waitForMutex:

        invoke  WaitForSingleObject, [drawMutex], -1

        cmp     eax, 0
        jne     .waitForMutex

        stdcall memcpy, [data], edi, 256
        invoke  ReleaseMutex, [drawMutex]

        jmp     .cycle
    
.Ret:
    ret
endp
