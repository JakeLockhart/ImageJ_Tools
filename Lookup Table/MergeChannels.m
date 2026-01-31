function MergedStack = MergeChannels(varargin)
    % <Documentation>
        % MergeChannels()
        %   Merge RGB channels of image stacks
        %   Created by: jsl5865
        %   
        % Syntax:
        %   MergedStack = MergeChannels(varargin)
        %
        % Description:
        %   
        % Input:
        %   
        % Output:
        %   
    % <End Documentation>

    TotalStacks = numel(varargin);
    if TotalStacks == 1
        Identifier = "InvalidStacks:NotEnoughStacksToMerge";
        ME = MException(Identifier, 'Only 1 stack loaded, cannot merge a stack with itself.');
        throwAsCaller(ME)
    end

    for Stack = 1:TotalStacks
        varargin{Stack} = StandardImageDimensions(varargin{Stack});
    end

    StackSizes = zeros(TotalStacks, 4);
    for Stack = 1:TotalStacks
        StackSizes(Stack, :) = size(varargin{Stack});
    end

    if size(unique(StackSizes, 'rows'), 1) ~= 1
        Identifier = "InvalidStacks:IncompatibleSizes";
        ME = MException(Identifier, 'Stacks do not have the same sizes. Check total Rows, Columns, Frames');
        throwAsCaller(ME)
    end
    
    MergedDimension = ndims(varargin{1}) + 1;
    MergedStack = max(cat(MergedDimension, varargin{:}), [], MergedDimension);

end