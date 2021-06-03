% v = VideoReader('1.mp4','CurrentTime',1);
global fr
v = VideoReader('1.mp4');
fr =1/v.FrameRate;


global skip_frame;
global current_axis;
global angle_degrees;
j = -1;
i = 1;
skip_frame=50;
tic;
axis_point =[];
result =[];

while hasFrame(v)
    img = readFrame(v);
    while hasFrame(v) && j==(-1)
        
        f = figure('Name','My Angle Measurement Tool',...
            'NumberTitle','off',...
            'IntegerHandle','off');
        
        current_axis = my_fn_angle_measurement_tool(img, current_axis);
        %close 'My Angle Measurement Tool'
        
        %%Fream no
        e = uicontrol('units', 'normalized');
        e.Style = 'text';
        e. Tag = 'text';
        var = sprintf('Current Frame no: %d', i),
        e.String = var;
        e.Position = [0.4 0.02 0.1 0.05];

        %% skip button
        c = uicontrol('units', 'normalized');
        c.String = 'Save Image';
        c.Position = [0.5 0.02 0.1 0.05];
        c.Value = 25;
        c.UserData = img;
        c.Callback = {@save_img, i,fr};
        guidata(c)
        
        %% skip
        d = uicontrol('units', 'normalized');
        d.Style = 'edit';
        d. Tag = 'edit';
        d.String = skip_frame;
        d.Position = [0.6 0.02 0.1 0.05];
        d.Callback = @edit1_CreateFcn;
        skip_frame = str2num(get(d,'String'));
        
        %%  continue button
        h = uicontrol('units', 'normalized','Position',[0.7 0.02 0.1 0.05],'String','Continue',...
            'Callback','uiresume(gcbf)');
        disp('This will print immediately');
        uiwait(gcf);
        disp('This will print after you click Continue');
        skip_frame = str2num(get(d,'String'))
        set(d,'String',num2str(skip_frame))
        if isempty(result)
            result=[i*fr  angle_degrees]            
        else
            result =[result;i*fr  angle_degrees]
        end

        
        %%
        close(f);
        j = skip_frame-1;
    end
    i = i+1;
    j=j-1;
end
scatter(result(:,1),result(:,2))
axis auto
toc


function save_img(hObject, eventdata, handles,fr)
k=handles*fr;
name = sprintf('%.4f.jpg',k)
imwrite(hObject.UserData,name,'jpg','Comment','My JPEG file');
end



