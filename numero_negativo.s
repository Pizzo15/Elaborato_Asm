.section .data

meno:
	.ascii "-"

.section .text

.global numero_negativo

.type numero_negativo, @function	# funzione che stampa il carattere "-" davanti a un numero se 						# questo è negativo

numero_negativo:
	cmp $0, %eax			# confronto eax e 0
	jge fine			# se il numero è positivo termino
	
	neg %eax			# se il numero è negativo lo nego e ottengo il suo opposto
	pushl %eax			# salvo in stack il valore numerico

	movl $4, %eax			# system call write: stampa il simbolo "-" ad indicare la 						# negatività del valore
	movl $1, %ebx
	leal meno, %ecx
	movl $1, %edx
	int $0x80
		
	popl %eax			# ripristino in eax il valore del Bias

fine:
	ret
