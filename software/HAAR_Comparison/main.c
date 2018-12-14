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

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	HAAR_PTR[0] = key[3];
	HAAR_PTR[1] = key[2];
	HAAR_PTR[2] = key[1];
	HAAR_PTR[3] = key[0];
	HAAR_PTR[4] = msg_enc[3];
	HAAR_PTR[5] = msg_enc[2];
	HAAR_PTR[6] = msg_enc[1];
	HAAR_PTR[7] = msg_enc[0];

	// set start to high
	HAAR_PTR[14] = 1;

	// wait until decrypt is done, then get from registers
	while(HAAR_PTR[15]!= 1);

	msg_dec[0] = HAAR_PTR[8];
	msg_dec[1] = HAAR_PTR[9];
	msg_dec[2] = HAAR_PTR[10];
	msg_dec[3] = HAAR_PTR[11];

	HAAR_PTR[14]= 0;
	HAAR_PTR[15] = 0;
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{


    return 0;
}
