compile:
	fasm ./src/main.asm WallKing.exe

run:
	./WallKing.exe

exec:
	fasm ./src/main.asm WallKing.exe
	./WallKing.exe

clean:
	rm WallKing.exe