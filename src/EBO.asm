proc EBO.Constructor uses esi,\
    ptrId, sizeInd, objIndices

    invoke  glGenBuffers, 1, [ptrId]
    mov     esi, [ptrId]
    invoke  glBindBuffer, GL_ELEMENT_ARRAY_BUFFER, dword [esi]
    invoke  glBufferData, GL_ELEMENT_ARRAY_BUFFER, [sizeInd], [objIndices], GL_STATIC_DRAW

    ret
endp

proc EBO.Bind,\
    id

    invoke  glBindBuffer, GL_ELEMENT_ARRAY_BUFFER, [id]

    ret
endp

proc EBO.Unbind

    invoke  glBindBuffer, GL_ELEMENT_ARRAY_BUFFER, 0

    ret
endp

proc EBO.Delete,\
    ptrId

    invoke  glDeleteBuffers, 1, [ptrId]

    ret
endp