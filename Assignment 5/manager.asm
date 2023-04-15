;****************************************************************************************************************************
;Program name: "Data Validation". This program will validate incoming numbers and performance comparison of two versions 
;of the sine function
;Copyright (C) 2023 Kevin Ortiz.                                                                            *
;                                                                                                                           *
;This file is part of the software program "Data Validation".                                                                   *
;Data Validation is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                    *
;Data Validation is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
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
;  Program name: Data Validation
;  Programming languages: one module in C and one modules in x86
;  Date program began: 2023 April 14
;  Date of last update: 2023 April 14
;  Comments reorganized: 2023 April 14
;  Files in this program: driver.c, manager.asm, r.sh
;  Status: Complete. Program was tested extensively with no errors.
;
;Purpose
;  This program will manage the Data Validation program
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

; extern c functions
extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern getchar

; declare max bytes for name
INPUT_SIZE equ 256

global manager

segment .data

welcome  db "This program Sine Function Benchmark is maintained by Kevin Ortiz",10,0
prompt_name db "Please enter your name: ",10,0
display_name db "It is nice to meet you ",0
prompt_angle db " .Please enter an angle number in degrees: ",10,0
prompt_terms db "Thank you.  Please enter the number of terms in a Taylor series to be computed: ",10,0
prompt_thank_you db "Thank you.  The Taylor series will be used to compute the sine of your angle.",10,0
display_tics db "The computation completed in %llu tics",0
display_computation " and the computed value is %.9lf",10,0
float_form db "%lf",0

segment .bss
; === Reserve bytes for array, name, title, and request_number =======================================================
name: resb INPUT_SIZE ; Reserve 256 bytes

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
;Block to prompt This program Sine Function Benchmark is maintained by Kevin Ortiz
push qword 0
mov rax,0
mov rdi,welcome
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter your name:
push qword 0
mov rax,0
mov rdi,prompt_name
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get user name using fgets, pass in name and the number of reserved bytes
push qword 0
mov rax, 0
mov rdi, name
mov rsi, INPUT_SIZE
mov rdx, [stdin]    ; read in a line
call fgets
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get string length via strlen and replacing '\n' with '\0'
push qword 0
mov rax, 0
mov rdi, name
call strlen ; get length of string
sub rax, 1  ; account for \n
mov byte [name + rax], 0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt It is nice to meet you
push qword 0
mov rax,0
mov rdi, display_name
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt name of user
push qword 0
mov rax,0
mov rdi,name
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter an angle number in degrees:
push qword 0
mov rax,0
mov rdi,prompt_angle
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs an angle number in degrees
push qword 0
mov rax,0
mov rdi, float_form
mov rsi,rsp
call scanf
movsd xmm15, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that calls getchar to clear error when using scanf then fgets since it gets \n char
push qword 0
call getchar
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter an angle number in degrees:
;push qword 0
;mov rax,1
;mov rdi,float_form
;movsd xmm0, xmm15
;call printf
;pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Thank you.  Please enter the number of terms in a Taylor series to be computed: 
push qword 0
mov rax,0
mov rdi,prompt_terms
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs the number of terms in a Taylor series
push qword 0
mov rax,0
mov rdi, float_form
mov rsi,rsp
call scanf
movsd xmm14, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to convert the number in degrees to a number in radians.
;      Then apply the Taylor series to the number in radians.
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get the time in tics START
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r14, rdx
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that the Taylor series will be used to compute the sine of your angle

;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get the time in tics END
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r13, rdx
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block to get the elapsed time
sub r13, r14
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The computation completed in %llu tics and the computed value is %.9lf"
push qword 0
mov rax,0
mov rdi,display_tics
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt and the computed value is %.9lf"
push qword 0
mov rax,1
mov rdi,display_computation
movsd xmm0,xmm15
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the tics to driver.c
mov rax, r13
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