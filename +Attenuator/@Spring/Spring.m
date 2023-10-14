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
%         function obj = Spring(Args)
%             arguments
%                 Args.K
%                 Args.FNode
%                 Args.MNode
%             end
%             obj@Attenuator.Attenuator("K", Args.K, "FNode", Args.FNode, "MNode", Args.MNode)
%             if Args.K == 0
%                 disp("Warning: Force constant is zero!")
%             end
%         end

        function f = Force(obj)
            f = obj.Constant*obj.Compression;
        end
    end

end
