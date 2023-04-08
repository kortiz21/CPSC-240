#!/bin/bash

#Program: Arrays
#Author: Kevin Ortiz

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble magnitude.asm"
nasm -f elf64 -l magnitude.lis -o magnitude.o magnitude.asm

echo "Assemble input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Assemble append.asm"
nasm -f elf64 -l append.lis -o append.o append.asm

echo "compile main.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c17

echo "compile display_array.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o display_array.o display_array.c -std=c17

echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o final-manager.out manager.o input_array.o main.o magnitude.o append.o display_array.o -std=c17

echo "Run the manager Program:"
./final-manager.out

# For cleaner working directory, you can:
rm *.o
rm *.out
rm *.lis

echo "Script file terminated."