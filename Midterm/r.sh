#!/bin/bash

#Program: faraday
#Author: Kevin Ortiz
#Author email: keortiz@csu.fullerton.edu
#Course and Section: CPSC240-13
#Today's Date: Mar 22, 2023
#CWID: 886097146
#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble faraday.asm"
nasm -f elf64 -l faraday.lis -o faraday.o faraday.asm

echo "compile ampere.cpp using g++ compiler standard 2020"
g++ -c -Wall -m64 -no-pie -o ampere.o ampere.cpp -std=c++20

echo "Link object files using the g++ Linker standard 2020"
g++ -m64 -no-pie -o final-faraday.out faraday.o ampere.o -std=c++20

echo "Run the faraday Program:"
./final-faraday.out

# For cleaner working directory, you can:
rm *.lis
rm *.o
rm *.out

echo "Script file terminated."