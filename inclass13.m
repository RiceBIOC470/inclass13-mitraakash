% Akash Mitra
% am132

%Inclass 13

%Part 1. In this directory, you will find an image of some cells expressing a 
% fluorescent protein in the nucleus. 
% A. Create a new image with intensity normalization so that all the cell
% nuclei appear approximately eqully bright. 

% Read image
img_reader = bfGetReader('Dish1Well8Hyb1Before_w0001_m0006.tif');
img_iplane = [];
img_iplane2 = [];
chan = img_reader.getSizeC;
for k=1:img_reader.getSizeT
    img_iplane = img_reader.getIndex(img_reader.getSizeZ-1, chan-1, k-1)+1;
    img1 = bfGetPlane(img_reader, img_iplane);
% Dilate and normalize
    img1 = im2double(img1);
    img1_dilate = imdilate(img1, strel('disk',5));
    img1_norm = img1./img1_dilate;
    % imshow(img1_norm,[]);
end

subplot(1,2,1), imshow(img1, []), title('Original Image');

subplot(1,2,2), imshow(img1_norm, [])
title('Intensity normalized image')

% B. Threshold this normalized image to produce a binary mask where the nuclei are marked true. 

img_d = im2double(img1_norm);
img_bright = uint16((2^16-1)*(img_d/max(max(img_d))));
level = graythresh(img_bright);
img_bw = imbinarize(img_bright,level);

figure
imshowpair(img1_norm,img_bw,'montage');

% C. Run an edge detection algorithm and make a binary mask where the edges
% are marked true.

%Finding better edge detection algorithm
BW1 = edge(img1_norm,'sobel');
BW2 = edge(img1_norm,'canny');
figure;
imshowpair(BW1,BW2,'montage')
title('Sobel Filter                                   Canny Filter');

%Working with sobel
img_mask = BW1 > 0;
imshow(img_mask,[]);

% D. Display a three color image where the orignal image is red, the
% nuclear mask is green, and the edge mask is blue. 

img_display = cat(3, img_bw, im2double(imadjust(img1)), img_mask); 
imshow(img_display, []);

%Part 2. Continue with your nuclear mask from part 1. 
%A. Use regionprops to find the centers of the objects

labeledImage = bwlabel(img_bw, 8);    

cellMeasurements = regionprops(labeledImage, 'Centroid');
numberOfBlobs = size(cellMeasurements, 1);

allCellCentroids = [cellMeasurements.Centroid];
centroidsX = allCellCentroids(1:2:end-1);
centroidsY = allCellCentroids(2:2:end);


%B. display the mask and plot the centers of the objects on top of the
%objects


imshow(img_bw,[])
hold on
for i = 1:numel(cellMeasurements)
    plot(centroidsX,centroidsY, 'b*')
end
hold off


%C. Make a new figure without the image and plot the centers of the objects
%so they appear in the same positions as when you plot on the image (Hint: remember
%Image coordinates). 

for i = 1:numel(cellMeasurements)
    plot(centroidsX,centroidsY, 'b*')
end