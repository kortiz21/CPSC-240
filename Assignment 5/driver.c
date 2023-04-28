//****************************************************************************************************************************
//Program name: "Data Validation". This program will validate incoming numbers and performance comparison of two versions 
//of the sine function.
//Copyright (C) 2023 Kevin Ortiz.                                                                            *
//                                                                                                                           *
//This file is part of the software program "Data Validation".                                                                   *
//Data Validation is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//Data Validation is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Kevin Ortiz
//  Author email: keortiz@csu.fullerton.edu
//  Section: CPSC 240-13
//
//Program information
//  Program name: Data Validation
//  Programming languages: one module in C and two modules in x86
//  Date program began: 2023 April 27
//  Date of last update: 2023 April 27
//  Comments reorganized: 2023 April 27
//  Files in this program: driver.c, manager.asm, r.sh, isfloat.asm
//  Status: Complete. Program was tested extensively with no errors.
//
//Purpose
//  This program will be the driver for Data Validation program
//
//This file
//   File name: driver.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -Wall -m64 -no-pie -o driver.o driver.c -std=c17
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

extern int manager();

int main(int argc, char *argv[])
{
  printf("Welcome to Asterix Software Development Corporation\n");
  int result = manager();
  printf("Thank you for using this program.  Have a great day.\n");
  printf("The driver program received this number %d. A zero will be returned to the OS. Bye.\n", result);

}