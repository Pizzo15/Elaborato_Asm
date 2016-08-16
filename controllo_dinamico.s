.section .data
controllo:
	.ascii "Modalità controllo dinamico inserita\n"
controllo_len:
	.long . - controllo

totale:
	.ascii "Inserire il numero totale dei passeggeri a bordo:\n"
totale_len:
	.long . - totale

abc:
	.ascii "Inserire il numero totale dei passeggeri per le file A, B, C\n"

abc_len:
	.long . - abc

a:
	.ascii "A: "
a_len:
	.long . - a
b:
	.ascii "B: "
b_len:
	.long . - b

c:
	.ascii "C: "
c_len:
	.long . - c
d:
	.ascii "D: "
d_len:
	.long . - d
e:
	.ascii "E: "
e_len:
	.long . - e
f:
	.ascii "F: "
f_len:
	.long . - f

def:
	.ascii "Inserire il numero totale dei passeggeri per le file D, E, F:\n"
def_len:
	.long . - def

diverso:
	.ascii "Somma totali file diverso da totale passeggero\n"
diverso_len:
	.long . - diverso

superamento_totale:
	.ascii "Capienza massima: 180 passeggeri!\n"
superamento_totale_len:
	.long . - superamento_totale

superamento_totale_fila:
	.ascii "Capienza massima fila: 30 passeggeri!\n"
superamento_totale_fila_len:
	.long . - superamento_totale_fila

.section .text
.align 4

.global controllo_dinamico

.type controllo_dinamico, @function	# funzione che esegue le istruzioni specificate nel caso la 						# sequenza inserita sia 3 3 2

controllo_dinamico:
	pushl %ebp			# salva in cima allo stack il contenuto di ebp
	movl %esp, %ebp			# fa puntare ebp alla stessa zona di memoria puntata da esp
	subl $28, %esp			# fa puntare esp alla zona di memoria il cui indirizzo 						# corrisponde al precedente meno 28

	movl $4, %eax			# system call write: stampa un messaggio di notifica 						# dell'inserimento della modalità controllo dinamico
	movl $1, %ebx
	leal controllo, %ecx
	movl controllo_len, %edx
	int $0x80

inizio:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero totale di passeggeri
	movl $1, %ebx
	leal totale, %ecx
	movl totale_len, %edx
	int $0x80
	
	call atoi_input			# legge il valore inserito tramite la funzione atoi_input
	
	cmpl $180, %eax			# confronta il valore letto con 180
	jle coerente			# se il n° totale di passeggeri è maggiore della capienza totale 						# dell'aereo chiede nuovamente di inserire il valore

	movl $4, %eax			# system call write: stampa un messaggio di errore nel caso il 						# valore inserito non sia accettabile
	movl $1, %ebx
	leal superamento_totale, %ecx
	movl superamento_totale_len, %edx
	int $0x80
	jmp inizio

coerente:
	movl %eax, -4(%ebp)		# salva in pila il n° totale dei passeggeri

	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero totale di passeggeri per le file A, B, C
	movl $1, %ebx
	leal abc, %ecx
	movl abc_len, %edx
	int $0x80

req_a:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero di passeggeri per la fila A
	movl $1, %ebx
	leal a, %ecx
	movl a_len, %edx
	int $0x80

	call atoi_input			# legge il valore inserito tramite atoi_inpu

	cmpl $30, %eax			# confronta il valore con 30
	jle ok_a			# se il n° di passeggeri nella fila A è maggiore di 30 chiede 						# nuovamente di inserire un valore

	movl $4, %eax			# system call write: stampa un messaggio di errore per il 						# superamento del n° massimo di passeggeri per fila	
	movl $1, %ebx
	leal superamento_totale_fila, %ecx
	movl superamento_totale_fila_len, %edx
	int $0x80
	jmp req_a

ok_a:
	movl %eax, -8(%ebp)		# salva in pila il n° di passeggeri della fila A

req_b:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero di passeggeri per la fila B
	movl $1, %ebx
	leal b, %ecx
	movl b_len, %edx
	int $0x80

	call atoi_input			# legge il valore inserito

	cmpl $30, %eax			# confronta il valore con 30
	jle ok_b			# se il n° di passeggeri nella fila B è maggiore di 30 chiede 						# nuovamente di inserire un valore

	movl $4, %eax			# system call write: stampa un messaggio di errore per il 						# superamento del n° massimo di passeggeri per fila
	movl $1, %ebx
	leal superamento_totale_fila, %ecx
	movl superamento_totale_fila_len, %edx
	int $0x80
	jmp req_b

ok_b:
	movl %eax, -12(%ebp)		# salva in pila il n° di passeggeri della fila B

