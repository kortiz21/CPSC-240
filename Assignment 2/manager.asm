;****************************************************************************************************************************
;Program name: "Arrays".  This program will sum your array of 64-bit floats. 
;Copyright (C) 2023 Kevin Ortiz.                                                                            *
;                                                                                                                           *
;This file is part of the software program "Arrays".                                                                   *
;Arrays is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                    *
;Arrays is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
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
;  Program name: Arrays
;  Programming languages: two modules in C and four modules in X86
;  Date program began: 2023 Feb 16
;  Date of last update: 2023 Feb 16
;  Comments reorganized: 2023 Feb 16
;  Files in this program: main.c, display_array.c, manager.asm, magnitude.asm, append.asm, input_array.asm, r.sh
;  Status: Complete. Program was tested extensively with no errors.
;
;Purpose
;  This program will manage your array of 64-bit floats.
;
;This file
;   File name: manager.asm
;   Language: x86-64
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration
extern printf
extern scanf
extern magnitude
extern append
extern input_array
extern display_array

global manager

segment .data

welcome  db "This program will manage your arrays of 64-bit floats.",10,0
prompt_array_A db "For array A enter a sequence of 64-bit floats seperated by white space.",10,0
prompt_array_B db "For array B enter a sequence of 64-bit floats seperated by white space.",10,0
control_D db "After the last input press enter followed by Control+D",10,0
display_array_A db "These numbers were received and placed into array A",10,0
display_array_B db "These numbers were received and placed into array B",10,0
display_mag_A db "The magnitude of array A is %1.5lf",10,0
display_mag_B db "The magnitude of array B is %1.5lf",10,0
display_AandB db "A⊕ B contains",10,0
display_mag_AandB db "The magnitude of A⊕ B is %1.5lf",10,0
display_append db "Arrays A and B have been appended and given the name A⊕ B.",10,0

segment .bss
arrayA resq 6
arrayB resq 6
arrayAB resq 12

segment .text

manager:

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
;Block to explain what program does
push qword 0
mov rax,0
mov rdi,welcome
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt array A input
push qword 0
mov rax,0
mov rdi,prompt_array_A
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt control+D
push qword 0
mov rax,0
mov rdi,control_D
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs sequence of 64-bit floats into array A
push qword 0
mov rax,0
mov rdi,arrayA; pass in array A as 1st parameter
mov rsi,6; pass in array size as 2nd parameter
call input_array
mov r15, rax
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that outputs sequence of 64-bit floats
push qword 0
mov rax,0
mov rdi,display_array_A
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that displays via display_array.c
push qword 0
mov rax,0
mov rdi,arrayA
mov rsi,r15
call display_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that computes magnitude via magnitude.asm
push qword 0
mov rax,0
mov rdi,arrayA
mov rsi,6
call magnitude
movsd xmm15,xmm0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output the magnitude of array A
push qword 0
mov rax,1
mov rdi,display_mag_A
movsd xmm0,xmm15
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt array B input
push qword 0
mov rax,0
mov rdi,prompt_array_B
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt control+D
push qword 0
mov rax,0
mov rdi,control_D
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs sequence of 64-bit floats into array B
push qword 0
mov rax,0
mov rdi,arrayB; pass in array B as 1st parameter
mov rsi,6; pass in array size as 2nd parameter
call input_array
mov r14,rax
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that outputs sequence of 64-bit floats
push qword 0
mov rax,0
mov rdi,display_array_B
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that displays via display_array.c
push qword 0
mov rax,0
mov rdi,arrayB
mov rsi,r15
call display_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that computes magnitude via magnitude.asm
push qword 0
mov rax,0
mov rdi,arrayB
mov rsi,6
call magnitude
movsd xmm15,xmm0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output the magnitude of array B
push qword 0
mov rax,1
mov rdi,display_mag_B
movsd xmm0,xmm15
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt array A and array B have been appended
push qword 0
mov rax,0
mov rdi,display_append
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt array AB contains
push qword 0
mov rax,0
mov rdi,display_AandB
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to append array A and array B to array AB
push qword 0
;mov rax,0
mov rdi,arrayA ; pass array A
mov rsi,arrayB ; pass array B
mov rdx,arrayAB ; pass array AB
mov rcx,r15 ; pass size of array A
mov r8,r14 ; pass size of array B
call append
mov r15, rax
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that displays array AB via display_array.c
push qword 0
mov rax,0
mov rdi,arrayAB
mov rsi,r15
call display_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to calculate the magnitude of array AB
push qword 0
mov rax,0
mov rdi,arrayAB
mov rsi,r15
call magnitude
movsd xmm15,xmm0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to display the magnitude of array AB
push qword 0
mov rax,1
mov rdi,display_mag_AandB
movsd xmm0,xmm15
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the magnitude to main.c
movsd xmm0,xmm15
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