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
volatile unsigned int * MEM_PTR = (unsigned int *) 0x1000;

/**
 * Determines whether or not the data stored in the integral buffer corresponds to a face.
 *
 * @return : true if it passes all 22 stages, false otherwise
 */
_Bool HAAR_Comparison()
{
	double accumulator = 0;

	double feat_count = 0;
	double rect_count = 0;

	// loop through 22 stages of HAAR Classifiers
	for (double i = 0; i < 22; i++) {
		double feat_upper_bound = feat_count + FEAT_NUMS[(int)i];

		// loop through the features, and the corresponding rectangles
		for (double j = feat_count; j < feat_upper_bound; j++) {
			double integral = 0;
			double rect_upper_bound = rect_count + RECT_NUMS[(int)j];
			for (double k = rect_count; k < rect_upper_bound; k++) {
				for (double x = RECT_DATA[(int)k][2]; x < RECT_DATA[(int)k][2] + RECT_DATA[(int)k][0]; x++) {
					for (double y = RECT_DATA[(int)k][3]; y < RECT_DATA[(int)k][3] + RECT_DATA[(int)k][1]; y++) {

						// increment according to the integral buffer (calculated by hardware)
						integral += MEM_PTR[(int)(y * 20 + x)] / 10000000;
					}
				}
			}
			if (integral > FEAT_DATA[(int)j][0])
				accumulator += FEAT_DATA[(int)j][2];
			else
				accumulator += FEAT_DATA[(int)j][1];
		}

		// if it did not meet the stage threshold, then it is not a face
		if (accumulator < STAGE_DATA[(int)i])
			return 0;
	}

	return 1;
}

/**
 *	Runs the HAAR_Comparison and stores the result in the corresponding register.
 */
int main()
{
	// Do not begin SW calculations until it gets the signal to begin
	while (!MEM_PTR[509]);

	_Bool is_face = HAAR_Comparison();
	MEM_PTR[511] = is_face;

	// tell HW that SW is done
	MEM_PTR[510] = 1;

    return 0;
}
