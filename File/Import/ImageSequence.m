function imageStack = ImageSequence
    % <Documentation>
        % ImageSequence()
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
    
    fprintf('Select tif file(s) to load...\n')
    [fileName, folderPath] = userSelectFiles;
    validateImportSelection;
    paths = fileExplorer;
    imageStack = loadSequence;
    fprintf('File(s) loaded ✓')
    

    function [fileName, folderPath] = userSelectFiles()
        [fileName, folderPath] = uigetfile('*.tif', 'Import tif files...', ...
                                                'MultiSelect', 'on');
    end

    function validateImportSelection()
        if isequal(fileName, 0)
            Identifier = 'ImportSelection::NoFileSelected';
            ME = MException(Identifier, 'No files selected to import.');
            throwAsCaller(ME)
        end

        if ischar(fileName)
            fileName = {fileName};
        end
    end

    function paths = fileExplorer()
        paths = string(fileName);
        for file = 1:numel(fileName)
            paths(file) = fullfile(folderPath, fileName{file});
        end
    end

    function imageStack = loadSequence()
        imageStack = [];

        for file = 1:numel(paths)
            timer = tic;
            fileInfo = imfinfo(paths(file));
            frames = numel(fileInfo);
            rows = fileInfo(1).Height;
            columns = fileInfo(1).Width;
            subStack = zeros(rows, columns, frames, "like", imread(paths(file), 1));
            
            for frame = 1:frames
                subStack(:,:,frame) = imread(paths(file), frame);
            end
            
            importTime = toc(timer);
            fprintf('\tImported %s %d (%.3gs)\n', fileName{file}, file, importTime)
            imageStack = cat(3, imageStack, subStack);
        end
    end
end