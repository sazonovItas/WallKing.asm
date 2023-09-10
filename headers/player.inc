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
    Condition           dd              ? 

    jumpVeloc           GLfloat         ?

ends

    AIR_CONDITION      =        1
    WALK_CONDITION     =        2