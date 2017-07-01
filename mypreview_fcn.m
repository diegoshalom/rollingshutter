function mypreview_fcn(obj,event,hImage)
% Example update preview window function.

persistent pos;

if isempty(pos) 
    pos=1;
end

persistent im;
if isempty(im) 
    im=uint8(nan(size(event.Data)));
end

%save current image in the matrix
imHeight=size(event.Data,1);
matrix=getappdata(hImage,'matrix');
current=1+mod(pos,imHeight);

%ESTO ES RE LENTO. lo lento es el indexing
%podria  hacerlo con sub2ind, calculando las posiciones 
% de los indices una sola vez, guardando persistente, y
%sumando lo correspondiente a current. 
matrix(current,:,:,:)=event.Data;


setappdata(hImage,'matrix',matrix);
pos=pos+1;


% Build Rolling Shutter image
for j=1:imHeight
    currentline=1+imHeight-j;
    diagonalFrame=1+mod(pos+j,imHeight);
    im(currentline,:,:)=matrix(diagonalFrame,currentline,:,:);
end

% % Build Rolling Shutter image (2 lines)
% for j=1:2:imHeight    
%     currentline=1+imHeight-j;
%     diagonalFrame=1+mod(pos+j,imHeight);
%     im(currentline,:,:)=matrix(diagonalFrame,currentline,:,:);
% 
%     currentline=1+imHeight-j-1;
%     diagonalFrame=1+mod(pos+j,imHeight);
%     im(currentline,:,:)=matrix(diagonalFrame,currentline,:,:);
% end


% Get timestamp for frame.
tstampstr = event.Timestamp;

% Get handle to text label uicontrol.
ht = getappdata(hImage,'HandleToTimestampLabel');

% Set the value of the text label.
set(ht,'String',tstampstr);

% Display image ACTUAL data.
%set(hImage, 'CData', event.Data)

% Display image ROLLING SHUTTER data.
set(hImage, 'CData', im)