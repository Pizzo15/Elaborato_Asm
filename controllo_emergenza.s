.section .data

emergenza:
	.ascii "Modalità controllo emergenza inserita\n"
emergenza_len:
	.long . - emergenza

.section .text

.global controllo_emergenza

.type controllo_emergenza, @function	# funzione che esegue le istruzioni specificate nel caso la 						# sequenza inserita sia 9 9 2

controllo_emergenza:
	movl $4, %eax			# system call write: stampa un messaggio di notifica di 					# inserimento della modalità di emergenza
	movl $1, %ebx
	leal emergenza, %ecx
	movl emergenza_len, %edx
	int $0x80

	ret
