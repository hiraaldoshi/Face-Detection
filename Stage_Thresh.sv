module Stage_Threshold (

input int stage_num,
output real value

);

string name;
assign name = {"STAGE_THRESH_", $sformatf("%d", stage_num)};

always_comb
    begin

        case (name)

            "STAGE_THRESH_0": value  <= 0.82268941402435302734;
            "STAGE_THRESH_1": value  <= 6.95660877227783203125;
            "STAGE_THRESH_2": value  <= 9.49854278564453125000;
            "STAGE_THRESH_3": value  <= 18.41296958923339843750;
            "STAGE_THRESH_4": value  <= 15.32413959503173828125;
            "STAGE_THRESH_5": value  <= 21.01063919067382812500;
            "STAGE_THRESH_6": value  <= 23.91879081726074218750;
            "STAGE_THRESH_7": value  <= 24.52787971496582031250;
            "STAGE_THRESH_8": value  <= 27.15335083007812500000;
            "STAGE_THRESH_9": value  <= 34.55411148071289062500;
            "STAGE_THRESH_10": value  <= 39.10728836059570312500;
            "STAGE_THRESH_11": value  <= 50.61048126220703125000;
            "STAGE_THRESH_12": value  <= 54.62007141113281250000;
            "STAGE_THRESH_13": value  <= 50.16973114013671875000;
            "STAGE_THRESH_14": value  <= 66.66912078857421875000;
            "STAGE_THRESH_15": value  <= 67.69892120361328125000;
            "STAGE_THRESH_16": value  <= 69.22987365722656250000;
            "STAGE_THRESH_17": value  <= 79.24907684326171875000;
            "STAGE_THRESH_18": value  <= 87.69602966308593750000;
            "STAGE_THRESH_19": value  <= 90.25334930419921875000;
            "STAGE_THRESH_20": value  <= 104.74919891357421875000;
            "STAGE_THRESH_21": value  <= 105.76110076904296875000;

            default: value <= -1;

        endcase

    end

endmodule 
