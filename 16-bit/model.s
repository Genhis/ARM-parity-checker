	.global _start
_start:
	mov	R3,#1
	mov	R7,#4
	
	mov	R4,#0xF		@ Test range 0xFFFF - 0; CHANGE for quicker testing to 0xF
	loop:
		mov	R0,R4
		bl	v_dec
		bl	space
		bl	v_bin
		bl	space
		bl	generate16
		bl	v_bin
		bl	colon
		mov	R5,R0
		
		mov	R6,#20
		flip:
			mov	R0,R6
			bl	tab
			cmp	R6,#10
			bllt	space
			bl	v_dec
			bl	space
			
			eor	R0,R5,R3,lsl R6
			bl	v_bin
			bl	space
			
			bl	correct16
			bl	v_bin
			bl	space
			cmp	R0,R4
			
			mov	R0,#1
			ldrne	R1,=error
			movne	R2,#9
			ldreq	R1,=char+2
			moveq	R2,#1
			svc	0
			
			subs	R6,#1
			bge	flip
		
		@ Start section: NO FLIPPED BIT
		
		mov	R0,R5
		bl	tab
		bl	space
		bl	space
		bl	space
		bl	v_bin
		bl	space
		
		bl	correct16
		bl	v_bin
		bl	space
		cmp	R0,R4
		
		mov	R0,#1
		ldrne	R1,=error
		movne	R2,#9
		ldreq	R1,=char+2
		moveq	R2,#1
		svc	0
		
		@ End section
		
		subs	R4,#1
		bge	loop
	
	mov	R7,#1
	svc	0

space:
	push	{R0-R2}
	mov	R0,#1
	ldr	R1,=char
	mov	R2,#1
	svc	0
	pop	{R0-R2}
	bx	LR

tab:
	push	{R0-R2}
	mov	R0,#1
	ldr	R1,=indent
	mov	R2,#4
	svc	0
	pop	{R0-R2}
	bx	LR

colon:
	push	{R0-R2}
	mov	R0,#1
	ldr	R1,=char+1
	mov	R2,#2
	svc	0
	pop	{R0-R2}
	bx	LR
	
	.data
error:	.ascii	" - error\n"
indent:	.ascii	"    "
char:	.ascii	" :\n"
