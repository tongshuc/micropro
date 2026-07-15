
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

int scao8658_a3(char *pattern_ptr);

void A3_scao8658(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 3 Test\n\n"
	   "This is the A3 function by scao8658\n"
	   );

    return;
  }

  int fetch_status;
  char *pattern;

  fetch_status = fetch_string_arg(&pattern);

  if (fetch_status) {
    // Default logic goes here
    pattern = "Test Pattern";
  }

  printf("scao8658_a3 returned: %d\n", scao8658_a3(pattern) );
}

ADD_CMD("scao8658_a3", A3_scao8658,"Run A3 for scao8658")

