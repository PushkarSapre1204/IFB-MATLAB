classdef Spring < Attenuator.Attenuator
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
                Args.K = 0;
                Args.FNode = [0,0];
                Args.MNode = [0,0];
            end
            obj@Attenuator.Attenuator("FNode", Args.FNode, "MNode", Args.MNode)
            obj.Constant = Args.K;
            if Args.K == 0
                disp("Warning: Force constant is zero!")
            end
        end

        function f = Force(obj)
            f = obj.Constant*obj.Compression;
        end
    end

end
