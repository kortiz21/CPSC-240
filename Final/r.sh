#!/bin/bash

#Program: controller
#Author: Kevin Ortiz
#Author email: keortiz@csu.fullerton.edu
#Course and Section: CPSC240-13 Final
#Today's Date: May 15, 2023
#CWID: 886097146
#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble controller.asm"
nasm -f elf64 -l controller.lis -o controller.o controller.asm

echo "compile driver.c using gcc compiler standard 2017"
gcc -c -Wall -m64 -no-pie -o driver.o driver.c -std=c17

echo "Link object files using the gcc Linker standard 2017"
gcc -m64 -no-pie -o final-controller.out controller.o -lm driver.o -std=c17

echo "Run the controller Program:"
./final-controller.out

# For cleaner working directory, you can:
rm *.lis
rm *.o
rm *.out

echo "Script file terminated."