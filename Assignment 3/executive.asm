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

;Declaration
; extern c functions
extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern qsort
; extern modules
extern quick_sort
extern fill_random_array
extern show_array

; declare max bytes for name, title and request_number
INPUT_SIZE equ 256

global executive

segment .data
ask_name  db "Please enter your name:",0
ask_title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc):",0
welcome db "Nice to meet you ",0
space db " ", 0
newline db "", 10, 0
program_description db "This program will generate 64-bit IEEE float numbers.",10,0
ask_request_number db "How many numbers do you want.  Today's limit is 100 per customer.",10,0
new_number db "Request no accepted, please enter a number at or within range of 0-100",10,0
storing_number db "Your numbers have been stored in an array.  Here is that array.",10,0
header db "IEEE754            Scientific Decimal",10,0
sorting db "The array is now being sorted.",10,0
update db "Here is the updated array.",10,0
normalize db "The random numbers will be normalized. Here is the normalized array",10,0
goodbye1 db "Good bye ",0
goodbye2 db ". You are welcome any time.",10,0
int_form db "%d",0

segment .bss
; === Reserve bytes for array, name, title, and request_number =======================================================

array: resq 100 ; Reserve 100 qwords
name: resb INPUT_SIZE ; Reserve 256 bytes
title: resb INPUT_SIZE ; Reserve 256 bytes
request_number: resb INPUT_SIZE ; Reserve 256 bytes

segment .text 

executive:

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
;Block to prompt Please enter your name:
push qword 0
mov rax,0
mov rdi,ask_name
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
;Block to prompt Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc):
push qword 0
mov rax,0
mov rdi,ask_title
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get user title using fgets, pass in title and the number of reserved bytes
push qword 0
mov rax, 0
mov rdi, title
mov rsi, INPUT_SIZE
mov rdx, [stdin]
call fgets
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get string length and replacing '\n' with '\0'
push qword 0
mov rax, 0
mov rdi, title
call strlen
sub rax, 1
mov byte [title + rax], 0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Nice to meet you
push qword 0
mov rax,0
mov rdi,welcome
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt title of user
push qword 0
mov rax,0
mov rdi,title
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt space between user and title
push qword 0
mov rax,0
mov rdi,space
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
;Block to prompt new line
push qword 0
mov rax,0
mov rdi,newline
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt This program will generate 64-bit IEEE float numbers.
push qword 0
mov rax,0
mov rdi,program_description
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt How many numbers do you want.  Today’s limit is 100 per customer.
push qword 0
mov rax,0
mov rdi,ask_request_number
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs number of 64-bit random numbers user wants
check:
push qword 0
mov rax,0
mov rdi, int_form
mov rsi,rsp
call scanf
mov r9, [rsp]   ; places requested number from top of stack into r9 to be used in program for array size
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that checks if user input for array size is legal (under or at 100)
cmp r9,100
jg not_within_range
cmp r9,0
jb not_within_range
jmp continue
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that prompts user to request a number within range 0 - 100
not_within_range:
push qword 0
mov rax,0
mov rdi,new_number
call printf
pop rax

jmp check
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Your numbers have been stored in an array.  Here is that array.
continue:
push qword 0
mov rax,0
mov rdi,storing_number
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to generate array of 64-bit number
push qword 0
mov rax,0
mov rdi,array   ; pass in array
mov rsi,r9  ; pass in array size
call fill_random_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt IEEE754 Scientific Decimal
push qword 0
mov rax,0
mov rdi,header
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that calls show_array to show array in hex and scientific notation
push qword 0
mov rax,0
mov rdi,array
mov rsi,r9
call show_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The array is now being sorted.
push qword 0
mov rax,0
mov rdi,sorting
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Here is the updated array.
push qword 0
mov rax,0
mov rdi,update
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to sort array of 64-bit numbers
push qword 0
mov rdi, array  ; pass in array
mov rsi, r9     ; pass in array size
mov rdx, 8      ; pass in byte size
mov rcx, quick_sort ; call quick_sort function to compare
call qsort
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt IEEE754 Scientific Decimal
push qword 0
mov rax,0
mov rdi,header
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that calls show_array to show array in hex and scientific notation
push qword 0
mov rax,0
mov rdi,array
mov rsi,r9
call show_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The random numbers will be normalized. Here is the normalized array
push qword 0
mov rax,0
mov rdi,normalize
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that will normalize the array from 1.0 <= number < 2
push qword 0
mov rax,0
mov r13, 0  ; index for loop
beginLoop:
cmp r13, r9
jge exitLoop

mov rbx, [array + 8*r13]
shl rbx,12
shr rbx,12
mov r8,1023
shl r8, 52
or rbx,r8
mov [array + 8*r13], rbx
inc r13
jmp beginLoop

exitLoop:
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to sort array of 64-bit numbers since normalized array wasn't sorted
push qword 0
mov rdi, array  ; pass in array
mov rsi, r9     ; pass in array size
mov rdx, 8      ; pass in byte size
mov rcx, quick_sort ; call quick_sort function to compare
call qsort
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt IEEE754 Scientific Decimal
push qword 0
mov rax,0
mov rdi,header
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that calls show_array to show array in hex and scientific notation
push qword 0
mov rax,0
mov rdi,array
mov rsi,r9
call show_array
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Good bye 
push qword 0
mov rax,0
mov rdi,goodbye1
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt title of user
push qword 0
mov rax,0
mov rdi,title
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt . You are welcome any time.
push qword 0
mov rax,0
mov rdi,goodbye2
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the name of user
mov rax,name
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