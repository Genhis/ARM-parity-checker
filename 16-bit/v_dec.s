	.global v_dec

@	Subroutine v_dec will display a 32-bit register in decimal digits
@		R0: a number to be displayed in decimal
@		LR: the return address
@		All register contents will be preserved

v_dec:	push	{R0-R9}		@ Save contents of registers R0 through R7
	mov	R3,R0		@ R3 will hold a copy of input word to be displayed

				@ Prepare for output
	mov	R2,#1		@	1 character
	mov	R0,#1		@	to stdout
	mov	R7,#4		@	(write operation)

	cmp	R3,#0		@ Determine if minus sign is needed
	bge	absval		@ If it's positive, just display it
	
	ldr	R1,=msign	@ Load minus sign character (first bracket)
	svc	0		@	and display it

	rsb	R3,R3,#0	@ Get absolute value (negative of negative) for display

absval:	cmp	R3,#10		@ Test whether only one's column is needed
	blt	onecol		@ Go output "final" column of display

	ldr	R6,=pow10+8	@ Point to hundred's column of power of ten table

high10:	ldr	R5,[R6],#4	@ Load next higher power of ten

	cmp	R3,R5		@ Test if we've reached the highest power of ten needed
	bge	high10		@ Continue search for greater power of ten

	sub	R6,#8		@ We stepped two integers too far.

nxtdec:	ldr	R1,=dig-1	@ Point to 1 byte before "0123456789" string
	ldr	R5,[R6],#-4	@ Load next lower power of 10 (move right 1 dec column)

mod10:	add	R1,#1		@ Set R1 pointing to the next higher digit '0' through '9'
	subs	R3,R5		@ Do a count down to find the correct digit
	bge	mod10		@ Keep subtracting current decimal column value

	addlt	R3,R5		@ We counted one too many (went negative)
	svc	0		@ Display the next digit

	cmp	R5,#10		@ Have we gone all to way to one's column?
	bgt	nxtdec		@ If not, continue in nxtdec loop

onecol:	ldr	R1,=dig		@ Pointer to "0123456789"
	add	R1,R3		@ Generate offset for one's digit
	svc	0		@ Write out the final digit

	pop	{R0-R9}		@ Restore saved register contents
	bx	LR		@ Return to the calling program

	.data
pow10:	.word 1
	.word 10
	.word 100
	.word 1000
	.word 10000
	.word 100000
	.word 1000000
	.word 10000000
	.word 100000000
	.word 1000000000
	.word 0x7FFFFFFF
dig:	.ascii "0123456789"
msign:	.ascii "-"
	.end
