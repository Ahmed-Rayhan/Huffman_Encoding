
% Huffman Encoding and Decoding to compress an image, code developed by Ahmed Rayhan

clc;
clear all;
close all;
number_of_colors = 256;

% Reading image
a = imread('your_image.png');
figure(1), imshow(a), title('Original Image')

% Converting an image to grayscale
grayImage = rgb2gray(a);
figure(2), imshow(grayImage), title('Grayscale Image')

% Using indexed image
[I, myCmap] = rgb2ind(a, number_of_colors);

% Size of the image
[m, n] = size(I);
Totalcount = m * n;

% Variables to find the probability
cnt = 1;

% Computing the cumulative probability
pro = zeros(256, 1);
for i = 0:255
    k = (I == i);
    count = sum(k(:));
    % pro array is having the probabilities
    pro(cnt) = count / Totalcount;
    cnt = cnt + 1;
end

% Display the probabilities
figure(3), bar(0:255, pro)
title('Probability Distribution of Pixel Values')
xlabel('Pixel Value')
ylabel('Probability')
% Probablities can also be found using histcounts
pro1 = histcounts(I,0:256,'Normalization','probability');

cumpro = cumsum(pro); % if the cumulative sum is needed
sigma = sum(pro); % if the sum is needed; should always be 1.0

%Symbols for an image
symbols = 0:255;

%Huffman code Dictionary
dict = huffmandict(symbols,pro);

%function which converts array to vector
newvec = reshape(I,[numel(I),1]);

%Huffman Encodig
hcode = huffmanenco(newvec,dict);

%Huffman Decoding
dhsig1 = huffmandeco(hcode,dict);

%convertign dhsig1 double to dhsig uint8
dhsig = uint8(dhsig1);

%vector to array conversion
back = reshape(dhsig,[m n]);

%converting image from grayscale to rgb
RGB = ind2rgb(back,myCmap);
imwrite(RGB,'decoded.JPG');
figure(3),imshow(RGB)

% Plot the original and Huffman encoded data lengths
original_data_length = numel(I) * 8; % in bits
encoded_data_length = length(hcode);
figure(6), bar([original_data_length, encoded_data_length])
set(gca, 'xticklabel', {'Original Data', 'Encoded Data'})
title('Comparison of Original and Encoded Data Lengths')
ylabel('Number of Bits')
