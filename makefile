EXE= run
AS= as
LD= ld
FLAGS= -gstabs
OBJ= atoi_stack.o main.o itoa.o controllo_emergenza.o controllo_dinamico.o calcolo_bias.o atoi_input.o numero_negativo.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

numero_negativo.o: numero_negativo.s
	$(AS) $(FLAGS) -o numero_negativo.o numero_negativo.s
calcolo_bias.o: calcolo_bias.s
	$(AS) $(FLAGS) -o calcolo_bias.o calcolo_bias.s
controllo_dinamico.o: controllo_dinamico.s
	$(AS) $(FLAGS) -o controllo_dinamico.o controllo_dinamico.s
controllo_emergenza.o: controllo_emergenza.s
	$(AS) $(FLAGS) -o controllo_emergenza.o controllo_emergenza.s
itoa.o: itoa.s
	$(AS) $(FLAGS) -o itoa.o itoa.s
atoi_stack.o: atoi_stack.s
	$(AS) $(FLAGS) -o atoi_stack.o atoi_stack.s
atoi_input.o: atoi_input.s
	$(AS) $(FLAGS) -o atoi_input.o atoi_input.s
main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s

clean:
	rm -f *.o $(EXE) core
