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

    ; Setup broadcast socket
    mov     [Client.Broadcast_addr + sockaddr_in.sin_family], AF_INET
    mov     [Client.Broadcast_addr + sockaddr_in.sin_port], ax
    mov     dword [Client.Broadcast_addr + sockaddr_in.sin_addr], not 0

    ; Recv Addr
    mov     [Client.Recv_addr + sockaddr_in.sin_family], AF_INET
    mov     [Client.Recv_addr + sockaddr_in.sin_port], ax
    mov     dword [Client.Recv_addr + sockaddr_in.sin_addr], 0

    ; Get table of addresses
    invoke  GetIpAddrTable, Client.IPAddrTableBuf, Client.dIPAddrTableSz, NULL
    test    eax, eax
    jnz     .Error

    ; Create buffer for recieving and sending messages
    stdcall malloc, MESSAGE_SIZE
    cmp     eax, NULL
    je      .Error

    mov     [Client.BufferSend], eax

    stdcall malloc, MESSAGE_SIZE
    cmp     eax, NULL
    je      .Error

    mov     [Client.BufferRecv], eax

    stdcall malloc, MESSAGE_SIZE
    cmp     eax, NULL
    je      .Error

    mov     [Client.BufferDraw], eax

    ; create mutex for recv data
    invoke  CreateMutex, NULL, 0, NULL
    mov     [Client.MutexDrawBuf], eax

    ; Create thread for send message
    invoke  CreateThread, NULL, 0, Client.ThSend, NULL, 0, Client.ThSendId
    test    eax, eax
    jz      .Error

    ; Create thread for recv message
    invoke  CreateThread, NULL, 0, Client.ThRecv, NULL, 0, Client.ThRecvId
    test    eax, eax
    jz      .Error

    jmp     .Exit

.Error:
    mov     [Client.State], CLIENT_STATE_OFFLINE
    invoke  closesocket, ebx
    invoke  WSACleanup
    mov     [Client.ThStopSd], true
    mov     [Client.ThStopRv], true
    jmp     .Ret

.Exit:
    mov     [Client.State], CLIENT_STATE_ONLINE

.Ret:
    ret
endp


proc Client.ThSend,\
    data

.HandleState:

    cmp     [Client.ThStopSd], true
    je      .Ret

    mov     eax, [Client.State]
    JumpIf  CLIENT_STATE_ONLINE,    .OnlineState
    JumpIf  CLIENT_STATE_REQUEST,   .RequestState
    JumpIf  CLIENT_STATE_ACCEPT,    .AcceptState

    jmp     .HandleState

    .OnlineState:


        jmp     .HandleState

    .RequestState:

        stdcall Client.RequestMessage, [Client.BufferSend]
        stdcall Client.Broadcast, [Client.BufferSend], MESSAGE_SIZE

        invoke  Sleep, Client.RequestTimeout

        jmp     .HandleState 

    .AcceptState:

        stdcall Client.AcceptMessage, [Client.BufferSend]
        invoke sendto, [Client.Socket], [Client.BufferSend], MESSAGE_SIZE, 0,\
                Client.Server_addr, sizeof.sockaddr_in

        invoke Sleep, Client.AcceptSendTimeout 

        cmp     eax, SOCKET_ERROR
        je      .ErrorMsg

        jmp     .HandleState

    .ErrorMsg:

        jmp     .HandleState


.Ret:
    ret
endp

proc Client.RequestMessage uses edi,\
    pBuf

    mov     edi, [pBuf]

    stdcall memzero, edi, MESSAGE_SIZE

    ; Check sum
    mov     word [edi], MESSAGE_SIZE
    add     edi, 2

    stdcall memcpy, edi, Client.CheckMsgTitle, 8
    add     edi, 8

    mov     byte [edi], CLIENT_PL_JOIN

    ret
endp

proc Client.AcceptMessage uses edi,\
    pBuf

    mov     edi, [pBuf]

    stdcall memzero, edi, MESSAGE_SIZE

    ; Check sum
    mov     word [edi], MESSAGE_SIZE
    add     edi, 2

    ; Standart title
    stdcall memcpy, edi, Client.CheckMsgTitle, 8
    add     edi, 8

    ; State of the player
    mov     byte [edi], CLIENT_PL_UPDATE
    add     edi, 1

    ; Send player uptime
    mov     eax, [Client.Uptime]
    mov     dword [edi], eax
    add     edi, 4

    ; Copy draw Data
    mov     esi, [mainPlayer]
    add     esi, Player.DrawPlayer

    invoke WaitForSingleObject, [esi + DrawData.lock], INFINITY
    ; Copy Position
    push    esi
    add     esi, DrawData.Position
    stdcall memcpy, edi, esi, sizeof.Vector3
    pop     esi

    ; Copy Angles
    add     edi, sizeof.Vector3
    push    esi
    add     esi, DrawData.Angles
    stdcall memcpy, edi, esi, sizeof.Vector3
    pop     esi
    add     edi, sizeof.Vector3

    ; Copy scales
    push    esi
    add     esi, DrawData.Scale
    stdcall memcpy, edi, esi, sizeof.Vector3
    pop     esi
    add     edi, sizeof.Vector3

    ; Copy Textures
    push    esi
    add     esi, DrawData.TexId
    mov     eax, dword [esi]
    mov     dword [edi], eax
    pop     esi
    invoke ReleaseMutex, [esi + DrawData.lock]

    ret
