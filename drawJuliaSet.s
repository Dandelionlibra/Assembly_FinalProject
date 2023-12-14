.data
.align 4

color:
    .hword 0    @ signed half-word
    .align 4
maxIter:
    .align 4



.text

drawJuliaSet:
	stmfd	sp!,{r4-r11, lr}		@ push return address onto stack
    mov     r4, r1, lsl	#1	        @ r4 = r1<<1 (logical shift left 1) (Operand2)
    mov     r4, r5                  @ (Operand2)
    mov     r4, rrx     	        @ r4 rotate right 1 bit with extend (Operand2)
    movs    r4, #0                  @ (Operand2)
    moveq   r5, sp                  @ (Conditional execution)
    ldrlt   r4, =constant           @ (Conditional execution)
    ldrge   r4, =constant           @ (Conditional execution)
    movne   r4, #0                  @ (Conditional execution)

    orr     sp, lr, r1              @ !!!! the tenth instruction
@----------------------
    mov     sp, r5
    mov     r5, #0                  @ r5 = x

    str     r3, [sp, #-4]!          @ push r3 to stack
    str     r2, [sp, #-4]!          @ push r2 to stack
    str     r1, [sp, #-4]!          @ push r1 to stack
    str     r0, [sp, #-4]!          @ push r0 to stack


outer_loop:
    cmp     r5, r2                  @ r2 is width
    bge     finish_outer_loop
    mov     r6, #0                  @ r6 = y
inner_loop:
    cmp     r6, r3
    bge     finish_inner_loop
@---------count zx----------------------------
    mov     r10, r2
    ldr     r10, r10, asr #1        @ width>>1
    sub     r10, r5, r10            @ x - (width>>1)
    mul     r10, r10, .constant     @ 1500 * (x - (width>>1))
    mov     r0, r10
    mov     r10, r2
    ldr     r10, r10, asr #1        @ width>>1
    mov     r1, r10
    bl      __aeabi_idiv            @ r0 = r0 / r1
    mov     r10, r0
@---------count zy----------------------------
    mov     r11, r3
    ldr     r11, r11, asr #1        @ height>>1
    sub     r11, r6, r11            @ y - (height>>1)
    mul     r11, r11, .constant+4   @ 1000 * (y - (height>>1))
    mov     r0, r11
    mov     r11, r2
    ldr     r11, r11, asr #1        @ height>>1
    mov     r1, r11
    bl      __aeabi_idiv            @ r0 = r0 / r1
    mov     r11, r0
@----------i = maxIter-------------------------
    mov     r9, #255                @ i = 255 (maxIter)
    mul     r8, r10, r10            @ r8 = zx*zx
    mul     r7, r11, r11            @ r7 = zy*zy
    adds    r4, r8, r7              @ r4 = zx*zx + zy*zy

while:
@----------while condition expression-----------
    cmp     r4, .constant+8
    bge     finish_while
    cmp     r9, #0
    bge     finish_while
@-----------------------------------------------






finish_while:
finish_inner_loop:
    add     r5, #1


finish_outer_loop:

@---------------------------------------
	mov		r0, #0		@ move return value into r0
	ldmfd	sp!, {lr}	@ pop return address from stack
	mov		pc, lr		@ return from name


.constant:
    .word   1500
    .word   1000
    .word   4000000
    .word   0xff
    .word   0xffff
    .align  4
