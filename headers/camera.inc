struct Camera

    Position        Vector3         ?
    Orientation     Vector3         0.0, 0.0, -1.0
    Up              Vector3         0.0, 1.0,  0.0

    width           dd              ?
    height          dd              ?

    speed           GLfloat         0.1
    sensitivity     GLfloat         100.0

ends