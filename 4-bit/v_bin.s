@	Subroutine v_bin will display a 32-bit register in binary digits
@		R0: contains a number to be displayed in binary
@		LR: contains the return address
@		All register contents will be preserved

	.global v_bin
v_bin:	push {R0-R7}
	mov R3,R0		@copy the binary number
	mov R6,#7		@number of bits to go through - 1
	mov R4,#1		@used to mask off 1 bit at a time for display

	mov R0,#1		@prepare for stdout
	mov R7,#4

	ldr R5,=dig		@load digits
	mov R2,#1		@prepare for 1-digit output

nxtbit:	and R1,R4,R3,lsr R6	@select next 0 or 1 to be displayed
	add R1,R5		@set R1 pointing to "0" or "1" in memory
	svc 0

	subs R6,#1		@decrement number of bits remaining to display
	bge nxtbit		@if R0 >= 0, jump to nxtbit

	pop {R0-R7}		@restore saved register contents
	bx LR			@return to the calling program

	.data
dig:	.ascii "01"
	.end
