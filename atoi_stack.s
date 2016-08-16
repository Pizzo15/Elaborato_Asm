.section .data
car:
	.byte 0

.section .text

.global atoi_stack

.type atoi_stack, @function	# funzione che converte una stringa di carattere il cui indirizzo si 					# trova in eax e delimitata da un byte nullo in un numero restituito in 				# eax

atoi_stack:
	pushl %ebx		# salva in stack ebx, ecx, edx
	pushl %ecx
	pushl %edx
	movl %eax, %ecx		# sposta eax in ecx
	xorl %eax, %eax		# azzera eax
	xorl %edx, %edx		# azzera edx

inizio:
	xorl %ebx, %ebx		# azzera ebx
	mov (%ecx, %edx), %bl	# sposta 
	testb %bl, %bl		# controllo se è stato raggiunto il carattere 0 di fine stringa
	jz fine
	movb %bl, car
	subb $48, car		# converte il codice ascii della cifra nel numero corrispondente
	movl $10, %ebx
	pushl %edx		# salvo in stack edx: verrà modificato dalla mull
	mull %ebx		# eax = eax * 10
	popl %edx
	xorl %ebx, %ebx
	movb car, %bl		# copio car nel byte meno significativo di ebx
	addl %ebx, %eax		# eax = eax + ebx
	incl %edx
	jmp inizio

fine:
	popl %edx		# ripristino i valori dei registri edx, ecx, ebx
	popl %ecx
	popl %ebx
	ret
