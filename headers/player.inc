struct DrawData
    lock            dd          ?
    Position        Vector3     ?
    Angles          Vector3     ?
    Scale           Vector3     ?
    AmbientTexId    dd          ?
    DiffuseTexId    dd          ?
    SpecularTexId   dd          ?
    Shininess       dd          ?
ends

struct Player

    ; Camera
    camera          Camera          ?

    ; Different types movement velocity 
    speed           GLfloat         ?

    ; radius for dodging textures by camera
    chasingRadius   GLfloat         ?
    maxCamRadius    GLfloat         ?
    minCamRadius    GLfloat         ?
    curCamRadius    GLfloat         ?

    ; camera velocity
    camTexture      Easing          ?
    camTextureVel   GLfloat         ?

    ; collision size
    sizeBlockCol    GLfloat         ?

    ; Size for draws
    sizeBlockDraw   GLfloat         ?
    XYZangles       Vector3         ?

    ; Chasing light
    offsetChasingLight  dd          ?
    offsetColorLight    dd          ?
    chasingLight        Easing      ?
    lightVelocity       Vector3     ?

    ; Level  
    pLevel              dd          ?

    ; Draw 
    DrawPlayer      DrawData        ?

    ; Physics
    Position        Vector3         ?
    prevPosition    Vector3         ?
    Acceleration    Vector3         ?
    Velocity        Vector3         ?
    jumpVeloc       GLfloat         ?
    Dir             Vector3         ?
    Condition       dd              ?
  
    forwAni         Easing          ?
    backAni         Easing          ?
    leftAni         Easing          ?
    rightAni        Easing          ?

    bforwAni        Easing          ?
    bbackAni        Easing          ?
    bleftAni        Easing          ?
    brightAni       Easing          ?

    fallAni         Easing          ?
    jumpAni         Easing          ?
    slideAni        Easing          ?
    slideJump       Easing          ?
    slideVec        Vector3         ?
    slideNewJump    dd              ?
    slideDirJump    dd              ?

ends

    FALL_STATE          =       0000_0001b
    SLIDE_STATE         =       0000_0010b
    WALK_STATE          =       0000_0100b

    NO_DIR              =       0000_0000b
    X_DIR_PLUS          =       0000_0001b
    X_DIR_MINUS         =       0000_0010b
    Y_DIR_PLUS          =       0000_0100b
    Y_DIR_MINUS         =       0000_1000b
    Z_DIR_PLUS          =       0001_0000b
    Z_DIR_MINUS         =       0010_0000b

    ;   Some player const
    WALK_SPEED          =       0.01
    RUN_SPEED           =       0.015

    ;   Keys define for handlers
    PL_JUMP             =       VK_SPACE
    PL_FORWARD          =       'W'
    PL_BACKWARD         =       'S'
    PL_LEFT             =       'A'
    PL_RIGHT            =       'D'
    PL_ENHANCE_COLOR    =       VK_UP
    PL_WEAK_COLOR       =       VK_DOWN
    PL_STOP_CAM_TEX     =       'X'
    PL_STOP_CAM_CHASING =       'C'
    PL_STOP_LIGHT       =       'L'
    PL_NEXT_LIGHT       =       'N'
    PL_PREV_LIGHT       =       'P'
    PL_RESPAWN          =       'R'
    PL_TELEPORT         =       'T'
    PL_HELP             =       'H'
    PL_LIGHT_R          =       '1'
    PL_LIGHT_G          =       '2'
    PL_LIGHT_B          =       '3'
    PL_LEVEL_SAVE_KEY   =       VK_F5

    pl_help             db      true
    pl_stop_light       db      false
    pl_jump             db      false
    pl_run              db      false
    pl_forward          db      false
    pl_backward         db      false
    pl_left             db      false
    pl_right            db      false 
    pl_stop_cam_tex     db      true
    pl_stop_cam_chasing db      false

    maxPlayerPitch      dd      1.50
    colorStep           dd      0.2