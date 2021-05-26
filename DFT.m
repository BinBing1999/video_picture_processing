%%DFT and IFDT
im=imread('1.jpg');
rim=im(:,:,1);%%RGB~123
gim=im(:,:,2);
bim=im(:,:,3);
[m,n]=size(rim);

F_red=zeros(m,n);
for u=1:m
    for v=1:n
        for x=1:m
            for y=1:n
                F_red(u,v)=F_red(u,v)+double(rim(x,y))*exp(-2*pi*1i*(u*x/m+v*y/n));
            end
        end
    end
end
iFt_red=zeros(m,n);
for x=1:m
    for y=1:n
        for u=1:m
            for v=1:n
                iFt_red(x,y)=iFt_red(x,y)+double(F_red(u,v))*exp(2*pi*1i*(u*x/m+v*y/n))/(m*n);
            end
        end
    end
end
iFt_red=uint8(iFt_red);
F_red=abs(F_red);

F_green=zeros(m,n);
for u=1:m
    for v=1:n
        for x=1:m
            for y=1:n
                F_green(u,v)=F_green(u,v)+double(gim(x,y))*exp(-2*pi*1i*(u*x/m+v*y/n));
            end
        end
    end
end
iFt_green=zeros(m,n);
for x=1:m
    for y=1:n
        for u=1:m
            for v=1:n
                iFt_green(x,y)=iFt_green(x,y)+double(F_green(u,v))*exp(2*pi*1i*(u*x/m+v*y/n))/(m*n);
            end
        end
    end
end
iFt_green=uint8(iFt_green);
F_green=abs(F_green);

F_blue=zeros(m,n);
for u=1:m
    for v=1:n
        for x=1:m
            for y=1:n
                F_blue(u,v)=F_blue(u,v)+double(bim(x,y))*exp(-2*pi*1i*(u*x/m+v*y/n));
            end
        end
    end
end
iFt_blue=zeros(m,n);
for x=1:m
    for y=1:n
        for u=1:m
            for v=1:n
                iFt_blue(x,y)=iFt_blue(x,y)+double(F_blue(u,v))*exp(2*pi*1i*(u*x/m+v*y/n))/(m*n);
            end
        end
    end
end
iFt_blue=uint8(iFt_blue);
F_blue=abs(F_blue);

figure,
subplot(2,2,1),imshow(im);
title('原始图象');
subplot(2,2,2),imshow(F_red,[]);%对double必须使用【】模式
title('红色分量DFT结果');
subplot(2,2,3),imshow(F_green,[]);
title('绿色分量DFT结果');
subplot(2,2,4),imshow(F_blue,[]);
title('蓝色分量DFT结果');

F2_red=fftshift(F_red);
F2_red=log(F2_red+1);
F2_green=fftshift(F_green);
F2_green=log(F2_green+1);
F2_blue=fftshift(F_blue);
F2_blue=log(F2_blue+1);
figure,
subplot(2,2,1),imshow(im);
title('原始图象');
subplot(2,2,2),imshow(F2_red,[]);
title('红色分量DFT结果平移加缓和');
subplot(2,2,3),imshow(F2_green,[]);
title('绿色分量DFT结果平移加缓和');
subplot(2,2,4),imshow(F2_blue,[]);
title('蓝色分量DFT结果平移加缓和');

re_im=cat(3,iFt_red,iFt_green,iFt_blue);%%通道合併
figure,
subplot(1,2,1),imshow(im);
title('原始图像');
subplot(1,2,2),imshow(re_im);
title('DFT反变换得到的图像');
D=abs(im-re_im);
disp('The error is :');
disp(sum(D(:)));
