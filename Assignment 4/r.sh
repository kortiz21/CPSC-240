#!/bin/bash

#Program: Benchmark
#Author: Kevin Ortiz

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble getradicand.asm"
nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm

echo "compile main.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c17

echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o final-manager.out manager.o main.o getradicand.o -std=c17

echo "Run the manager Program:"
./final-manager.out

# For cleaner working directory, you can:
rm *.o
rm *.out
rm *.lis

echo "Script file terminated."