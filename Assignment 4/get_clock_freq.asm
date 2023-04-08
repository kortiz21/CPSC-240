;****************************************************************************************************************************
;Program name: "Benchmark". This program will benchmark the performance of the square root instruction in SSE and also the 
;square root program in the standard C library .
;Copyright (C) 2023 Kevin Ortiz.                                                                            *
;                                                                                                                           *
;This file is part of the software program "Benchmark".                                                                   *
;Benchmark is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                    *
;Benchmark is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************

;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Kevin Ortiz
;  Author email: keortiz@csu.fullerton.edu
;
;Program information
;  Program name: Benchmark
;  Programming languages: one modules in C and three modules in x86
;  Date program began: 2023 April 3
;  Date of last update: 2023 April 3
;  Comments reorganized: 2023 April 3
;  Files in this program:main.c, manager.asm, get_clock_freq.asm, getradicand.asm, r.sh, rg.sh
;  Status: Complete. Program was tested extensively with no errors.
;
;Purpose
;  This program will get the clock frequency
;
;This file
;   File name: get_clock_freq.asm
;   Language: x86-64
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l get_clock_freq.lis -o get_clock_freq.o get_clock_freq.asm
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration
;extern atof
extern printf

global get_clock_freq

segment .data

segment .bss

segment .text

get_clock_freq:

;backup section

;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

;Executable section

mov rax,0x0000000000000016
cpuid
;mov       rdi,cpufrequency
;mov       rsi, rax                                          ;Copy minimum frequency to second parameter
mov rdx,rbx                                          ;Copy maximum frequency to third parameter
;mov qword rax,0                                             ;Do not output from any xmm registers
;call      printf                                            ;Call a library function to produce the output
;--------------------------------------------------------------------
;Block to get data from cpu
;mov rax, 0x0000000080000004
;cpuid

;Answer is in ebx:eax as big endian strings using the standard ordering of bits.
;mov       r15, rbx      ;Second part of string saved in r15
;mov       r14, rax      ;First part of string saved in r14
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Catenate the two short strings into one 8-byte string in big endian
;and r15, 0x00000000000000FF    ;Convert non-numeric chars to nulls
;shl r15, 32
;or r15, r14                    ;Combined string is in r15

;Use of mask: The number 0x00000000000000FF is a mask.  
;In general masks are used to change some bits to 0 (or 1) and leave others unchanged.

;Convert string now stored in r15 to an equivalent IEEE numeric quadword.
;push r15
;mov rax,0          ;The value in rax is the number of xmm registers passed to atof, 
;mov rdi,rsp        ;rdi now points to the start of the 8-byte string.
;call atof          ;The number is now in xmm0
;pop rax
;--------------------------------------------------------------------

;reverse section
;===== Restore original values to integer registers ===================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret