proc Game.Game\ 
    pPlayer

    stdcall Game.MoveObject, [pPlayer]
    stdcall Draw.Scene, [pPlayer], blocksMapTry, [sizeBlocksMapTry], lightsMapTry, [sizeLightsMapTry]

.Ret:
    ret
endp
proc Game.MoveObject\
    pPlayer

    locals 
            currentFrame            dd              ?
    endl

    invoke  GetTickCount
    mov     [currentFrame], eax

    sub     eax, [time]
    cmp     eax, 1
    jb      .Skip

    stdcall Player.Update, [pPlayer], eax, [sizeBlocksMapTry], blocksMapTry

    mov     eax, [currentFrame]
    mov     [time], eax

.Skip:

.Ret:
    ret
endp