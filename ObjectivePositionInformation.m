function ObjectivePositions = ObjectivePositionInformation(MDF_Files, Mode)
    % <Documentation>
        % StichZStacks_RelativePosition()
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
        MDF_Files
        Mode char {mustBeMember(Mode, {'RelativePosition', 'ImageJ_GridPositions'})} = 'ImageJ_GridPositions'
    end

    TotalFiles = numel(MDF_Files.MetaData);
    switch Mode
        case 'RelativePosition'
            ObjectivePositions = CalculateObjectiveTranslations(MDF_Files.MetaData);

        case 'ImageJ_GridPositions'
            ObjectivePositions = ImageJTilePositions(MDF_Files);

    end

    %% Helper Functions
    function ObjectivePositions = CalculateObjectiveTranslations(MDF_Files)
        ObjectivePositions = zeros(TotalFiles, 3);
        for File = 1:TotalFiles
            ObjectivePositions(File, :) = FindObjectivePosition(MDF_Files{File}.Notes);
        end
        ObjectivePositions = CalculateRelativePosition(ObjectivePositions);
    end

    function TextFile = ImageJTilePositions(MDF_Files)
        ObjectivePositions = zeros(TotalFiles, 3);
        FileNames = strings(TotalFiles, 1);
        MDFCoordinates = strings(TotalFiles, 1);

        for File = 1:TotalFiles
            [~, Name, ~] = fileparts(MDF_Files.DirectoryInfo.FolderInfo(File).name);     
            FileNames(File) = Name;

            ObjectivePositions(File, :) = FindObjectivePosition(MDF_Files.MetaData{File}.Notes);
            X = ObjectivePositions(File, 1);
            Y = ObjectivePositions(File, 2);
            Z = ObjectivePositions(File, 3);

            MDFCoordinates(File) = sprintf('%s.tif; ; (%.2f, %.2f, %.2f)', Name, X, Y, Z);

        end

        TextHeader = {"# Define the number of dimensions we are working on"
                      "dim = 3"
                      "# Define the image coordinates (in pixels)"
                     };
        TextFile = [TextHeader; MDFCoordinates];
        TextFile = strjoin(TextFile, newline);

    end

    function Position_XYZ = FindObjectivePosition(Notes)
        Objective_X = ConvertToNumericPosition(Notes.ObjectivePositionX);
        Objective_Y = ConvertToNumericPosition(Notes.ObjectivePositionY);
        Objective_Z = ConvertToNumericPosition(Notes.ObjectivePositionZ);

        Position_XYZ = [Objective_X, Objective_Y, Objective_Z];
    end

    function RelativePosition = CalculateRelativePosition(Position_XYZ)
        ReferencePosition = Position_XYZ(1, :);
        RelativePosition = Position_XYZ - ReferencePosition;
    end

    function Position = ConvertToNumericPosition(PositionString)
        ExpressionArgument = '[^\d\.\-eE]';
        Position = regexprep(PositionString, ExpressionArgument, '');
        Position = str2double(Position);
    end

end