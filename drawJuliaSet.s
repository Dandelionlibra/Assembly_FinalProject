.data

.text
.global drawJuliaSet
.align  4
drawJuliaSet:
    movs     r4, #0                  @ r4 = 0
    ldrlt   r4, .constant           @ (Conditional execution)
    ldrge   r4, .constant           @ (Conditional execution)
    mov     r4, r1, lsl	#1	        @ r4 = r1<<1 (logical shift left 1) (Operand2)
    mov     r4, r5                  @ (Operand2)
    mov     r4, r4, rrx     	    @ r4 rotate right 1 bit with extend (Operand2)
    movs    r4, #0                  @ (Operand2)
    moveq   r5, sp                  @ (Conditional execution)
    movne   r4, #0                  @ (Conditional execution)
    orr     sp, lr, r1              @ !!!! the tenth instruction
    mov     sp, r5

@---------------------- start ----------------------
    str     lr, [sp, #-4]!           @ push old lr to stack
    str     fp, [sp, #-4]!           @ push old fp to stack
    add     fp, sp, #0              @ fp = sp
    sub     sp, sp, #44             @ allocate 44 bytes on stack for local variables
    str     r3, [fp, #-4]           @ push r3 to stack, fp-4 = height
    str     r2, [fp, #-8]          @ push r2 to stack, fp-8 = width
    str     r1, [fp, #-12]          @ push r1 to stack, fp-12 = cY
    str     r0, [fp, #-16]          @ push r0 to stack, fp-16 = cX
    @ fp+4 = lr
    @ fp+8 = frameBuffer


    mov     r5, #0                  @ r5 = 0
    str     r5, [fp, #-20]           @ int x = 0

outer_loop:
    ldr     r2, [fp, #-8]           @ r2 = width
    ldr     r5, [fp, #-20]           @ r5 = x
    cmp     r5, r2                  @ if(r5 >= r2)
    bge     finish_outer_loop       @ goto finish_outer_loop


    mov     r6, #0                  @ r6 = y
    str     r6, [fp, #-24]           @ int y = 0
inner_loop:
    ldr     r3, [fp, #-4]           @ r3 = height
    ldr     r6, [fp, #-24]           @ r6 = y
    cmp     r6, r3
    bge     finish_inner_loop
@---------count zx----------------------------
    ldr     r0, [fp, #-8]           @ r0 = width
    mov     r0, r0, asr #1          @ r0 = r0 >> 1 = width>>1
    ldr     r1, [fp, #-20]          @ r1 = x
    sub     r0, r1, r0              @ r0 = x - (width>>1)
    ldr     r1, .constant           @ r1 = 1500
    mul     r0, r0, r1       @ 1500 * (x - (width>>1))
    ldr     r1, [fp, #-8]           @ r1 = width
    mov     r1, r1, asr #1        @ width>>1
    bl      __aeabi_idiv            @ r0 = r0 / r1
    str     r0, [fp, #-28]          @ int zx = r0
@---------------------------------------------
@---------count zy----------------------------
    ldr     r0, [fp, #-4]           @ r0 = height
    mov     r0, r0, asr #1          @ r0 = height>>1
    ldr     r1, [fp, #-24]          @ r1 = y
    sub     r0, r1, r0              @ y - (height>>1)
    ldr     r1, .constant+4         @ r1 = 1000
    mul     r0, r0, r1              @ 1000 * (y - (height>>1))
    ldr     r1, [fp, #-4]           @ r1 = height
    mov     r1, r1, asr #1        @ height>>1
    bl      __aeabi_idiv            @ r0 = r0 / r1
    str     r0, [fp, #-32]          @ int zy = r0
@---------------------------------------------
@----------calculate condition------------------

    mov     r0, #255                @ i = 255 (maxIter)
    str     r0, [fp, #-36]          @ int i = 255
init_while:    
    ldr     r1, [fp, #-28]          @ r1 = zx
    mul     r1, r1, r1              @ r1 = zx*zx
    ldr     r2, [fp, #-32]          @ r2 = zy
    mul     r2, r2, r2              @ r2 = zy*zy
    adds    r3, r1, r2              @ r3 = zx*zx + zy*zy
@-----------------------------------------------
while:
@----------while condition expression-----------
    ldr     r2, .constant+8         @ r2 = 4000000
    cmp     r3, r2
    bge     finish_while
    cmp     r0, #0
    ble     finish_while
@-----------------------------------------------
@----------do while-----------------------------
    ldr     r1, [fp, #-28]          @ r1 = zx
    mul     r1, r1, r1              @ r1 = zx*zx
    ldr     r2, [fp, #-32]          @ r2 = zy
    mul     r2, r2, r2              @ r2 = zy*zy
    sub     r0, r1, r2              @ r0 = zx*zx - zy*zy
    ldr     r1, .constant+4         @ r1 = 1000
    bl      __aeabi_idiv            @ r0 = (zx*zx - zy*zy) / 1000
    ldr     r1, [fp, #-16]          @ r1 = cX
    add     r0, r0, r1              @ r0 = (zx*zx - zy*zy) / 1000 + cX
    str     r0, [fp, #-40]          @ tmp = (zx*zx - zy*zy) / 1000 + cX
    ldr     r0, [fp, #-28]          @ r0 = zx
    ldr     r1, [fp, #-32]          @ r1 = zy
    mov     r1, r1, lsl #1          @ r1 = zy << 1
    mul     r0, r1                  @ r0 = 2*zx*zy
    ldr     r1, .constant+4         @ r1 = 1000
    bl      __aeabi_idiv            @ r0 = (zx*zy) / 1000
    ldr     r1, [fp, #-12]          @ r1 = cY
    add     r0, r0, r1              @ r0 = (zx*zy) / 1000 + cY
    str     r0, [fp, #-32]          @ zy = (zx*zy) / 1000 + cY
    ldr     r0, [fp, #-40]          @ r0 = tmp
    str     r0, [fp, #-28]          @ zx = tmp

    ldr     r0, [fp, #-36]          @ r0 = i
    subs    r0, r0, #1              @ i--
    str     r0, [fp, #-36]          @ i = r0
    b      init_while                    @ goto init_while
@-----------------------------------------------

finish_while:
    ldr     r0, [fp, #-36]          @ r0 = i
    and     r0, r0, #0xff           @ r0 = i & 0xff
    mov     r1, #8
    orr     r0, r0, r0, lsl r1      @ r0 = (i & 0xff) | (i & 0xff << 8)

    ldr     r1, .constant+12        @ r1 = 0xffff
    bic     r0, r1, r0              @ r0 = (~r0) & 0xffff
    mov     r3, r0                  @ color = r3 = r0

    ldr     r0, [fp, #8]           @ r0 = frame
    ldr     r1, [fp, #-8]          @ r1 = width
    ldr     r2, [fp, #-24]         @ r2 = y
    @
    mov     r1, r1, asl #1         @ r1 = 2*width (because of short type)
    @
    mul     r1, r1, r2             @ r1 = 2* width * y
    add     r0, r1                 @ r0 = frame + 2*width * y
    ldr     r1, [fp, #-20]         @ r1 = x
    add     r0, r1, asl #1          @ r0 = frame + 2*width * y + 2x
    mov     r0, r0
    strh    r3, [r0]               @ *(frame+ 2*width*y + 2x) = color

    ldr     r6, [fp, #-24]           @ r6 = y
    adds    r6, r6, #1               @ y++
    str     r6, [fp, #-24]           @ y = r6
    b       inner_loop              @ goto inner_loop


finish_inner_loop:

    ldr     r5, [fp, #-20]           @ r5 = x
    adds    r5, r5, #1               @ x++
    str     r5, [fp, #-20]           @ x = r5
    b       outer_loop              @ goto outer_loop
@---------------------------------------
finish_outer_loop:
	
    mov		r0, #0		@ move return value into r0
	add     sp, fp, #0              @ deallocate local variables
    ldr     fp, [sp], #4            @ pop old fp from stack
    ldr     lr, [sp], #4            @ pop old lr from stack
	bx      lr		@ return to caller
    .align  4


.constant:
    .word   1500
    .word   1000
    .word   4000000
    .word   0xffff
    .align  4
