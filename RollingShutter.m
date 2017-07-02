function RollingShutter
%Simulating a rolling shutter in matlab with the webcam
%
%

% Create a video input object.
vid = videoinput('winvideo');
% vid = videoinput('winvideo', 1, 'I420_176x144');
%vid = videoinput('winvideo', 1, 'I420_320x240');

% Create a figure window. This example turns off the default
% toolbar and menubar in the figure.
hFig = figure('Toolbar','none',...
       'Menubar', 'none',...
       'NumberTitle','Off',...
       'Name','My Custom Preview GUI');
   
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
    'Position',[1 1 75 60]);

% Create the image object in which you want to
% display the video preview data.
vidRes = get(vid, 'VideoResolution');
imWidth = vidRes(1);
imHeight = vidRes(2);
nBands = get(vid, 'NumberOfBands');
hImage = image( zeros(imHeight, imWidth, nBands) );

% Specify the size of the axes that contains the image object
% so that it displays the image at the right resolution and
% centers it in the figure window.
figSize = get(hFig,'Position');
figWidth = figSize(3);
figHeight = figSize(4);
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

%to reset the frame counter in each run
set(hImage,'UserData',0)

%start preview
preview(vid, hImage);

end
