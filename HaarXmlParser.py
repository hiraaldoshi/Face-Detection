"""
This file is used to convert the HAAR Classifier Data from an XML format into variables, for use in SystemVerilog.
The information is printed, and later put into a header file by using:

    $python HaarXmlParser.py >> examlpe.h

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
            "y_coord": "Y_coord",
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


def Stage_Data_Arr(stage_thresh):
    """
    Generates a double array for the stage thresholds from HAAR data.
    """
    
    print ("double STAGE_DATA[" + str(len(stage_thresh)) + "] = {")
    print ()
    for thresh in stage_thresh.items():
        print ("    " + thresh[1] + ",")

    print ()
    print ("};")


def Feat_Data_Arr(feature_thresh, left, right):
    """
    Generates a double array, containing arrays of size three to hold all corresponding feature data.

        sub arrays contain:
            {feature_thresh, left, right}
    """

    print ("double FEAT_DATA[" + str(len(feature_thresh)) + "][3] = {")
    print ()
    for thresh, l, r in zip(feature_thresh.items(), left.items(), right.items()):
        print ("    {" + thresh[1] + ", " + l[1] + ", " + r[1] + "},")

    print ()
    print ("};")


def Rect_Data_Arr(width, height, x_coord, y_coord):
    """
    Generates a double array, containing arrays of size four to hold all corresponding rectangle data.

        sub arrays contain:
            {width, height, x_coord, y_coord}
    """

    print ("double RECT_DATA[" + str(len(width)) + "][4] = {")
    print ()
    for w, h, x, y in zip(width.items(), height.items(), x_coord.items(), y_coord.items()):
        print ("    {" + w[1] + ", " + h[1] + ", " + x[1] + ", " + y[1] + "},")

    print()
    print ("};")


def C_Code_Gen(variable):
    """
    Function to invoke one of the C Code generating functions

    This function generates one of the three arrays needed for the HAAR_Comparison in C, all of which are of double type
    and varying sizes.
    """
    
    if variable == "stage":
        stage_thresh = haar_parser("stage thresh")
        Stage_Data_Arr(stage_thresh)

    elif variable == "feature":
        feature_thresh = haar_parser("feature thresh")
        left = haar_parser("left")
        right = haar_parser("right")
        Feat_Data_Arr(feature_thresh, left, right)

    elif variable == "rectangle":
        width = haar_parser("width")
        height = haar_parser("height")
        x_coord = haar_parser("x_coord")
        y_coord = haar_parser("y_coord")
        Rect_Data_Arr(width, height, x_coord, y_coord)

    else:
        print ("Parameter did not match, try stage, feature, or rectangle")


if __name__ == '__main__': 
    variable = sys.argv[1]
    C_Code_Gen(variable)
