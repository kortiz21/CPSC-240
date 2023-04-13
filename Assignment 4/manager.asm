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
;  Programming languages: one modules in C and two modules in x86
;  Date program began: 2023 April 13
;  Date of last update: 2023 April 13
;  Comments reorganized: 2023 April 13
;  Files in this program: main.c, manager.asm, getradicand.asm, r.sh
;  Status: Complete. Program was tested extensively with no errors.
;
;Purpose
;  This program will manage the Benchmark program
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

;extern functions
extern printf
extern scanf

;extern modules
extern getradicand

; declare max bytes for cpu name
INPUT_SIZE equ 256

global manager

segment .data

welcome  db "Welcome to Square Root Benchmarks by Kevin Ortiz",10,0
customer_service db "For customer service contact me at keortiz@csu.fullerton.edu",10,0
display_cpu db "Your CPU is %s",10,0
prompt_max_clock_speed db "Enter your max clock speed in MHz:",10,0
display_max_clock_speed db "Your max clock speed is %d MHz",10,0
display_sqrt db "The square root of %.10lf is %.11lf.",10,0
prompt_iterations db "Next enter the number of times iteration should be performed:",10,0
display_clock db "The time on the clock is %llu tics",10,0
display_progress db "The bench mark of the sqrtsd instruction is in progress.",10,0
display_clock_and_bench db "The time on the clock is %llu tics and the benchmark is completed.",10,0
display_elapsed_time db "The elapsed time was %llu tics",10,0
display_one_sqrt_time_ns db "The time for one square root computation is %.5lf tics which equals %.5lf ns.",10,0
int_form db "%d",0
float_form db "%lf",0
nanoseconds dq 1000000000.0


segment .bss
; === Reserve bytes for cpu name =======================================================
cpu_info: resb INPUT_SIZE ; reserve 256 bytes

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
;Block to prompt Welcome to Square Root Benchmarks by Kevin Ortiz
push qword 0
mov rax,0
mov rdi,welcome
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt For customer service contact me at keortiz@csu.fullerton.edu
push qword 0
mov rax,0
mov rdi,customer_service
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get cpu brand name, model name and speed from local device via cpuid
;get CPU brand name
mov r15, 0x80000002
mov rax,r15
cpuid

mov [cpu_info],rax
mov [cpu_info + 4],rbx
mov [cpu_info + 8],rcx
mov [cpu_info + 12],rdx

;get CPU model name
mov r15, 0x80000003
mov rax,r15
cpuid

mov [cpu_info + 16],rax
mov [cpu_info + 20],rbx
mov [cpu_info + 24],rcx
mov [cpu_info + 28],rdx

;get CPU speed
mov r15, 0x80000004
mov rax,r15
cpuid

mov [cpu_info + 32],rax
mov [cpu_info + 36],rbx
mov [cpu_info + 40],rcx
mov [cpu_info + 44],rdx
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Your CPU is {CPU brand name, model name, speed}
push qword 0
mov rax,0
mov rdi,display_cpu
mov rsi,cpu_info
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Enter your max clock speed in MHz:
push qword 0
mov rax,0
mov rdi, prompt_max_clock_speed
mov rsi,rdx
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get max clock speed
push qword 0
mov rax,0
mov rdi, int_form
mov rsi,rsp
call scanf
mov r15, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Your max clock speed is {max clock speed} MHz
push qword 0
mov rax,0
mov rdi, display_max_clock_speed
mov rsi,r15
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to compute sqrt of radicand number
push qword 0
mov rax,0
call getradicand
movsd xmm15,xmm0 ; sqrt of radicand
movsd xmm14,xmm1 ; original user input
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The square root of {} is {}.
push qword 0
mov rax,2
mov rdi,display_sqrt
movsd xmm0,xmm14 ;movsd xmm0,xmm15
movsd xmm1,xmm15 ;movsd xmm1, xmm14
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Next enter the number of times iteration should be performed:
push qword 0
mov rax,0
mov rdi, prompt_iterations
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get number of iterations
push qword 0
mov rax,0
mov rdi, int_form
mov rsi,rsp
call scanf
mov r12, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get the time in tics START
;xor rax, rax
;xor rdx,rdx
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r14, rdx
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The time on the clock is %d tics
push qword 0
mov rax,0
mov rdi, display_clock
mov rsi, r14
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The bench mark of the sqrtsd instruction is in progress.
push qword 0
mov rax, 0
mov rdi, display_progress
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block to begin benchmark loop
mov r11, 0
beginLoop:
    cmp r11, r12
    je exitLoop

    sqrtsd xmm14, xmm15

    inc r11
    jmp beginLoop
exitLoop:
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get the time in tics END
;xor rax, rax
;xor rdx,rdx
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r13, rdx
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block that prompts The time on the clock is %d tics and the benchmark is completed.
push qword 0
mov rax, 0
mov rdi, display_clock_and_bench
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block to get the elapsed time
sub r13, r14
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block that prompts The elapsed time was %d tics
push qword 0
mov rax, 0
mov rdi, display_elapsed_time
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block that calculates tics per one compuation and converts it to nanoseconds
mov rax, r13 ; eplased time
cvtsi2sd xmm15, rax ; convert r13 to xmm register

mov rax,r12 ; iterations
cvtsi2sd xmm14,rax ; convert r12 to xmm register

divsd xmm15, xmm14 ; tics per one computation = eplased tics / iterations

movsd xmm0, xmm15 ; store tics per one computation in xmm0

imul r15, 1000000 ; convert MHz to Hz
mov rax, r15 ; max clock speed
cvtsi2sd xmm13, rax ; convert r15 to xmm register

movsd xmm10, [nanoseconds] ; set xmm10 to nanoseconds in .data - nanoseconds dq 1000000000.0

divsd xmm15, xmm13 ; tics per one computation / cpu speed

mulsd xmm15, xmm10 ; tics per second * nanoseconds
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block that prompts The time for one square root computation is %1.5lf tics which equals %1.5lf ns.
push qword 0
mov rax, 2
mov rdi, display_one_sqrt_time_ns
movsd xmm1, xmm15 ; store nanoseconds
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the nanoseconds to main.c
movsd xmm0, xmm15
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