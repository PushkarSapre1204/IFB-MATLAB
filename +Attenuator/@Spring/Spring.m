classdef Spring < Attenuator.Attenuator
    properties (SetAccess = immutable)
        Constant
        L0 {mustBeNonnegative}
    end
    
    properties (Dependent)
        Compression
    end


    %% Methods
    
    % Constructor
    methods
        function obj = Spring(Args)
            arguments
                Args.K
                Args.FNode
                Args.MNode
                Args.tubCenter
                Args.L0
            end
            obj@Attenuator.Attenuator("FNode", Args.FNode, "MNode", Args.MNode, "tubCenter", Args.tubCenter)
            if Args.K == 0
                disp("Warning: Force constant is zero!")
            end
            obj.Constant = Args.K;
            obj.L0 = Args.L0;
        end

        function L = get.Compression(obj)
            L = norm(obj.FixedNode - obj.MobileNode);          % Find current length
            L = obj.L0 - L;         % Find delta L
        end
        function f = Force(obj, Args)
            arguments
                obj 
                Args.PrintOutput = "False"
            end
            Components = (obj.FixedNode - obj.MobileNode)/sqrt(sum((obj.FixedNode - obj.MobileNode).^2));   
            f = obj.Constant*obj.Compression*Components;
            if Args.PrintOutput == "True"
                disp(f)
            end
        end
        
    end

end
