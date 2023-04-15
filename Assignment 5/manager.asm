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
extern sin

;extern isfloat

; declare max bytes for name
INPUT_SIZE equ 256

global manager

segment .data

welcome  db "This program Sine Function Benchmark is maintained by Kevin Ortiz",10,0
prompt_name db "Please enter your name: ",10,0
display_name db "It is nice to meet you ",0
prompt_angle db ". Please enter an angle number in degrees: ",10,0
;invalid_msg db "Invalid. Please try again:",10,0
prompt_terms db "Thank you. Please enter the number of terms in a Taylor series to be computed: ",10,0
display_thank_you db "Thank you. The Taylor series will be used to compute the sine of your angle.",10,0
display_tics db "The computation completed in %llu tics",0
display_computation db " and the computed value is %.9lf",10,0
display_challenge_msg_one db "Next the sine of %.9lf",0
display_challenge_msg_two db " will be computed by the function 'sin' in the library <math.h>.",10,0
display_challenge_tics db "The computation completed in %llu",0
display_challenge_computation db " tics and gave the value %.9lf",10,0
float_form db "%lf",0
int_form db"%d",0
radian_conversion_constant dq 0.017453292519943295

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

begin:
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

;the user's input is checked to see if it is a valid float value
;mov rax, 0
;mov rdi, rsp            ;passing user input stored at the top of the stack into the first parameter
;call isfloat               ;isfloat checks if the user entered a valid float value
;cmp rax, 0                  ;A condition is met if a valid float is entered it returns 1, else it returns 0
;je invalidInput     

;jmp exit

;invalidInput:
;A invalid message displays if the user did not input a valid float value
;mov rax, 0
;mov rdi, invalid_msg        ;"The last input was invalid and not entered into the array. "
;call printf
;jmp begin

;exit:
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
;Block to prompt Thank you. Please enter the number of terms in a Taylor series to be computed: 
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
mov rdi, int_form
mov rsi,rsp
call scanf
mov r15, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to convert the number in degrees to a number in radians.
movsd xmm6, xmm15 ; copy into xmm6 for challange portion of code
movsd xmm13, xmm15
mulsd xmm13, [radian_conversion_constant]
movsd xmm15, xmm13
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Thank you. The Taylor series will be used to compute the sine of your angle.
push qword 0
mov rax,0
mov rdi,display_thank_you
call printf
pop rax
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
;Block that the Taylor series will be used to compute the sine of your angle by applying the the angle in radians.

; first term of taylor series in sin is angle in radians from user
movsd xmm14, xmm15 ; xmm15 holds angle in radians, set to xmm14 (current term)

; initialize the constant values from int to float from [(-1 * x^2) / (2n+3 * 2n+2)]
mov rax, 3
cvtsi2sd xmm13, rax ; convert int 3 into float
mov rax, 2
cvtsi2sd xmm12, rax ; convert int 2 into float
mov rax, -1
cvtsi2sd xmm5, rax ; convert int -1 into float

mov r12, 0 ; counter for loop 
cvtsi2sd xmm11, r12 ; nth term of taylor series (xmm11)

beginLoop:
cmp r12, r15 ; compare counter to r15 (terms entered by user)
je exitLoop

addsd xmm10, xmm14 ; xmm10 will hold the total sum of the sequence, add current term xmm14

; compute the next term of the taylor sequence
; 2n+3
; creating temporary register for calculations xmm9
movsd xmm9, xmm12
mulsd xmm9, xmm11
addsd xmm9, xmm13
; 2n+2
; creating temporary register for calculations xmm8
movsd xmm8, xmm12
mulsd xmm8, xmm11
addsd xmm8, xmm12
; (2n+3) * (2n+2)
mulsd xmm8, xmm9
; x^2
; creating temporary register for calculations xmm7
movsd xmm7, xmm15
mulsd xmm7, xmm7
; (-1 * x^2) / ( (2n+3) * (2n+2) )
divsd xmm7, xmm8
mulsd xmm7, xmm5

; multiply the next term with the current term and set the current term to result
mulsd xmm14, xmm7

inc r12 ; increment counter
cvtsi2sd xmm11, r12 ; increment nth term of taylor series

jmp beginLoop

exitLoop:
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
;Block to prompt The computation completed in %llu tics
push qword 0
mov rax,0
mov rdi,display_tics
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

mov r12,r13 ; copy r13 for challenge portion

;--------------------------------------------------------------------
;Block to prompt and the computed value is %.9lf"
push qword 0
mov rax,1
mov rdi,display_computation
movsd xmm0,xmm10
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Next the sine of %.9lf
push qword 0
mov rax,1
mov rdi,display_challenge_msg_one
movsd xmm0,xmm6
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt will be computed by the function "sin" in the library <math.h>.
push qword 0
mov rax,0
mov rdi,display_challenge_msg_two
call printf
pop rax
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
;Block to calculate sin via <math.h>
push qword 0
mulsd xmm6, [radian_conversion_constant]
movsd xmm0, xmm6
call sin
movsd xmm15, xmm0
pop rax

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
;Block to prompt The computation completed in %llu tics
push qword 0
mov rax,0
mov rdi,display_challenge_tics
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt and gave the value %.9lf"
push qword 0
mov rax,1
mov rdi,display_challenge_computation
movsd xmm0,xmm15
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the tics to driver.c
mov rax, r12
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