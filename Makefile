compile:
	fasm ./src/main.asm main.exe

run:
	./main.exe

exec:
	fasm ./src/main.asm main.exe
	./main.exe

clean:
	rm main.exe