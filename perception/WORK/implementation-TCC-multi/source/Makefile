all: build
build: main.o identification.o
	gcc -o process main.o identification.o 
main.o:
	gcc -o main.o -c main.c -Wall -ggdb
identification.o:
	gcc -o identification.o -c identification.c -Wall -ggdb
clean:
	rm -rf *.o process