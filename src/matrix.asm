proc Matrix.Projection uses edi,\
     aspect, fov, zNear, zFar, matrix

        locals
                sine            dd              ?
                cotangent       dd              ?
                deltaZ          dd              ?
                radians         dd              ?
        endl

        mov     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     edi, [matrix]

        fld     [fov]
        fld1
        fld1
        faddp
        fdivp
        fdiv    [radian]
        fstp    [radians]

        fld     [zFar]
        fsub    [zNear]
        fstp    [deltaZ]

        fld     [radians]
        fsin
        fstp    [sine]

        fld     [radians]
        fcos
        fdiv    [sine]
        fstp    [cotangent]

        fld     [cotangent]
        fdiv    [aspect]
        fstp    [edi + Matrix4x4.m11]

        fld     [cotangent]
        fstp    [edi + Matrix4x4.m22]

        fld     [zFar]
        fadd    [zNear]
        fdiv    [deltaZ]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fchs
        fstp    [edi + Matrix4x4.m34]

        fld1
        fld1
        faddp
        fchs
        fmul    [zNear]
        fmul    [zFar]
        fdiv    [deltaZ]
        fstp    [edi + Matrix4x4.m43]

        invoke  glMultMatrixf, edi
        invoke  glGetFloatv, GL_PROJECTION_MATRIX, [matrix]

        ret
endp
proc Matrix.LookAt uses esi edi ebx,\
     camera, target, up, matrix

        locals
                temp                    dd              ?
                cnstX                   dd              5.0
                cnstY                   dd              5.0
                cnstZ                   dd              5.0
                cameraDirection         Vector3
                cameraRight             Vector3
                cameraUp                Vector3
                x                       dd              ?
                y                       dd              ?
                z                       dd              ?
        endl

        mov     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [esi + Vector3.x]
        fsub    [edi + Vector3.x]
        fstp    [cameraDirection.x]

        fld     [esi + Vector3.y]
        fsub    [edi + Vector3.y]
        fstp    [cameraDirection.y]

        fld     [esi + Vector3.z]
        fsub    [edi + Vector3.z]
        fstp    [cameraDirection.z]

        lea     eax, [cameraDirection]
        stdcall Vector3.Normalize, eax

        lea     eax, [cameraDirection]
        lea     ecx, [cameraRight]
        stdcall Vector3.Cross, ebx, eax, ecx

        lea     eax, [cameraRight]
        stdcall Vector3.Normalize, eax

        lea     eax, [cameraDirection]
        lea     ecx, [cameraRight]
        lea     ebx, [cameraUp]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [cameraRight]
        mov     edi, [matrix]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m11]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m12]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m13]

        lea     ebx, [cameraUp]
        fld     [ebx + Vector3.x]
        fstp    [edi + Matrix4x4.m21]
        fld     [ebx + Vector3.y]
        fstp    [edi + Matrix4x4.m22]
        fld     [ebx + Vector3.z]
        fstp    [edi + Matrix4x4.m23]

        lea     esi, [cameraDirection]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m31]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m32]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m33]

        fld1
        fstp    [edi + Matrix4x4.m44]

        invoke  glMultMatrixf, edi 

        mov     esi, [camera]
        fld     [esi + Vector3.z]
        fchs
        fstp    [z]
        push    [z]
        fld     [esi + Vector3.y]
        fchs
        fstp    [y]
        push    [y]
        fld     [esi + Vector3.x]
        fchs
        fstp    [x]
        push    [x]

        invoke  glTranslatef
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, [matrix]

        ret
endp