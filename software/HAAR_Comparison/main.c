/************************************************************************
 Final Project Nios Software

 Performs the HAAR Comparison stage in software by accessing the on-chip
 memory storage and utilizing the constants in HAAR_Constants.h

 authors: Hiraal Doshi and Selena Torres
 ************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "HAAR_Constants.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * HAAR_PTR = (unsigned int *) 0x1000;

/**
 *
 *
 *  Input:
 */
void Compare_Classifiers()
{

	//	HAAR_PTR[0] = key[3];

}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{


    return 0;
}
