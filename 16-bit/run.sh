as -o model.o model.s
as -o v_bin.o v_bin.s
as -o v_dec.o v_dec.s
as -o generate16.o generate16.s
as -g -o correct16.o correct16.s
ld -o model generate16.o correct16.o v_dec.o v_bin.o model.o
echo "Starting tests... It may take up to 10 minutes to complete extensive testing."
echo "To interrupt the program, press Ctrl+C."
echo "For QUICK testing, change value of R4 in model.s"
echo ""
echo -e "\033[1;31mDISCLAIMER: This only compares generated check bits with the corrected ones. If both your generate16 and correct16 are incorrect in a certain way, this tool may produce incorrect results as well.\033[0m"
echo ""
./model > log.txt
echo "Done! Open log.txt to see the results and look for \"error\" keyword."
