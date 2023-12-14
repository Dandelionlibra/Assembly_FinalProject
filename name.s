.data
.align 4
msg2:
    .word   msg2            @ msg2 store the address of label msg1 (4 bytes)
    .asciz  "*****Print Name*****\n"
	.align 4
msg3:
    .word   msg3
    .asciz  "Team 17\n"
	.align 4
name1:
    .asciz  "Lo Haichi\n"
	.align 4
name2:
    .asciz  "Huang Yijia\n"
	.align 4
name3:
    .asciz  "Lin Yuchen\n"
	.align 4
msg4:
    .asciz  "*****End Print*****\n"
	.align 4

strset:                     @ Array
    .word   name1
    .word   name2
    .word   name3

    .globl  msg2
    .globl  msg3
    .globl  msg4
    .globl  strset

.text
    .globl  name
name:
	stmfd	sp!,{lr}	@ push return address onto stack

	ldr		r4,=msg2    @ r4 = *msg2
    mov     r2, #1      @ r2 = 1 
    ldr     r0,[r4, r2, lsl #2]!	@ r0 = r4 + r2<<4 (logical shift left 2),
                                    @ then store the address in r4 (1.Addressing mode)(Operand2 is logical shift left by 2)
    mov     r0, r4      @ r0 = r4
	bl		printf      @ printf("*****Print Name*****\n")

	ldr     r4,=msg3    @ r4 = *msg3
    mov     r2, #4      @ r2 = 4
    ldr     r0,[r4], r2 @ load r0 with word at the address r4 then increment r4 by r2 (2.Addressing mode)
    mov     r0, r4      @ r0 = r4
	bl      printf      @ printf("Team 17\n")

    mov     r4,#0       @ r4 = 0
loop:
    eors	r0,r0,r0			@ r0 = r0^r0(expression = 0) and set CPSR flags(Z set 1)
    ldreq	r0,=strset			@ if Z == 1, r0 = *(strset) (Conditional Execution)
    ldr		r0,[r0, r4]			@ r0 = r0 + r4; r0 = r0 + 0 (3.Addressing mode)
    bl		printf				@ printf(strset)
    add		r4,r4,#4			@ r4 = r4 + 4
    cmp		r4,#12				@ if(r4 == 12)
    blt		loop				@ jump to loop


    ldr		r0,=msg4			@ r0 = * msg4
    bl		printf				@ printf("*****End Print*****\n")



	mov		r0, #0				@ move return value into r0
	ldmfd	sp!, {lr}           @ pop return address from stack
	mov		pc, lr              @ return from name
