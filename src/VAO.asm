proc VAO.Constructor,\
    ptrId

    invoke  glGenVertexArrays, 1, [ptrId]

    ret
endp

proc VAO.LinkAttribVBO uses esi,\
    VBOid, layout, count, type, norm, sizeElem, offsetElem

    stdcall VBO.Bind, [VBOid]
    invoke  glVertexAttribPointer, [layout], [count], [type], [norm], [sizeElem], [offsetElem]
    invoke  glEnableVertexAttribArray, [layout]
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