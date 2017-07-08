function out=DeviceSelect

DEVLIST=BuildDeviceList;

if isempty(DEVLIST)
    out=[];    
    return
end

%prompt the device
str = {DEVLIST.DeviceName};
[devnum,ok] = listdlg('PromptString','Select a Device:',...
                'SelectionMode','single',...
                'ListString',str);
if ok==0
    out=[];
    return
end

%prompt the Format
str = DEVLIST(devnum).SupportedFormats;
[formatnum,ok] = listdlg('PromptString','Select a Format:',...
                'SelectionMode','single',...
                'ListString',str);

if ok==0
    out=[];
    return
end

%return the selected device and format
out.Adaptor=DEVLIST(devnum).Adaptor;
out.DeviceID=DEVLIST(devnum).DeviceID;
out.Format=str{formatnum};
            
    
end

function DEVLIST=BuildDeviceList
%list the adaptors, and then list the devices attached to each adaptor
AD=imaqhwinfo;%adaptor's list
DEVLIST=struct([]);
for indad=1:length(AD.InstalledAdaptors)%for each adaptor
    Adaptor=AD.InstalledAdaptors{indad};
    DEV=imaqhwinfo(Adaptor);
    for inddev=1:length(DEV.DeviceIDs) %list the devices on this adaptor 
        dev=DEV.DeviceInfo(inddev);
        dev.Adaptor=Adaptor;
        DEVLIST=[DEVLIST dev]; %build a list of devices
    end
end
end
