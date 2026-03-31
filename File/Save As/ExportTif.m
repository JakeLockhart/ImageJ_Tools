function ExportTif(ImageStack, FileSize, FileName, SaveIn)
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
        ImageStack (:,:,:) {mustBeNumeric}
        FileSize (1,1) double = 1e9
        FileName (1,1) string = ""
        SaveIn (1,1) string = ""
    end

    validateExportProperties;
    exportInBatches(ImageStack, FileSize);

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
        framesPerBatch = max(floor(memory / bytesPerFrame), 1);

        for startFrame = 1:framesPerBatch:frames
            timer = tic;
            endFrame = min(startFrame + framesPerBatch -1, frames);
            batchStack = stack(:,:, startFrame:endFrame);

            batchName = sprintf('%s_%02d.tif', FileName, ceil(startFrame/framesPerBatch));
            imwrite(batchStack(:,:,1), fullfile(SaveIn, batchName), 'WriteMode', 'overwrite', 'Compression','none');
            for i = 2:size(batchStack,3)
                imwrite(batchStack(:,:,i), fullfile(SaveIn, batchName), 'WriteMode', 'append', 'Compression','none');
            end

            exportTime = toc(timer);
            fprintf('\tExported %s (%0.3gs, %d frames)\n', batchName, exportTime, size(batchStack,3))
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
