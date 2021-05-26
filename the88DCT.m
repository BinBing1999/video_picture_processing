%%8*8DCT
im=imread('1.jpg');
rim=im(:,:,1);%%RGB����123
gim=im(:,:,2);
bim=im(:,:,3);
[m,n]=size(rim);
rim=double(rim);
gim=double(gim);
bim=double(bim);
A=zeros(8);
for i=0:7
    for j=0:7
        if i==0
            a=sqrt(1/8);
        else
            a=sqrt(2/8);
        end            
         A(i+1,j+1)=a*cos(pi*(j+0.5)*i/8);
     end
end
mask1=[1,1,1,1,1,1,0,0;
    1,1,1,1,1,0,0,0;
    1,1,1,1,0,0,0,0;
    1,1,1,0,0,0,0,0;
    1,1,0,0,0,0,0,0;
    1,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;];%%����ǰ�����Խ��ߵĲ���
mask2=[1,1,0,0,0,0,0,0;
    1,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0;];%%����3para
mask3=[1,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,0;
    1,1,1,1,1,1,0,0;
    1,1,1,1,1,0,0,0;
    1,1,1,1,0,0,0,0;
    1,1,1,0,0,0,0,0;
    1,1,0,0,0,0,0,0;
    1,0,0,0,0,0,0,0;];%%�������ϵĲ���


CT_red=blkproc(rim,[8,8],'P1*x*P2',A,A');%CT�ֿ�任
CT_green=blkproc(gim,[8,8],'P1*x*P2',A,A');
CT_blue=blkproc(bim,[8,8],'P1*x*P2',A,A');
 
iDCT_red=uint8(blkproc(CT_red,[8,8],'P1*x*P2',A',A));
iDCT_green=uint8(blkproc(CT_green,[8,8],'P1*x*P2',A',A));
iDCT_blue=uint8(blkproc(CT_blue,[8,8],'P1*x*P2',A',A));

CT_red_1= blkproc(CT_red,[8 8],'P1.*x',mask1);
CT_green_1= blkproc(CT_green,[8 8],'P1.*x',mask1);
CT_blue_1= blkproc(CT_blue,[8 8],'P1.*x',mask1);
CT_red_2= blkproc(CT_red,[8 8],'P1.*x',mask2);
CT_green_2= blkproc(CT_green,[8 8],'P1.*x',mask2);
CT_blue_2= blkproc(CT_blue,[8 8],'P1.*x',mask2);
CT_red_3= blkproc(CT_red,[8 8],'P1.*x',mask3);
CT_green_3= blkproc(CT_green,[8 8],'P1.*x',mask3);
CT_blue_3= blkproc(CT_blue,[8 8],'P1.*x',mask3);

iDCT_red_1=uint8(blkproc(CT_red_1,[8,8],'P1*x*P2',A',A));
iDCT_green_1=uint8(blkproc(CT_green_1,[8,8],'P1*x*P2',A',A));
iDCT_blue_1=uint8(blkproc(CT_blue_1,[8,8],'P1*x*P2',A',A));
iDCT_red_2=uint8(blkproc(CT_red_2,[8,8],'P1*x*P2',A',A));
iDCT_green_2=uint8(blkproc(CT_green_2,[8,8],'P1*x*P2',A',A));
iDCT_blue_2=uint8(blkproc(CT_blue_2,[8,8],'P1*x*P2',A',A));
iDCT_red_3=uint8(blkproc(CT_red_3,[8,8],'P1*x*P2',A',A));
iDCT_green_3=uint8(blkproc(CT_green_3,[8,8],'P1*x*P2',A',A));
iDCT_blue_3=uint8(blkproc(CT_blue_3,[8,8],'P1*x*P2',A',A));

re_im=cat(3,iDCT_red,iDCT_green,iDCT_blue);%%ͨ���ρ�,��ȫ�֏�
re_im_1=cat(3,iDCT_red_1,iDCT_green_1,iDCT_blue_1);
re_im_2=cat(3,iDCT_red_2,iDCT_green_2,iDCT_blue_2);
re_im_3=cat(3,iDCT_red_3,iDCT_green_3,iDCT_blue_3);

figure,
subplot(1,2,1),imshow(im);
title('ԭʼͼ��');
subplot(1,2,2),imshow(re_im);
title('8*8DCT���任ͼ��');
D=abs(im-re_im);
disp('The error is :');
disp(sum(D(:)));

figure,
subplot(2,2,1),imshow(re_im);
title('�������еĂS��');
subplot(2,2,2),imshow(re_im_1);
title('����ǰ�������Ǿ��ĂS��');
subplot(2,2,3),imshow(re_im_2);
title('����ǰ3���S��');
subplot(2,2,4),imshow(re_im_3);
title('�������Ͻ����еĂS��');