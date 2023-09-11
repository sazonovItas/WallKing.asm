struct Player

    Position        Vector3         ?
    Orientation     Vector3         ? 
    Up              Vector3         ?

    width           dd              ?
    height          dd              ?

    speed           GLfloat         ?
    sensitivity     GLfloat         ? 

    pitch           GLfloat         ?
    yaw             GLfloat         ?

    view            Matrix4x4       ?
    proj            Matrix4x4       ?

    ; Physics
    prevPosition        Vector3         ?
    Acceleration        Vector3         ?
    Velocity            Vector3         ?
    Direction           Vector3         ?
    Condition           dd              ? 

    jumpVeloc           GLfloat         ?

ends

    JUMP_CONDITION      =           1
    WALK_CONDITION      =           2
    SLIDE_CONDITION     =           3

    ;   Keys define for handlers
    PL_JUMP         =       VK_SPACE
    PL_FORWARD      =       'W'
    PL_BACKWARD     =       'S'
    PL_LEFT         =       'A'
    PL_RIGHT        =       'D'

    pl_jump         db      false
    pl_forward      db      false
    pl_backward     db      false
    pl_left         db      false
    pl_right        db      false

    maxClimbSpeed   dd      0.1
    maxPlayerPitch  dd      1.50