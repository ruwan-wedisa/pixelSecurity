%predefined form guide method
function varargout = untitled(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


%opening form initialize
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;


guidata(hObject, handles);


function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%Resim Seçme
function pushbutton1_Callback(hObject, eventdata, handles)
[filename1 pathname1]=uigetfile({'*.png;*.jpg'},'Select an Image File') %Select a picture with a .png or .jpg extension from the file system. uigetfile is Open file selection dialog box
global fullpathname1
fullpathname1 = strcat(pathname1,filename1) %We have combined the name and location of the image.
set(handles.text3,'String',fullpathname1) %We wrote the textbox in the name and location of the image.
img=imread(fullpathname1); %read picture.
axes(handles.axes1); %We've set the axes to show the picture.
imshow(img); %Show The Picture.

%Selecting a Text File
function pushbutton3_Callback(hObject, eventdata, handles)
[filename2 pathname2]=uigetfile({'*.txt'},'Text File Selector') %File with .txt extension from file system.
global fullpathname2
fullpathname2 = strcat(pathname2,filename2) %combined the name and location of the file.
set(handles.text4,'String',fullpathname2) %The name and location of the file and wrote to the textbox.
text = fileread(fullpathname2) %Read the file.
set(handles.text5,'String',text) %Written file contents to Textbox.

%File Encryption
function pushbutton4_Callback(hObject, eventdata, handles)
global fullpathname1
global fullpathname2
FID = fileread(fullpathname2);    %read the selected Text file.
Str=uint16(FID);    %Text file read is converted to uint16.

x=imread(fullpathname1);   %read the selected image file.
x=uint16(x);                %Convert image file to uint16.
[x_row,x_col]=size(x); %the image has rows and columns.

c=numel(Str);   %The file has a number of characters.
a=1;

%Cipher Loop
for i=1:x_row
    for j=1:x_col
        if(a<=c) %The number of characters in the picture is looped.      
            if(x(i,j)+Str(a)>255) %If the value of the pixel values of the image and the value of the text file is greater than 255, then we add the values and reduuce 256 from them.
                temp=x(i,j)+Str(a)-256;
            else
                temp=x(i,j)+Str(a); %We have collected the values of the text file with the pixel values of the image.
            end
            z(i,j)=uint8(temp); %The temp matrix is converted to uint8 and the encoded partitions are discarded to the image matrix..
            %plce the result of process into new image matrix
        else
            z(i,j)=uint8(x(i,j)); %The orginal picture matrix is converted to uint8 and the resting values of the orginal image are taken to the image matte..
            %also place the original image parts that we did not change
        end
        a=a+1;
    end
end
imwrite(z,'encrypted.png');     %write encrypted image file.
img=imread('encrypted.png');    %We read the encrypted image file.
axes(handles.axes2);    %We've set the axes to show the picture.
imshow(img);    % Show The Picture.






% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
[filename1 pathname1]=uigetfile({'*.png;*.jpg'},'Select an Image File') %Select a picture with a .png or .jpg extension from the file system. uigetfile is Open file selection dialog box
global originalImgPath
originalImgPath = strcat(pathname1,filename1) %We have combined the name and location of the image.
set(handles.text14,'String',originalImgPath) %We wrote the textbox in the name and location of the image.
imgOrigin=imread(originalImgPath); %read picture.



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
[filename1 pathname1]=uigetfile({'*.png;*.jpg'},'Select an Image File') %Select a picture with a .png or .jpg extension from the file system. uigetfile is Open file selection dialog box
global encryptedImgPath
encryptedImgPath = strcat(pathname1,filename1) %We have combined the name and location of the image.
set(handles.text17,'String',encryptedImgPath) %We wrote the textbox in the name and location of the image.
imgEncrypted=imread(encryptedImgPath); %read picture.




%Solving an encrypted picture
function pushbutton5_Callback(hObject, eventdata, handles)

global originalImgPath
global encryptedImgPath

x=imread(encryptedImgPath);  %read the encrypted.png file.
y=imread(originalImgPath);   %read an orginal picture.

x=uint16(x);    %Converted encrypted picture to 16 bit.
y=uint16(y);    %Converting original image to 16 bit.

[x_row, x_col]=size(x); %We found the number of rows and columns of the encrypted image.

b=0;k=1;

%Decryption Cycle
for i=1:x_row
    for j=1:x_col
        %Combines encrypted picture and decodes the encrypted file.
        if(x(i,j)>=y(i,j)) %The pixel values of the encrypted image are larger than the pixel values of the original image.
            a=x(i,j)-y(i,j); %The difference between the pixel value of the original image and the encrypted image is taken.
        else
            a=256+x(i,j)-y(i,j); %The difference between the pixel values of the original image and the encrypted image is taken and 256 is added.
        end
        
        if(a~=0)
            z(k)=uint8(a); %We have created a text file matrix .
            k=k+1;
        else
            b=1;
            break;
        end
    end
    if(b==1)
        break;
    end
end

fid=fopen('decrypted.txt','w'); %We created the decrypted.txt file and opened it
for i=1:k-1 %k is number of characters in txt file
    fprintf(fid,'%c',z(i)); %  Write data to the decrypted.txt file
end

text = fileread('decrypted.txt') %read the decrypted.txt file.
set(handles.text6,'String',text) %show content of file in text6 textbox


