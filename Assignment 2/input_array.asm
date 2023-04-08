;****************************************************************************************************************************
;Program name: "Arrays".  This program will manage your array of 64-bit floats. 
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
;  Date program began: 2023 Feb 17
;  Date of last update: 2023 Feb 17
;  Comments reorganized: 2023 Feb 17
;  Files in this program: main.c, display_array.c, manager.asm, magnitude.asm, append.asm, input_array.asm, r.sh
;  Status: Complete. Program was tested extensively with no errors.
;
;Purpose
;  This program will input the contents from scanf into the array
;
;This file
;   File name: input_array.asm
;   Language: x86-64
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration
extern printf
extern scanf
extern stdin
extern clearerr

global input_array

segment .data

float_form db "%lf",0

segment .bss

segment .text

input_array:

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
;Block that inputs sequence of 64-bit floats
mov r15,rdi; copy array into r15
mov r14,rsi; copy array size into r14

mov r13,0 ; for loop counter

enterLoop:
    cmp r14,r13; exit loop when array size hits counter
    je exitLoop

    mov rax,0
    mov rdi,float_form
    push qword 0
    mov rsi,rsp
    call scanf
    cdqe    ; convert double quad extend
    cmp rax,-1 ; loop exit when ctrl+d entered
    pop r12

    je exitLoop
    mov [r15 + 8*r13],r12
    inc r13 ; loop increment
    jmp enterLoop
exitLoop:

;--------------------------------------------------------------------
;Block that fixes ctrl+d  error
mov rax,0
mov rdi, [stdin]
call clearerr

pop rax
mov rax,r13
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