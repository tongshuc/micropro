@ Assembly File - Lab 8 / Assignment 5 Version
@
@ NOTE THERE IS A DATA SECTION AT THE END OF THIS FILE.
@ USE THAT DATA SECTION FOR ANY DATA YOU NEED, DO NOT ADD ANOTHER.


@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols.


    .code   16
    .text

    .align  2
    .syntax unified


@ ============================================================
@ LAB 8
@ ============================================================

    .global scao8658_lab8
    .code   16
    .thumb_func
    .type   scao8658_lab8, %function


@ Function Declaration : void scao8658_lab8(void)
@
@ Input: None
@ Returns: Nothing
@
@ Lab 8 test function.


scao8658_lab8:
    push {lr}

    @ Toggle LED 3
    mov r0, #3
    bl BSP_LED_Toggle

    @ Delay
    ldr r0, =0xFFFFFFF
    bl busy_delay

    @ Toggle LED 3 again
    mov r0, #3
    bl BSP_LED_Toggle

    pop {lr}
    bx lr

    .size scao8658_lab8, .-scao8658_lab8



@ ============================================================
@ ASSIGNMENT 4 MAIN FUNCTION
@ ============================================================

    .global scao8658_a4
    .type   scao8658_a4, %function


@ Function Declaration :
@ int scao8658_a4(int status, int num_to_skip, int direction)
@
@ Input:
@   r0 = status
@   r1 = num_to_skip
@   r2 = direction
@
@ Returns:
@   r0 = 0 on success
@


scao8658_a4:
    push {r4-r6, lr}

    @ Save running status
    ldr r4, =a4_is_running
    str r0, [r4]

    @ Save skip value
    ldr r4, =a4_skip_value
    str r1, [r4]

    @ Reset current skip counter
    ldr r4, =a4_skip_count
    mov r5, #0
    str r5, [r4]

    @ If direction is zero, keep the previous direction
    cmp r2, #0
    beq keep_direction

    @ Save new direction
    ldr r4, =a4_direction
    str r2, [r4]


keep_direction:

    @ Start from LED 0
    ldr r4, =a4_current_led
    mov r5, #0
    str r5, [r4]

    @ Turn off all LEDs
    mov r0, #0
    bl BSP_LED_Off

    mov r0, #1
    bl BSP_LED_Off

    mov r0, #2
    bl BSP_LED_Off

    mov r0, #3
    bl BSP_LED_Off

    mov r0, #4
    bl BSP_LED_Off

    mov r0, #5
    bl BSP_LED_Off

    mov r0, #6
    bl BSP_LED_Off

    mov r0, #7
    bl BSP_LED_Off

    @ Return success
    mov r0, #0

    pop {r4-r6, lr}
    bx lr

    .size scao8658_a4, .-scao8658_a4



@ ============================================================
@ ASSIGNMENT 5 MAIN FUNCTION
@ ============================================================

    .global scao8658_a5
    .type   scao8658_a5, %function


@ Function Declaration :
@ int scao8658_a5(int status, int num_to_skip, int direction)
@
@ Input:
@   r0 = status
@   r1 = num_to_skip
@   r2 = direction
@
@ Returns:
@   r0 = 0 on success
@
@ This function enables Assignment 5 processing and starts
@ the independent watchdog.
@


scao8658_a5:
    push {r4, lr}

    @ Save A5 running status
    ldr r4, =a5_running
    str r0, [r4]

    @ Initialize watchdog using reload value 8000
    ldr r0, =8000
    bl mes_InitIWDG

    @ Start the watchdog
    bl mes_IWDGStart

    @ Return success
    mov r0, #0

    pop {r4, lr}
    bx lr

    .size scao8658_a5, .-scao8658_a5



@ ============================================================
@ ASSIGNMENT 4 BUTTON FUNCTION
@ ============================================================

    .global scao8658_a4_btn
    .type   scao8658_a4_btn, %function


@ Function Declaration : void scao8658_a4_btn(void)
@
@ Input: None
@ Returns: Nothing
@
@ This function is called by the user button interrupt.
@


scao8658_a4_btn:
    push {lr}

    @ Get address of button counter
    ldr r1, =a4_button_count

    @ Load current count
    ldr r0, [r1]

    @ Increment count
    add r0, r0, #1

    @ Keep count between 0 and 7
    and r0, #7

    @ Store new count
    str r0, [r1]

    @ Toggle the selected LED
    bl BSP_LED_Toggle

    pop {lr}
    bx lr

    .size scao8658_a4_btn, .-scao8658_a4_btn



@ ============================================================
@ ASSIGNMENT 5 BUTTON FUNCTION
@ ============================================================

    .global scao8658_a5_btn
    .type   scao8658_a5_btn, %function


@ Function Declaration : void scao8658_a5_btn(void)
@
@ Input: None
@ Returns: Nothing
@
@ Records that the user button has been pressed.
@ The A5 tick function uses this flag to stop refreshing
@ the watchdog.
@


scao8658_a5_btn:
    push {lr}

    @ Get address of the A5 button flag
    ldr r1, =a5_btn_pressed

    @ Set button flag to one
    mov r0, #1
    str r0, [r1]

    pop {lr}
    bx lr

    .size scao8658_a5_btn, .-scao8658_a5_btn



@ ============================================================
@ ASSIGNMENT 4 TICK FUNCTION
@ ============================================================

    .global scao8658_a4_tick
    .type   scao8658_a4_tick, %function


@ Function Declaration : void scao8658_a4_tick(void)
@
@ Input: None
@ Returns: Nothing
@
@ Timer-driven Assignment 4 LED processing.
@ No busy delays are used inside this interrupt-driven code.
@


