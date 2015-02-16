		;*******************************************
		; Sergio Garcia Prado
		; Oscar Fernandez Angulo
		; Funcion dftsse.
		;*******************************************

extern lista

global dftsse

segment .data
	quinientosDoce dq 512
	menosUno dq -1

segment .bss
	aux resq 1
	real  resq 1
	imaginario  resq 1
	p resq 1

segment .text

dftsse:

	mov ecx, 1024
	; ecx es j

	
	loop_j:
		;guardamos la j
		mov eax, ecx
		;ecx es k
		mov ecx, 1024

		loop_k:

			;restamos uno a j y k  			
			mov rbx, rcx
			add ebx, -1
			mov rdx, rax
			add edx, -1

			;multiplicamos j*k
			imul rbx, rdx
	
			;metemos j*k a la pila 
			mov qword[aux], rbx			
			fild qword[aux]	

			;dividimos j*k/512
			fild qword[quinientosDoce]
			fdivp st1, st0

			;cambiamos de signo la expresion anterior
			fild qword[menosUno]
			fmulp st1, st0

			;y finalmente la multiplicamos por pi
			fldpi
			fmulp st1, st0

			;calculamos el coseno de -(j*k/512) y lo guardamos en memoria bajo el nombre de "real"
			fstp qword[p]
			fld qword[p]
			fcos
			fstp qword[real]
			
			;calculamos el seno de -(j*k/512) y lo guardamos en memoria bajo el nombre de "imaginario"
			fld qword[p]
			fsin
			fstp qword[imaginario]
			
			;calculamos la direccion del primer elemento (X real) de la fila que nos corresponde y la guardamos el el registro edx
			mov edx, ecx
			add edx, -1
			sal edx, 5
			
			;calculamos la direccion de la fila donde se encuentra la j que hay que guardar y la guardamos el el registro ebx
			mov ebx, eax
			add ebx, -1
			sal ebx, 5
			
			
			;metemos en xmm0 (Xk real, Xk real)
			movhpd xmm0, [lista+edx]
			movlpd xmm0, [lista+edx]
			
			;metemos en xmm1 (imaginario, real)
			movhpd xmm1, [imaginario]
			movlpd xmm1, [real]
			
			;metemos en xmm2 (Xk imaginario, Xk imaginario)
			movhpd xmm2, [lista+edx+8]
			movlpd xmm2, [lista+edx+8]
			
			;metemos en xmm3 (real, imaginario)
			movhpd xmm3, [real]
			movlpd xmm3, [imaginario]
			
			;guardamos en xmm4 (Fj real,Fj imaginario)
			movhpd xmm4, [lista+ebx+24]
			movlpd xmm4, [lista+ebx+16]

			;operamos con los registros para optener una parte del sumatorio que compone cada f, la parte imaginaria quedaria en la parte mas alta del registro xmm0 y la real en la mas baja
			mulpd xmm0, xmm1
			mulpd xmm2, xmm3
			addsubpd xmm0, xmm2
			addpd xmm0, xmm4

			;guardamos los resultados en su posicion del array
			movhpd [lista+ebx+24], xmm0
			movlpd [lista+ebx+16], xmm0
			

			dec ecx
			jnz loop_k


		mov ecx, eax
		dec ecx
		jnz loop_j

ret


