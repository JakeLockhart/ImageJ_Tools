function projectedStack = Projection(stack, projectionType, startSlice, endSlice)
    % <Documentation>
        % Projection()
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
        stack (:,:,:) {mustBeNumeric}
        projectionType (1,1) string {mustBeMember(projectionType, ["Average Intensity", "Min Intensity", "Max Intensity", "Sum Slices", "Standard Deviation", "Median"])} = "Average Intensity"
        startSlice (1,1) double {mustBeInteger, mustBePositive} = 1
        endSlice (1,:) double {mustBeInteger, mustBePositive} = []
    end

    endSlice = validateSliceRange(startSlice, endSlice);
    stack = stack(:,:,startSlice:endSlice);
    switch projectionType
        case "Average Intensity"
            projectedStack = AverageIntensity();

        case "Min Intensity"
            projectedStack = MinIntensity();

        case "Max Intensity"
            projectedStack = MaxIntensity();

        case "Sum Slices"
            projectedStack = SumSlices();

        case "Standard Deviation"
            projectedStack = StandardDeviation();

        case "Median"
            projectedStack = Median();

    end
    
    figure("Name", projectionType);
    imagesc(projectedStack);
    axis image
    colormap gray
    title(sprintf('%s Projection', projectionType))
    xlabel('Pixels')
    ylabel('Pixels')

    % Stack projection logic
    function endSlice = validateSliceRange(start, stop)
        identifier = "InvalidInput:SliceRange";
        if isempty(stop)
            endSlice = size(stack,3);
            return
        end
        
        if stop < start
            me = MException(identifier, 'Stop (%d) slice is before start (%d) slice', stop, start);
            throwAsCaller(me)
        end
    end

    function projectedStack = AverageIntensity()
        projectedStack = squeeze(mean(stack, 3));
    end

    function projectedStack = MinIntensity()
        projectedStack = squeeze(min(stack, [], 3));
    end

    function projectedStack = MaxIntensity()
        projectedStack = squeeze(max(stack, [], 3));
    end

    function projectedStack = SumSlices()
        projectedStack = squeeze(sum(stack, 3));
    end

    function projectedStack = StandardDeviation()
        projectedStack = squeeze(std(double(stack), 0, 3));
    end

    function projectedStack = Median()
        projectedStack = squeeze(median(stack, 3));
    end

end