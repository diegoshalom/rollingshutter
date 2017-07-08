function mypreview_fcn(obj,event,hImage) %#ok<INUSL>
% Example update preview window function.

assignin('base','hImage',hImage);



try
    % number of lines per update
    scanspeed=getappdata(hImage,'scanspeed');
    
    %frame
    frame=getappdata(hImage,'frame');
    
    %image
    im=getappdata(hImage,'im');


    %save current image in the matrix
    imHeight=size(event.Data,1);
    numImages=floor(size(event.Data,1)/scanspeed);
    matrix=getappdata(hImage,'matrix');
    current=1+mod(frame,numImages);
    matrix(current).image=event.Data;
    setappdata(hImage,'matrix',matrix);
    frame=frame+1;

    % % Build Rolling Shutter image, one line at a time
    % for j=1:imHeight
    %     whichFrame=1+mod(frame+j-1,imHeight);
    %     currentline=imHeight-(j-1);
    %     im(currentline,:,:)=matrix(whichFrame).image(currentline,:,:);
    % end

    
    %Build Rolling Shutter image, many lines at a time
    for j=1:imHeight
        whichFrame=1+mod(floor(frame+(j-1)/scanspeed),numImages);
        currentline=imHeight-(j-1);
        im(currentline,:,:)=matrix(whichFrame).image(currentline,:,:);
    end

    %image
    setappdata(hImage,'im',im);
    
    %frame
    setappdata(hImage,'frame',frame);    

    % Get timestamp for frame.
    tstampstr = event.Timestamp;
    tstampstr = sprintf('%s\n%2.1fs\n%dframes\n%2.1ffps\n Speed: x%d',event.Timestamp,toc,frame,frame/toc,scanspeed);


    % Get handle to text label uicontrol.
    ht = getappdata(hImage,'HandleToTimestampLabel');

    % Set the value of the text label.
    set(ht,'String',tstampstr);

    % Display image ACTUAL data.
    % set(hImage, 'CData', event.Data)

    % Display image ROLLING SHUTTER data.
    set(hImage, 'CData', im)
    
    
catch ME
    ME
    keyboard
end
end