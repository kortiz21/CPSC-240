//****************************************************************************************************************************
//Program name: "Pythagoras".  This program will compute the length of the hypotenuse of a right triangle given the lengths
//of the two sides. Copyright (C) 2023 Kevin Ortiz.                                                                            *
//                                                                                                                           *
//This file is part of the software program "Pythagoras".                                                                   *
//Pythagoras is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
//version 3 as published by the Free Software Foundation.                                                                    *
//Pythagoras is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
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
//  Program name: Pythagoras
//  Programming languages: One module in C++ and one module in X86
//  Date program began: 2023 Jan 24
//  Date of last update: 2023 Feb 3
//  Comments reorganized: 2023 Feb 3
//  Files in this program: driver.cpp, pythagoras.asm, r.sh
//  Status: Finished. Program was tested extensively with no errors.
//
//Purpose
//  Output the hypotenuse from pythagoras.asm in addition to user dialog.
//
//This file
//   File name: driver.cpp
//   Language: C++
//   Max page width: 132 columns
//   Compile: g++ -c -Wall -m64 -no-pie -o manage-floats.o manage-floats.c -std=c17
//   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================
#include <iostream>
#include <iomanip>
#include <cstdlib>

extern "C" double hypotenuse();

int main(int argc, char* argv[])
{
  double h = 0.0;
  std::cout << "The main function driver.cpp has begun.\n";
  std::cout << "The function hypotenuse will now be called.\n";
  std::cout << "Welcome to Pythagoras Math Lab programmed by Kevin Ortiz\n";
  std::cout << "Please contact me at keortiz@csu.fullerton.edu if you need assistance.\n";
  h = hypotenuse();
  std::cout << std::fixed << std::setprecision(12);
  std::cout << "The main file has received this number and will keep it for now.\n" << h << std::endl;
  std::cout << "We hope you enjoyed your right angles. Have a good day. A zero will be sent to your operating system.\n";
  std::cout << "Have a nice day.\n";
  return 0;
}