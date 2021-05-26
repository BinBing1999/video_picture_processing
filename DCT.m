%%DCT AND IDCT
im=imread('1.jpg');
rim=im(:,:,1);%%RGB對應123
gim=im(:,:,2);
bim=im(:,:,3);
[m,n]=size(rim);
if n>m
    N=n;
    kk=1;
elseif m>n
    N=m;
    kk=2;
else
    N=n;
    kk=0;
end
A=zeros(N);
rim=double(rim);
gim=double(gim);
bim=double(bim);
if kk==1
    com=zeros(n-m,n);
    rim=[rim;com];
    gim=[gim;com];
    bim=[bim;com];
elseif kk==2
    com=zeros(m,m-n);
    rim=[rim,com];
    gim=[gim,com];
    bim=[bim,com];
end

for i=0:N-1
    for j=0:N-1
        if i==0
            a=sqrt(1/N);
        else
            a=sqrt(2/N);
        end            
         A(i+1,j+1)=a*cos(pi*(j+0.5)*i/N);
     end
 end
CT_red=A*rim*A';      %DCT变换
CT_green=A*gim*A';
CT_blue=A*bim*A';
 %%YY=dct2(X)  ;    %Matlab自带的dct变换
 
iDCT_red=uint8(A'*CT_red*A);
iDCT_green=uint8(A'*CT_green*A);
iDCT_blue=uint8(A'*CT_blue*A);
iDCT_red=iDCT_red(1:m,1:n);
iDCT_green=iDCT_green(1:m,1:n);
iDCT_blue=iDCT_blue(1:m,1:n);

figure,
subplot(2,2,1),imshow(im);
title('原始图象');
subplot(2,2,2),imshow(log(abs(CT_red)),[]);
title('红色分量DCT结果');colormap(gray(4));colorbar;
subplot(2,2,3),imshow(log(abs(CT_green)),[]);
title('绿色分量DCT结果');colormap(gray(4));colorbar;
subplot(2,2,4),imshow(log(abs(CT_blue)),[]);
title('蓝色分量DCT结果');colormap(gray(4));colorbar;

imwrite(CT_red,'CT_red.jpg');
imwrite(CT_green,'CT_green.jpg');
imwrite(CT_blue,'CT_blue.jpg');

re_im=cat(3,iDCT_red,iDCT_green,iDCT_blue);%%通道合併
imwrite(re_im,'iDCT.jpg'); 
figure,
subplot(1,2,1),imshow(im);
title('原始图像');
subplot(1,2,2),imshow(re_im);
title('DCT反变换得到的图像');
D=abs(im-re_im);
disp('The error is :');
disp(sum(D(:)));
