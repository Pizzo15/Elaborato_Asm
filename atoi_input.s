.section .data
car:
	.long 0

.section .text

.global atoi_input

.type atoi_input, @function	# funzione che converte una stringa di caratteri da tastiera delimitata 				# da '\n' in un numero che viene restituito in eax

atoi_input:
	pushl %ebx		# salva in stack i valori dei registri ebx, ecx, edx
	pushl %ecx
	pushl %edx
	xorl %eax, %eax		# azzera eax

inizio:
	pushl %eax		# salva in stack eax

	movl $3, %eax		# system call read: lettura del prossimo carattere inserito da tastiera
	xorl %ebx, %ebx
	leal car, %ecx
	movl $1, %edx
	int $0x80

	cmp $10, car		# controlla se il carattere letto è uguale a "\n"
	je fine			# se si finisce
	
	subb $48, car		# converte il codice ascii della cifra nel numero corrispondente
	popl %eax		# spila il valore memorizzato finora in eax

	movl $10, %ebx		# ebx = 10
	mull %ebx		# eax = eax * 10 (ebx)

	addl car, %eax		# aggiunge l'ultimo valore letto nella posizione meno significativa di 					# eax
	jmp inizio		# ripete il ciclo di lettura

fine:
	popl %eax		# salva in eax il valore letto

	popl %edx		# ripristina il valore degli altri registri
	popl %ecx
	popl %ebx
	ret
