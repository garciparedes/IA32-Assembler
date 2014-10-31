;Autores:
;   Sergio Garcia Prado
;   Oscar Fernández Angulo

segment .text
global interes

interes:
	push rbp
	mov rbp, rsp
	
	mov rdx, 0x00000ffff

;recupera el capital de la pila
	mov rax, qword[rbp+24]
	and rax, rdx

;recupera el redito
	mov rbx, qword[rbp+32]
	and rbx, rdx

;recupera el tiempo
	mov rcx, qword[rbp+40]
	and rcx, rdx

;calcula el interes
	imul rax, rbx	
	imul rax, rcx
	mov rdx, 0
	mov rbx, 100	
	idiv rbx
	
;introduce el resultado en la pila
	mov qword[rbp+16], rax

	pop rbp
	ret