req_c:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero di passeggeri per la fila C
	movl $1, %ebx
	leal c, %ecx
	movl c_len, %edx
	int $0x80

	call atoi_input			# legge il valore inserito

	cmpl $30, %eax			# confronta il valore con 30
	jle ok_c			# se il n° di passeggeri nella fila C è maggiore di 30 chiede 						# nuovamente di inserire un valore

	movl $4, %eax			# system call write: stampa un messaggio di errore per il 						# superamento del n° massimo di passeggeri per fila
	movl $1, %ebx
	leal superamento_totale_fila, %ecx
	movl superamento_totale_fila_len, %edx
	int $0x80
	jmp req_c

ok_c:
	movl %eax, -16(%ebp)		# salva in pila il n° di passeggeri della fila B

	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero totale di passeggeri per le file D, E, F
	movl $1, %ebx
	leal def, %ecx
	movl def_len, %edx
	int $0x80

req_d:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero di passeggeri per la fila D
	movl $1, %ebx
	leal d, %ecx
	movl d_len, %edx
	int $0x80

	call atoi_input			# legge il valore inserito

	cmpl $30, %eax			# confronta il valore con 30
	jle ok_d			# se il n° di passeggeri nella fila D è maggiore di 30 chiede 						# nuovamente di inserire un valore

	movl $4, %eax			# system call write: stampa un messaggio di errore per il 						# superamento del n° massimo di passeggeri per fila
	movl $1, %ebx
	leal superamento_totale_fila, %ecx
	movl superamento_totale_fila_len, %edx
	int $0x80
	jmp req_d

ok_d:
	movl %eax, -20(%ebp)		# salva in pila il n° di passeggeri della fila B

req_e:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero di passeggeri per la fila E
	movl $1, %ebx
	leal e, %ecx
	movl e_len, %edx
	int $0x80

	call atoi_input			# legge il valore inserito

	cmpl $30, %eax			# confronta il valore con 30
	jle ok_e			# se il n° di passeggeri nella fila E è maggiore di 30 chiede 						# nuovamente di inserire un valore

	movl $4, %eax			# system call write: stampa un messaggio di errore per il 						# superamento del n° massimo di passeggeri per fila
	movl $1, %ebx
	leal superamento_totale_fila, %ecx
	movl superamento_totale_fila_len, %edx
	int $0x80
	jmp req_e

ok_e:
	movl %eax, -24(%ebp)		# salva in pila il n° di passeggeri della fila B

req_f:
	movl $4, %eax			# system call write: stampa un messaggio di richiesta di 						# inserimento del numero di passeggeri per la fila F
	movl $1, %ebx
	leal f, %ecx
	movl f_len, %edx
	int $0x80

	call atoi_input			# legge il valore inserito

	cmpl $30, %eax			# confronta il valore con 30
	jle ok_f			# se il n° di passeggeri nella fila F è maggiore di 30 chiede 						# nuovamente di inserire un valore

	movl $4, %eax			# system call write: stampa un messaggio di errore per il 						# superamento del n° massimo di passeggeri per fila
	movl $1, %ebx
	leal superamento_totale_fila, %ecx
	movl superamento_totale_fila_len, %edx
	int $0x80
	jmp req_f

ok_f:
	movl %eax, -28(%ebp)		# salva in pila il n° di passeggeri della fila F

	xorl %ecx, %ecx			# azzero ecx: lo uso come contatore del n° passeggeri per il 						# controllo coerenza
	addl -28(%ebp), %ecx		# ecx += nF
	addl -24(%ebp), %ecx		# ecx += nE
	addl -20(%ebp), %ecx		# ecx += nD
	addl -16(%ebp), %ecx		# ecx += nC
	addl -12(%ebp), %ecx		# ecx += nB
	addl -8(%ebp), %ecx		# ecx += nA
	cmpl -4(%ebp), %ecx		# confronto il valore ottenuto con il n° totale di passeggeri 						# inserito da tastiera

	je calcolo			# se il valore è coerente passo al calcolo dei bias

	movl $4, %eax			# system call write: stampa un messaggio di errore nel caso i 						# valori totali inseriti non siano coerenti
	movl $1, %ebx
	leal diverso, %ecx
	movl diverso_len, %edx
	int $0x80
	jmp inizio			# faccio ripartire l'inserimento dei valori precendenti

calcolo:
	call calcolo_bias		# chiamata alla funzione calcolo_bias

fine:
	movl %ebp, %esp			# fa puntare ebp alla cella puntata da esp
	popl %ebp			# ripristino ebp alla situazione di partenza
	ret

