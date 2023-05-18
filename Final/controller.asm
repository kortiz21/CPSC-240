;****************************************************************************************************************************
;  Author name: Kevin Ortiz
;  Author email: keortiz@csu.fullerton.edu
;  Course and Section: CPSC240-13 Final
;  Today' Date: May 15 2023
;  CWID: 886097146
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration
extern printf
extern scanf
extern cos
extern atof

; declare max bytes for name
INPUT_SIZE equ 256

global controller

segment .data

prompt_sides db "Please enter the lengths of two sides of a triangle separated by ws: ",0
prompt_angle db "Please enter the size of the angle in degrees between the two sides: ",0
display_third_side db "The length of the third side is %1.4lf",10,0
display_begin_tics db "The time on the clock before the computation was %llu tics.",10,0
display_end_tics db "The time on the clock after the computation was %llu tics.",10,0
display_elapsed_time db "The elapsed time was %llu tics",10,0
display_frequency db "The frequency of the clock in this computer is %llu tics/sec.",10,0
confirm db "Thank you. You entered two sides %1.6lf and %1.6lf",10,0
bye db "Bye",10,0
float_form db "%lf",0
radian_conversion_constant dq 0.017453292519943295
nanoseconds dq 1000000000.0

segment .bss
; === Reserve bytes for cpu name =======================================================
cpu_info: resb INPUT_SIZE ; reserve 256 bytes

segment .text

controller:

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
;Block to prompt Please enter the lengths of two sides of a triangle separated by ws: 
push qword 0
mov rax,0
mov rdi, prompt_sides
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs two sides of a triangle
push qword 0
mov rax,0
mov rdi, float_form
mov rsi, rsp
call scanf
movsd xmm10, [rsp]
mov rdi, float_form
mov rsi, rsp
call scanf
movsd xmm11, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter the size of the angle in degrees between the two sides: 
push qword 0
mov rax,0
mov rdi, prompt_angle
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs angle in degrees
push qword 0
mov rax,0
mov rdi, float_form
mov rsi, rsp
call scanf
movsd xmm12, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to convert the number in degrees to a number in radians.
movsd xmm13, xmm12
mulsd xmm13, [radian_conversion_constant]
movsd xmm12, xmm13
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
;Block to calculate cos via <math.h>
push qword 0
mov rax, 0
movsd xmm0, xmm12
call cos
movsd xmm12, xmm0
pop rax

;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that computes the length of the third side
;c2  =  a2  +  b2  -  2ab*cos(angle opposite to side c in radians)
; initialize the constant value from int to float f0r 2
mov rax, 2
cvtsi2sd xmm15, rax ; convert int 2 into float
; calculate a2
movsd xmm13, xmm10
mulsd xmm10, xmm10
; calculate b2
movsd xmm14, xmm11
mulsd xmm11, xmm11
; calculate 2ab
mulsd xmm13, xmm14
mulsd xmm13, xmm15
; calculate 2ab*cos(angle opposite to side c in radians)
mulsd xmm12,xmm13
; calculate a2  +  b2  -  2ab*cos(angle opposite to side c in radians)
addsd xmm10, xmm11
subsd xmm10, xmm12
; caluclate sqrt(a2  +  b2  -  2ab*cos(angle opposite to side c in radians)) = c
sqrtsd xmm15, xmm10
movsd xmm0, xmm15
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
;Block to prompt The length of the third side is
push qword 0
mov rax,1
mov rdi, display_third_side
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The time on the clock before the computation was 
push qword 0
mov rax,0
mov rdi,display_elapsed_time
mov rsi, r14
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The time on the clock after the computation was
push qword 0
mov rax,0
mov rdi,display_elapsed_time
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
; Block to get the elapsed time
sub r13, r14
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The elapsed time was
push qword 0
mov rax,0
mov rdi,display_elapsed_time
mov rsi, r13
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get cpu brand name, model name and speed from local device via cpuid
;get CPU brand name
mov r15, 0x80000004
mov rax,r15
cpuid

mov [cpu_info],rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that converts the string to a float via atof
push qword 0
mov rax,0
mov rdi, cpu_info
call atof
movsd xmm15, xmm0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that converts the frequency of the clock from Ghz to tics/sec
mulsd xmm15, [nanoseconds] ; set xmm15 to nanoseconds in .data - nanoseconds dq 1000000000.0
cvtsd2si r15, xmm15
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt The frequency of the clock in this computer is tics/sec
push qword 0
mov rax,0
mov rdi,display_frequency
mov rsi, r15
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Bye
push qword 0
mov rax,0
mov rdi, bye
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the the frequency of the clock in this computer in tics/sec
mov rax, r15
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