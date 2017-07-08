function RollingShutter
%Simulating a rolling shutter in matlab with the webcam
%

%disable annoying Warning: The ColorEnable property was unable ...
msgId='winvideo:propertyAdjusted';
warning('off',msgId);

%choose device and format
out=DeviceSelect;

if isempty(out)
    disp('No device detected or selected')
    disp('If webcam is connected, you might need to install support package')
    disp('Install the file (you need login and password): osgenericvideointerface.mlpkginstall ')
    disp('Downloaded from here: https://www.mathworks.com/matlabcentral/fileexchange/45183-image-acquisition-toolbox-support-package-for-os-generic-video-interface')
    disp('Check it here: https://www.mathworks.com/help/imaq/installing-the-support-packages-for-image-acquisition-toolbox-adaptors.html')
    return
end
vid = videoinput(out.Adaptor, out.DeviceID, out.Format);

% Create a video input object.
% vid = videoinput('winvideo');
% vid = videoinput('winvideo', 1, 'I420_640x480');

% Create a figure window. This example turns off the default
% toolbar and menubar in the figure.
hFig = figure('Toolbar','none',...
       'Menubar', 'none',...
       'NumberTitle','Off',...
       'Name','My Custom Preview GUI');

%ufff... Closing the window doesn't clear the persistent variables! So
%there are problems if you change resolution. Best solution is to clear
%persistent variables by hand.
set(hFig,'DeleteFcn','clear im;clear frame;disp(''Bye!'')');
   
% Set up the push buttons
% % % uicontrol('String', 'Start Preview',...
% % %     'Callback', 'tic;preview(vid)',...
% % %     'Units','normalized',...
% % %     'Position',[0 0 0.15 .07]);
% % % uicontrol('String', 'Stop Preview',...
% % %     'Callback', 'stoppreview(vid)',...
% % %     'Units','normalized',...
% % %     'Position',[.17 0 .15 .07]);
% % % uicontrol('String', 'Close',...
% % %     'Callback', 'close(gcf)',...
% % %     'Units','normalized',...
% % %     'Position',[0.34 0 .15 .07]);


% Create the text label for the timestamp
hTextLabel = uicontrol('style','text','String','Timestamp', ...
    'Units','pixels',...
    'Position',[1 1 80 70]);

uicontrol('String', '+',...
    'Callback', 'scanspeed=getappdata(hImage,''scanspeed'');scanspeed=scanspeed+1;setappdata(hImage,''scanspeed'',scanspeed)',...
    'Units','pixels',...
    'Position',[65 1 15 15]);
uicontrol('String', '-',...
    'Callback', 'scanspeed=getappdata(hImage,''scanspeed'');scanspeed=max(1,scanspeed-1);setappdata(hImage,''scanspeed'',scanspeed)',...
    'Units','pixels',...
    'Position',[1 1 15 15]);

% Create the image object in which you want to display the video preview data.
vidRes = get(vid, 'VideoResolution');
imWidth = vidRes(1);
imHeight = vidRes(2);
nBands = get(vid, 'NumberOfBands');
hImage = image( zeros(imHeight, imWidth, nBands) );

%set default scanspeed, updated lines at a time
scanspeed=round(imHeight/(30*4));%to scan the entire image in about 4 seconds (at 30fps)

% Specify the size of the axes 
set(gca,'unit','normalized','position',[.0 .0 1 1]);

% Set up the update preview window function.
setappdata(hImage,'UpdatePreviewWindowFcn',@mypreview_fcn);

% Make handle to text label available to update function.
setappdata(hImage,'HandleToTimestampLabel',hTextLabel);

%Create empty matrix with all succesive images
matrix=struct([]);
matrix(1).image=zeros(imHeight, imWidth, nBands,'uint8');
matrix(2:imHeight)=matrix(1);
setappdata(hImage,'matrix',matrix);

%set scanspeed, image and frame number
setappdata(hImage,'scanspeed',scanspeed);
im=zeros(imHeight, imWidth, nBands,'uint8');  
setappdata(hImage,'im',im);
frame=1;  
setappdata(hImage,'frame',frame);

%start preview
preview(vid, hImage);

%start timer
tic
end
