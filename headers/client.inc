    ; Client for local network through broadcast    

    ; Constants
    IPPROTO_UDP                 =                   0x11
    SERVER_PORT                 =                   8829

    SO_BROADCAST                =                   0x0020
    SO_REUSEADDR                =                   0x0004
    SOL_SOCKET                  =                   0xFFFF

    MESSAGE_SIZE                =                   512

    ; Errors
    INVALID_SOCKET              =                   0xFF_FF_FF_FF
    SOCKET_ERROR                =                   0xFF_FF_FF_FF

    CLIENT_STATE_OFFLINE        =                   0000_0001b
    CLIENT_STATE_REQUEST        =                   0000_0010b
    CLIENT_STATE_ONLINE         =                   0000_0100b
    CLIENT_STATE_ACCEPT         =                   0000_1000b

    CLIENT_ADAPTERS_BUF_MAX     =                   1024

    ; client data
    Client.State                dd                  ?
    Client.BufferSend           dd                  ?
    Client.BufferRecv           dd                  ?

    Client.dIPAddrTableSz       dd                  CLIENT_ADAPTERS_BUF_MAX
    Client.IPAddrTableBuf       db                  (CLIENT_ADAPTERS_BUF_MAX) dup ?

    Client.flag                 dd                  ?
    Client.Broadcast_addr       sockaddr_in         ?
    Client.Server_addr          sockaddr_in         ?
    Client.Recv_addr            sockaddr_in         ?
    Client.wsaData              WSADATA             ?
    Client.Socket               dd                  ?

    Client.MutexDrawBuf         dd                  NULL         

    Client.ThSendId             dd                  NULL
    Client.ThRecvId             dd                  NULL

    Client.ThStopSd             db                  false
    Client.ThStopRv             db                  false