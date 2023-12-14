.data
    .align 4
namefunc:
    .word   namefunc
    .asciz  "Function1: Name\n"
    .align 4
idfunc:
    .asciz  "Function2: ID\n"
	.align 4

mainmsg1:
    .asciz   "\nMain Function:\n"
	.align 4
mainmsg2:
    .asciz   "*****Print All*****\n"
	.align 4

endl:
    .asciz   "\n"
	.align 4

fmtStrIntSpace:
    .asciz  "%d "
	.align 4

    .globl  endl

.text
	.globl  main
main:
	stmfd	sp!,{lr}		@ push return address onto stack
    ldr     r0, =namefunc	@ r0 = *namefunc
    ldr     r0, [r0]		@ r0 = namefunc
    add     r0, r0, #4		@ r0 = r0 + 4
    bl      printf			@ printf("Function1: Name\n")
    mov     r0, r0, asr #0	@ r0 = r0 >> 0 (Operand2 is arithmetic shift right by 0)
	bl		name			@ call name.s


    ldr		r0, =idfunc		@ r0 = *idfunc
    bl      printf			@ printf("Function2: ID\n")
	bl		id				@ call id.s

    ldr		r0, =mainmsg1	@ r0 = *mainmsg1
    bl		printf			@ printf("\nMain Function:\n")

    ldr     r0, =mainmsg2	@ r0 = *mainmsg2
    bl      printf			@ printf("*****Print All*****\n")

    ldr     r0, =msg3		@ r0 = *mag3
    add     r0, r0, #4		@ r0 = r0 + 4
    bl      printf			@ printf("Team 17\n")

    mov     r4, #0			@ r4 = 0

main_loop:

    ldr     r0, =fmtStrIntSpace	@ r0 = *fmtStrIntSpace
    ldr     r1, =idlist		@ r1 = *idlist
    ldr     r1, [r1, r4]	@ r0 = r0 + r4 ; r0 = idlist[i]
    bl      printf
    ldr     r0, =strset		@ r0 = *strset
    ldr     r0, [r0, r4]	@ r0 = r0 + r4 ; r0 = strset[i]
    bl      printf

    add     r4, r4, #4		@ r4 = r4 + 4
    cmp     r4, #12
    blt     main_loop


    ldr     r0, =idmsg7		@ r0 = *idmsg7
    bl      printf			@ printf("ID Summation = ")

    ldr     r0, =intendl
    ldr     r1, =summation	@ r1 = *summation
    ldr     r1, [r1]		@ r1 = r1
    bl      printf			@ printf("%d",summation)

    ldr		r0, =msg4		@ r0 = *msg4
    bl		printf			@ printf("*****End Print*****\n")


	mov		r0, #0		@ move return value into r0
	ldmfd	sp!, {lr}	@ pop return address from stack
	mov		pc, lr		@ return from name
