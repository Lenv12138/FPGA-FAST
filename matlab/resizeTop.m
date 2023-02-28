%% matlab 双线性插值

% img = '../tb/tb_data/test_1136_pic_input.bmp';
img = './1_L.png';
I = imread(img);
I = rgb2gray(I);
I_1136_test = imblizoom(I, 0.8);

% mx_fid = fopen('./keyPointx_SIMD.txt', 'r');
% [keyPointy_SIMD, num_r] = fscanf(my_fid,'%03d',[1 inf]);

I_1136 = imresize(I, 0.8, 'bilinear');

% 将图片写入txt文件
% [r_size, c_size] = size(I);
% fid_gray = fopen('./1_L_gray.txt');
% for r=1:r_size
%     for c=1:c_size
%         fprintf(fid_gray, '%03d', I(r,c));
%     end
% end
% fclose(fid_gray);

% file1 = fopen('./1_L_gray_y.txt', 'r');
% [r_hdl, num_r] = fscanf(file1,'%03d',[1 inf]);
% r_hdl = r_hdl + 1;

figure
imshow(I);

figure
imshow(I_1136);