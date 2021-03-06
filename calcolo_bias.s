.section .data

bias1:
	.ascii "Bias flap 1: "
bias1_len:
	.long . - bias1

bias2:
	.ascii "Bias flap 2: "
bias2_len:
	.long . - bias2

bias3:
	.ascii "Bias flap 3: "
bias3_len:
	.long . - bias3

bias4:
	.ascii "Bias flap 4: "
bias4_len:
	.long . - bias4

.section .text

.global calcolo_bias

.type calcolo_bias, @function	# funzione che calcola le differenze di peso tra parte sinistra e destra 					# del velivolo e imposta il bias per l'inclinazione del flap

calcolo_bias:
	pushl %ebp		# impila il registro speciale ebp
	movl %esp, %ebp		# aggiorna lo stack pointer per puntare alla base della pila
	subl $20, %esp		# decrementa esp di 20 unità in modo che punti 5 celle più in alto

	xorl %edx, %edx		# azzera edx
	movl 28(%ebp), %eax	# sposto nA in eax per prepararlo alla sottrazione
	subl 8(%ebp), %eax	# x=nA-nF
	sarl %eax		# eseguo la divisione per 2 del valore di x con uno shift a destra
	movl $3, %ecx		# sposto la costante k1 nel registro ecx
	imull %ecx		# moltiplico x/2 per 3 ottenendo la prima costante da utilizzare nel 					# calcolo dei bias
	movl %eax, -4(%ebp)	# salvo il valore ottenuto nella pila -> x'

	xorl %edx, %edx		# azzero edx
	movl 24(%ebp), %eax	# sposto nB in eax per prepararlo alla sottrazione
	subl 12(%ebp), %eax	# y=nB-nE
	sarl %eax		# divido y per 2
	movl $6, %ecx		# sposto la costante k2 in ecx
	imull %ecx		# moltiplico y/2 per 6
	movl %eax, -8(%ebp)	# salvo il valore ottenuto in pila -> y'

	xorl %edx, %edx		# azzero edx
	movl 20(%ebp), %eax	# sposto nC in eax per prepararlo alla sottrazione
	subl 16(%ebp), %eax	# z=nC-nD
	sarl %eax		# divido z per 2
	movl $12, %ecx		# sposto la costante k3 in ecx
	imull %ecx		# moltiplico z/2 per 12
	movl %eax, -12(%ebp)	# salvo il valore ottenuto in pila -> z'

	movl -4(%ebp), %eax	# sposto x' in eax
	addl -8(%ebp), %eax	# Bias1=x'+y'
	movl %eax, -16(%ebp)	# salvo il valore Bias1 in pila

	movl -8(%ebp), %eax	# sposto y' in eax
	addl -12(%ebp), %eax	# Bias2=y'+z'
	movl %eax, -20(%ebp)	# salvo il valore Bias2 in pila
	
	movl $4, %eax		# system call write
	movl $1, %ebx
	leal bias1, %ecx
	movl bias1_len, %edx
	int $0x80

	movl -16(%ebp), %eax	# sposto il valore di Bias1 in eax per prepararlo alla stampa
	call numero_negativo	# chiamata alla funzione numero_negativo
	call itoa		# stampo il valore contenuto in eax

	movl $4, %eax		# system call write
	movl $1, %ebx
	leal bias2, %ecx
	movl bias2_len, %edx
	int $0x80

	movl -20(%ebp), %eax	# sposto Bias2 in eax
	call numero_negativo
	call itoa		# stampo il valore

	movl $4, %eax		# system call write
	movl $1, %ebx
	leal bias3, %ecx
	movl bias3_len, %edx
	int $0x80

	movl -20(%ebp), %eax	# sposto Bias2 in eax
	neg %eax		# nego il valore per ottenere Bias3
	call numero_negativo
	call itoa		# stampo il valore

	movl $4, %eax		# system call write
	movl $1, %ebx
	leal bias4, %ecx
	movl bias4_len, %edx
	int $0x80

	movl -16(%ebp), %eax	# sposto Bias1 in eax
	neg %eax		# nego il valore per ottenere Bias4
	call numero_negativo
	call itoa		# stampo il valore

	movl %ebp, %esp		# fa puntare a esp la cella puntata da ebp
	popl %ebp		# ripristina il registro ebp alla posizione precedente
	ret