endp

proc Client.ThRecv uses edi,\
    data

    locals
        len         dd      sizeof.sockaddr_in
    endl

.HandleState:

    cmp     [Client.ThStopRv], true
    je      .Ret

    mov     eax, [Client.State]
    JumpIf  CLIENT_STATE_ONLINE,    .OnlineState
    JumpIf  CLIENT_STATE_REQUEST,   .RequestState
    JumpIf  CLIENT_STATE_ACCEPT,    .AcceptState

    jmp     .HandleState

    .OnlineState:

        jmp     .HandleState

    .RequestState:

        lea     edi, [len]
        invoke  recvfrom, [Client.Socket], [Client.BufferRecv], MESSAGE_SIZE, 0x0,\ 
                Client.Recv_addr, edi

        cmp     eax, SOCKET_ERROR
        je      .ErrorMsg

        cmp     eax, MESSAGE_SIZE
        jne     .ErrorMsg

        stdcall Client.CheckRequestMessage, [Client.BufferRecv]

        cmp     eax, true
        jne     .ErrorMsg

        stdcall memcpy, Client.Server_addr, Client.Recv_addr, sizeof.sockaddr_in
        mov     [Client.State], CLIENT_STATE_ACCEPT

        jmp     .HandleState

    .AcceptState:

        lea     edi, [len]

        lea     edi, [len]
        invoke  recvfrom, [Client.Socket], [Client.BufferRecv], MESSAGE_SIZE, 0x0,\ 
                Client.Recv_addr, edi

        cmp     eax, SOCKET_ERROR
        je      .ErrorMsg

        cmp     eax, MESSAGE_SIZE
        jne     .ErrorMsg

        mov     eax, [Client.Recv_addr + sockaddr_in.sin_addr]
        cmp     eax, [Client.Server_addr + sockaddr_in.sin_addr]
        jne     .ErrorMsg

        mov     ax, [Client.Recv_addr + sockaddr_in.sin_port]
        cmp     ax, [Client.Server_addr + sockaddr_in.sin_port]
        jne     .ErrorMsg

        ; check message for correctness
        stdcall Client.CheckAcceptMessage, [Client.BufferRecv]

        cmp     eax, true
        jne     .ErrorMsg

        invoke  WaitForSingleObject, [Client.MutexDrawBuf], INFINITY
        stdcall memcpy, [Client.BufferDraw], [Client.BufferRecv], MESSAGE_SIZE
        invoke  ReleaseMutex, [Client.MutexDrawBuf]

        jmp     .HandleState

    .ErrorMsg:

        jmp     .HandleState

.Ret:
    ret
endp

proc Client.CheckRequestMessage uses edi,\
    pBuf
    
    mov     edi, [pBuf]    

    cmp     word [edi], MESSAGE_SIZE
    jne     .Error

    cmp     byte [edi + 2], 'W'
    jne     .Error
    cmp     byte [edi + 3], 'a'
    jne     .Error
    cmp     byte [edi + 4], 'l'
    jne     .Error
    cmp     byte [edi + 5], 'l'
    jne     .Error
    cmp     byte [edi + 6], 'K'
    jne     .Error
    cmp     byte [edi + 7], 'i'
    jne     .Error
    cmp     byte [edi + 8], 'n'
    jne     .Error
    cmp     byte [edi + 9], 'g'
    jne     .Error

    add     edi, 10
    mov     ax, word [edi]
    cmp     ax, Client.RequestOk
    jne     .Error

    mov     eax, dword [edi + 2]
    mov     [Client.Uptime], eax

    jmp     .Exit

.Error:
    mov     eax, false
    jmp     .Ret

.Exit:
    mov     eax, true

.Ret:
    ret
endp

proc Client.CheckAcceptMessage uses edi,\
    pBuf
    
    mov     edi, [pBuf]    

    cmp     word [edi], MESSAGE_SIZE
    jne     .Error

    cmp     byte [edi + 2], 'W'
    jne     .Error
    cmp     byte [edi + 3], 'a'
    jne     .Error
    cmp     byte [edi + 4], 'l'
    jne     .Error
    cmp     byte [edi + 5], 'l'
    jne     .Error
    cmp     byte [edi + 6], 'K'
    jne     .Error
    cmp     byte [edi + 7], 'i'
    jne     .Error
    cmp     byte [edi + 8], 'n'
    jne     .Error
    cmp     byte [edi + 9], 'g'
    jne     .Error

    mov     eax, dword [edi + 10]
    cmp     eax, [Client.Uptime]
    jb      .Error

    mov     [Client.Uptime], eax

    jmp     .Exit

.Error:
    mov     eax, false
    jmp     .Ret

.Exit:
    mov     eax, true

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

proc Client.KeyDown\
    wParam, lParam

    ret
endp

proc Client.KeyUp\
    wParam, lParam

    cmp     [wParam] , CLIENT_CONNECT_KEY
    jne     @F

    mov     [Client.State], CLIENT_STATE_REQUEST
    jmp     .SkipUp

    @@:

    .SkipUp:

    ret
endp