close all; clear all; clc;

img = imread('./1_L.png');
I1 = rgb2gray(img);
% file1 = fopen('./1_L_gray.txt', 'w');
% fprintf(file1, '%d\n', img');
% fclose(file1);
[m,n] = size(I1);
score_ocv = zeros(m, n);
score_hdl = zeros(m, n);
t=10;   %阈值
flag_1 = zeros(1,25);
flag_2 = zeros(1,25);
d=0;
for i=4:m-3     % 行
    for j=4:n-3         % 列
        p=I1(i,j);    
        %步骤1，得到以p为中心的16个邻域点
        pn=[I1(i-3,j) I1(i-3,j+1) I1(i-2,j+2) I1(i-1,j+3) I1(i,j+3) I1(i+1,j+3) I1(i+2,j+2) I1(i+3,j+1) ...
            I1(i+3,j) I1(i+3,j-1) I1(i+2,j-2) I1(i+1,j-3) I1(i,j-3) I1(i-1,j-3) I1(i-2,j-2) I1(i-3,j-1)];
        pn(17:25) = pn(1:9);
        
%         d = bitor(get_ocv_d(pn(1), p, t), get_ocv_d(pn(9), p, t));
%         if (d == 0)
%             continue;
%         end
%         d = bitand(d, bitor(get_ocv_d(pn(3), p, t), get_ocv_d(pn(11), p, t)));
%         d = bitand(d, bitor(get_ocv_d(pn(5), p, t), get_ocv_d(pn(13), p, t)));
%         d = bitand(d, bitor(get_ocv_d(pn(7), p, t), get_ocv_d(pn(15), p, t)));
%         if (d == 0)
%             continue;
%         end
%         d = bitand(d, bitor(get_ocv_d(pn(2), p, t), get_ocv_d(pn(10), p, t)));
%         d = bitand(d, bitor(get_ocv_d(pn(4), p, t), get_ocv_d(pn(12), p, t)));
%         d = bitand(d, bitor(get_ocv_d(pn(6), p, t), get_ocv_d(pn(14), p, t)));
%         d = bitand(d, bitor(get_ocv_d(pn(8), p, t), get_ocv_d(pn(16), p, t)));
%         
%         count = 0;
%         if (d == 1)
%             for k=1:length(pn)
%                 if (int16(pn(k)) - int16(p) < -t)
%                     count = count + 1;
%                     if (count >= 9)
%                         score_ocv(i, j) = get_ocv_score(pn, p, t);
%                         score_hdl(i, j) = get_hdl_ocv_score(pn, p, t);
%                         break;
%                     end
%                 else 
%                     count = 0;
%                 end
%             end
%         end
%         
%         count = 0;
%         if (d == 2)
%             for k=1:length(pn)
%                 if (pn(k) - p > t)
%                     count = count + 1;
%                     if (count >= 9)
%                         score_ocv(i, j) = get_ocv_score(pn, p, t);
%                         score_hdl(i, j) = get_hdl_ocv_score(pn, p, t);
%                         break;
%                     end
%                 else
%                     count = 0;
%                 end
%             end
%         end
            
        flag_2 = find(int16(pn) - int16(p) - t > 0);
        flag_1 = find(int16(p) - int16(pn) - t > 0);
        flag1_bit = zeros(1, 25);
        flag2_bit = zeros(1, 25);

        if (length(flag_1) >= 9)
            flag1_bit(flag_1) = 1; 
            ifcgty_1 = int16(0);
            ifcgty_1 = check_contiguity(flag1_bit);
            if (ifcgty_1)
                score_ocv(i, j) = get_ocv_score(pn, p, t);
%                 score_hdl(i, j) = get_hdl_ocv_score(pn, p, t);
                score_hdl(i, j) = get_hdl_score(pn, p, t);
                ifcgty_1 = 0;
                continue;
            else
                score_ocv(i, j) = 0;
                score_hdl(i, j) = 0;
            end
        end

        if (length(flag_2) >= 9)
            flag2_bit(flag_2) = 1; 
            ifcgty_2 = int16(0);
            ifcgty_2 = check_contiguity(flag2_bit);
            if (ifcgty_2)
                score_ocv(i, j) = get_ocv_score(pn, p, t);
%                 score_hdl(i, j) = get_hdl_ocv_score(pn, p, t);
                score_hdl(i, j) = get_hdl_score(pn, p, t);
                ifcgty_2 = 0;
                continue;
            else
                score_ocv(i, j) = 0;
                score_hdl(i, j) = 0;
            end
        end
   end
end

%步骤5，非极大抑制，并且画出特征点
r_ocv=[]; r_hdl=[]; 
c_ocv=[]; c_hdl=[];
for i=4:m-3
    for j=4:n-3
        if score_ocv(i,j)~=0
            % 使用max(max(来进行非极大值抑制的方法,不能处理3x3的窗口内有多个极大值的情况
            % 在opencv中对于这种情况把它看做非角点.
            if (score_ocv(i,j) > score_ocv(i-1, j-1) && score_ocv(i,j) > score_ocv(i-1, j) && score_ocv(i,j) > score_ocv(i-1, j+1) && ...,
                score_ocv(i,j) > score_ocv(i, j-1)   && score_ocv(i,j) > score_ocv(i, j+1) && ...,
                score_ocv(i,j) > score_ocv(i+1, j-1) && score_ocv(i,j) > score_ocv(i+1, j) && score_ocv(i,j) > score_ocv(i+1, j+1))
                r_ocv = [r_ocv,i];
                c_ocv = [c_ocv,j];
            end
        end
        if score_hdl(i,j)~=0
            % 使用max(max(来进行非极大值抑制的方法,不能处理3x3的窗口内有多个极大值的情况
            % 在opencv中对于这种情况把它看做非角点.
            if (score_hdl(i,j) > score_hdl(i-1, j-1) && score_hdl(i,j) > score_hdl(i-1, j) && score_hdl(i,j) > score_hdl(i-1, j+1) && ...,
                score_hdl(i,j) > score_hdl(i, j-1)   && score_hdl(i,j) > score_hdl(i, j+1) && ...,
                score_hdl(i,j) > score_hdl(i+1, j-1) && score_hdl(i,j) > score_hdl(i+1, j) && score_hdl(i,j) > score_hdl(i+1, j+1))
                r_hdl = [r_hdl,i];
                c_hdl = [c_hdl,j];
            end
        end
    end
end
%%
% corners1=detectFASTFeatures(uint8(prev),'MinContrast',60/255);
% y = corners1.Location(:,1);
% x = corners1.Location(:,2);

%%
% file1 = fopen('../tb/1_L_gray_y.txt', 'r');
% [r_hdl, num_r] = fscanf(file1,'%03d',[1 inf]);
% r_hdl = r_hdl + 1;
% 
% file1 = fopen('../tb/1_L_gray_x.txt', 'r');
% [c_hdl, num_c] = fscanf(file1,'%03d',[1 inf]);
% c_hdl = c_hdl + 1;


my_fid = fopen('../tb/1_L_gray_y.txt', 'r');
mx_fid = fopen('../tb/1_L_gray_x.txt', 'r');
[keyPointy_SIMD, num_r] = fscanf(my_fid,'%03d',[1 inf]);
[keyPointx_SIMD, num_c] = fscanf(mx_fid,'%03d',[1 inf]);
keyPointy_SIMD = keyPointy_SIMD + 1;
keyPointx_SIMD = keyPointx_SIMD + 1;
% 
% r_hdl = keyPointy_SIMD;
% c_hdl = keyPointx_SIMD;

figure(1);
imshow(I1);
hold on;
scatter(c_ocv,r_ocv,25,'r*','MarkerFaceAlpha',1);
hold on;
% scatter(c_ocv,r_ocv,15,'bd','MarkerFaceAlpha',1);
scatter(c_hdl,r_hdl,5,'g^','MarkerFaceAlpha',0.5);
legend('opencv', 'HDL');
% for test 0522

% 比较HDL的计算结果和OpenCV的计算结果
r_err = 0; c_err = 0;
if (length(r_ocv) ~= length(r_hdl)) 
    fprintf("OpenCV's FAST corner numbers (%d) is not equal to HDL's number(%d)\r\n", length(r_ocv), length(r_hdl));
    for i=1:length(r_ocv) 
        r_err = abs(r_ocv(i)-r_hdl(i));
        c_err = abs(c_ocv(i)-c_hdl(i));
        if ((r_err ~= 0) || (c_err ~= 0))
            fprintf("corner number %d is wrong", i);
            err_corner(i, 1:2) = [c_err, r_err];
        end
    end
else 
    fprintf("Corner number(%d) is equal \r\n", length(r_ocv));
    for i=1:length(r_ocv) 
        r_err = abs(r_ocv(i)-r_hdl(i));
        c_err = abs(c_ocv(i)-c_hdl(i));
        if ((r_err ~= 0) || (c_err ~= 0))
            fprintf("corner number %d is wrong", i);
            err_corner(i, 1:2) = [c_err, r_err];
        end
    end
end



%%
%对比score
% adapthisteq

function ifcgty = check_contiguity(flag)
    count = 0;
    for k=1:length(flag)
        if (flag(k))
            count = count + 1;
        else
            count = 0;
        end

        if (count >= 9)
            ifcgty = 1;
            break;
        else
            ifcgty = 0;
        end
    end
    ifcgty = int16(ifcgty);
end

function d = get_ocv_d(pn, p, t)
    if (int16(pn) - int16(p)> int16(t))
        d = int16(2);
    elseif (int16(pn) - int16(p) < -int16(t))
        d = int16(1);
    else
        d = 0;
    end
end

function ocv_score = get_ocv_score(pn, p, t)
    a0 = int32(t);
    d = int32(int32(p) - int32(pn));
    for k=1:2:16
        a = min(d(k+1), d(k+2));
        a = min(a, d(k+3));
        if ( a<=a0)
            continue;
        end
        a = min(a, d(k+4));
        a = min(a, d(k+5));
        a = min(a, d(k+6));
        a = min(a, d(k+7));
        a = min(a, d(k+8));
        a0 = max(a0, min(a, d(k)));
        a0 = max(a0, min(a, d(k+9)));
    end
    b0 = -int32(a0);
    for k=1:2:16
        b = max(d(k+1), d(k+2));
        b = max(b, d(k+3));
        b = max(b, d(k+4));
        b = max(b, d(k+5));
        if ( b>=b0)
            continue;
        end
        b = max(b, d(k+6));
        b = max(b, d(k+7));
        b = max(b, d(k+8));
        b0 = min(b0, max(b, d(k)));
        b0 = min(b0, max(b, d(k+9)));
    end
    ocv_score = -b0 - 1;
end

% 按照圆弧选取最小的然后选最大的.
% opencv 选取最小然后选取最大是存在一定的顺序的, 不能一次性比较所有连续的圆弧.
% 必须得一段弧一段弧的比较大小, 直接去全局的最大或者最小值, 仍然会有问题.
function score = get_hdl_ocv_score(pn, p, t)
    d_bright_tmp = []; 
    d_dark_tmp = [];
    count_b = 0; count_d=0;
    score_bright = []; score_dark = [];
    % 把圆周上连续的弧都存到元胞里面, 因为一段连续弧的个数可能超过9, 所以没有用数组, 而是用元胞
    % 并且连续弧可能被分割, 所以用元胞数组存储被分割的连续弧
    d_bright_arc = {}; d_dark_arc = {};
    i = 1; j = 1;
    flag_1 = 0; flag_2 = 0;
    score = -1;
    for k=1:length(pn)
        if (int16(pn(k)) > int16(p) + t)
            count_b=count_b+1;
            d_bright_tmp = [d_bright_tmp, (int16(pn(k)) - int16(p))];
            % 圆周上的点都比圆心点要亮
            if (count_b >= 9)
                d_bright_arc{i} = d_bright_tmp;
                flag_1 = 1;
            end
        elseif (count_b>=9)
            d_bright_arc{i} = d_bright_tmp;
            i = i + 1;
            flag_1 = 1;
            count_b = 0;
            d_bright_tmp = [];
        else
            count_b = 0;
            d_bright_tmp = [];
        end
        
        if (int16(pn(k)) < int16(p) - t)
            count_d=count_d+1;
            d_dark_tmp = [d_dark_tmp, int16(p) - int16(pn(k))];
            if (count_d >= 9)
                d_dark_arc{j} = d_dark_tmp;
                flag_2 = 1;
            end
        elseif (count_d>=9)
            d_dark_arc{j} = d_dark_tmp;
            count_d = 0;
            flag_2 = 1;
            d_dark_tmp = [];
            j = j + 1;
        else
            count_d = 0;
            d_dark_tmp = [];
        end
    end
    
    for i = 1:size(d_bright_arc, 2)
        num_arc = size(d_bright_arc{1, i}, 2) - 9;
        num_arc = num_arc + 1;
        for j = 1:num_arc
           score_bright = [min(d_bright_arc{1, i}(j:j+8)), score_bright];
        end
    end
    if (flag_1)
       if (max(score_bright) < t)
           score = t - 1;
       else
           score = max(score_bright) - 1;
       end
    end
    
    for i = 1:size(d_dark_arc, 2)
        num_arc = size(d_dark_arc{1, i}, 2) - 9;
        for j = 1:num_arc+1
           score_dark = [min(d_dark_arc{1, i}(j:j+8)), score_dark];
        end
    end
    if (flag_2)
       if (max(score_dark) < t)
           score = t - 1;
       else
           score = max(score_dark) - 1;
       end
    end
%     % 周围的点比中心点亮
%     % 插值都是按照p-pn计算
%     if (length(score_b_tmp)>0)
%         if (max(score_b_tmp) > -t)
%             score = -min(score_b_tmp)-1;
%         else
%             score = -min(score_b_tmp) - 1;
%         end
%     end
%     
%     % 周围的点比中心点暗
%     if (length(score_d_tmp)>0)
%         if (min(score_d_tmp) < t)
%             score = max(score_d_tmp)-1;
%         else
%             score = max(score_d_tmp) - 1;
%         end
%     end
end

function score = get_hdl_score(pn, p, t)
    score_b = 0; score_d = 0;
    for k=1:16
        if (int16(pn(k)) - int16(p) > t)
            score_b = score_b + (abs(int16(pn(k))-int16(p)) - int16(t));
        elseif (int16(pn(k)) - int16(p) < -t)
            score_d = score_d + (abs(int16(pn(k))-int16(p)) - int16(t));
        end
    end
    score = max(score_b, score_d);
end

