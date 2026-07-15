@ Test code for my own new function called from C

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

    .global scao8658_lab6        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   scao8658_lab6, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int scao8658_lab6(int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 

@ Here is the actual scao8658_lab6 function
@ Function Declaration : int scao8658_lab6(int wait)
@
@ Input: r0 = delay value from user
@ Returns: r0 = number of LED toggles before button press
@
@ This function toggles LEDs from index 7 down to 0.
@ After each toggle, it delays, then checks the user button.
@ If the button is pressed, the function returns the toggle count.

scao8658_lab6:
    push {r4, r5, r6, lr}

    mov r4, r0              @ r4 = wait value
    mov r5, #7              @ r5 = LED index
    mov r6, #0              @ r6 = toggle counter

lab6_loop:
    cmp r5, #0              @ check whether index is below 0
    bge lab6_index_ok       @ if index >= 0, continue

    mov r5, #7              @ reset LED index to 7

lab6_index_ok:
    mov r0, r5              @ r0 = current LED index
    bl BSP_LED_Toggle       @ toggle current LED

    add r6, r6, #1          @ increase toggle counter

    sub r5, r5, #1          @ move to next LED index

    mov r0, r4              @ r0 = delay value
    bl busy_delay           @ wait

    mov r0, #0              @ BUTTON_USER = 0
    bl BSP_PB_GetState      @ read user button state

    cmp r0, #0              @ 0 means button not pressed
    beq lab6_loop           @ continue if button not pressed

    mov r0, r6              @ return toggle counter

    pop {r4, r5, r6, lr}
    bx lr
    .size scao8658_lab6, .-scao8658_lab6
@@ Function Header Block
.global scao8658_lab7
.type scao8658_lab7,%function

scao8658_lab7:
    push {lr}

    @ r0 already contains delay
    bl busy_delay

    mov r0,#0

    pop {lr}
    bx lr

.size scao8658_lab7,.-scao8658_lab7
.global scao8658_a3
.type   scao8658_a3, %function

@ Function Declaration: int scao8658_a3(char *pattern_ptr)
@
@ Input: r0 (i.e. r0 is a pointer to the first character of the pattern)
@ Returns: r0
@ 

@ Here is the function
scao8658_a3:

    bx lr
    .size   scao8658_a3, .-scao8658_a3

@ Function Declaration: int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 is how many cycles to delay)
@ Returns: r0
@ 

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION
busy_delay:
    push {r6}
    mov r6, r0

    d3lay_loop:
        subs r6, r6, #1
        bge d3lay_loop

        mov r0, #0      @ Return zero (success)

    pop {r6}
    bx lr               @ Return to calling function


@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
