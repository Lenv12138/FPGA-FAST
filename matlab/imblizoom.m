function [ ZI ] = imblizoom(I, zmf )

%----------------------双线性插值法缩放矩阵或图像---------------------------
% Input：
%       I：图像文件名或矩阵（整数值（0~255））
%       zmf：缩放因子，即缩放的倍
% Output：
%       缩放后的图像矩阵 ZI
% Usage:
%       ZI = SSELMHSIC('ImageFileName',zmf)
%       对图像I进行zmf倍的缩放并显示
%    Or:
%       ZI = SSELMHSIC(I,zmf)
%       对矩阵I进行zmf倍的缩放并显示
%    ...
%-------------------------------------------------------------------
    %%%%    Authors:   Zhi Liu
    %%%%    XiDian University Student
    %%%%    EMAIL:     zhiliu.mind@gmail.com
    %%%%    DATE:      16-12-2013
%% Step1 对数据进行预处理
if ~exist('I','var') || isempty(I)
    error('输入图像 I未定义或为空！');
end
if ~exist('zmf','var') || isempty(zmf) || numel(zmf) ~= 1
     error('位移矢量 zmf未定义或为空或 zmf中的元素超过2！');
end
if isstr(I)
    % I为图像索引
    % M为图像索引值所对应的像素值
    [I,M] = imread(I);
end
if zmf <= 0
     error('缩放倍数 zmf的值应该大于0！');
end

%% Step2 通过原始图像和缩放因子得到新图像的大小，并创建新图像。
[IH,IW,ID] = size(I);   % 图像分辨率和数据位宽
% 在老师的代码中, 向下取整
ZIH = floor(IH*zmf); % 计算缩放后的图像高度，最近取整
ZIW = floor(IW*zmf); % 计算缩放后的图像宽度，最近取整
ZI = zeros(ZIH,ZIW,ID); % 创建新图像

%% Step3 扩展矩阵I边缘
% 上下左右各扩展一列.
IT = zeros(IH+2,IW+2,ID);
IT(2:IH+1,2:IW+1,:) = I;

IT(1,2:IW+1,:)=I(1,:,:); IT(IH+2,2:IW+1,:)=I(IH,:,:);
IT(2:IH+1,1,:)=I(:,1,:); IT(2:IH+1,IW+2,:)=I(:,IW,:);
IT(1,1,:) = I(1,1,:);    IT(1,IW+2,:) = I(1,IW,:);
IT(IH+2,1,:) = I(IH,1,:);IT(IH+2,IW+2,:) = I(IH,IW,:);

I=double(I);

%% Step4 由新图像的某个像素（zi，zj）映射到原始图像(ii，jj)处，并插值。
for zj = 1:ZIW         % 对图像进行按列逐元素扫描
    for zi = 1:ZIH
        ii = (zi-1)/zmf; jj = (zj-1)/zmf;
%         ii = (zi)/zmf; jj = (zj)/zmf;
        i = floor(ii); j = floor(jj); % 向下取整
        u = ii - i; v = jj - j;
        i = i + 1; j = j + 1;
        ZI(zi,zj,:) = (1-u)*(1-v)*I(i,j,:) +(1-u)*v*I(i,j+1,:)...
                    + u*(1-v)*I(i+1,j,:) +u*v*I(i+1,j+1,:);
    end
end

ZI = floor(ZI);         % 四舍五入, 模拟FPGA中放大16倍后要除以16, 但是只取了商的正数.
ZI = uint8(ZI);
I = uint8(ZI);
%% 以图像的形式显示同现矩阵P
% figure
% imshow(I);
% axis on
% title(['原图像（大小： ',num2str(IH),'*',num2str(IW),'*',num2str(ID),')']);
% figure
% imshow(ZI);
% axis on
% title(['缩放后的图像（大小： ',num2str(ZIH),'*',num2str(ZIW),'*',num2str(ID)',')']);

end  