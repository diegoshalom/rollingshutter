function mypreview_fcn(obj,event,hImage) %#ok<INUSL>
% Example update preview window function.

persistent frame;% pos is the number of current frame
if get(hImage,'UserData')==0
    set(hImage,'UserData','')
    frame=0;
    tic
end

persistent im;% the image to be presented. initalized only once.
if isempty(im) 
    im=uint8(nan(size(event.Data)));
end

%save current image in the matrix
imHeight=size(event.Data,1);
matrix=getappdata(hImage,'matrix');
current=1+mod(frame,imHeight);
matrix(current).image=event.Data;
setappdata(hImage,'matrix',matrix);
frame=frame+1;

% Build Rolling Shutter image 
for j=1:imHeight
    whichFrame=1+mod(frame+j-1,imHeight);
    currentline=imHeight-(j-1);
    im(currentline,:,:)=matrix(whichFrame).image(currentline,:,:);
end

% % % Intento de hacer de a varias lineas, pero no me funciona como yo % queria
% % nlines=1;
% % for j=1:nlines:imHeight
% %     for k=1:nlines        
% %         whichFrame=1+mod(frame+j-1,imHeight);
% %         currentline=imHeight-(j-1)-(k-1);
% %         im(currentline,:,:)=matrix(whichFrame).image(currentline,:,:);
% %     end
% % end

% Get timestamp for frame.
tstampstr = event.Timestamp;
tstampstr = sprintf('%s\n%2.1fs\n%dframes\n%2.1ffps ',event.Timestamp,toc,frame,frame/toc);


% Get handle to text label uicontrol.
ht = getappdata(hImage,'HandleToTimestampLabel');

% Set the value of the text label.
set(ht,'String',tstampstr);

% Display image ACTUAL data.
% set(hImage, 'CData', event.Data)

% Display image ROLLING SHUTTER data.
set(hImage, 'CData', im)

end