function GrayStack = RGBToGrayscale(Stack)
    % <Documentation>
        % RGBToGrayscale()
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
    if Dimensions < 3 || (Dimensions == 3 && size(Stack,3) ~= 3) || (Dimensions == 4 && size(Stack,4) ~= 3)
        GrayStack = Stack;
        fprintf('Stack is already grayscale.\n')
        return

    elseif Dimensions == 3 && size(Stack,3) == 3
        GrayStack = Stack(:,:,1);

    elseif Dimensions == 4 && size(Stack, 4) == 3
        GrayStack = Stack(:,:,:,1);

    end

end