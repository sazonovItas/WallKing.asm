proc VAO.Constructor,\
    ptrId

    invoke  glGenVertexArrays, 1, [ptrId]

    ret
endp

proc VAO.LinkVBO uses esi,\
    VBOid, layout

    stdcall VBO.Bind, [VBOid]
    invoke  glEnableVertexAttribArray, [layout]
    invoke  glVertexAttribPointer, [layout], 3, GL_FLOAT, GL_FALSE, 3 * 4, 0
    stdcall VBO.Unbind

    ret
endp

proc VAO.Bind,\
    id

    invoke  glBindVertexArray, [id] 

    ret
endp

proc VAO.Unbind

    invoke  glBindVertexArray, 0

    ret
endp

proc VAO.Delete,\
    ptrId

    glDeleteVertexArrays, 1, [ptrId]

    ret
endp