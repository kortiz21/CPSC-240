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
;  This program will get the radicand
;
;This file
;   File name: getradicand.asm
;   Language: x86-64
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration
extern printf
extern scanf

global getradicand

segment .data
prompt_radicand db "Please enter a floating radicand for square root bench marking:",10,0
float_form db "%lf",0

segment .bss

segment .text

getradicand:

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

push qword 0 ; to have functions remain in the boundary to end in a 0 and not 8

;Executable section
;--------------------------------------------------------------------
;Block to prompt Please enter a floating radicand for square root bench marking:
push qword 0
mov rax,0
mov rdi,prompt_radicand
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get floating radicand
push qword 0
mov rax,0
mov rdi, float_form
mov rsi,rsp
call scanf
movsd xmm15, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to compute sqrt of the radicand
movsd xmm14,xmm15 ; original user input
sqrtsd xmm15,xmm15 ; sqrt of user input
;--------------------------------------------------------------------

pop rax

movsd xmm0, xmm15 ; copy sqrt to xmm0 register
movsd xmm1, xmm14 ; copy original user input to xmm1 register
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