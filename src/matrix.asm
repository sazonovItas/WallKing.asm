proc Matrix.Projection uses edi,\
        fov, aspect, zNear, zFar, matrix

        locals
                sine            dd              ?
                cotangent       dd              ?
                deltaZ          dd              ?
                radians         dd              ?
        endl

        invoke  glMatrixMode, GL_PROJECTION
        invoke  glLoadIdentity

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
                temp    dd              ?
                zAxis   Vector3
                xAxis   Vector3
                yAxis   Vector3
        endl

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        
        mov     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [zAxis.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [zAxis.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [zAxis.z]

        lea     eax, [zAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [zAxis]
        lea     ecx, [xAxis]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [xAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [xAxis]
        lea     ecx, [zAxis]
        lea     ebx, [yAxis]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [xAxis]
        mov     edi, [matrix]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m11]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m21]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m31]

        fld     [ebx + Vector3.x]
        fstp    [edi + Matrix4x4.m12]
        fld     [ebx + Vector3.y]
        fstp    [edi + Matrix4x4.m22]
        fld     [ebx + Vector3.z]
        fstp    [edi + Matrix4x4.m32]

        lea     esi, [zAxis]
        fld     [esi + Vector3.x]
        fchs
        fstp    [edi + Matrix4x4.m13]
        fld     [esi + Vector3.y]
        fchs
        fstp    [edi + Matrix4x4.m23]
        fld     [esi + Vector3.z]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fstp    [edi + Matrix4x4.m44]

        invoke  glMultMatrixf, edi

        mov     esi, [camera]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.y]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.x]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef
        invoke  glGetFloatv, GL_MODELVIEW_MATRIX, [matrix]

        ret
endp

proc Matrix.MultVec4OnMat4x4 uses esi edi ebx,\
        pVec4, pMat, pResult

        mov     edi, [pVec4]
        mov     esi, [pMat]
        mov     ebx, [pResult]

        fld     [edi + Vector4.x]
        fmul    [esi + Matrix4x4.m11]
        fld     [edi + Vector4.y]
        fmul    [esi + Matrix4x4.m21]
        faddp
        fld     [edi + Vector4.z]
        fmul    [esi + Matrix4x4.m31]
        faddp
        fadd    [esi + Matrix4x4.m41]
        fstp    [ebx + Vector4.x]
        
        fld     [edi + Vector4.x]
        fmul    [esi + Matrix4x4.m12]
        fld     [edi + Vector4.y]
        fmul    [esi + Matrix4x4.m22]
        faddp
        fld     [edi + Vector4.z]
        fmul    [esi + Matrix4x4.m32]
        faddp
        fadd    [esi + Matrix4x4.m42]
        fstp    [ebx + Vector4.y]

        fld     [edi + Vector4.x]
        fmul    [esi + Matrix4x4.m13]
        fld     [edi + Vector4.y]
        fmul    [esi + Matrix4x4.m23]
        faddp
        fld     [edi + Vector4.z]
        fmul    [esi + Matrix4x4.m33]
        faddp
        fadd    [esi + Matrix4x4.m43]
        fstp    [ebx + Vector4.z]

        mov     [ebx + Vector4.w], 1.0
        ret
endp