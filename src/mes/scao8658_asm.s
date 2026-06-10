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
