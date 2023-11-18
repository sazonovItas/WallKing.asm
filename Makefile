compile:
	fasm ./src/main.asm WallKing.exe

runClient:
	gcc ./client/client.c -o ./client/client.exe -lws2_32
	./client/client.exe

run:
	./WallKing.exe

exec:
	fasm ./src/main.asm WallKing.exe
	./WallKing.exe

clean:
	rm WallKing.exe