classdef Attenuator 
    properties  (SetAccess = immutable)
        Constant
        FixedNode = [] 
        MobileNode = [1,2]
    end
    properties (Dependent)
        FixedNodeX
        FixedNodeY
    end

    methods
        function x = get.FixedNodeX(obj)
            x = obj.FixedNodeX;
        end
        function y = get.FixedNodeY(obj)
            y = obj.FixedNodeY;
        end
    end
end

