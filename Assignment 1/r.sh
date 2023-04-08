#!/bin/bash

#Program: Pythagoras
#Author: Kevin Ortiz

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble pythagoras.asm"
nasm -f elf64 -l pythagoras.lis -o pythagoras.o pythagoras.asm

echo "compile driver.cpp using g++ compiler standard 2020"
g++ -c -Wall -m64 -no-pie -o driver.o driver.cpp -std=c++20

echo "Link object files using the g++ Linker standard 2020"
g++ -m64 -no-pie -o final-pythagoras.out pythagoras.o driver.o -std=c++20

echo "Run the Pythagoras Program:"
./final-pythagoras.out

# For cleaner working directory, you can:
rm *.lis
rm *.o
rm *.out

echo "Script file terminated."