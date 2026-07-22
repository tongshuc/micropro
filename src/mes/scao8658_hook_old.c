
/* 
*  C to assembler menu hook
 *
 *  Modified by scao8658
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"
#include "stm32f3_discovery_gyroscope.h"
int scao8658_lab6(int wait);
int scao8658_lab7(int delay);

void Lab6_scao8658(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 6\n\n"
	   "This command tests new lab 6 function by scao8658\n"
	   );

    return;
  }

 uint32_t wait;
int fetch_status;

fetch_status = fetch_uint32_arg(&wait);

if(fetch_status){
    wait = 0xFFFFF;
}

printf("scao8658_lab6 returned: %d\n",
       scao8658_lab6(wait));
}

ADD_CMD("scao8658_lab6", Lab6_scao8658,"Test the new lab 6 function")
void Lab7_scao8658(int action)
{
    if(action == CMD_SHORT_HELP)
        return;

    if(action == CMD_LONG_HELP) {
        printf(
            "Lab 7\n\n"
            "Usage: scao8658_lab7 <count> <delay> <axis>\n"
            "axis 0 = all, 1 = X, 2 = Y, 3 = Z\n"
        );
        return;
    }

    uint32_t count;
    uint32_t delay;
    uint32_t axis;

    if(fetch_uint32_arg(&count))
        count = 5;

    if(fetch_uint32_arg(&delay))
        delay = 0xFFFFF;

    if(fetch_uint32_arg(&axis))
        axis = 0;

    if(axis > 3)
        axis = 0;

    float xyz[3] = {0};

    for(uint32_t i = 0; i < count; i++)
    {
        BSP_GYRO_GetXYZ(xyz);

        if(axis == 0) {
            printf(
                "Gyroscope returns:\n"
                " X: %f\n"
                " Y: %f\n"
                " Z: %f\n",
                xyz[0] / 256,
                xyz[1] / 256,
                xyz[2] / 256
            );
        }
        else if(axis == 1) {
            printf("X: %f\n", xyz[0] / 256);
        }
        else if(axis == 2) {
            printf("Y: %f\n", xyz[1] / 256);
        }
        else if(axis == 3) {
            printf("Z: %f\n", xyz[2] / 256);
        }

        scao8658_lab7(delay);
    }

    printf("Done\n");
}
ADD_CMD(
    "scao8658_lab7",
    Lab7_scao8658,
    "Test the new lab 7 function"
)

/*
 * Assembly function for Assignment 3.
 *
 * Parameters:
 *   wait        - delay passed directly to busy_delay
 *   pattern_ptr - pointer to the LED pattern string
 *   num         - maximum number of complete pattern repeats
 *
 * Returns:
 *   Number of times BSP_LED_Toggle was called.
 */
int scao8658_a3(uint32_t wait, char *pattern_ptr, uint32_t num);

/*
 * Menu hook for Assignment 3.
 *
 * Usage:
 *   scao8658_a3 <wait> <pattern> <num>
 *
 * Example:
 *   scao8658_a3 0xFFFFF 11234 5
 *
 * This C function only retrieves the arguments, supplies sensible
 * defaults, calls the assembly function, and prints its return value.
 * All Assignment 3 game logic is implemented in assembly.
 */
void A3_scao8658(int action)
{
    if(action == CMD_SHORT_HELP)
        return;

    if(action == CMD_LONG_HELP) {
        printf(
            "Assignment 3 - Blinking Lights\n\n"
            "Usage: scao8658_a3 <wait> <pattern> <num>\n"
            "  wait    - delay passed directly to busy_delay\n"
            "  pattern - sequence of LED numbers\n"
            "  num     - maximum number of pattern repeats\n"
            "\n"
            "Example:\n"
            "  scao8658_a3 0xFFFFF 11234 5\n"
        );

        return;
    }

    uint32_t wait;
    char *pattern;
    uint32_t num;

    /*
     * Retrieve the arguments in the required order:
     * wait, pattern, num.
     */
    if(fetch_uint32_arg(&wait)) {
        wait = 0xFFFFF;
    }

    if(fetch_string_arg(&pattern)) {
        pattern = "1234";
    }

    if(fetch_uint32_arg(&num)) {
        num = 5;
    }

    printf(
        "scao8658_a3 returned: %d\n",
        scao8658_a3(wait, pattern, num)
    );
}

ADD_CMD(
    "scao8658_a3",
    A3_scao8658,
    "Run Assignment 3 blinking lights"
)

