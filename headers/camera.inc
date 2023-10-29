struct Camera

    camPosition     Vector3         ?
    Orientation     Vector3         ? 
    Up              Vector3         ?

    width           dd              ?
    height          dd              ?

    speed           GLfloat         ?
    camVelocity     Vector3         ?
    sensitivity     GLfloat         ? 

    moving          Easing          ?
    slowing         Easing          ?

    pitch           GLfloat         ?
    yaw             GLfloat         ?

    view            Matrix4x4       ?

    proj            Matrix4x4       ?
    fovDeg          GLfloat         ?
    nearPlane       GLfloat         ?
    farPlane        GLfloat         ?

    translate       Vector3         ?
    radius          GLfloat         ?
ends