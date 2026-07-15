
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
int scao8658_lab7(void);

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
    if(action == CMD_SHORT_HELP) {
        return;
    }

    if(action == CMD_LONG_HELP) {
        printf(
            "Lab 7\n\n"
            "This command tests the new lab 7 function by scao8658\n"
        );
        return;
    }

    float xyz[3] = {0};

    BSP_GYRO_GetXYZ(xyz);

    printf(
        "Gyroscope returns:\n"
        " X: %f\n"
        " Y: %f\n"
        " Z: %f\n",
        xyz[0] / 256,
        xyz[1] / 256,
        xyz[2] / 256
    );

    printf(
        "scao8658_lab7 returned: %d\n",
        scao8658_lab7()
    );
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

