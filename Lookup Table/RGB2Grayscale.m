function GrayStack = RGB2Grayscale(Stack)
    % <Documentation>
        % RGBToGrayscale()
        %   Convert an RGB image to a grayscale image
        %   Created by: jsl5865
        %   
        % Syntax:
        %   GrayStack = RGB2Grayscale(Stack)
        %
        % Description:
        %   Converts an RGB image stack to a grayscale image stack. 
        %   This function essentially removes only the color channel of an RGB stack
        %       in order to preserve pixel intensity.
        %
        % Input:
        %   Stack   - An image stack which can be single- or multi-paged with a color
        %               channel.
        %
        % Output:
        %   GrayStack   - A grayscale version of the input image stack
        %   
    % <End Documentation>
    arguments
        Stack {mustBeNumeric}
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