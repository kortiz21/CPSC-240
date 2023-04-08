#!/bin/bash

#Program: executive
#Author: Kevin Ortiz

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble executive.asm"
nasm -f elf64 -l executive.lis -o executive.o executive.asm

echo "Assemble fill_random_array.asm"
nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm

echo "Assemble show_array.asm"
nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm

echo "Assemble isnan.asm"
nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm

echo "compile quick_sort.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o quick_sort.o quick_sort.c -std=c17

echo "compile main.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c17

echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o final-executive.out executive.o quick_sort.o main.o fill_random_array.o show_array.o isnan.o -std=c17

echo "Run the executive Program:"
./final-executive.out

# For cleaner working directory, you can:
rm *.o
rm *.out
rm *.lis

echo "Script file terminated."