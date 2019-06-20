function varargout = CLPI(varargin)
% CLPI M-file for CLPI.fig
%      CLPI, by itself, creates a new CLPI or raises the existing
%      singleton*.
%
%      H = CLPI returns the handle to a new CLPI or the handle to
%      the existing singleton*.
%
%      CLPI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLPI.M with the given input arguments.
%
%      CLPI('Property','Value',...) creates a new CLPI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CLPI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CLPI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to hlp CLPI

% Last Modified by GUIDE v2.5 18-May-2017 14:42:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CLPI_OpeningFcn, ...
                   'gui_OutputFcn',  @CLPI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CLPI is made visible.
function CLPI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CLPI (see VARARGIN)

% Choose default command line output for CLPI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CLPI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CLPI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
[filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.tif'},'选择照片');
str=[pathname,filename];
im=imread(str);
axes(handles.axes1);
imshow(im)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
im2 = im(end:-1:1,:,:);%垂直翻转
im3 = im(:,end:-1:1,:);%水平翻转
im4 = im(end:-1:1,end:-1:1,:);%对角翻转
if size(im,3)==1
    im5 = medfilt2(im,[3,2]);
else
    im51=medfilt2(im(:,:,1),[3,2]);%R通道滤波
    im52=medfilt2(im(:,:,2),[3,2]);%R通道滤波
    im53=medfilt2(im(:,:,3),[3,2]);%R通道滤波
    im5=cat(3,im51,im52,im53);%中值滤波后的图像
end
axes(handles.axes2);
imshow(im5)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im imgysw imgray
%{
img = im;
img_1=img(:,:,1);
img_2=img(:,:,2);
img_3=img(:,:,3);
Y=0.299*img_1+0.587*img_2+0.114*img_3;%平衡系数
[m,n]=size(Y);
k=Y(1,1);
for i=1:m
    for j=1:n
        if Y(i,j)>=k
            k=Y(i,j);
            k1=i;
            k2=j;
        end
    end
end
[m1,n1]=find(Y==k);
Rave=sum(sum(img_1));
Rave=Rave/(m*n);
Gave=sum(sum(img_2));
Gave=Gave/(m*n);
Bave=sum(sum(img_3));
Bave=Bave/(m*n);
Kave=(Rave+Gave+Bave)/3;
img_1=(Kave/Rave)*img_1;
img_2=(Kave/Gave)*img_2;
img_3=(Kave/Bave)*img_3;
imgysw=cat(3,img_1,img_2,img_3);
axes(handles.axes2);
imshow(imgysw)
%}
imgray = rgb2gray(im);
axes(handles.axes2);
imshow(imgray)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off
feature jit off
global im im_noise
im_noise=imnoise(im,'salt & pepper',0.05);
axes(handles.axes2);
imshow(im_noise)

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off
feature jit off
global im_noise im_filter
n=size(size(im_noise));
if n(1,2)==2
    im_filter=medfilt2(im_noise,[3,2]);
else
    im_filter1=medfilt2(im_noise(:,:,1),[3,2]);
    im_filter2=medfilt2(im_noise(:,:,2),[3,2]);
    im_filter3=medfilt2(im_noise(:,:,3),[3,2]);
    im_filter=cat(3,im_filter1,im_filter2,im_filter3);
end
axes(handles.axes2);
imshow(im_filter)    


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off
feature jit off
global im_noise im_filter imgysw Plate Plate2 Plate2s
[Path] = uigetdir('','保存的图像');
%imwrite(uint8(im_filter),strcat(Path,'\','pic_correct.bmp'),'bmp');
imwrite(uint8(Plate2s),strcat(Path,'\','pic_correct.bmp'),'bmp');

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw imgray
axes(handles.axes2);
BW=edge(imgray,'sobel',0.08);
imshow(BW)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw im_filter  imgray
axes(handles.axes2);
BW=edge(imgray,'prewitt');
imshow(BW)

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw imgray
axes(handles.axes2);
BW=edge(imgray,'canny');
imshow(BW)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw BWr imgray
axes(handles.axes2);
BWr=edge(imgray,'roberts');
imshow(BWr)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw BWr BW1
axes(handles.axes2);
SE = strel('rectangle',[10,70]);
BW1 = imclose(BWr,SE);
%BW2 = imerode(BW1,SE);%腐蚀
%BW3 = imdilate(BW2,SE);%膨胀
imshow(BW1)

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw BWr BW1 BW2
axes(handles.axes2);
SE = strel('rectangle',[20,40]);
BW2 = imerode(BW1,SE);%腐蚀
%BW3 = imdilate(BW2,SE);%膨胀
imshow(BW2)

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw BW BW2 BW3
axes(handles.axes2);
SE = strel('rectangle',[20,40]);
BW3 = imdilate(BW2,SE);%膨胀
imshow(BW3)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw BW BW3 BWs BW2
axes(handles.axes2);
BWs = bwareaopen(BW2,8000);
imshow(BWs)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im BWs myI Plate
%[x,y,z]=size(BWs);
%myI = double(BWs); 


%{
myI = BWs;
for i=1:x         %找出X方向的上界和下界
    for j=1:y
        if (myI(x,y,1)==1)
          % x1 = i;
          
        end
    end
end
for m=i:x
    for n=1:y
        if (myI(x,:,1)==0)
            %x2 = m;
           
        end
    end
end
%axes(handles.axes2);
%Plate = im(IX1:IX2,:,:);
%imshow(Plate)
%set(handles.text1,'String','老大');
 set(handles.edit1,'String',i);
 set(handles.edit2,'String',m);
%}


[y,x,z]=size(BWs);  %y方向对应行，x方向对应列，z方向对应深度，z=1为二值图像
myI=double(BWs);  %数据类型转换，每个方向范围在0~1  0为黑，1为白（车牌区域）
Im1=zeros(y,x);  %创建一个与图像一样大小的空矩阵，用于记录行扫描时蓝色像素点的位置
Im2=zeros(y,x);  %创建一个与图像一样大小的空矩阵，用于记录列扫描时蓝色像素点的位置
Blue_y=zeros(y,1);%创建一个列向量，用于统计行扫描某行的蓝色像素点个数
%开始行扫描，对每一个像素进行分析，统计满足条件的像素所在行对应的个数，确定车牌的上下边界
   for i=1:y      %行扫描
       for j=1:x
            if  (myI(i,j,1)==1)      %在RGB彩色模型中（0，0，1）表示蓝色，转换数据后 1为蓝色，在二值图中蓝色呈现出白色，也就是1，i,j为坐标。
               Blue_y(i,1)=Blue_y(i,1)+1;%统计第i行蓝色像素点的个数
               Im1(i,j)=1; %标记蓝色像素点的位置
           end
       end
   end
   
% Y方向车牌区域确定
[temp,MaxY]=max(Blue_y);
 
%阈值的设置是经验，采用统计分析方法和车牌的固定特征设置阈值，在规定大小的车辆图像上车牌区域的长宽经过统计，收敛于某个值
Th=5;  %阈值参数可改（要提取的蓝颜色参数经验值范围）
 
%向上追溯，直到车牌区域上边界
PY1=MaxY;
while((Blue_y(PY1,1)>=Th)&&(PY1>1))
    PY1=PY1-1;
end
 
%向下追溯，直到车牌区域的下边界
PY2=MaxY;
while((Blue_y(PY2,1)>=Th)&&(PY2<y))
    PY2=PY2+1;
end
%对车牌区域进行校正，加框，减少车牌区域信息丢失
PY1=PY1-2;
PY2=PY2+2;
if PY1<1
    PY1=1;
end
if PY2>y
    PY2=y;
end
 
%得到车牌区域
IY=im(PY1:PY2,:,:);
 
%%%%%%%%%  X方向 %%%%%%%%%%%
%进一步确定x方向（竖直方向）的车牌区域，确定车牌的左右边界
Blue_x=zeros(1,x);   %创建一个行向量，同于统计列扫描某行的蓝色像素点个数
%列扫描，确定车牌的左右边界
for j=1:x     
    for i=PY1:PY2
           if  (myI(i,j,1)==1)
              Blue_x(1,j)=Blue_x(1,j)+1;  %统计第j列蓝色像素点的个数
              Im2(i,j)=1; %标记蓝色像素点的位置
           end
    end
end
 
%向右追溯，直到找到车牌区域左边界
PX1=1;
Th1=3; %经验阈值的选取，可改
while((Blue_x(1,PX1)<3)&&(PX1<x))
    PX1=PX1+1;
end
%向左追溯，直到找到车牌区域右边界
PX2=x;
while(Blue_x(1,PX2)<Th1&&(PX2>PX1))
    PX2=PX2-1;
end
% 对车牌区域进行校正，加框，减少信息丢失
PX1=PX1-2;
PX2=PX2+2;
if PX1<1
    PX1=1;
end
if PX2>x
    PX2=x;
end
 
%得到车牌区域
IX=im(:,PX1:PX2,:);
 
%分割车牌区域
row=[PY1 PY2];
col=[PX1 PX2];
Im3=Im1+Im2;  %图像代数运算
Im3=logical(Im3);
Im3(1:PY1,:)=0;
Im3(PY2:end,:)=0;
Im3(:,1:PX1)=0;
Im3(:,PX2:end)=0;
axes(handles.axes2);
Plate=im(PY1:PY2,PX1:PX2,:);
imshow(Plate)




% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Plate Plate2
warning off
feature jit off
axes(handles.axes2);
Plate2 = im2bw(Plate,graythresh(Plate));
imshow(Plate2)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Plate2 Plate2s
warning off
feature jit off
axes(handles.axes2);
Plate2s = bwareaopen(Plate2,100);
imshow(Plate2s)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off
global Plate2s x y
feature jit off
I1=Plate2s;%其中I1是定位完成需要分割的图片
I2=bwareaopen(I1,100);%去除小于1000像素的区块
[y,x]=size(I2);%% 分割字符按行积累量
I3=double(I2);
X1=zeros(1,x);%1行X列的行向量
for j=1:x
for i=1:y
        if(I3(i,j,1)==1)%为白点，即前景像素点时
            X1(1,j)= X1(1,j)+1;%列向量对应的列加1
        end
end
end
%figure,subplot(1,2,2);
%plot(0:x-1,X1),title('车牌列像素点累计'),xlabel('列值'),ylabel('像素和');
Px0 = round(x/8.2);%48将第一个字符切出来，round是四舍五入函数
%set(handles.edit3,'string',Px0);
Z=I2(:,1:Px0,:);%将第一个字符切分出来
   axes(handles.axes3);
            imshow(Z)
Px1=1;
for i=1:6
while ((X1(1,Px0)<6)&&(Px0<x))
        Px0=Px0+1;
end
Px1=Px0;
while (((X1(1,Px1)>6)&&(Px1<x)||((Px1-Px0)<20)))
        Px1=Px1+1;
end
Z=I2(:,Px0:Px1,:);%将定位好的字符分割出来
switch strcat('Z',num2str(i))%将Z与变量i进行字符连接，形成选项
        case 'Z1'
            PIN0=Z;
            axes(handles.axes4);
            imshow(Z)
        case 'Z2'
            PIN1=Z;
            axes(handles.axes5);
            imshow(Z)
        case 'Z3'
            PIN2=Z;
            axes(handles.axes6);
            imshow(Z)
        case 'Z4'
            PIN3=Z;
            axes(handles.axes7);
            imshow(Z)
        case 'Z5'
            PIN4=Z;
            axes(handles.axes8);
            imshow(Z)
        case 'Z6'
            PIN5=Z;
            axes(handles.axes9);
            imshow(Z)
       
        otherwise
            PIN6=Z;
            axes(handles.axes10);
            imshow(Z)
end
%axes(handles.axes2);
%imshow(Z)
Px0=Px1;
end


% --- Executes during object creation, after setting all properties.
function pushbutton18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgray
imgrayh = imhist(imgray); 
axes(handles.axes2);
imshow(imgrayh)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im  Plate2 Plate2s x y
warning off
feature jit off
% 求垂直投影

for m=1:x
     S=sum(Plate2s(1:y,m)); 
end
n=1:x;
I=plot(n,S);
axes(handles.axes2);
imshow(I)
%S(m)
%axes(handles.axes2);
%f=sum(Plate2s,1);
%f=sum(Plate2s);
%x=1:.1:100;
%plot(handles.axes2,x,f);

%imshow(f)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw imgray
set(handles.radiobutton1,'Value',1);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
set(handles.radiobutton4,'Value',0);
axes(handles.axes2);
BW=edge(imgray,'sobel',0.08);
imshow(BW)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw im_filter  imgray
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',1);
set(handles.radiobutton3,'Value',0);
set(handles.radiobutton4,'Value',0);
axes(handles.axes2);
BW=edge(imgray,'prewitt');
imshow(BW)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw im_filter  imgray
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',1);
set(handles.radiobutton4,'Value',0);
axes(handles.axes2);
BW=edge(imgray,'canny');
imshow(BW)
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im_noise imgysw BWr imgray
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
set(handles.radiobutton4,'Value',1);
axes(handles.axes2);
BWr=edge(imgray,'roberts');
imshow(BWr)
% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
im2 = im(end:-1:1,:,:);%垂直翻转
im3 = im(:,end:-1:1,:);%水平翻转
im4 = im(end:-1:1,end:-1:1,:);%对角翻转
if size(im,3)==1
    im5 = medfilt2(im,[3,2]);
else
    im51=medfilt2(im(:,:,1),[3,2]);%R通道滤波
    im52=medfilt2(im(:,:,2),[3,2]);%R通道滤波
    im53=medfilt2(im(:,:,3),[3,2]);%R通道滤波
    im5=cat(3,im51,im52,im53);%中值滤波后的图像
end
imgray = rgb2gray(im);
BWr=edge(imgray,'roberts');
SE = strel('rectangle',[10,70]);
BW1 = imclose(BWr,SE);
Se = strel('rectangle',[20,40]);
BW2 = imerode(BW1,Se);%腐蚀
BWs = bwareaopen(BW2,8000);
[y,x,z]=size(BWs);  %y方向对应行，x方向对应列，z方向对应深度，z=1为二值图像
myI=double(BWs);  %数据类型转换，每个方向范围在0~1  0为黑，1为白（车牌区域）
Im1=zeros(y,x);  %创建一个与图像一样大小的空矩阵，用于记录行扫描时蓝色像素点的位置
Im2=zeros(y,x);  %创建一个与图像一样大小的空矩阵，用于记录列扫描时蓝色像素点的位置
Blue_y=zeros(y,1);%创建一个列向量，用于统计行扫描某行的蓝色像素点个数
%开始行扫描，对每一个像素进行分析，统计满足条件的像素所在行对应的个数，确定车牌的上下边界
   for i=1:y      %行扫描
       for j=1:x
            if  (myI(i,j,1)==1)      %在RGB彩色模型中（0，0，1）表示蓝色，转换数据后 1为蓝色，在二值图中蓝色呈现出白色，也就是1，i,j为坐标。
               Blue_y(i,1)=Blue_y(i,1)+1;%统计第i行蓝色像素点的个数
               Im1(i,j)=1; %标记蓝色像素点的位置
           end
       end
   end
   
% Y方向车牌区域确定
[temp,MaxY]=max(Blue_y);
 
%阈值的设置是经验，采用统计分析方法和车牌的固定特征设置阈值，在规定大小的车辆图像上车牌区域的长宽经过统计，收敛于某个值
Th=5;  %阈值参数可改（要提取的蓝颜色参数经验值范围）
 
%向上追溯，直到车牌区域上边界
PY1=MaxY;
while((Blue_y(PY1,1)>=Th)&&(PY1>1))
    PY1=PY1-1;
end
 
%向下追溯，直到车牌区域的下边界
PY2=MaxY;
while((Blue_y(PY2,1)>=Th)&&(PY2<y))
    PY2=PY2+1;
end
%对车牌区域进行校正，加框，减少车牌区域信息丢失
PY1=PY1-2;
PY2=PY2+2;
if PY1<1
    PY1=1;
end
if PY2>y
    PY2=y;
end
 
%得到车牌区域
IY=im(PY1:PY2,:,:);
 
%%%%%%%%%  X方向 %%%%%%%%%%%
%进一步确定x方向（竖直方向）的车牌区域，确定车牌的左右边界
Blue_x=zeros(1,x);   %创建一个行向量，同于统计列扫描某行的蓝色像素点个数
%列扫描，确定车牌的左右边界
for j=1:x     
    for i=PY1:PY2
           if  (myI(i,j,1)==1)
              Blue_x(1,j)=Blue_x(1,j)+1;  %统计第j列蓝色像素点的个数
              Im2(i,j)=1; %标记蓝色像素点的位置
           end
    end
end
 
%向右追溯，直到找到车牌区域左边界
PX1=1;
Th1=3; %经验阈值的选取，可改
while((Blue_x(1,PX1)<3)&&(PX1<x))
    PX1=PX1+1;
end
%向左追溯，直到找到车牌区域右边界
PX2=x;
while(Blue_x(1,PX2)<Th1&&(PX2>PX1))
    PX2=PX2-1;
end
% 对车牌区域进行校正，加框，减少信息丢失
PX1=PX1-2;
PX2=PX2+2;
if PX1<1
    PX1=1;
end
if PX2>x
    PX2=x;
end
Plate=im(PY1:PY2,PX1:PX2,:);


Plate2 = im2bw(Plate,graythresh(Plate));
Plate2s = bwareaopen(Plate2,100);

I1=Plate2s;%其中I1是定位完成需要分割的图片
I2=bwareaopen(I1,100);%去除小于1000像素的区块
[n,m]=size(I2);%% 分割字符按行积累量
I3=double(I2);
X1=zeros(1,m);%1行X列的行向量
for j=1:m
for i=1:n
        if(I3(i,j,1)==1)%为白点，即前景像素点时
            X1(1,j)= X1(1,j)+1;%列向量对应的列加1
        end
end
end
%figure,subplot(1,2,2);
%plot(0:x-1,X1),title('车牌列像素点累计'),xlabel('列值'),ylabel('像素和');
Px0 = round(m/8.2);%48将第一个字符切出来，round是四舍五入函数
%set(handles.edit3,'string',Px0);
Z=I2(:,1:Px0,:);%将第一个字符切分出来
   axes(handles.axes3);
            imshow(Z)
Px1=1;
for i=1:6
while ((X1(1,Px0)<6)&&(Px0<m))
        Px0=Px0+1;
end
Px1=Px0;
while (((X1(1,Px1)>6)&&(Px1<m)||((Px1-Px0)<20)))
        Px1=Px1+1;
end
Z=I2(:,Px0:Px1,:);%将定位好的字符分割出来
switch strcat('Z',num2str(i))%将Z与变量i进行字符连接，形成选项
        case 'Z1'
            PIN0=Z;
            axes(handles.axes4);
            imshow(Z)
        case 'Z2'
            PIN1=Z;
            axes(handles.axes5);
            imshow(Z)
        case 'Z3'
            PIN2=Z;
            axes(handles.axes6);
            imshow(Z)
        case 'Z4'
            PIN3=Z;
            axes(handles.axes7);
            imshow(Z)
        case 'Z5'
            PIN4=Z;
            axes(handles.axes8);
            imshow(Z)
        case 'Z6'
            PIN5=Z;
            axes(handles.axes9);
            imshow(Z)
       
        otherwise
            PIN6=Z;
            axes(handles.axes10);
            imshow(Z)
end
%axes(handles.axes2);
%imshow(Z)
Px0=Px1;
end
