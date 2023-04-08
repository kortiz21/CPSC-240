;****************************************************************************************************************************
;Program name: "Executive".  This program will generate up to 100 random number using the non-deterministic random number   *
;generator found inside of modern X86 microprocessors.   Initially random numbers are generated that extend throughout the  *
;entire space of all 64-bit IEEE754 numbers.Later the random numbers are restricted to the interval 1.0 <= Number < 2.0 or  * 
;even intervals such as 1.0 <= number < M, where is a predetermined fixed upper limit..                                     *
;Copyright (C) 2023 Kevin Ortiz.                                                                                            *
;                                                                                                                           *
;This file is part of the software program "Executive".                                                                     *
;Executive is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License     *
;version 3 as published by the Free Software Foundation.                                                                    *
;Executive is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied            *
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
;  Program name: Executive
;  Programming languages: two modules in C and four modules in X86
;  Date program began: 2023 Mar 9
;  Date of last update: 2023 Mar 9
;  Comments reorganized: 2023 Mar 9
;  Files in this program: main.c, executive.asm, quick_sort.c, fill_random_array.asm, show_array.asm, isnan.asm, r.sh, rg.sh
;  Status: Complete. Program was tested extensively with no errors.
;
;Purpose
;  This program will manage user input for name, title and number of random 64-bit numbers and manage all files
;
;This file
;   File name: executive.asm
;   Language: x86-64
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l executive.lis -o executive.o executive.asm
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================


;===== Begin code area ===========================================================================================================

;Declaration
extern isnan

global fill_random_array

segment .data

segment .bss

segment .text

fill_random_array:

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
beginLoop:  ; begin of loop
    cmp r13,r14
    jge exitLoop

    rdrand rbx  ; generate rnandom number into rbx

    mov rdi,rbx ; copy onto rdi to use in isnan function
    call isnan

    cmp rax,0
    jne beginLoop

    mov [r15 + 8*r13],rbx   ; insert random number after passing through isnan into array

    inc r13 ; increment loop
    jmp beginLoop
exitLoop:   ; exit loop

pop rax
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