//****************************************************************************************************************************
//Program name: "Benchmark". This program will benchmark the performance of the square root instruction in SSE and also the 
//square root program in the standard C library .
//Copyright (C) 2023 Kevin Ortiz.                                                                            *
//                                                                                                                           *
//This file is part of the software program "Benchmark".                                                                   *
//Benchmark is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//Benchmark is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Kevin Ortiz
//  Author email: keortiz@csu.fullerton.edu
//
//Program information
//  Program name: Benchmark
//  Programming languages: one modules in C and two modules in x86
//  Date program began: 2023 April 13
//  Date of last update: 2023 April 13
//  Comments reorganized: 2023 April 13
//  Files in this program: main.c, manager.asm, getradicand.asm, r.sh
//  Status: Complete. Program was tested extensively with no errors.
//
//Purpose
//  This program will be the main driver for Benchmark program
//
//This file
//   File name: main.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern double manager();

int main(int argc, char *argv[])
{
  double result = manager();
  printf("The main function has received this number %.5lf and will keep it for future reference.\n", result);
  printf("The main function will return a zero to the operating system.\n");
}