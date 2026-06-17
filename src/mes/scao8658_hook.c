/*
 * C to assembler menu hook
 *
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int scao8658_add_test(int x, int y, uint32_t delay);

void AddTest(int action)
{
    if(action==CMD_SHORT_HELP)
        return;

    if(action==CMD_LONG_HELP)
    {
        printf("Addition Test\n\n"
               "This command tests new addition function by scao8658\n");
        return;
    }
uint32_t delay;
int fetch_status;

fetch_status = fetch_uint32_arg(&delay);

if(fetch_status)
{
    delay = 0xFFFFFF;
}

    printf("scao8658_add_test returned: %d\n",
       scao8658_add_test(99, 87, delay));
}

ADD_CMD("scao8658_add", AddTest,
        "Test the new add function");
int scao8658_string_test(char *p);

void scao8658_StringTest(int action)
{
    if(action==CMD_SHORT_HELP)
        return;

    if(action==CMD_LONG_HELP)
    {
        printf("String Test\n\n"
               "This command tests new string function by scao8658\n");
        return;
    }

    int fetch_status;
    char *destptr;

    fetch_status = fetch_string_arg(&destptr);

    if(fetch_status)
    {
        return;
    }

    printf("string_test returned: %d\n",
           scao8658_string_test(destptr));
}

ADD_CMD("scao8658_string",
        scao8658_StringTest,
        "Test the new string function")
