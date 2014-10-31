;Autores:
;   Sergio Garcia Prado
;   Oscar Fernández Angulo

segment .data

menCapi	db "Capital: "
menRedi	db "Redito: "
menTiem	db "Tiempo: "
menInte	db "Intereses: "

segment .bss

capital resb 64
redito resb 64
tiempo resb 64
intereses resb 64

num resb 32
numeroascii resb 64
interesNum resb 64


segment .text
global salida

salida:
	push rbp
	mov rbp, rsp
	
;imprime menCapi
	mov eax, 4
	mov ebx, 1
	mov ecx, menCapi
	mov edx, 9
	int 80h

;recupera el capital de la pila
	mov rax, qword[rbp+24]
	mov qword[capital], rax
	
	call caracteres
	mov qword[num], rsi

;imprime el capital
	mov eax, 4
	mov ebx, 1
	mov ecx, capital
	sub dword[num], 1
	mov edx, num
	int 80h
	

;imprime menRedi
	mov eax, 4
	mov ebx, 1
	mov ecx, menRedi
	mov edx, 8
	int 80h

;recupera el redito de la pila
	mov rax, qword[rbp+32]
	mov qword[redito], rax

	call caracteres
	mov qword[num], rsi

;imprime el redito
	mov eax, 4
	mov ebx, 1
	mov ecx, redito
	sub dword[num], 1
	mov edx, num
	int 80h


;imprime menTiem
	mov eax, 4
	mov ebx, 1
	mov ecx, menTiem
	mov edx, 8
	int 80h

;recupera el tiempo de la pila
	mov rax, qword[rbp+40]
	mov qword[tiempo], rax

	call caracteres
	mov qword[num], rsi

;imprime el tiempo
	mov eax, 4
	mov ebx, 1
	mov ecx, tiempo
	sub dword[num], 1
	mov edx, num
	int 80h


;imprime menInte
	mov eax, 4
	mov ebx, 1
	mov ecx, menInte
	mov edx, 11
	int 80h

;recupera el interes de la pila
	mov rax, qword[rbp+16]
	mov qword[intereses], rax
	
	call caracteres
	mov rcx, rsi
	mov qword[interesNum], rsi
	
	mov rdx, 0
	mov rsi, 10
	mov ebx, 0
	mov rax, qword[intereses]

;pasa el interes a ascii
	L3:
		idiv rsi
		add rdx, 0x30
		mov byte[numeroascii+ecx], dl
		mov edx,0
		loop L3
	
;imprime el interes
	mov rax, 4 
	mov rbx, 1 
	mov rcx, numeroascii
	mov rdx, interesNum
	int 80h 

	pop rbp
	ret

;cuenta el numero de caracteres que tiene una palabra
caracteres:
	mov ebx, 10
	mov rsi, 0
	L2:
		mov edx, 0
		p1:
		idiv ebx
		p2:
		add rsi, 1
		
		mov ecx, eax	
		add ecx, 1
		loop L2
	ret



	
