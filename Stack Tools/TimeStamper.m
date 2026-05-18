function timeStamp = TimeStamper
    % <Documentation>
        % TimeStamper()
        %   Create a time-stamp for an image stack. Based on ImageJ(FIJI)'s TimeStamper functionality
        %   Created by: jsl5865
        %   
        % Syntax:
        %   timeStamp = TimeStamper
        %
        % Description:
        %   Creates a grayscale time-stamp image stack that can be used to merge with an exiting 
        %       multi-page image stack. The time-stamp is rendered frame-by-frame using MatLab's 
        %       insertText() and exported via the ExportTif() as a multi-page TIFF stack.
        %   A graphical user interface is used to define the time-stamp's appearance, functionaity, 
        %       image dimensions, and output bit-depth.
        %   The generated time-stamp stack contains white text on a black background and is 
        %       intended to be used as a separate image channel that can be merged with an existing 
        %       channel in ImageJ(FIJI)'s processing workflow. 
        %   Notes:
        %       - The time stamp is rendered in white on a black background
        %       - The 'Preview' option depicts the first frame of the image stack to be generated
        %
        % Input:
        %   NA
        %   
        % Output:
        %   timeStamp - an Row x Column x Frame image stack of the time stamp whose datatype is 
        %               dependent on the user defined BitDepth.
        %   
    % <End Documentation>

    parameters = getUserParameters;
    if parameters.OperationCanceled
        ME = MException('OperationCanceled:CanceledByUser', 'Time stamper ended by user');
        throwAsCaller(ME)
    end
    timeStamp = createTimeStamp(parameters);
    ExportTif(timeStamp)

    function parameters = getUserParameters()
        parameters.OperationCanceled = true;
        [window, mainLayout] = defineWindowLayout;
        defineWindowSize(450, 300);
        defineParameterPanel(mainLayout);
        defineControlPanel(mainLayout);
        uiwait(window)

        if isvalid(window)
            parameters = window.UserData;
            close(window)
        end
        
        %% User interface logic
        function [window, mainLayout] = defineWindowLayout
            window = uifigure("Name", "Time Stamper", "WindowStyle", "alwaysontop");
            window.AutoResizeChildren = "off";

            mainLayout = uigridlayout(window, [2,1]);
            mainLayout.RowHeight = {'1x', 50};
            mainLayout.ColumnWidth = {'1x'};
        end

        function parameterPanel = defineParameterPanel(mainLayout)
            parameterPanel = uipanel(mainLayout);

            % Input parameters
            parameterPanel.Layout.Row = 1;
            parameterGrid = uigridlayout(parameterPanel, [8,4]);
            parameterGrid.ColumnWidth = {120, '1x', 120, '1x'};

            lStartTime = uilabel(parameterGrid, "Text", 'Start Time:', "HorizontalAlignment", "right"); lStartTime.Layout.Row = 1; lStartTime.Layout.Column = 1;
            lFrameRate = uilabel(parameterGrid, "Text", 'Frame Rate (FPS):', "HorizontalAlignment", "right"); lFrameRate.Layout.Row = 2; lFrameRate.Layout.Column = 1;
            lXLocation = uilabel(parameterGrid, "Text", 'XLocation (px):', "HorizontalAlignment", "right"); lXLocation.Layout.Row = 1; lXLocation.Layout.Column = 3;
            lYLocation = uilabel(parameterGrid, "Text", 'YLocation (px):', "HorizontalAlignment", "right"); lYLocation.Layout.Row = 2; lYLocation.Layout.Column = 3;
            lFont = uilabel(parameterGrid, "Text", 'Font:', "HorizontalAlignment", "right"); lFont.Layout.Row = 3; lFont.Layout.Column = 1;
            lFontSize = uilabel(parameterGrid, "Text", 'Font Size:', "HorizontalAlignment", "right"); lFontSize.Layout.Row = 3; lFontSize.Layout.Column = 3;
            lPrefix = uilabel(parameterGrid, "Text", 'Prefix:', "HorizontalAlignment", "right"); lPrefix.Layout.Row = 4; lPrefix.Layout.Column = 1;
            lSuffix = uilabel(parameterGrid, "Text", 'Suffix:', "HorizontalAlignment", "right"); lSuffix.Layout.Row = 5; lSuffix.Layout.Column = 1;
            lDecimalPlaces = uilabel(parameterGrid, "Text", 'Decimal Places:', "HorizontalAlignment", "right"); lDecimalPlaces.Layout.Row = 6; lDecimalPlaces.Layout.Column = 1;
            lFormat = uilabel(parameterGrid, "Text", "'00:00' Format", "HorizontalAlignment", "right"); lFormat.Layout.Row = 6; lFormat.Layout.Column = 3;
            lWidth = uilabel(parameterGrid, "Text", "Width (px)", "HorizontalAlignment", "right"); lWidth.Layout.Row = 7; lWidth.Layout.Column = 1;
            lHeight = uilabel(parameterGrid, "Text", "Height (px)", "HorizontalAlignment", "right"); lHeight.Layout.Row = 7; lHeight.Layout.Column = 3;
            lFrames = uilabel(parameterGrid, "Text", "Frames", "HorizontalAlignment", "right"); lFrames.Layout.Row = 8; lFrames.Layout.Column = 1;
            lBitDepth = uilabel(parameterGrid, "Text", "BitDepth", "HorizontalAlignment", "right"); lBitDepth.Layout.Row = 8; lBitDepth.Layout.Column = 3;
            
            p.StartTime = uieditfield(parameterGrid, "numeric", "Value", 0.00, "RoundFractionalValues", false, "ValueDisplayFormat", '%.2f'); p.StartTime.Layout.Row = 1; p.StartTime.Layout.Column = 2;
            p.FrameRate = uieditfield(parameterGrid, "numeric", "Limits", [0, inf], "Value", 1, "RoundFractionalValues", false, "ValueDisplayFormat", '%.2f'); p.FrameRate.Layout.Row = 2; p.FrameRate.Layout.Column = 2;
            p.XLocation = uieditfield(parameterGrid, "numeric", "Limits", [1, inf], "Value", 1); p.XLocation.Layout.Row = 1; p.XLocation.Layout.Column = 4;
            p.YLocation = uieditfield(parameterGrid, "numeric", "Limits", [1, inf], "Value", 1); p.YLocation.Layout.Row = 2; p.YLocation.Layout.Column = 4;
            p.Font = uidropdown(parameterGrid, "Items", listTrueTypeFonts, "Value", "Arial", "Placeholder", "Arial"); p.Font.Layout.Row = 3; p.Font.Layout.Column = 2;
            p.FontSize = uieditfield(parameterGrid, "numeric", "Limits", [1, inf], "Value", 12); p.FontSize.Layout.Row = 3; p.FontSize.Layout.Column = 4;
            p.Prefix = uieditfield(parameterGrid, "text", "Value", '', "Placeholder", ''); p.Prefix.Layout.Row = 4; p.Prefix.Layout.Column = [2 4];
            p.Suffix = uieditfield(parameterGrid, "text", "Value", 's', "Placeholder", 's'); p.Suffix.Layout.Row = 5; p.Suffix.Layout.Column = [2 4];
            p.DecimalPlaces = uieditfield(parameterGrid, "numeric", "Value", 2); p.DecimalPlaces.Layout.Row = 6; p.DecimalPlaces.Layout.Column = 2;
            p.Format = uicheckbox(parameterGrid, "Value", true, "Text", ""); p.Format.Layout.Row = 6; p.Format.Layout.Column = 4;
            p.Width = uieditfield(parameterGrid, "numeric", "Limits", [1, inf], "Value", 100); p.Width.Layout.Row = 7; p.Width.Layout.Column = 2; 
            p.Height = uieditfield(parameterGrid, "numeric", "Limits", [1, inf], "Value", 100); p.Height.Layout.Row = 7; p.Height.Layout.Column = 4; 
            p.Frames = uieditfield(parameterGrid, "numeric", "Limits", [1, inf], "Value", 1, "Placeholder", "1"); p.Frames.Layout.Row = 8; p.Frames.Layout.Column = 2; 
            p.BitDepth = uidropdown(parameterGrid, "Items", ["8-Bit", "16-Bit", "32-Bit"], "Value", "16-Bit", "PlaceHolder", "16-Bit"); p.BitDepth.Layout.Row = 8; p.BitDepth.Layout.Column = 4; 
            
            window.UserData = p;
        end

        function controlPanel = defineControlPanel(mainLayout)
            controlPanel = uipanel(mainLayout);
            controlPanel.Layout.Row = 2; controlPanel.Layout.Column = 1;
            buttonGrid = uigridlayout(controlPanel, [1,4]);

            bPreview = uibutton(buttonGrid, "Text", "Preview", "ButtonPushedFcn", @(~,~) previewButton); bPreview.Layout.Row = 1; bPreview.Layout.Column = 1;
            bDone = uibutton(buttonGrid, "Text", "OK", "ButtonPushedFcn", @(~,~) doneButton); bDone.Layout.Row = 1; bDone.Layout.Column = 3;
            bCancel = uibutton(buttonGrid, "Text", "Cancel", "ButtonPushedFcn", @(~,~) cancelButton); bCancel.Layout.Row = 1; bCancel.Layout.Column = 4;

            function previewButton
                close all
                previewParameters = extractParameters(window);
                previewParameters.Frames = 1;

                demo = createTimeStamp(previewParameters);
                imshow(demo, []);
            end

            function doneButton
                close all
                window.UserData = extractParameters(window);
                uiresume(window)
            end

            function cancelButton
                parameters = struct();
                parameters.OperationCanceled = true;
                window.UserData = parameters;

                uiresume(window)
            end

            function parameters = extractParameters(window)
                p = window.UserData;
                parameters = struct();
                parameters.OperationCanceled = false;

                parameters.StartTime = p.StartTime.Value;
                parameters.FrameRate = p.FrameRate.Value;
                parameters.XLocation = p.XLocation.Value;
                parameters.YLocation = p.YLocation.Value;
                parameters.Font = p.Font.Value;
                parameters.FontSize = p.FontSize.Value;
                parameters.Prefix = p.Prefix.Value;
                parameters.Suffix = p.Suffix.Value;
                parameters.DecimalPlaces = p.DecimalPlaces.Value;
                parameters.Format = p.Format.Value;
                parameters.Width = p.Width.Value;
                parameters.Height = p.Height.Value;
                parameters.Frames = p.Frames.Value;
                parameters.BitDepth = p.BitDepth.Value;
            end
        end

        function defineWindowSize(width, height)
            screenSize = get(0, "ScreenSize");
            leftEdge = (screenSize(3) - width) / 2;
            bottomEdge = (screenSize(4) - height) / 2;

            window.Position = [leftEdge, bottomEdge, width, height];
        end

    end

    function textStack = createTimeStamp(parameters)
        rows = parameters.Height;
        columns = parameters.Width;
        frames = parameters.Frames;
        switch parameters.BitDepth
            case "8-Bit"
                bitDepth = 'uint8';
            case "16-Bit"
                bitDepth = 'uint16';
            case "32-Bit"
                bitDepth = 'uint32';
            otherwise
                error("Unkown bit-depth: %s", parameters.BitDepth);
        end

        textStack = zeros(rows, columns, frames, bitDepth);
        time = parameters.StartTime + (0:frames-1) / parameters.FrameRate;

        for frame = 1:frames
            background = zeros(rows, columns, 'uint8');
            rgbBackground = repmat(background, [1,1,3]);

            label = createTimeLabel;
            rgbTimeStamp = insertText(rgbBackground, ...
                                        [parameters.XLocation, parameters.YLocation], ...
                                        label, ...
                                        "Font", parameters.Font, ...
                                        "FontSize", parameters.FontSize, ...
                                        "BoxOpacity", 0, ...
                                        "TextColor", "white" ...
                                    );

            grayTimeStamp = rgb2gray(rgbTimeStamp);
            mask = grayTimeStamp > 200;
            textStack(:,:,frame) = cast(mask, bitDepth) * intmax(bitDepth);
        end

        function label = createTimeLabel
            if parameters.Format
                currentTime = time(frame);
                timeDirection = "";
                if currentTime < 0
                    timeDirection = "-";
                end

                currentTime = abs(currentTime);
                hours = floor(currentTime/3600);
                minutes = floor(mod(currentTime, 3600)/60);
                seconds = mod(currentTime, 60);

                if hours > 0
                    baseLabel = sprintf('%s%02d:%02d:%02.0f', timeDirection, hours, minutes, seconds);
                else
                    baseLabel = sprintf('%s%02d:%02.0f', timeDirection, minutes, seconds);
                end

            else
                sigFigs = sprintf('%%.%df', parameters.DecimalPlaces);
                baseLabel = sprintf(sigFigs, time(frame));
            end

            label = sprintf('%s%s%s', parameters.Prefix, baseLabel, parameters.Suffix);
        end
    end

end