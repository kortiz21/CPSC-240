#!/bin/bash

#Program: Benchmark
#Author: Kevin Ortiz

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm -g -gdwarf

echo "Assemble getradicand.asm"
nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm -g -gdwarf

echo "Assemble get_clock_freq.asm"
nasm -f elf64 -l get_clock_freq.lis -o get_clock_freq.o get_clock_freq.asm -g -gdwarf

echo "compile main.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c17 -g

echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o final-manager.out manager.o get_clock_freq.o main.o getradicand.o -std=c17

echo "Run the manager Program:"
gdb ./final-manager.out

# For cleaner working directory, you can:
rm *.o
rm *.out
rm *.lis

echo "Script file terminated."