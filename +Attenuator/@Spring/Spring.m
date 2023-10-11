classdef Spring < Attenuator
    properties (SetAccess = immutable)
        Constant
    end
    
    properties
        Compression
    end


    %% Methods
    
    % Constructor
    methods
        function obj = Spring(Args)
            arguments
                Args.Constant = 0;
                Args.FNode = [0,0];
                Args.MNode = [0,0];
            end
            obj@Attenuator("FNode", Args.FNode, "MNode", Args.MNode)
            obj.Constant = Args.Constant;
            if Args.Constant == 0
                disp("Warning: Force constant is zero!")
            end
        end

        function f = Force(obj)
            f = obj.Constant*obj.Compression;
        end
    end

end
