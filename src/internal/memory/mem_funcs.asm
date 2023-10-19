; Get place of the process's Heap
proc memInit

    invoke  GetProcessHeap
    mov     [hHeap], eax

    ret
endp

; Return begin of the memory allocated or null
; Return result in eax
proc malloc\
    sizeInBytes

    invoke HeapAlloc, [hHeap], 8, [sizeInBytes]

    ret
endp

; Release memory that was allocated
proc free\
    ptrMem

    invoke HeapFree, [hHeap], 8, [ptrMem]

    ret
endp