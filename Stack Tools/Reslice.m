function ReslicedStack = Reslice(Stack, Orientation)
    % <Documentation>
        % Reslice()
        %   Create an orthagonal view of a image stack
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ReslicedStack = Reslice(Stack, Orientation)
        %
        % Description:
        %   A method to change the orientation of an image stack.
        %
        % Input:
        %   Stack       - An image stack
        %   Orientation - The reslice orientation: 'XY', 'XZ', 'YZ'
        %   
        % Output:
        %   ReslicedStack   - An orthagonal view of the original image stack
        %
    % <End Documentation>
    arguments
        Stack
        Orientation (1,:) char {mustBeMember(Orientation, {'XY', 'XZ', 'YZ'})} = 'XZ'
    end

    switch Orientation
        case "XY"
            ReslicedStack = permute(Stack, [1,2,3]);
        case "YZ"
            ReslicedStack = permute(Stack, [2,1,3]);
        case "XZ"
            ReslicedStack = permute(Stack, [3,2,1]);
    end
end