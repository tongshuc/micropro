/*
 *  C to assembler menu hook - Lab 8 Version
 *
 *  Modified by 
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "stm32f3_discovery_gyroscope.h"

#include "common.h"

#define N 500

// A4 Interrupt Handlers - these are in scao8658_asm.s
void scao8658_a4_btn(void);
void scao8658_a4_tick(void);


// Timer tick hook for our timer interrupt
// driven programming.
//
// Note that for now, this function toggles LED 0 every N cycles.
void scao8658_tick(void)
{
  // Our tick variable is static so that it keeps its value from one
  // function call to the next.
  //
  // If this was not static, this would not work because ticks would
  // get reinitialized every time the function was called.
  static int32_t ticks;
  
  // Increment our tick count every time the timer interrupt fires.
  // Can you measure approximately how fast the tick is running? Try
  // timing how long it takes for the LED to blink 10 times.
  ticks++;

  // Every time we reach N cycles, reset the tick count to zero
  // and toggle LED 0.
  //
  // This proves to us that our interrupt is working.
  if (ticks > N)
  {
    ticks = 0;
    scao8658_a4_tick();
  }


}

// Button press hook for our button interrupt
// driven programming.
//
// Note that for now, this function toggles LED 6 when the button is pressed.
void scao8658_btn(void)
{
  // For now, just toggle an LED to prove the button press was noticed.
  scao8658_a4_btn();
}

int scao8658_lab8(void);

void Lab8_scao8658(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 8\n\n"
	   "This command tests new lab 8 function by scao8658\n"
	   );

    return;
  }


  printf("scao8658_lab8 returned: %d\n", scao8658_lab8() );
}


ADD_CMD("scao8658_lab8", Lab8_scao8658,"Test the new lab 8 function")
// Assembly function for Lab 9
int scao8658_lab9(void);

// Menu command for Lab 9
void Lab9_scao8658(int action)
{
    if (action == CMD_SHORT_HELP)
        return;

    if (action == CMD_LONG_HELP)
    {
        printf(
            "Lab 9\n\n"
            "This command tests new lab 9 function by scao8658\n"
        );
        return;
    }

    printf("scao8658_lab9 returned: %d\n", scao8658_lab9());
}

ADD_CMD(
    "scao8658_lab9",
    Lab9_scao8658,
    "Test the new lab 9 function"
)

int scao8658_a4(int status, int num_to_skip, int direction);

void A4_scao8658(int action)
{
    if(action==CMD_SHORT_HELP)
        return;

    if(action==CMD_LONG_HELP)
    {
        printf("Assignment 4 Test\n\n"
               "This command tests new A4 function by scao8658\n");
        return;
    }

    int fetch_status;

    uint32_t status = 1;
    uint32_t num_to_skip = 0;
    int32_t direction = 1;

    fetch_status = fetch_uint32_arg(&status);
    if(fetch_status)
        status = 1;

    fetch_status = fetch_uint32_arg(&num_to_skip);
    if(fetch_status)
        num_to_skip = 0;

    fetch_status = fetch_int32_arg(&direction);
    if(fetch_status)
        direction = 1;

    printf("scao8658_a4 returned: %d\n",
           scao8658_a4(status, num_to_skip, direction));
}

ADD_CMD("scao8658_a4", A4_scao8658,"Test the A4 function")

// Watchdog functions implemented in watchdog.c
void mes_InitIWDG(int reload);
void mes_IWDGStart(void);
void mes_IWDGRefresh(void);

// Lab 10 watchdog menu command
void Lab10_scao8658(int action)
{
    if (action == CMD_SHORT_HELP)
        return;

    if (action == CMD_LONG_HELP)
    {
        printf(
            "Lab 10\n\n"
            "This command tests the watchdog timer by scao8658\n"
        );
        return;
    }

    uint32_t reload = 9999;
int fetch_status;

fetch_status = fetch_uint32_arg(&reload);

if (fetch_status)
{
    reload = 9999;
}

printf("Initializing Watchdog with reload value %lu\n",
       (unsigned long)reload);

mes_InitIWDG(reload);

    printf("Starting Watchdog\n");
    mes_IWDGStart();
}

ADD_CMD(
    "scao8658_lab10",
    Lab10_scao8658,
    "Test the new Lab 10 function"
)




