proc Client.Start uses edi esi ebx,\
    data

    locals 
        text            db              "WallKing", 0
        name            db              "Alex", 0
        server_ip       db              "192.168.1.255", 0
        ; server_ip       db              "192.168.115.255", 0
        ; server_ip       db              "127.0.0.1", 0
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

    stdcall Client.Init

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

    lea     edi, [RecvAddr]
    mov     [edi + sockaddr_in.sin_family], AF_INET

    invoke  htons, 8829
    mov     [edi + sockaddr_in.sin_port], ax

    lea     ebx, [server_ip]
    invoke  inet_addr, ebx
    mov     [edi + sockaddr_in.sin_addr], eax

    lea     edi, [buf]
    lea     ebx, [RecvAddr]
    stdcall Client.Broadcast, edi, 256

    lea     edi, [recvBuf]
    lea     esi, [ServerAddr]
    lea     ebx, [ServerAddrLen]
    mov     dword [ebx], sizeof.sockaddr_in
    invoke  recvfrom, [Client.Socket], edi, 256, 0, esi, ebx
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
        invoke  sendto, [Client.Socket], edi, 256, 0, ebx, sizeof.sockaddr_in
        cmp     eax, -1
        je      .cycle


        lea     edi, [recvBuf]
        lea     esi, [ServerAddr]
        lea     ebx, [ServerAddrLen]
        mov     dword [ebx], sizeof.sockaddr_in
        invoke  recvfrom, [Client.Socket], edi, 256, 0, esi, ebx
        cmp     eax, -1
        je     .cycle

        .waitForMutex:

        invoke  WaitForSingleObject, [Client.MutexDrawBuf], INFINITY

        cmp     eax, 0
        jne     .waitForMutex

        stdcall memcpy, [data], edi, 256
        invoke  ReleaseMutex, [Client.MutexDrawBuf]

        jmp     .cycle
    
.Ret:
    ret
endp

proc Client.Broadcast uses edi esi ebx,\
    pMsg, msgSz

    mov     ecx, dword [Client.IPAddrTableBuf + MIB_IPADDRTABLE.dwNumEntries]
    xor     esi, esi

.loopBroadcast:

    push    ecx

    mov     eax, dword [Client.IPAddrTableBuf + MIB_IPADDRTABLE.table + esi + MIB_IPADDRROW.dwAddr]
    mov     edx, dword [Client.IPAddrTableBuf + MIB_IPADDRTABLE.table + esi + MIB_IPADDRROW.dwMask]
    not     edx
    or      eax, edx

    ; Broadcast address
    mov     [Client.Broadcast_addr + sockaddr_in.sin_addr], eax
    mov     ebx, [pMsg]
    mov     edi, [msgSz]

    ; Send message to address
    invoke  sendto, [Client.Socket], ebx, edi, 0, Client.Broadcast_addr, sizeof.sockaddr_in

    ; Add esi to get new address
    add     esi, sizeof.MIB_IPADDRROW

    pop     ecx
    loop    .loopBroadcast

.Ret:
    ret
endp

proc Client.Init uses ebx edi esi 

    mov     [Client.State], CLIENT_STATE_ONLINE

    ; Init Wsa data
    invoke WSAStartup, 0x0202, Client.wsaData
    test    eax, eax
    jnz     .Error

    ; create socket
    invoke socket, AF_INET, SOCK_DGRAM, IPPROTO_UDP
    cmp     eax, INVALID_SOCKET
    je      .Error

    ; Safe handle in eax just for optimization
    mov     [Client.Socket], eax
    xchg    eax, ebx

    ; Get server port to ax
    mov     ax, SERVER_PORT
    xchg    ah, al

    ;       
    mov     [Client.Broadcast_addr + sockaddr_in.sin_family], AF_INET
    mov     [Client.Broadcast_addr + sockaddr_in.sin_port], ax

    ; Get table of addresses
    invoke  GetIpAddrTable, Client.IPAddrTableBuf, Client.dIPAddrTableSz, NULL
    test    eax, eax
    jnz     .Error

    jmp     .Exit

.Error:
    mov     [Client.State], CLIENT_STATE_OFFLINE
    invoke  closesocket, ebx
    invoke  WSACleanup
    xor     eax, eax
    jmp     .Ret

.Exit:
    mov     [Client.State], CLIENT_STATE_ONLINE
    jmp     .Ret

.Ret:
    ret
endp

proc Client.ThSend 

.Ret:
    ret
endp

proc Client.ThRecv

.Ret:
    ret
endp

proc Client.Destroy

    cmp     [Client.State], CLIENT_STATE_OFFLINE
    je      @F

    mov     [Client.State], CLIENT_STATE_OFFLINE

    mov     [Client.ThStopSd], true
    mov     [Client.ThStopRv], true

    invoke  closesocket, [Client.Socket]
    invoke  WSACleanup

@@:
    ret
endp