; Weeke's -> TCP/UDP Flooder (Assembly)

section .data   ; Constant Data
        getIPMsg db 'Enter IP: '                                ; Get IP Input
        lenGetIPMsg equ $-getIPMsg                              ; Get Length of input

        getPortMsg db 'Enter Port: '                            ; Get Port Input
        lenGetPortMsg equ $-getPortMsg                          ; Get Length of input

        getTimeMsg db 'Enter Time: '                            ; Get Time Input
        lenGetTimeMsg equ $-getTimeMsg                          ; Get Length of Input

       ; getTypeMsg db 'Enter Flood Type (UDP or TCP): '         ; Get Type Input
       ; lenGetTypeMsg equ $-getTypeMsg                          ; Get Length of Input

section .bss
        num resb 100

section .text
        global _start

_start:                                          ; User Prompt
        mov eax, 4
        mov ebx, 1
        mov ecx, getIPMsg
        mov edx, lenGetIPMsg
        int 80h                                  ; Call Kernal

        mov eax, 4
        mov ebx, 1
        mov ecx, getPortMsg
        mov edx, lenGetPortMsg
        int 80h                                  ; Call Kernal

        mov eax, 4
        mov ebx, 1                               ; Standard Output (print to terminal)
        mov ecx, getTimeMsg
        mov edx, lenGetTimeMsg
        int 80h                                  ; Call Kernal

       ; mov eax, 4
       ; mov ebx, 1                               ; standard output (print to terminal)
       ; mov ecx, getTypeMsg
       ; mov edx, lenGetTpeMsg                    ; Call Kernal
       ; int 80h

        ; Read and Store user input
        mov eax, 3
        mov ebx, 2
        mov ecx, num
        mov edx, 5
        int 80h

        ; Exit(0)
        mov eax, 1                               ; Call Sys_Exit
        mov ebx, 0                               ; Read from standard input
        int 80h
