# Huffman Encoding for Image Compression

This MATLAB code implements Huffman encoding for image compression, providing intermediate steps and visualizations to aid understanding.

## Initialization and Image Reading

```matlab
clc;
clear all;
close all;
number_of_colors = 256;
```

- `clc;` clears the command window.
- `clear all;` clears all variables from the workspace.
- `close all;` closes all figure windows.
- `number_of_colors = 256;` sets the number of colors to 256 for the indexed image.

### Reading and Displaying the Original Image

```matlab
a = imread('your_image.png');
figure(1), imshow(a), title('Original Image');
```

- `a = imread('your_image.png');` reads the image file into the variable `a`.
- `figure(1), imshow(a), title('Original Image');` displays the original image in a figure window with a title.

### Converting the Image to Grayscale

```matlab
grayImage = rgb2gray(a);
figure(2), imshow(grayImage), title('Grayscale Image');
```

- `grayImage = rgb2gray(a);` converts the RGB image to a grayscale image.
- `figure(2), imshow(grayImage), title('Grayscale Image');` displays the grayscale image.

### Converting the Grayscale Image to an Indexed Image

```matlab
[I, myCmap] = rgb2ind(a, number_of_colors);
```

- `[I, myCmap] = rgb2ind(a, number_of_colors);` converts the RGB image to an indexed image, `I`, using 256 colors and stores the colormap in `myCmap`.

### Calculating the Probability Distribution of Pixel Values

```matlab
[m, n] = size(I);
Totalcount = m * n;

cnt = 1;
pro = zeros(256, 1);
for i = 0:255
    k = (I == i);
    count = sum(k(:));
    pro(cnt) = count / Totalcount;
    cnt = cnt + 1;
end
```

- `[m, n] = size(I);` gets the dimensions of the indexed image.
- `Totalcount = m * n;` calculates the total number of pixels in the image.
- The `for` loop calculates the probability distribution of pixel values:
  - `k = (I == i);` creates a binary mask where the pixel value is `i`.
  - `count = sum(k(:));` counts the number of pixels with value `i`.
  - `pro(cnt) = count / Totalcount;` calculates the probability of the pixel value `i`.
  - `cnt = cnt + 1;` increments the counter.

### Displaying the Probability Distribution

```matlab
figure(3), bar(0:255, pro)
title('Probability Distribution of Pixel Values')
xlabel('Pixel Value')
ylabel('Probability')
```

- `figure(3), bar(0:255, pro)` creates a bar plot of the probability distribution.
- `title('Probability Distribution of Pixel Values')` sets the title of the plot.
- `xlabel('Pixel Value')` labels the x-axis.
- `ylabel('Probability')` labels the y-axis.

### Computing Additional Probability Information

```matlab
pro1 = histcounts(I, 0:256, 'Normalization', 'probability');
cumpro = cumsum(pro); 
sigma = sum(pro);
```

- `pro1 = histcounts(I, 0:256, 'Normalization', 'probability');` computes the probability distribution using the `histcounts` function.
- `cumpro = cumsum(pro);` computes the cumulative sum of the probabilities.
- `sigma = sum(pro);` computes the sum of the probabilities (should be 1.0).

### Creating the Huffman Dictionary

```matlab
symbols = 0:255;
dict = huffmandict(symbols, pro);
```

- `symbols = 0:255;` defines the symbols for the pixel values.
- `dict = huffmandict(symbols, pro);` creates the Huffman dictionary based on the symbols and their probabilities.

### Visualizing the Huffman Dictionary

```matlab
code_lengths = cellfun('length', dict(:, 2));
figure(4), bar(0:255, code_lengths)
title('Huffman Code Lengths for Each Symbol')
xlabel('Symbol')
ylabel('Code Length')
```

- `code_lengths = cellfun('length', dict(:, 2));` calculates the length of each Huffman code.
- `figure(4), bar(0:255, code_lengths)` creates a bar plot of the Huffman code lengths.
- `title('Huffman Code Lengths for Each Symbol')` sets the title of the plot.
- `xlabel('Symbol')` labels the x-axis.
- `ylabel('Code Length')` labels the y-axis.

### Encoding the Image using Huffman Encoding

```matlab
newvec = reshape(I, [numel(I), 1]);
hcode = huffmanenco(newvec, dict);
```

- `newvec = reshape(I, [numel(I), 1]);` reshapes the indexed image into a vector.
- `hcode = huffmanenco(newvec, dict);` encodes the vector using Huffman encoding.

### Displaying the Length of the Huffman Encoded Data

```matlab
disp('Length of Huffman encoded data:')
disp(length(hcode))
```

- `disp('Length of Huffman encoded data:')` displays a message.
- `disp(length(hcode))` displays the length of the Huffman encoded data.

### Decoding the Huffman Encoded Data

```matlab
dhsig1 = huffmandeco(hcode, dict);
dhsig = uint8(dhsig1);
back = reshape(dhsig, [m, n]);
```

- `dhsig1 = huffmandeco(hcode, dict);` decodes the Huffman encoded data.
- `dhsig = uint8(dhsig1);` converts the decoded data to `uint8`.
- `back = reshape(dhsig, [m, n]);` reshapes the decoded data back to the original image dimensions.

### Converting Indexed Image Back to RGB and Displaying the Decoded Image

```matlab
RGB = ind2rgb(back, myCmap);
imwrite(RGB, 'decoded.JPG');
figure(5), imshow(RGB), title('Decoded Image')
```

- `RGB = ind2rgb(back, myCmap);` converts the indexed image back to RGB using the original color map.
- `imwrite(RGB, 'decoded.JPG');` writes the decoded image to a file.
- `figure(5), imshow(RGB), title('Decoded Image');` displays the decoded image.

### Comparing Original and Encoded Data Lengths

```matlab
original_data_length = numel(I) * 8; % in bits
encoded_data_length = length(hcode);
figure(6), bar([original_data_length, encoded_data_length])
set(gca, 'xticklabel', {'Original Data', 'Encoded Data'})
title('Comparison of Original and Encoded Data Lengths')
ylabel('Number of Bits')
```

- `original_data_length = numel(I) * 8;` calculates the length of the original data in bits.
- `encoded_data_length = length(hcode);` gets the length of the Huffman encoded data.
- `figure(6), bar([original_data_length, encoded_data_length])` creates a bar plot comparing the lengths of the original and encoded data.
- `set(gca, 'xticklabel', {'Original Data', 'Encoded Data'})` sets the x-axis labels.
- `title('Comparison of Original and Encoded Data Lengths')` sets the title of the plot.
- `ylabel('Number of Bits')` labels the y-axis.
