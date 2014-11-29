		;*******************************************
		; Sergio Garcia Prado
		; Oscar Fernandez Angulo
		; Funcion calculo.
		;*******************************************
extern x,y

global calculo

segment .data
	cerocinco dq 0.5

segment .bss
	dividendo resq 1
	divisor resq 1
	xlog2e  resq 1
	parte_entera  resq 1
	entero  resq 1
	exponencial  resq 1

segment .text

calculo:

	finit

		;*******************************************
		; Calcula el valor absoluto de x
		; y si este es mayor que 1 salta al
		; bloque de codigo else_part
		; Nota: hay que mover los bits C a flags
		;*******************************************
	fld qword[x]
	fabs
	fld1
	fcompp
	fstsw ax		
	sahf	
	jnae else_part
	
then_part:

		;*******************************************
		; Da el valor 1 a la y
		;*******************************************	
	fld1
	fstp qword [y]

	jmp next

else_part:

		;*******************************************
		; calcula xlog2e y lo copia a "xlog2e"
		;*******************************************
	fldl2e
	fmul qword[x]
	fst qword [xlog2e]

		;*******************************************
		; resta 0,5 para que se redondee hacia abajo
		; y copia el valor en 'entero'
		;*******************************************
	fsub qword[cerocinco]
	frndint
	fst qword [entero]

		;*******************************************
		; calcula la parte entera del exponente
		; y la almacena en "parte_entera"
		;*******************************************
	fld1
	fscale
	fstp qword [parte_entera]

		;*******************************************
		; resta la parte entera para quedarse solo
		; la parte decimal 
		; y calcula el exponende de esta
		;*******************************************
	fld qword[xlog2e]
	fsub qword[entero]
	f2xm1
	fld1
	faddp st1, st0

		;*******************************************
		;multiplica la parte decimal
		;por la parte entera para tener
		;el exponencial completo, luego lo almacena
		;*******************************************
	fmul qword[parte_entera]
	fstp qword [exponencial]

		;*******************************************
		; calcula sinx 
		; y lo multiplica por el exponencial
		; despues lo almacena en dividendo
		;*******************************************
	fld qword[x]
	fsin
	fmul qword[exponencial]
	fstp qword[dividendo]

		;*******************************************	
		;calcula la raiz de x²-1 
		;y lo almacena en divisor
		;*******************************************
	fld qword[x]
	fmul st0
	fld1
	fsubp st1, st0
	fsqrt 
	fstp qword [divisor]
	
		;*******************************************
		; carga el "dividendo"
		; lo divide entre el "divisor"
		; y lo almacena en "y"
		;*******************************************
	fld qword[dividendo]
	fdiv qword[divisor]
	fstp qword[y]

next:

	ret
