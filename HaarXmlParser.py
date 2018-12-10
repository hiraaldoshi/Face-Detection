"""
This file is used to convert the HAAR Classifier Data from an XML format into variables, for use in SystemVerilog.
The information is printed, and later put into a sv file by using:

    $python HaarXmlParser.py "parameter" >> examlpe.h

Note: the file was written for use by Python 3

Authors: Hiraal Doshi and Selena Torres
"""

import sys
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


def haar_parser(variable):
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

    stage_thresh = {}
    feature_thresh = {}
    left = {}
    right = {}
    x_coord = {}
    y_coord = {}
    width = {}
    height = {}

    for haar_data in root.findall('haarcascade_frontalface_alt'):
        for stage in haar_data.findall('stages'):
            for underscore in stage.findall('_'):
                for tree in underscore.findall('trees'):
                    feature_number = 0

                    STAGE_THRESH = float(sci_notation_to_float(underscore.find('stage_threshold').text))

                    # store the data in form: STAGE_THRESH_stage# : value
                    # f'{variable:.20f}' is used to suppress the default convention of Python to print floats in sci notation
                    stage_thresh["STAGE_THRESH_" + str(stage_number)] = str(f'{STAGE_THRESH:.20f}')
                    for underscore_1 in tree.findall('_'):
                        for underscore_2 in underscore_1.findall('_'):

                            # get the desired data
                            FEATURE_THRESH = float(sci_notation_to_float(underscore_2.find('threshold').text))
                            LEFT = float(sci_notation_to_float(underscore_2.find('left_val').text))
                            RIGHT = float(sci_notation_to_float(underscore_2.find('right_val').text))

                            # store the data in the form: VARIABLE_stage#_feature# : value
                            feature_thresh["FEATURE_THRESH_" + str(stage_number) + "_" + str(feature_number)] = str(f'{FEATURE_THRESH:.20f}')
                            left["LEFT_" + str(stage_number) + "_" + str(feature_number)] = str(f'{LEFT:.20f}')
                            right["RIGHT_" + str(stage_number) + "_" + str(feature_number)] = str(f'{RIGHT:.20f}')

                            # get the desired data from rectangles
                            for feature in underscore_2.findall('feature'):
                                for rects in feature.findall('rects'):
                                    rectangle_number = 0
                                    for rect in rects.findall('_'):
                                        first_space = rect.text.find(" ")
                                        second_space = rect.text.find(" ", first_space + 1)
                                        third_space = rect.text.find(" ", second_space + 1)
                                        fourth_space = rect.text.find(" ", third_space + 1)

                                        x_coord["X_COORD_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number)] = rect.text[0:first_space]
                                        y_coord["Y_COORD_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number)] = rect.text[first_space:second_space]
                                        width["WIDTH_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number)] = rect.text[second_space:third_space]
                                        height["HEIGHT_" + str(stage_number) + "_" + str(feature_number) + "_" + str(rectangle_number)] = rect.text[third_space:fourth_space]

                                        rectangle_number += 1

                            feature_number += 1

                    stage_number += 1

    # figure out which data we need now
    switch = {
            "stage thresh": stage_thresh,
            "feature thresh": feature_thresh,
            "left": left,
            "right": right,
            "x_coord": x_coord,
            "y_coord": y_coord,
            "width": width,
            "height": height
    }

    desired_list = switch.get(variable, "NONE")
    return desired_list


def SystemVerilog_Gen(variable):
    """
    Function to generate SystemVerilog-formatted output; for use in generating long, generic case statements.
    The formatted code is printed to generate output in the following format:
        
        module Variable (

            input string name,
            output real value

        );

        always_comb
            begin

                case (name)

                    option_0: value <= value_0;
                    option_1: value <= value_1;
                    ...
                    ...
                    option_n: value <= value_n;

                    default: value <= 0;

                endcase

            end

        endmodule
    """
    
    switch = {
            "stage thresh": "Stage_Threshold",
            "feature thresh": "Feature_Threshold",
            "left": "Left",
            "right": "Right",
            "x_coord": "X_Coord",
            "y_coord": "Y_Coord",
            "width": "Width",
            "height": "Height"
    }
    
    module_name = switch.get(variable, "NO MATCH")

    # check which module we are making
    if module_name == "NO MATCH":
        print ("The parameter you used did not match, try one of the following:")
        print ()
        print ("    stage thresh, feature thresh, left, right, x_coord, y_coord, width, or height")

        return

    # print the formatted code
    print ("module " + module_name + " (")
    print ()
    print ("input string name,")
    print ("output real value")
    print ()
    print (");")
    print ()
    print ("always_comb")
    print ("    begin")
    print ()
    print ("        case (name)")
    print ()

    # get the data, and print the required cases
    data = haar_parser(variable)
    for key, value in data.items():
        print ("            \"" + key + "\": value  <= " + value + ";")

    print ()
    print ("            default: value <= 0;")
    print ()
    print ("        endcase")
    print ()
    print ("    end")
    print ()
    print ("endmodule ")


if __name__ == '__main__': 
    variable = sys.argv[1]
    SystemVerilog_Gen(variable)
