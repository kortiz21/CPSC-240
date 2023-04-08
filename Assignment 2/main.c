//****************************************************************************************************************************
//Program name: "Arrays".  This program will manage your array of 64-bit floats. 
//Copyright (C) 2023 Kevin Ortiz.                                                                            *
//                                                                                                                           *
//This file is part of the software program "Arrays".                                                                   *
//Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//Arrays is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
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
//  Program name: Arrays
//  Programming languages: two modules in C and four modules in X86
//  Date program began: 2023 Feb 17
//  Date of last update: 2023 Feb 17
//  Comments reorganized: 2023 Feb 17
//  Files in this program: main.c, display_array.c, manager.asm, magnitude.asm, append.asm, input_array.asm, r.sh
//  Status: Complete. Program was tested extensively with no errors.
//
//Purpose
//  This program will manage your array of 64-bit floats.
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
  printf("Welcome to Arrays of Integers\n"
         "Brought to you by Kevin Ortiz\n");
  double result = manager();
  printf("Main received %.10lf and will keep it for future use.\n", result);
  printf("Main will return 0 to the operating system. Bye.\n");
}