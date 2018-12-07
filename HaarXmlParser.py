"""
This file is used to convert the HAAR Classifier Data from an XML format into variables, for use in SystemVerilog.
The information is printed, and later put into a header file by using:

    $python HaarXmlParser.py >> examlpe.h

Note: the file was written for use by Python 3

Authors: Hiraal Doshi and Selena Torres
"""

import xml.etree.ElementTree as ET


def sci_notation_to_float(n):
    """
    Converts a string in scientific notation format to a float in regular format
    """

    if 'e' in n:
        exponent = float(n[n.find('e') + 1:])
        number = float(n[:n.find('-') - 1])
        number *= 10**exponent
        
        return number

    return n


def haar_parser():
    """
    Parses needed information from HAAR training data in an XML
    gets: 
            - the (feature) threshold
            - the left value
            - the right value
            - the stage threshold
    """

    tree = ET.parse('haarcascade_frontalface_alt.xml')
    root = tree.getroot()
    stage_number = 0

    for haar_data in root.findall('haarcascade_frontalface_alt'):
        for stage in haar_data.findall('stages'):
            for underscore in stage.findall('_'):
                for tree in underscore.findall('trees'):
                    feature_number = 0

                    STAGE_THRESH = float(sci_notation_to_float(underscore.find('stage_threshold').text))

                    # print the data in form: `define STAGE_THRESH_stage# value
                    # f'{variable:.20f}' is used to suppress the default convention of Python to print floats in sci notation
                    print ("`define STAGE_THRESH_" + str(stage_number) + " " + str(f'{STAGE_THRESH:.20f}') + ";")
                    for underscore_1 in tree.findall('_'):
                        for underscore_2 in underscore_1.findall('_'):

                            # get the desired data
                            FEATURE_THRESH = float(sci_notation_to_float(underscore_2.find('threshold').text))
                            LEFT = float(sci_notation_to_float(underscore_2.find('left_val').text))
                            RIGHT = float(sci_notation_to_float(underscore_2.find('right_val').text))

                            # print the data in the form: `define VARIABLE_stage#_feature# value
                            print ("`define FEATURE_THRESH_" + str(stage_number) + "_" + str(feature_number) + " " + str(f'{FEATURE_THRESH:.20f}') + ";")
                            print ("`define LEFT_" + str(stage_number) + "_" + str(feature_number) + " " + str(f'{LEFT:.20f}') + ";")
                            print ("`define RIGHT_" + str(stage_number) + "_" + str(feature_number) + " " + str(f'{RIGHT:.20f}') + ";")

                            # get the desired data from rectangles
                            for feature in underscore_2.findall('feature'):
                                for rects in feature.findall('rects'):
                                    rectangle_number = 0
                                    for rect in rects.findall('_'):
                                        first_space = rect.text.find(" ")
                                        second_space = rect.text.find(" ", first_space + 1)
                                        third_space = rect.text.find(" ", second_space + 1)
                                        fourth_space = rect.text.find(" ", third_space + 1)

                                        print ("`define X_COORD_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number) + " " + rect.text[0:first_space] + ";")
                                        print ("`define Y_COORD_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number) + rect.text[first_space:second_space] + ";")
                                        print ("`define WIDTH_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number) + rect.text[second_space:third_space] + ";")
                                        print ("`define HEIGHT_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number) + rect.text[third_space:fourth_space] + ";")

                                        rectangle_number += 1

                            feature_number += 1

                    stage_number += 1


if __name__ == '__main__': haar_parser()
