    .data
	.align 4
idmsg1:
    .asciz  "*****Input ID*****\n"
	.align 4
idmsg2:
    .asciz  "** Please Enter Member 1 ID:**\n"
	.align 4
idmsg3:
    .asciz  "** Please Enter Member 2 ID:**\n"
	.align 4
idmsg4:
    .asciz  "** Please Enter Member 3 ID:**\n"
	.align 4

summation:
	.word	0
idlist:
	.word	0
	.word	0
	.word	0

.align 4
inputstr:
    .space 128

.align 4
fmtstrint:					@ buffer when scanf id
    .asciz  "%d"

.align 4
fmtstr:						@ buffer when scanf command
    .asciz  "%s"

.align 4
command:
    .asciz  "p"

.align 4
intendl:
    .asciz  "%d\n"

.align 4
idmsg5:
    .asciz  "** Please Enter Command **\n"
.align 4
idmsg6:
    .asciz  "*****Print Team Member ID and ID Summation*****\n"
.align 4
idmsg7:
    .asciz  "ID Summation = "
.align 4
idmsg8:
    .asciz	"*****End Print*****\n"
.align 4
endl:
    .asciz   "\n"
	.align 4

    .globl	summation
    .globl	fmtstr
    .globl	idlist
    .globl	idmsg7
    .globl	intendl
    .globl	idmsg8


.text
	.globl	id
id:
	stmfd	sp!,{lr}		@ push return address onto stack
    mov     r0, #0			@ clear r0
    mov     r1, #0			@ clear r1
    mov     r0, r1, lsl	#1	@ r0 = r4<<1 (logical shift left 1) 
@--------------------
    mov     r0, lr      	@ save return address (Operand2 is lr)
    adds    lr, pc, r0  	@ !!!
    mov     lr, r0			@ save the return address which is original save in lr back to lr
@--------------------
    eors    r0, r0, r0		@ clear r0		@ r0 = r0^r0(expression = 0) and
							@ set CPSR flags(N = 0; Z = 1; C = clear; V = clear)

    cmp     r0, #1			@ according to the result of r0-1, set CPSR ( N = 1; Z = 0 )
    ldrlt   r0, =idmsg1		@ if N set and Z clear, load the address of idmsg1 into r0 (Conditional Execution)
    bl      printf      	@ call printf printf("*****Input ID*****\n")
@--------------------
    mov     r0, #1			@ (Operand2 is 1)
    cmp     r0, #0
    ldrgt   r0, =idmsg2
    bl      printf			@ call printf printf("** Please Enter Member 1 ID:**\n")
@--------------------		@ input id1
    ldr     r0, =fmtstrint	@ r0 = *fmtstrint
    ldr     r1, =idlist		@ r1 = *idlist
    bl      scanf			@ scanf( "%s", idlist )
@--------------------
    ldr     r0, =idmsg3		@ r0 = *idmsg3
    bl      printf			@ printf("** Please Enter Member 2 ID:**\n")
@--------------------  		@ input id2
    ldr     r0, =fmtstrint	@ r0 = *fmtstrint
    ldr     r1, =idlist+4	@ r1 = *(idlist+4)
    bl      scanf			@ scanf( "%s", idlist+4 )
@--------------------
    ldr     r0, =idmsg4		@ r0 = *idmsg4
    bl      printf			@ printf("** Please Enter Member 3 ID:**\n")
@--------------------  @ input id3
    ldr     r0, =fmtstrint	@ r0 = *fmtstrint
    ldr     r1, =idlist+8	@ r1 = *(idlist+8)
    bl      scanf			@ scanf( "%s", idlist+8 )
@====================
loop2:
    ldr     r0, =idmsg5		@ load address of idmsg5 into r0
    bl      printf			@ printf("** Please Enter Command **\n")
@-----input command-------
    ldr     r0, =fmtstr		@ load address of fmtstr into r0
    ldr     r1, =inputstr	@ load the address of inputstr into r1
    bl      scanf			@ scanf( "%s", inputstr )

@ if inputstr != "p", then jump to loop2
    ldr     r0, =inputstr	@ load the address of inputstr into r0
    ldr     r1, =command	@ load the address of command into r1
    bl      strcmp			@ compare the string in r0 and r1, store the return value in r0
    cmp     r0, #0
    bne     loop2
@====================
    ldr     r0, =idmsg6		@ load the address of idmsg6 into r0
    bl      printf			@ printf("*****Print Team Member ID and ID Summation*****\n")

@ print id1
    ldr     r0, =intendl	@ r0 = "%d\n", let printf print a int
    ldr     r1, =idlist		@ r1 = *idlist
    ldr     r1, [r1]		@ r1 = idlist[0]
    bl      printf			@ printf(id1)
@ print id2
    ldr     r0, =intendl
    ldr     r1, =idlist+4	@ r1 = *(idlist+4)
    ldr     r1, [r1]		@ r1 = idlist[1]
    bl      printf
@ print id3
    ldr     r0, =intendl
    ldr     r1, =idlist+8	@ r1 = *(idlist+8)
    ldr     r1, [r1]		@ r1 = idlist[2]
    bl      printf

@--------------------

    ldr     r0, =endl		@ r0 = *endl
    bl      printf
    ldr     r0, =idmsg7		@ r0 = *idmsg7
    bl      printf			@ printf("ID Summation = ")


@ calculate summation

    mov		r4, #0			@ counter
loop3:
    ldr     r0, =idlist		@ r0 = *idlist
    ldr     r0, [r0, r4]	@ r0 = idlist[0]
    ldr     r1, =summation	@ r1 = *summation
    ldr     r1, [r1]		@ r1 = summation
    add     r1, r1, r0		@ r1 = r1 + r0
							@ r1 = summation + idlist[i]

    ldr     r0, =summation	@ r0 = *summation
    str     r1, [r0]		@ r1 = r0	(r1 = summation)


    add     r4, r4, #4		@ r4 = r4 + 4
    cmp     r4, #12
    blt     loop3

@ print summation

    ldr     r0, =intendl	@ r0 = "%d\n", let printf print a int
    ldr     r1, =summation	@ r1 = *summation
    ldr     r1, [r1]		@ r1 = r1
    bl      printf			@ printf("%d",summation)

@ end print

    ldr     r0, =idmsg8		@ r0 = *idmsg8
    bl      printf			@ printf("*****End Print*****\n")

	ldr     r0, =idlist			@ move return value into r0
	ldmfd   sp!, {lr}		@ pop return address from stack
	mov     pc, lr			@ return from name
