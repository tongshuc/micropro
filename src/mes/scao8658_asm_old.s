@ scao8658_asm.s Data section - initialized values
.data

.align 3
huge:   .octa 0xAABBCCDDDDCCBBFF
big:    .word 0xAAEEBBFF
num:    .byte 0xAB

str2:   .asciz "Guten Tag!"
count:  .word 12345

@ End of data section


.syntax unified
.cpu cortex-m4
.thumb
.text


@ Function Declaration
@ Function: scao8658_add_test
@ Purpose: Load and manipulate data, then test addition
.global scao8658_add_test
.type scao8658_add_test, %function

scao8658_add_test:
    push {r4, lr}

   

    @ Load the addresses of each item
    ldr r0, =num
    ldr r0, =big
    ldr r0, =huge
    ldr r0, =str2

    @ Load the first byte of str2
    ldr r2, =str2
    ldrb r0, [r2]

    @ Load the first word of str2
    ldr r2, =str2
    ldr r0, [r2]

    @ Load the value of num
    ldr r2, =num
    ldrb r0, [r2]

    @ Load the value of big
    ldr r2, =big
    ldr r0, [r2]

    @ Load the 64-bit value of huge
    ldr r2, =huge
    ldrd r0, r1, [r2]

   

    add r4, r0, r1

    mov r0, r2
    bl busy_delay

    mov r0, r4

    pop {r4, lr}
    bx lr


@ Function Declaration
@ Function: busy_delay
@ Purpose: Perform a simple delay loop
.global scao8658_string_test

scao8658_string_test:

StringLoop:
    ldrb r1, [r0]
    cmp r1, #0
    beq OutLabel

    add r0, r0, #1
    b StringLoop

OutLabel:
    bkpt
    bx lr

.size scao8658_string_test, .-scao8658_string_test
.align 2
.syntax unified
.global scao8658_a2
.code 16
.thumb_func
.type scao8658_a2, %function

@ Function Declaration : int scao8658_a2(int num, int wait)
@
@ Input:
@   r0 = num
@   r1 = wait
@
@ Returns:
@   r0 = total toggle count
@
scao8658_a2:

    push {r4, r5, r6, r7, lr}

    mov r4, r0
    mov r5, r1
    mov r6, #0

a2_cycle_loop:

    cmp r4, #0
    beq a2_done

    mov r7, #0

a2_led_loop:

    cmp r7, #8
    beq a2_cycle_done

    mov r0, r7
    bl BSP_LED_Toggle

    add r6, r6, #1

    mov r0, r5
    bl busy_delay

    add r7, r7, #1
    b a2_led_loop

a2_cycle_done:

    sub r4, r4, #1
    b a2_cycle_loop

a2_done:

    mov r0, r6

    pop {r4, r5, r6, r7, lr}
    bx lr

.size scao8658_a2, .-scao8658_a2
.global busy_delay
.type busy_delay, %function
busy_delay:
    push {r6}

    mov r6, r0

delay_label:
    subs r6, r6, #1
    bge delay_label

    mov r0, #0

    pop {r6}
    bx lr
