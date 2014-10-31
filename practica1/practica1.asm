;Autores:
;   Sergio Garcia Prado
;   Oscar Fernández Angulo

segment .data

menCap	db "Introduzca el Capital", 10
menRed	db "Introduzca el Redito", 10
menTie	db "Introduzca el Tiempo",10

segment .bss

x resb 1

capital resb 64
redito resb 64
tiempo resb 64

capitaldec resb 64
reditodec resb 64
tiempodec resb 64
resultado resb 64

num resb 32


segment .text

extern interes
extern salida
global _start

_start:
	
;Escribe menCap
	mov eax, 4
	mov ebx, 1
	mov ecx, menCap
	mov edx, 22
	int 80h

;Recive Capital
;Numero hasta cuato cifras
	mov eax, 03
	mov ebx, 00
	mov ecx, capital
	mov edx, 32
	int 80h
	
	mov ecx, eax
	mov ebx, dword[capital]
	mov dword[num], ebx

	call ascii_bin

	mov dword[capitaldec],ebx
	

;Escribe menCap
	mov eax, 4
	mov ebx, 1
	mov ecx, menRed
	mov edx, 21
	int 80h

;Recive Redito
;Numero hasta cuato cifras
	mov eax, 03
	mov ebx, 00
	mov ecx, redito
	mov edx, 32
	int 80h

	mov ecx, eax
	mov ebx, dword[redito]
	mov dword[num], ebx

	

	call ascii_bin
	
	mov dword[reditodec],ebx

;Escribe menTie
	mov eax, 4
	mov ebx, 1
	mov ecx, menTie
	mov edx, 21
	int 80h

;Recive Tiempo
;Numero hasta cuato cifras
	mov eax, 03
	mov ebx, 00
	mov ecx, tiempo
	mov edx, 32
	int 80h

	mov ecx, eax
	mov ebx, dword[tiempo]
	mov dword[num], ebx

	

	call ascii_bin
	mov dword[tiempodec],ebx

;intorduce capital, redito y tiempo a la pila
	push qword[capitaldec]
	push qword[reditodec]
	push qword[tiempodec]

;reserva un espacio vacio para resultado en la pila
	mov qword[resultado], 0
	push qword[resultado]

;llama al metodo intereses y guarda los resultados
	call interes	
	mov rbx, qword[rsp]
	mov qword[resultado], rbx
	
;cambia los valores de la pila de binario a ascii	
	mov rax, qword[capital]
	mov qword[rsp+8], rax
	
	mov rax, qword[redito]
	mov qword[rsp+16], rax
	
	mov rax, qword[tiempo]
	mov qword[rsp+24], rax

;llama al metodo que imprime los valores
	call salida


;finaliza el programa
	mov eax, 1
	mov ebx, 0
	int 80h
	

;Pasa lo que hay en num de ascii a bin
ascii_bin:
	mov ebx, 0
	sub ecx, 1
	mov eax, 0
	L1:
		;coge partes de "num" byte a byte
		mov dl,0
		mov dl, byte[num+eax]
		add eax, 1
		sub edx, 0x30
		
		;construye el numero con los digitos 
		imul ebx, 10
		add ebx, edx
		loop L1
	ret

