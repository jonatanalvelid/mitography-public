% Calculate Tukey critera per cell, from image-to-image tukeys
tukeys = tukeys;
fileNumbersCells4 = [1 3;4 5;6 7;8 10;11 13;14 16;17 19;20 22;23 25;26 27;28 30;31 33;34 36;37 39;40 41];
fileNumbersCells5 = [1 2;3 6;7 9;10 13;14 16;17 19;20 22;23 25;26 27;28 30;31 33;34 35;36 37;38 39;41 42;43 44;45 47;48 49];

fileNumbersCells = fileNumbersCells5;
for i = 1:length(fileNumbersCells)
    temp = tukeys(fileNumbersCells(i,1):fileNumbersCells(i,2));
    temp = temp(~isnan(temp));
    mean(temp)
end