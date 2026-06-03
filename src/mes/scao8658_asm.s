.syntax unified
.cpu cortex-m4
.thumb

.global scao8658_add_test

scao8658_add_test:
    push {r4, lr}

    add r4, r0, r1

    mov r0, r2
    bl busy_delay

    mov r0, r4

    pop {r4, lr}
    bx lr
.global busy_delay

busy_delay:
    push {r6}

    mov r6, r0

delay_label:
    subs r6, r6, #1
    bge delay_label

    mov r0, #0

    pop {r6}

    bx lr
