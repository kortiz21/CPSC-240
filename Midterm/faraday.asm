;****************************************************************************************************************************
;  Author name: Kevin Ortiz
;  Author email: keortiz@csu.fullerton.edu
;  Course and Section: CPSC240-13
;  Today' Date: Mar 22 2023
;  CWID: 886097146
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


;===== Begin code area ===========================================================================================================

;Declaration
extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern getchar

; declare max bytes for last_name, title 
INPUT_SIZE equ 256

global faraday

segment .data

prompt db "This program will help discover your work.",10,0
prompt_voltage db "Please enter the voltage applied to your electric device: ",0
prompt_resistance db "Please enter the electric resistance found in your device: ",0
prompt_time db "Please enter the time in seconds when your electric device was running: ",0
prompt_last_name db "What is your last name? ",0
prompt_title db "What is your title? ",0
thank_you_message db "Thank you ",0
work_message db ". The work performed by your device was %1.10lf joules.",10,0
goodbye db "Good-bye ",0
float_form db "%lf",0
space db " ",0
newline db "", 10, 0

segment .bss
last_name: resb INPUT_SIZE ; Reserve 256 bytes
title: resb INPUT_SIZE ; Reserve 256 bytes

segment .text

faraday:

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
;Block to prompt This program will help discover your work.
push qword 0
mov rax,0
mov rdi, prompt
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter the voltage applied to your electric device
push qword 0
mov rax,0
mov rdi, prompt_voltage
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs voltage from scanf in float form
push qword 0
mov rax,0
mov rdi, float_form
mov rsi,rsp
call scanf
movsd xmm10, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter the electric resistance found in your device
push qword 0
mov rax,0
mov rdi, prompt_resistance
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs electric resistance from scanf in float form
push qword 0
mov rax,0
mov rdi, float_form
mov rsi,rsp
call scanf
movsd xmm11, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Please enter the time in seconds when your electric device was running
push qword 0
mov rax,0
mov rdi, prompt_time
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that inputs time in seconds when electric device from scanf in float form
push qword 0
mov rax,0
mov rdi, float_form
mov rsi,rsp
call scanf
movsd xmm12, [rsp]
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that calls getchar to clear error when using scanf then fgets since it gets \n char
push qword 0
call getchar
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt What is your last name?
push qword 0
mov rax,0
mov rdi,prompt_last_name
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get last name using fgets, pass in last name and the number of reserved bytes
push qword 0
mov rax, 0
mov rdi, last_name
mov rsi, INPUT_SIZE
mov rdx, [stdin]
call fgets
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get string length via strlen and replacing '\n' with '\0'
push qword 0
mov rax, 0
mov rdi, last_name
call strlen
sub rax, 1
mov byte [last_name + rax], 0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt What is your title?
push qword 0
mov rax,0
mov rdi,prompt_title
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get title using fgets, pass in title and the number of reserved bytes
push qword 0
mov rax, 0
mov rdi, title
mov rsi, INPUT_SIZE
mov rdx, [stdin]
call fgets
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to get string length via strlen and replacing '\n' with '\0'
push qword 0
mov rax, 0
mov rdi, title
call strlen
sub rax, 1
mov byte [title + rax], 0
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block that compute W (Work) in joules via W = P * T = [(R * I) * I] * T
divsd xmm10, xmm11  ; divide voltage by resistance to get I
movsd xmm13, xmm10  ; copy I into new register

mulsd xmm11, xmm13  ; compute I * R which is voltage V
mulsd xmm11, xmm13  ; compute  V * I which is power P
mulsd xmm11, xmm12  ; compute P * T which is work W
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Thank you (title)
push qword 0
mov rax,0
mov rdi, thank_you_message
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output title entered
push qword 0
mov rax,0
mov rdi, title
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output thank you message and the work in joules
push qword 0
mov rax,1
movsd xmm0, xmm11
mov rdi, work_message
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to prompt Good-bye (title) (last_name)
push qword 0
mov rax,0
mov rdi, goodbye
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output title entered
push qword 0
mov rax,0
mov rdi, title
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output one space
push qword 0
mov rax,0
mov rdi, space
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output last_name entered
push qword 0
mov rax,0
mov rdi, last_name
call printf
pop rax
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Block to output last_name entered
push qword 0
mov rax,0
mov rdi, newline
call printf
pop rax
;--------------------------------------------------------------------

pop rax

;--------------------------------------------------------------------
;Block to output the work in joules to ampere.cpp
movsd xmm0, xmm11
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