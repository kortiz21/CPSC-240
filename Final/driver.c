//****************************************************************************************************************************
//  Author name: Kevin Ortiz
//  Author email: keortiz@csu.fullerton.edu
//  Course and Section: CPSC240-13 Final
//  Today' Date: May 15 2023
//  CWID: 886097146
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

extern long long unsigned int controller();

int main(int argc, char *argv[])
{
  printf("Welcome to triangle by Kevin Ortiz.\n");
  long long unsigned int result = controller();
  printf("The driver received this number for safekeeping: %llu\n", result);
}