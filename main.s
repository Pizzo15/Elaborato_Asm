.section .data

count:
	.long 0

titolo:
	.ascii "-------------------------------------------\n Airbus A320 - Controllo inclinazione flap\n-------------------------------------------\n"
titolo_len:
	.long . - titolo

failure:
	.ascii "Failure controllo codice. Modalità safe inserita.\n"
failure_len:
	.long . - failure

errato:
	.ascii "Codice errato, inserire nuovamente il codice\n"
errato_len:
	.long . - errato

.section .text

.global _start
.align 4

_start:
	movl $4,%eax		# System call write: stampa il titolo del programma
	movl $1, %ebx
	leal titolo, %ecx
	movl titolo_len, %edx
	int $0x80

prima_lettura:
	pop %eax		# salvo in eax valore in cima allo stack (numero argomenti passati da 					# linea di comando)

	cmp $4, %eax		# confronto eax e 4(valore atteso)

	jne errore		# se il valore non corrisponde salto alla sezione errore
	
	pop %eax		# pop a vuoto: salto il nome del programma

fetch_332:
	pop %eax		# salvo in eax il valore del primo parametro

	call atoi_stack		# chiamata alla funzione atoi_stack

	cmpl $3, %eax		# confronto eax a 3
	jne fetch_992		# se eax!=3 passo a controllare la sequenza 9 9 2

	pop %eax		# parametro successivo in eax
	call atoi_stack		# leggo il parametro

	cmpl $3, %eax		# confronto eax a 3
	jne errore		# la sequenza non è 3 3: errore

	pop %eax		# parametro successivo in eax
	call atoi_stack		# leggo il parametro

	cmpl $2, %eax		# confronto eax a 2
	jne errore		# la sequenza non è 3 3 2: errore
	call controllo_dinamico	# se la sequenza inserita è 3 3 2 passo alla modalità controllo dinamico
	jmp fine		# termino
	
fetch_992:
	cmpl $9, %eax		# controllo se eax è 9
	jne errore		# la sequenza non inizia nè per 9 nè per 3: errore

	pop %eax		# parametro successivo in eax
	call atoi_stack		# leggo il parametro

	cmpl $9, %eax		# confronto eax e 9
	jne errore		# se la sequenza non è 9 9: errore

	pop %eax		# parametro successivo in eax
	call atoi_stack		# leggo il parametro

	cmpl $2, %eax		# confronto eax a 2
	jne errore		# se la sequenza non è 9 9 2: errore
	call controllo_emergenza# se la sequenza inserita è 9 9 2 passo alla modalità controllo emergenza
	jmp fine		# termino
	
seconda_lettura:
	call atoi_input		# lettura della sequenza digitata da tastiera
	
	cmp $272702, %eax	# confronto il valore letto con 3 3 2
	jne novenovedue		# se il valore non corrisponde passo a controllare la sequenza 9 9 2
	call controllo_dinamico	# se la sequenza inserita è 3 3 2 passo alla modalità controllo dinamico

novenovedue:
	cmp $333302, %eax	# confronto il valore letto con 9 9 2
	jne errore		# se il valore non corrisponde segnalo errore
	call controllo_emergenza# se la sequenza inserita è 9 9 2 passo alla modalità controllo emergenza
	jmp fine		# termino

errore:	
	incl count		# incremento il contatore degli errori
	cmp $3, count		# confronto il contatore con 3
	je failure_message	# se il n° di errori consecutivi è 3 segnalo una failure e termino

	movl $4, %eax		# system call write: stampa un messaggio di errore nell'inserimento 					# della sequenza 
	movl $1, %ebx
	leal errato, %ecx
	movl errato_len, %edx
	int $0x80
	jmp seconda_lettura	# permette un nuovo inserimento all'utente

failure_message:
	movl $4, %eax 		# system call write: stampa un messaggio di failure a seguito di 3 					# errori di inserimento consecutivi
	movl $1, %ebx	
	leal failure, %ecx
	movl failure_len, %edx
	int $0x80

fine:
	movl $1, %eax		# system call exit: termina il programma
	xorl %ebx, %ebx
	int $0x80

