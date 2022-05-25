	.arch armv8-a
// (d*a)/(a + b*c) + (d + b)/(e - a)
	.data
	.align	3
res:	.skip 	8		// res - 64 bits
a:	.4byte	0		// a - 32 bits
b:	.2byte	-234		// b - 16 bits
c:	.4byte	0		// c - 32 bits
d:	.2byte	327		// d - 16 bits
e:	.4byte	100		// e - 32 bits

	.text
	.align	2
	.global	_start
	.type	_start, %function
_start:
	adr	x0, a
	ldr	w1, [x0]		// w1 = a
	adr	x0, b
	ldrsh	w2, [x0]		// w2 = b
	adr	x0, c
	ldr	w3, [x0]		// w3 = c
	adr	x0, d
	ldrsh	w4, [x0]		// w4 = d
	adr	x0, e
	ldr	w5, [x0]		// w5 = e
	smull	x6, w1, w4		// x6 = a*d
	smull	x7, w2, w3		// x7 = b*c
	add	x8, x7, w1, sxtw	// x8 = (a + b*c)
	add	w4, w4, w2		// w4 = d + b
	sub	w5, w5, w1		// w5 = e - a
	cbz	x8, exit_1
	sdiv	x8, x6, x8		// x8 = (d*a)/(a + b*c)
	cbz	w5, exit_1
	sdiv	w5, w4, w5		// w5 = (d + b)/(e - a)
	add	x8, x8, w5, sxtw	// x8 = res
	adr	x0, res
	str	x8, [x0]
exit_0:
	mov	x0, #0
	mov	x8, #93
	svc	#0
exit_1:
	mov	x0, #1
	mov	x8, #93
	svc	#0
	.size	_start, .-_start
