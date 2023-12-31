struct Point 
        x       dd              ?
        y       dd              ?
ends

struct Vertex
        x       GLfloat         ?
        y       GLfloat         ?
        z       GLfloat         ?
ends

struct PackedMesh
        vertices        dd      ?
        colors          dd      ?
        indices         dd      ?
        trianglesCount  dd      ?
ends

struct Mesh
        vertices        dd      ?
        colors          dd      ?
        normals         dd      ?
        verticesCount   dd      ?
        numTexture      dd      ?
        textures        dd      ?
ends