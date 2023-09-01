proc Camera.Constructor uses edi,\
    pCamera, width, height, pPosition 

    mov     edi, [pCamera]

    mov     eax, [width]
    mov     dword [edi + Camera.width], eax
    mov     eax, [height]
    mov     dword [edi + Camera.height], eax

    add     edi, Camera.Position
    stdcall Vector3.Copy, edi, [pPosition] 

    ret
endp

    proj        Matrix4x4       ?
    view        Matrix4x4       ?
    target      Vector3         ?

proc Camera.Matrix uses edi esi,\
    pCamera, FOVdeg, nearPlane, farPlane, ShaderID, pStrUniProj, pStrUniView

    locals 
        aspect      GLfloat         ?
    endl

    mov     edi, [pCamera]

    fild    [edi + Camera.width]    ; width
    fidiv   [edi + Camera.height]   ; width / height
    fstp    [aspect]                ;

    invoke  glMatrixMode, GL_PROJECTION
    invoke  glLoadIdentity
    stdcall Matrix.Projection, [FOVdeg], 2.0, [nearPlane], [farPlane], proj

    ; push    edi
    ; mov     edi, Camera.Position
    ; stdcall Vector3.Copy, target, edi 
    ; pop     edi

    ; push    edi
    ; mov     edi, Camera.Orientation
    ; stdcall Vector3.Add, target, edi 
    ; pop     edi

    ; mov     esi, edi
    ; add     edi, Camera.Position
    ; add     esi, Camera.Up
    ; invoke  glMatrixMode, GL_MODELVIEW
    ; invoke  glLoadIdentity
    ; stdcall Matrix.LookAt, edi, target, esi, view
    ; pop     edi

    invoke  glGetUniformLocation, [ShaderID], [pStrUniProj]
    invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, proj

    ; invoke  glGetUniformLocation, [ShaderID], [pStrUniView]
    ; invoke  glUniformMatrix4fv, eax, 1, GL_FALSE, view 

    ret
endp

proc Camera.Inputs uses edi esi ebx,\
    pCamera

    ret
endp