function [t_x, t_y, scale, ang, search_range] = initLandmarks(img, meanS, scale)
% initLandmarks
% 
% Helps get user input for best initial pose parameters of model shape
% within image.

warning('off','all');

showTitle = 0;

% number of pixels to search along the norm
search_range = 30;

if scale ~= 0
    t_x = 300/scale; t_y = 360/scale; scale = 1200/scale; ang = 0;
else
    t_x = 0; t_y = 0; scale = 1; ang = 0;
    showTitle = 1;
end

fig = figure;

replot(img, meanS, t_x, t_y, scale,ang);

ctrlBox = uibuttongroup('Position',[0 0 .2 1]);

ctrl_txPos = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Trans X +', ...
'Position',[5 450 60 30]);
ctrl_txPos.Value = 0;
ctrl_txPos.Callback = @onBtnTxPosPushed;

ctrl_txNeg = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Trans X -', ...
'Position',[65 450 60 30]);
ctrl_txNeg.Value = 0;
ctrl_txNeg.Callback = @onBtnTxNegPushed;

ctrl_tyPos = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Trans Y +', ...
'Position',[5 350 60 30]);
ctrl_tyPos.Value = 0;
ctrl_tyPos.Callback = @onBtnTyPosPushed;

ctrl_tyNeg = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Trans Y -', ...
'Position',[65 350 60 30]);
ctrl_tyNeg.Value = 0;
ctrl_tyNeg.Callback = @onBtnTyNegPushed;

ctrl_scalePos = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Scale +', ...
'Position',[5 250 60 30]);
ctrl_scalePos.Value = 0;
ctrl_scalePos.Callback = @onBtnScalePosPushed;

ctrl_scaleNeg = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Scale -', ...
'Position',[65 250 60 30]);
ctrl_scaleNeg.Value = 0;
ctrl_scaleNeg.Callback = @onBtnScaleNegPushed;

ctrl_rotPos = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Rotate +', ...
'Position',[5 150 60 30]);
ctrl_rotPos.Value = 0;
ctrl_rotPos.Callback = @onBtnRotPosPushed;

ctrl_rotNeg = uicontrol(ctrlBox,'Style','pushbutton', 'String', 'Rotate -', ...
'Position',[65 150 60 30]);
ctrl_rotNeg.Value = 0;
ctrl_rotNeg.Callback = @onBtnRotNegPushed;

rangeTxt = uicontrol(ctrlBox, 'Style','text', 'String', 'Range',...
'Position', [5 65 60 30]);

rangeValue = uicontrol(ctrlBox, 'Style','edit', 'String', search_range,...
'Position', [65 75 50 30]);

saveBtn = uicontrol(ctrlBox, 'Style','pushbutton', 'String', 'Save',...
'Position', [5 5 120 50]);
saveBtn.Callback = @onBtnSavePushed;


% halt program execution until user click on save button
uiwait;


    function replot(img, meanS, tx, ty, s, a)
        cla(gca);
        imshow(img,[]);
        if showTitle == 1, title("Only set the range. Pose params are not saved."); end
        hold on;
        X = model_to_image(meanS, tx, ty, s, a);
        plot(X(1:56), X(57:end),'-', 'LineWidth',1);
        hold off;
    end

    % callback functions
    function onBtnTxPosPushed(src,event)
        t_x = t_x + src.Value*2;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnTxNegPushed(src,event)
        t_x = t_x - src.Value*2;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnTyPosPushed(src,event)
        t_y = t_y + src.Value*2;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnTyNegPushed(src,event)
        t_y = t_y - src.Value*2;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnScalePosPushed(src,event)
        scale = scale + src.Value*10;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnScaleNegPushed(src,event)
        scale = scale - src.Value*10;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnRotPosPushed(src,event)
        ang = ang + src.Value/50;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnRotNegPushed(src,event)
        ang = ang - src.Value/50;
        replot(img, meanS, t_x, t_y, scale, ang);
    end

    function onBtnSavePushed(src,event)
        search_range = str2double(rangeValue.String);
        % resume execution
        uiresume;
        close(fig);
    end

end
