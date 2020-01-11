; Weeke's -> TCP/UDP Flooder (Assembly)

section .data   ; Constant Data
        getIPMsg db 'Enter IP: '                                ; Get IP Input
        lenGetIPMsg equ $-getIPMsg                              ; Get Length of input

        getPortMsg db 'Enter Port: '                            ; Get Port Input
        lenGetPortMsg equ $-getPortMsg                          ; Get Length of input

        getTimeMsg db 'Enter Time: '                            ; Get Time Input
        lenGetTimeMsg equ $-getTimeMsg                          ; Get Length of Input

section .bss
        internet_protocol resb 25
        port resb 6
        time resb 25

section .text
        global _start

_start:                                          ; User Prompt
        ; Get IP input
        mov eax, 4
        mov ebx, 1
        mov ecx, getIPMsg
        mov edx, lenGetIPMsg
        int 80h                                  ; Call Kernal

        ; Read and Store user input for internet_protocol
        mov eax, 3
        mov ebx, 1
        mov ecx, internet_protocol
        mov edx, 5
        int 80h

        ; Get Port Input
        mov eax, 4
        mov ebx, 1
        mov ecx, getPortMsg
        mov edx, lenGetPortMsg
        int 80h                                  ; Call Kernal

        ; Read and Store user input for Port
        mov eax, 3
        mov ebx, 0
        mov ecx, port
        mov edx, 5
        int 80h

        ; Get Time Input
        mov eax, 4
        mov ebx, 1                               ; Standard Output (print to terminal)
        mov ecx, getTimeMsg
        mov edx, lenGetTimeMsg
        int 80h                                  ; Call Kernal

        ; Read and Store user input for Time
        mov eax, 3
        mov ebx, 2
        mov ecx, time
        mov edx, 5
        int 80h

        ; Exit(0)
        mov eax, 1                               ; Call Sys_Exit
        mov ebx, 0                               ; Read from standard input
        int 80h
