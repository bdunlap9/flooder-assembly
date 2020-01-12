; Weeke's -> UDP Flooder (Assembly)

section .data   ; Constant Data
        getIPMsg db 'Enter IP: '                                               ; Get IP Input
        lenGetIPMsg equ $-getIPMsg                                             ; Get Length of input

        getPortMsg db 'Enter Port: '                                           ; Get Port Input
        lenGetPortMsg equ $-getPortMsg                                         ; Get Length of input

        getTimeMsg db 'Enter Time: '                                           ; Get Time Input
        lenGetTimeMsg equ $-getTimeMsg                                         ; Get Length of Input

        msg db "[Weeke's] -> UDP Flooder v1.0", 0xa                            ; String To Be Printed
        len equ $ - msg                                                        ; Get Length of String

        test db 'test message for loop', 0xa
        len equ $ - test

section .bss
        internet_protocol resb 16
        port resb 6
        time resb 25

section .text
        global _start

_start:                                                                         ; User Prompt
        ; Display Banner
        mov edx, len                                                            ; Message Length
        mov ecx, msg                                                            ; Message to write
        mov ebx, 1                                                              ; File Descriptor (stdout)
        mov eax, 4                                                              ; Call Sys_Write
        int 80h                                                                 ; Call Kernel

        ; Get IP input
        mov eax, 4
        mov ebx, 1
        mov ecx, getIPMsg
        mov edx, lenGetIPMsg
        int 80h                                                                 ; Call Kernal

        ; Read and Store user input for internet_protocol
        mov eax, 3
        mov ebx, 1
        mov ecx, internet_protocol
        mov edx, 16                                                             ; Stores length of string
        int 80h                                                                 ; Call Kernal

        ; Get Port Input
        mov eax, 4
        mov ebx, 1
        mov ecx, getPortMsg
        mov edx, lenGetPortMsg
        int 80h                                                                 ; Call Kernal

        ; Read and Store user input for Port
        mov eax, 3
        mov ebx, 0
        mov ecx, port
        mov edx, 5                                                              ; Stores length of string
        int 80h                                                                 ; Call Kernal

        ; Get Time Input
        mov eax, 4
        mov ebx, 1                                                              ; Standard Output (print to terminal)
        mov ecx, getTimeMsg
        mov edx, lenGetTimeMsg
        int 80h                                                                 ; Call Kernal

        ; Read and Store user input for Time
        mov eax, 3
        mov ebx, 2
        mov ecx, time
        mov edx, 25                                                             ; Stores length of string
        int 80h                                                                 ; Call Kernal

        ; Craft UDP Packet


        ; Loop for var time
        mov ecx, time
        l1:                                                                     ; Body of Loop
           ; Send Crafted UDP packet till time var ends from loop
           mov edx, len                                                         ; Message Length
           mov ecx, test                                                        ; Message to write
           mov ebx, 1                                                           ; File Descriptor (stdout)
           mov eax, 4                                                           ; Call Sys_Write
           int 80h                                                              ; Call Kernel
        loop l1                                                                 ; Start Loop

        ; Exit(0)
        mov eax, 1                                                              ; Call Sys_Exit
        mov ebx, 0                                                              ; Read from standard input
        int 80h                                                                 ; Call Kernal
