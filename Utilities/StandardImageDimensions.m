function Stack = StandardImageDimensions(Stack)
    % <Documentation>
        % StandardImageDimensions()
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
        Stack double {mustBeNumeric}
    end

    Dimensions = ndims(Stack);
    switch Dimensions
        case 3
            [Rows, Columns, Channels] = size(Stack);
            Frames = 1;

        case 4
            [Rows, Columns, Frames, Channels] = size(Stack);

        otherwise
            Identifier = "InvalidStack:NonStandardImageStack";
            ME = MException(Identifier, 'Stack has %d dimensions. \n\tImage projections have 3 dimensions: Rows x Columns x RGB\n\tMultipage image stacks have 4 dimensions: Rows x Columns x Frames x RGB', Dimensions);
            throwAsCaller(ME)
    end

    Stack = reshape(Stack, Rows, Columns, Frames, Channels);

end