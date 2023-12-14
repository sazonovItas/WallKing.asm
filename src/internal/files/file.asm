proc File.LoadContent uses edi,\
     fileName

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, NULL, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], NULL
        inc     eax
        mov     [length], eax
        stdcall malloc, [length]
        mov     [pBuffer], eax

        lea     edi, [read]
        invoke  ReadFile, [hFile], [pBuffer], [length], edi, NULL

        invoke  CloseHandle, [hFile]

        mov     eax, [pBuffer]

        ret
endp

proc File.WriteContent\
     fileName, pBuffer, sizeBuffer

        locals 
                hFile           dd              ?
        endl

        invoke  CreateFile, [fileName], GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
        mov     [hFile], eax

        invoke  WriteFile, [hFile], [pBuffer], [sizeBuffer], NULL, NULL
        invoke  CloseHandle, [hFile]

.Ret:
        ret
endp

proc File.LoadBmp uses edi,\
     fileName

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], ebx
        inc     eax
        mov     [length], eax
        stdcall malloc, [length]
        mov     [pBuffer], eax

        lea     edi, [read]
        invoke  ReadFile, [hFile], [pBuffer], [length], edi, ebx

        invoke  CloseHandle, [hFile]

        mov     eax, [pBuffer]

        ret
endp