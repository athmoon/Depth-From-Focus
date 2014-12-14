%reading all of the jpg files
d = dir('*.jpg');
pic_num = length(d);
for i = 1:pic_num
   N(:,:,i) = rgb2gray(imread(d(i).name));
end

f = 0.00295; %focal length of Tegra camera
focal_dis = double((1/45)*0.009541); %initial focus
x = 1536;
y = 2048;
final_focus = 0.009541;
N_new = zeros(2049, 1537, 44);

for k = 1:pic_num
    u = double(1/((1/f)-focal_dis)); %eq 1
    m = double(final_focus/u); %eq 3
    temp = imresize(N(:,:,k), m);
    height = size(temp, 1);
    width = size(temp, 2);
    N_new(:,:,k) = imcrop(temp, [floor((width/2)-(x/2)) floor((height/2)-(y/2)) x y]);
    focal_dis = focal_dis + (1/45)*0.009541;
end


K = 1; %a variable that is chosen based on the amount of texture in the scene
M = zeros(2049,1537,44);
alpha = 0.5;

for k = 1:pic_num
    I(:,:,k) = imfilter(N_new(:,:,k), fspecial('laplacian', alpha)).^2;
end

K_matrix = ones(K, K);

for k = 1:pic_num
    M(:,:,k) = imfilter(I(:,:,k), K_matrix);
end

for x=1:2049
    for y = 1:1537
        [g, index] = max(squeeze(M(x,y,:)));
        D(x,y) = index;
        All_focus(x,y) = N_new(x,y,D(x,y));
    end
end