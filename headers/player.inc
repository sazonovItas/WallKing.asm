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
    PL_RUN              =       VK_SHIFT
    PL_FORWARD          =       'W'
    PL_BACKWARD         =       'S'
    PL_LEFT             =       'A'
    PL_RIGHT            =       'D'
    PL_NORMAL_GRAV      =       'E'
    PL_ENHANCE_GRAV     =       VK_UP
    PL_WEAK_GRAV        =       VK_DOWN
    PL_STOP_CAM_TEX     =       'O'
    PL_STOP_CAM_CHASING =       'P'

    pl_jump             db      false
    pl_run              db      false
    pl_forward          db      false
    pl_backward         db      false
    pl_left             db      false
    pl_right            db      false 
    pl_normal_grav      db      false
    pl_enhance_grav     db      false 
    pl_weak_grav        db      false
    pl_stop_cam_tex     db      true
    pl_stop_cam_chasing db      false

    ;   Gravity just for fun
    EARTH_GRAVITY       dd       -0.0098
    MOON_GRAVITY        dd       -0.0016
    MARS_GRAVITY        dd       -0.0031
    MERCURY_GRAVITY     dd       -0.0036

    maxClimbSpeed       dd      0.1
    maxPlayerPitch      dd      1.50