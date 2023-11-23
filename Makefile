compile:
	fasm ./src/main.asm WallKing.exe

runClient:
	gcc ./client/client.c -o ./client/client.exe -lws2_32
	./client/client.exe

exec:
	./WallKing.exe

run:
	fasm ./src/main.asm WallKing.exe
	./WallKing.exe

clean:
	rm WallKing.exe