function ExportTif(ImageStack, FileName, SaveIn)
    % <Documentation>
        % ExportTif()
        %   
        %   Created by: jsl5865
        %   
        % Syntax:
        %   
        % Description:
        %   
        % Input:
        %   
        % Output:
        %   
    % <End Documentation>
    arguments
        ImageStack (:,:,:) double {mustBeNumeric}
        FileName (1,1) string = ""
        SaveIn (1,1) string = ""
    end

    validateExportProperties;
    exportInBatches(ImageStack, 1e9);

    function validateExportProperties()
        if FileName == "" || SaveIn == ""
            [FileName, SaveIn] = uiputfile('*.tif', 'Save image stack as...');
            [~, FileName, ~] = fileparts(FileName);
            if isequal(FileName,0) || isequal(SaveIn,0)
                Identifier = 'ImportSelection::NoFileSelected';
                ME = MException(Identifier, 'No files selected to import.');
                throwAsCaller(ME)
            end
        end
    end

    function exportInBatches(stack, memory)
        [rows, columns, frames] = size(stack);
        bytesPerFrame = rows * columns * bytesPerElement(stack);
        totalBatches = max(ceil((frames * bytesPerFrame)/memory), 1);
        framesPerBatch = ceil(frames / totalBatches);

        for frame = 1:framesPerBatch:frames
            batch_StartIndex = frame;
            batch_EndIndex = min(frame + framesPerBatch -1, frames);
            batchStack = stack(:,:, batch_StartIndex:batch_EndIndex);

            batchName = sprintf('%s_%02d.tif', FileName, ceil(frame/framesPerBatch));
            imwrite(batchStack(:,:,1), fullfile(SaveIn, batchName));
            for i = 2:size(batchStack, 3)
                imwrite(batchStack(:,:,i), fullfile(SaveIn, batchName), 'WriteMode', 'append')
            end
        end

        function bytes = bytesPerElement(data)
            switch class(data)
                case {'uint64', 'int64', 'double'}, bytes = 8;
                case {'uint32', 'int32', 'single'}, bytes = 4;
                case {'uint16', 'int16', 'char'},   bytes = 2;
                case {'uint8', 'int8', 'logical'},  bytes = 1;
                otherwise
                    error('Jan:sizeof:Type', 'Type not handles: %s', class(data));
            end
        end
    end
end
