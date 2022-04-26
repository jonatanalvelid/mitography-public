testimgsm = imgaussfilt(testimg2,0.9);
% testimgsm = testimg;
testimgsm = testimgsm.*(testimgsm>19);
BW = edge(testimgsm,'prewitt');

se = strel('disk',3);
BW = imclose(BW,se);
BW = imdilate(BW,se);
BW = imfill(BW,4,'holes');
BW = imerode(BW,se);

figure
imshow(BW)