scao8658_a4_tick:
    push {r4-r6, lr}

    @ Check whether Assignment 4 is running
    ldr r1, =a4_is_running
    ldr r0, [r1]

    cmp r0, #0
    ble a4_skip

    @ Load current skip counter
    ldr r1, =a4_skip_count
    ldr r2, [r1]

    @ Increment skip counter
    add r2, r2, #1

    @ Load required skip value
    ldr r3, =a4_skip_value
    ldr r4, [r3]

    @ Check whether enough ticks have occurred
    cmp r2, r4
    ble store_and_exit

    @ Reset skip counter
    mov r2, #0
    str r2, [r1]

    @ Load current LED
    ldr r5, =a4_current_led
    ldr r0, [r5]

    @ Toggle current LED
    bl BSP_LED_Toggle

    @ Load direction
    ldr r6, =a4_direction
    ldr r6, [r6]

    @ Negative direction moves to previous LED
    cmp r6, #0
    blt move_decreasing

    @ Positive direction:
    @ current LED = current LED + 1
    ldr r0, [r5]
    add r0, r0, #1
    and r0, r0, #7
    str r0, [r5]

    b a4_skip


move_decreasing:

    @ Negative direction:
    @ current LED = current LED - 1
    ldr r0, [r5]
    sub r0, r0, #1
    and r0, r0, #7
    str r0, [r5]

    b a4_skip


store_and_exit:

    @ Store updated skip counter
    str r2, [r1]


a4_skip:

    pop {r4-r6, lr}
    bx lr

    .size scao8658_a4_tick, .-scao8658_a4_tick



@ ============================================================
@ ASSIGNMENT 5 TICK FUNCTION
@ ============================================================

    .global scao8658_a5_tick
    .type   scao8658_a5_tick, %function


@ Function Declaration : void scao8658_a5_tick(void)
@
@ Input: None
@ Returns: Nothing
@
@ This function is called periodically by the timer interrupt.
@
@ When A5 is running:
@   1. Toggle the four corner LEDs using direct memory access.
@   2. Check whether the user button has been pressed.
@   3. Refresh the watchdog while the button has not been pressed.
@
@ When the button is pressed, watchdog refreshing stops.
@ The watchdog will then eventually reset the board.
@


scao8658_a5_tick:
    push {lr}

    @ Get address of A5 running flag
    ldr r1, =a5_running

    @ Load A5 running status
    ldr r0, [r1]

    @ Skip all A5 processing when A5 is not running
    cmp r0, #0
    ble a5_skip


    @ --------------------------------------------------------
    @ Direct LED addressing
    @ --------------------------------------------------------

    @ Load GPIO output data register address
    ldr r1, =LEDaddress
    ldr r1, [r1]

    @ Read current LED states
    ldrh r0, [r1]

    @ Toggle four corner LEDs
    @ 0xAA00 selects the four required LED bits
    ldr r2, =0xAA00
    eor r0, r0, r2

    @ Store updated LED states directly to GPIO
    strh r0, [r1]


    @ --------------------------------------------------------
    @ Watchdog processing
    @ --------------------------------------------------------

    @ Get address of button pressed flag
    ldr r1, =a5_btn_pressed

    @ Load button pressed status
    ldr r0, [r1]

    @ If button has been pressed, do not refresh watchdog
    cmp r0, #0
    bne a5_skip

    @ Button has not been pressed, so keep watchdog alive
    bl mes_IWDGRefresh


a5_skip:

    pop {lr}
    bx lr

    .size scao8658_a5_tick, .-scao8658_a5_tick



@ ============================================================
@ BUSY DELAY
@ ============================================================


@ Function Declaration : int busy_delay(int cycles)
@
@ Input:
@   r0 = number of cycles to delay
@
@ Returns:
@   r0 = 0
@
@ DO NOT USE THIS FUNCTION FROM THE A5 TICK FUNCTION.
@


busy_delay:
    push {r6}

    @ Save number of delay cycles
    mov r6, r0


d3lay_loop:

    @ Decrement delay counter
    subs r6, r6, #1

    @ Continue until counter becomes negative
    bge d3lay_loop

    @ Return success
    mov r0, #0

    pop {r6}
    bx lr



@ ============================================================
@ LAB 9
@ ============================================================

    .align 2
    .global scao8658_lab9

    .code 16
    .thumb_func

    .type scao8658_lab9, %function


@ Function Declaration : int scao8658_lab9(void)
@
@ Input: None
@ Returns:
@   r0 = 0
@
@ Lab 9 direct LED addressing test.
@


scao8658_lab9:
    push {lr}

    @ Load address containing the LED GPIO address
    ldr r1, =LEDaddress

    @ Load actual GPIO address
    ldr r1, [r1]

    @ Read current GPIO output
    ldrh r0, [r1]

    @ Toggle selected LED bits
    ldr r2, =0xAA00
    eor r0, r0, r2

    @ Write new GPIO output
    strh r0, [r1]

    @ Return success
    mov r0, #0

    pop {lr}
    bx lr

    .size scao8658_lab9, .-scao8658_lab9



@ ============================================================
@ LED GPIO ADDRESS
@ ============================================================

LEDaddress:
    .word 0x48001014



@ ============================================================
@ DATA SECTION
@ ============================================================

    .data


@ Assignment 4 variables

a4_is_running:
    .word 0

a4_button_count:
    .word 0

a4_skip_count:
    .word 0

a4_skip_value:
    .word 0

a4_direction:
    .word 1

a4_current_led:
    .word 0


@ Assignment 5 variables

a5_running:
    .word 0

a5_btn_pressed:
    .word 0



@ ============================================================
@ END OF ASSEMBLY FILE
@ ============================================================

    .end
