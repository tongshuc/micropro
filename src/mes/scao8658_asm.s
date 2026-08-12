@ Assembly File - Lab 8 Version
@
@ NOTE THERE IS A DATA SECTION AT THE END OF THIS FILE FOR ASSIGNMENT 4
@ USE THAT DATA SECTION FOR ANY DATA YOU NEED, DO NOT ADD ANOTHER.

@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 


    .code   16              @ This directive selects the instruction set being generated. 
                            @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                   @ Tell the assembler that the upcoming section is to be considered
                            @ assembly language instructions - Code section (text -> ROM)

@@ Function Header Block
    .align  2               @ Code alignment - 2^n alignment (n=2)
                            @ This causes the assembler to use 4 byte alignment

    .syntax unified         @ Sets the instruction set to the new unified ARM + THUMB
                            @ instructions. The default is divided (separate instruction sets)

    .global scao8658_lab8        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   scao8658_lab8, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : void scao8658_lab8(void)
@
@ Input: none
@ Returns: nothing
@ 

@ Here is the actual scao8658_lab8 function
scao8658_lab8:
    push {lr}

    @ For now, this function just toggles, delays, and toggles again.
    mov r0, #3
    bl BSP_LED_Toggle

    ldr r0, =0xFFFFFFF
    bl busy_delay

    mov r0, #3
    bl BSP_LED_Toggle

    pop {lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   scao8658_lab8, .-scao8658_lab8    @@ - symbol size (not strictly required, but makes the debugger happy)




.global scao8658_a4
.type   scao8658_a4, %function

@ Function Declaration : int scao8658_a4(int x)
@
@ Input: Document this
@ Returns: Document this
@ 

@ Here is the actual function
scao8658_a4:
    push {r4-r6, lr}

    @ r0 = status
    @ r1 = num_to_skip
    @ r2 = direction

    @ save running status
    ldr r4, =a4_is_running
    str r0, [r4]

    @ save skip value
    ldr r4, =a4_skip_value
    str r1, [r4]

    @ reset current skip counter
    ldr r4, =a4_skip_count
    mov r5, #0
    str r5, [r4]

    @ if direction != 0, save it
    cmp r2, #0
    beq keep_direction

    ldr r4, =a4_direction
    str r2, [r4]

keep_direction:

    @ start from LED0
    ldr r4, =a4_current_led
    mov r5, #0
    str r5, [r4]

    @ turn off all LEDs
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

    mov r0, #0

    pop {r4-r6, lr}
    bx lr


.global scao8658_a4_btn
.type   scao8658_a4_btn, %function

@ Function Declaration : void scao8658_a4_btn(void)
@
@ Input: None
@ Returns: Nothing
@ 
@ Reminder - this requires the button has been initialized as an interrupt
@ in main.c using BSP_PB_Init(BUTTON_USER, BUTTON_MODE_EXTI)
@ as well as requires a new function set up void EXTI0_IRQHandler(void)

@ Here is the actual function
.global scao8658_a5
.type scao8658_a5, %function

@ Function Declaration : int scao8658_a5(int status, int num_to_skip, int direction)
@
@ Input:
@   r0 = status
@   r1 = num_to_skip
@   r2 = direction
@
@ Returns:
@   r0 = 0 on success
@
@ This function starts or stops Assignment 5 processing.

scao8658_a5:
    push {r4, lr}

    @ Save A5 running status
    ldr r4, =a5_running
    str r0, [r4]

    @ Return success
    mov r0, #0

    pop {r4, lr}
    bx lr

.size scao8658_a5, .-scao8658_a5
scao8658_a4_btn:
    push {lr}

    ldr r1, =a4_button_count        @ Get the address of the counter
    ldr r0, [r1]                    @ Get the actual count
    add r0, r0, #1                  @ Increment the count
    and r0, #7                      @ Keep the count between 0 and 7
    str r0, [r1]                    @ Store the new count

    bl BSP_LED_Toggle               @ Toggle the current LED

    pop {lr}
    bx lr
    .size   scao8658_a4_btn, .-scao8658_a4_btn


.global scao8658_a4_tick
.type  scao8658_a4_tick, %function

@ Function Declaration : void scao8658_a4_tick(void)
@
@ Input: None
@ Returns: Nothing
@ 

@ Here is the actual function
scao8658_a4_tick:
  push {r4-r6, lr}

    @ As a starting point, this function implements the basics needed
    @ to determine if our A4 logic should be running.
    @
    @ You will have to add logic here for A4.

    @ Some useful notes
    @
    @ BSP_LED_On, BSP_LED_Off - same argument as BSP_LED_Toggle, sets
    @ the LED to ON or OFF as you tell it
    @
    @ How to delay: DO NOT use busy_delay - remember, this is an interrupt
    @ handler. If you need a delay, use a counter to count how many times
    @ this function has been called, and use that to skip a desired number
    @ of calls.


        @ Is A4 running?
    ldr r1, =a4_is_running
    ldr r0, [r1]

    cmp r0, #0
    ble a4_skip

    @ Load current skip counter
    ldr r1, =a4_skip_count
    ldr r2, [r1]

    @ Increment counter
    add r2, r2, #1

    @ Load required skip value
    ldr r3, =a4_skip_value
    ldr r4, [r3]

    @ Compare
    cmp r2, r4
    ble store_and_exit

    @ Time to perform an action
    mov r2, #0
    str r2, [r1]

       @ Toggle the current LED
    ldr r5, =a4_current_led
    ldr r0, [r5]
    bl BSP_LED_Toggle

    @ Load the direction
    ldr r6, =a4_direction
    ldr r6, [r6]

    @ Move to the previous LED when direction is negative
    cmp r6, #0
    blt move_decreasing

    @ Positive direction: current LED = current LED + 1
    ldr r0, [r5]
    add r0, r0, #1
    and r0, r0, #7
    str r0, [r5]
    b a4_skip

move_decreasing:
    @ Negative direction: current LED = current LED - 1
    ldr r0, [r5]
    sub r0, r0, #1
    and r0, r0, #7
    str r0, [r5]

    b a4_skip

store_and_exit:
    str r2, [r1]

a4_skip:

    @ ***** End of our tick function
   pop {r4-r6, lr}
   bx lr
    .size   scao8658_a4_tick, .-scao8658_a4_tick


@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 is how many cycles to delay)
@ Returns: r0
@ 

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION
.global scao8658_a5_tick
.type scao8658_a5_tick, %function

