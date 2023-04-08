;****************************************************************************************************************************
;Program name: "Pythagoras".  This program will compute the length of the hypotenuse of a right triangle given the lengths
;of the two sides. Copyright (C) 2023 Kevin Ortiz.                                                                            *
;                                                                                                                           *
;This file is part of the software program "Pythagoras".                                                                   *
;Pythagoras is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                    *
;Pythagoras is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
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
;  Program name: Pythagoras
;  Programming languages: One modules in C++ and one module in X86
;  Date program began: 2023 Jan 24
;  Date of last update: 2023 Feb 3
;  Comments reorganized: 2023 Feb 3
;  Files in this program: driver.cpp, pythagoras.asm, r.sh
;  Status: Finished. Program was tested extensively with no errors.
;
;Purpose
;  Compute the hypotenuse of a right triangle
;
;This file
;   File name: pythagoras.asm
;   Language: x86-64
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l pythagoras.lis -o pythagoras.o pythagoras.asm
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration

global hypotenuse
extern printf
extern scanf

segment .data

prompt_side1 db "Enter the length of the first side of the triangle.",10,0  ;10 is new line '/n' and 0 is 'null'
negative db "Negative values not allowed. Try again.",10,0
prompt_side2 db "Enter the length of the second side of the triangle.",10,0
float_form db "%lf",0   ; one float format
confirm db "Thank you. You entered two sides %1.6lf and %1.6lf",10,0
answer db "The length of the hypotenuse is %1.6lf",10,0

segment .bss

segment .text

hypotenuse:

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
;Block to prompt for 1st side
push qword 0    ;reserves 64 bits / 8 bytes
mov rax,0   ; number of xmm registers that will be used by next function call
mov rdi, prompt_side1   ; order for non-float parameters rdi,rsi,rdx,rcx,r8,r9
call printf
pop rax
;--------------------------------------------------------------------

check1:
;--------------------------------------------------------------------
;Block that inputs side 1
push qword 0
mov rax,0
mov rdi, float_form ;parameter for first side
mov rsi,rsp
call scanf
movsd xmm10, [rsp]  ;[rsp] is asm pointer to dereference rsp to put value into xmm register
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that checks for negative for 1st side
mov rax,0
cvtsi2sd xmm4, rax  ;convert int to floating point
ucomisd xmm10, xmm4 ;compare both xmm registers

jb isNegative1  ;if negative jump to isNegative1

jmp notNegative1    ;if not negative jump to notNegative1
;--------------------------------------------------------------------

isNegative1:
;--------------------------------------------------------------------
;Block to notify of negative number
push qword 0
mov rax,0
mov rdi, negative
call printf
pop rax

jmp check1  ;jump back to prompt user for side 1
;--------------------------------------------------------------------

notNegative1:
;--------------------------------------------------------------------
;Block to prompt for 2st side
push qword 0
mov rax,0
mov rdi, prompt_side2
call printf
pop rax
;--------------------------------------------------------------------

check2:
;--------------------------------------------------------------------
;Block that inputs side 2
push qword 0
mov rax,0
mov rdi, float_form ;parameter for second side
mov rsi,rsp
call scanf
movsd xmm11, [rsp]  ;[rsp] is asm pointer
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that checks for negative for 2nd side
mov rax,0
cvtsi2sd xmm4, rax  ;convert int to floating point
ucomisd xmm11, xmm4 ;compare both xmm registers

jb isNegative2  ;if negative jump to isNegative2

jmp notNegative2    ;if not negative jump to notNegative2
;--------------------------------------------------------------------

isNegative2:
;--------------------------------------------------------------------
;Block to notify of negative number
push qword 0
mov rax,0
mov rdi, negative
call printf
pop rax

jmp check2  ;jump back to prompt user for side 1
;--------------------------------------------------------------------

notNegative2:
;--------------------------------------------------------------------
;Block that confirms inputs
push qword 0
mov rax,2   ;mov rax,2 is used since 2 floating point registers are being outputtted
mov rdi,confirm
movsd xmm0, xmm10
movsd xmm1, xmm11
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to calculate the hypotenuse = sqrt ( a^2 + b^2 )
movsd xmm12, xmm10  ;preserve side 1
movsd xmm13, xmm11  ;preserve side 2
mulsd xmm12, xmm10  ;multiply side 1 to itself
mulsd xmm13, xmm11  ;multiply side 2 to itself
addsd xmm12, xmm13  ;add both sides together
sqrtsd xmm14, xmm12 ;square the total of both sides
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output the hypotenuse
push qword 0
mov rax,1   ;mov rax,1 is used since 1 floating point register is being outputted
movsd xmm0, xmm14
mov rdi, answer
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the hypotenuse to driver.cpp
movsd xmm0, xmm14
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