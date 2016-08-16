.section .data
car:
	.byte 0

.section .text

.global itoa

.type itoa, @function		# funzione che converte un intero contenuto in eax in una stringa e la 					# stampa a video

itoa:
	mov $0, %ecx		# carica 0 in ecx

continua_a_dividere:
	cmp $10, %eax		# confronta 10 con il contenuto di eax
	jge dividi		# se eax è >= 10 salta a dividi
	pushl %eax		# salva in cima allo stack eax
	inc %ecx		# incrementa ecx di 1 unità
				# conta quante push eseguo
				# ad ogni push salvo nello stack una cifra del numero
	mov %ecx, %ebx		# sposta in ebx il valore di ecx
	jmp stampa		# salta all'etichetta stampa

dividi:
	movl $0, %edx		# carica 0 in edx
	movl $10, %ebx		# carica 10 in ebx
	divl %ebx		# divide per 10 (ebx) il numero ottenuto concatenando dx e ax
				# il quoziente viene messo in eax, il resto in dx
	pushl %edx		# salva il resto nello stack
	inc %ecx		# incrementa il contatore delle cifre da stampare
	jmp continua_a_dividere	# salta all'etichetta continua_a_dividere

stampa:
	cmp $0, %ebx		# controlla se ci sono ancora caratteri da stampare
	je fine_itoa		# se ho finito di stampare (ebx=0) salto alla fine
	popl %eax		# prelevo l'elemento da stampare dallo stack
	movb %al, car		# memorizza nella variabile car il valore contenuto negli 8 bit
				# meno significativi di eax
	addb $48, car		# somma a car il codice ascii del carattere '0'
	dec %ebx		# decremento il numero di cifre da stampare
	pushw %bx		# salvo bx nello stack
	movl $4, %eax		# system call write: stampa il carattere salvato nella variabile car
	movl $1, %ebx
	leal car, %ecx
	mov $1, %edx
	int $0x80
	popw %bx		# ripristina il contatore dei caratteri da stampare
	jmp stampa		# salta all'etichetta stampa per stampare il prossimo carattere

fine_itoa:
	movb $10, car		# copia il codice ascii del carattere '\n' nella variabile car
	movl $4, %eax		# system call write: stampa il carattere new line per andare a capo
	movl $1, %ebx
	leal car, %ecx
	mov $1, %edx
	int $0x80
	ret
