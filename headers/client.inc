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
    CLIENT_CONNECT_KEY          =                   'C'

    CLIENT_ADAPTERS_BUF_MAX     =                   1024

    ; client data
    Client.State                dd                  CLIENT_STATE_OFFLINE

    Client.BufferSend           dd                  NULL
    Client.BufferRecv           dd                  NULL
    Client.BufferDraw           dd                  NULL

    ; Structure of reciving message
    Client.plPositioin          =                   0
    Client.plAngles             =                   12
    Client.plScale              =                   24
    Client.plAmbientTex         =                   36
    Client.plDiffuseTex         =                   40
    Client.plSpecularTex        =                   44
    Client.plShininess          =                   48

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

    
    ; Useful constants for client
    Client.WaitOnlineTimeOut    =                   1000
    Client.RequestTimeout       =                   500
    Client.RequestOk            =                   200
    Client.RequestError         =                   0  

    Client.AcceptSendTimeout    =                   8

    ; Checking message
    Client.CheckMsgTitle        db                  "WallKing", 0
    Client.SendMsgError         db                  "Send Error", 0
    Client.RecvMsgError         db                  "Recv Error", 0
    Client.Text                 db                  32 dup(0)
    
    CLIENT_PL_MESSAGE           =                   2
    CLIENT_PL_JOIN              =                   1
    CLIENT_PL_UPDATE            =                   0
    CLIENT_PL_EXIT              =                  -1