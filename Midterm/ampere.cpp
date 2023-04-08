//****************************************************************************************************************************
//  Author name: Kevin Ortiz
//  Author email: keortiz@csu.fullerton.edu
//  Course and Section: CPSC240-13
//  Today' Date: Mar 22 2023
//  CWID: 886097146
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================
#include <iostream>
#include <iomanip>
#include <cstdlib>

extern "C" double faraday();

int main(int argc, char* argv[])
{
  double h = 0.0;
  std::cout << "Welcome to the High Voltage Software System by Kevin Ortiz.\n";
  h = faraday();
  std::cout << std::fixed << std::setprecision(10);
  std::cout << "Thank you for your number " << h << ".  Have a nice research party.\n";
  std::cout << "Zero is returned to the operating system.\n";
  return 0;
}