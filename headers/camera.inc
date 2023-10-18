struct Camera

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
    fovDeg          GLfloat         ?
    nearPlane       GLfloat         ?
    farPlane        GLfloat         ?

    translate       Vector3         ?

ends