@ Function Declaration : void scao8658_a5_tick(void)
@
@ Input: None
@ Returns: Nothing
@
@ A5 periodic tick function.
@ A5 logic only executes while a5_running is non-zero.

scao8658_a5_tick:
    push {lr}

    @ Load the A5 running flag
    ldr r1, =a5_running
    ldr r0, [r1]

    @ Skip A5 logic when A5 is not running
    cmp r0, #0
    ble a5_skip

    
    @ Load the GPIO output data register address
    ldr r1, =LEDaddress
    ldr r1, [r1]

    @ Read the current LED states
    ldrh r0, [r1]

    @ Toggle the four corner LEDs
    ldr r2, =0xAA00
    eor r0, r0, r2

    @ Store the new LED states directly to GPIO
    strh r0, [r1]

a5_skip:
    pop {lr}
    bx lr

.size scao8658_a5_tick, .-scao8658_a5_tick
busy_delay:
    push {r6}
    mov r6, r0

    d3lay_loop:
        subs r6, r6, #1
        bge d3lay_loop

        mov r0, #0      @ Return zero (success)

    pop {r6}
    bx lr               @ Return to calling function
@@ Function Header Block
.align 2
.global scao8658_lab9

.code 16
.thumb_func

.type scao8658_lab9, %function

@ Function Declaration: int scao8658_lab9(void)
@
@ Input: None
@ Returns: r0
@
scao8658_lab9:
    push {lr}

    ldr r1, =LEDaddress
    ldr r1, [r1]

    ldrh r0, [r1]

    ldr r2, =0xAA00
     eor r0, r0, r2

    strh r0, [r1]

    mov r0, #0

   pop {lr}
   bx lr

.size scao8658_lab9, .-scao8658_lab9
LEDaddress:
    .word 0x48001014


@ Here is another data section, we will use it for some key interrupt items
@ We will put all necessary data for A4 in this block
.data

a4_is_running:    .word 0
a4_button_count:  .word 0

a4_skip_count:    .word 0
a4_skip_value:    .word 0

a4_direction:     .word 1

a4_current_led:   .word 0
a5_running:       .word 0

@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.

