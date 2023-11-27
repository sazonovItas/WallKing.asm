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
    CLIENT_STATE_ONLINE         =                   0000_0010b
    CLIENT_STATE_REQUEST        =                   0000_0100b
    CLIENT_STATE_ACCEPT         =                   0000_1000b

    ; Keys for client
    CLIENT_RECONNECT_KEY        =                   'C'

    CLIENT_ADAPTERS_BUF_MAX     =                   1024

    ; client data
    Client.State                dd                  CLIENT_STATE_OFFLINE

    Client.BufferSend           db                  MESSAGE_SIZE dup(0)
    Client.BufferRecv           db                  MESSAGE_SIZE dup(0)

    Client.Uptime               dd                  0
    Client.CntPlayers           dd                  0

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

    
    ; Useful data for client
    Client.RequestTimeout       =                   500
    Client.RequestOk            =                   200
    Client.RequestError         =                   0  

    Client.AcceptSendTimeout    =                   8

    ; Checking message
    Client.CheckMsgTitle        db              "WallKing", 0
    Client.SendMsgError         db              "Send Error", 0
    Client.RecvMsgError         db              "Recv Error", 0
    Client.Text                 db              20 dup(0)
    
    CLIENT_PL_JOIN               =               1
    CLIENT_PL_UPDATE             =               0
    CLIENT_PL_EXIT               =              -1