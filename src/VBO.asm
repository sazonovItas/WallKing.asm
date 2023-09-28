proc VBO.Constructor uses esi,\
    ptrId, sizeVert, objVertices

    invoke  glGenBuffers, 1, [ptrId]
    mov     esi, [ptrId]
    invoke  glBindBuffer, GL_ARRAY_BUFFER, dword [esi]
    invoke  glBufferData, GL_ARRAY_BUFFER, [sizeVert], [objVertices], GL_STATIC_DRAW

    ret
endp

proc VBO.Bind,\
    id

    invoke  glBindBuffer, GL_ARRAY_BUFFER, [id]

    ret
endp

proc VBO.Unbind

    invoke  glBindBuffer, GL_ARRAY_BUFFER, 0

    ret
endp

proc VBO.Delete,\
    ptrId

    invoke  glDeleteBuffers, 1, [ptrId]

    ret
endp