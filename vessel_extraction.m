function [ ] = ExudateVessel_detectionl( )

close;
clear all;
abc=0;
%{
datapath=strcat('E:\chiba project\retina\'); 

files = feval('dir',strcat(datapath,'*.jpg'));
[rf,cf] = size(files);
abc=abc+1
for i = 1:rf
    close all;
    disp (files(i).name)

    datafile=files(i).name;
    dataPathFile=strcat(datapath,datafile);
    name=files(i).name(1:size(files(i).name,2)-4);
%}
    I=imread('E:\chiba project\retina\im0077.jpg');
    
[v h n]=size(I);

if v>500
J=imresize(I,1); %image size is 500*752
else
    J=I;
end
[vj hj nj]=size(J);

red=J(:,:,1);
green=J(:,:,2);
figure,imshow(green)
imwrite(green,'E:\chiba project\single image\greenband.jpg');
blue=J(:,:,3);

JH=rgb2hsv(J);
H=JH(:,:,1);
S=JH(:,:,2);
V=JH(:,:,3);

Vfilter=medfilt2(green);  %noise removal
figure,imshow(Vfilter)
imwrite(Vfilter,'E:\chiba project\single image\noise removal.jpg');
Vadapt=adapthisteq(Vfilter);  %histogram equalization
figure,imshow(Vadapt)
imwrite(Vadapt,'E:\chiba project\single image\histogram equalization.jpg');

se = strel('disk',50);      %creates a flat, disk-shaped structuring element
GreenEnh = imsubtract(imadd(Vadapt,imtophat(Vadapt,se)), imbothat(Vadapt,se)); %top hat and bottom hat filtering
figure,imshow(GreenEnh)
imwrite(GreenEnh,'E:\chiba project\single image\Green enhanced.jpg');
%%%%%%%%extract vessels from histogram  equalized
%shade correction
img=double(Vadapt);  %replace green
mask=fspecial('average',35);  %creates a two-dimensional filter
bg=filter2(mask,img,'same');  %applying masking
tmp=img-bg*0.1;
tmp2=mat2gray(tmp);  %shade corrected image
figure,imshow(tmp2)
imwrite(tmp2,'E:\chiba project\single image\shade corrected.jpg');

%vessels extraction
se=ones(9,9);
test=imclose(imfill(tmp2, 'hole'),se);
v=imfill(tmp2,'hole');
vv=imsubtract(test,v);
gv=mat2gray(vv);
g=graythresh(gv);
bwg=im2bw(gv,g);
bwArea=bwareaopen(bwg,50);
figure,imshow(bwArea)
imwrite(bwArea,'E:\chiba project\single image\vessel from shade corrected.jpg');
%=======================================================
% Extract Vessels from green enhance
%shade correction
img=double(GreenEnh);  %replace green
mask=fspecial('average',35);
bg=filter2(mask,img,'same');
tmpG=img-bg*0.1;
tmp2G=mat2gray(tmpG);
figure,imshow(tmp2G)
imwrite(tmp2G,'E:\chiba project\single image\shade corrected green.jpg');
%figure,imshow(tmp2G)
%vessels extraction
se=ones(9,9);
testG=imclose(imfill(tmp2G, 'hole'),se);
vG=imfill(tmp2G,'hole');
%figure,imshow(vG)
vvG=imsubtract(testG,vG);
gvG=mat2gray(vvG);
%imtool(gvG)

gG=graythresh(gvG);
bwgG=im2bw(gvG,gG);
%figure,imshow(bwgG);

%remove object smaller than 10 pixels
bwAreaG=bwareaopen(bwgG,50);
figure,imshow(bwAreaG)
imwrite(bwAreaG,'E:\chiba project\single image\vessel from green enhance.jpg')
%figure,imshow(bwAreaG);

%=======================================================
% Add vessel from both type of image
bwArea=imadd(bwArea,bwAreaG);
bwArea=bwareaopen(bwArea,60);
%=======================================================

figure,imshow(bwArea)
imwrite(bwArea,'E:\chiba project\single image\final vessels.jpg')

end

