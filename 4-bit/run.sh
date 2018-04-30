as -o model.o model.s
as -o v_bin.o v_bin.s
as -o v_dec.o v_dec.s
as -g -o generate4.o generate4.s
as -g -o correct4.o correct4.s
ld -o model generate4.o correct4.o v_dec.o v_bin.o model.o
./model
echo ""