classdef Attenuator < handle
    properties (Abstract, SetAccess = immutable)
        Constant {mustBeNonmissing, mustBeNonnegative}
    end
    properties  (SetAccess = immutable) %, GetAccess = protected)
        FixedNode 
        NodeOffset 
    end
    properties  %(Access = protected)
        MobileNode  {mustBeNonmissing}
        MobileNodeVel 
    end
    properties (Dependent)
        %MobileNode  {mustBeNonmissing}
        FixedNodeX          % Xf
        FixedNodeY          % Yf
        MobileNodeX         % Xm
        MobileNodeY         % Ym 
        MobileNodeVelX      % Xm_dot
        MobileNodeVelY      % Ym_dot
    end

    properties (Dependent)
        Fx
        Fy
    end
    
    %% Methods
    
    % Constructor
    methods                 
        function obj = Attenuator(Args)
            arguments
                Args.FNode (1,2)
                Args.MNode (1,2)
                Args.tubCenter 
            end
            obj.FixedNode = Args.FNode;
            obj.MobileNode = Args.MNode;
            obj.NodeOffset = obj.MobileNode - Args.tubCenter;
        end
    end

    % Get methods
    methods     
        function x = get.FixedNodeX(obj)
            x = obj.FixedNode(1);
        end
        function y = get.FixedNodeY(obj)
            y = obj.FixedNode(2);
        end

        function x = get.MobileNodeX(obj)
            x = obj.MobileNode(1);
        end
        function y = get.MobileNodeY(obj)
            y = obj.MobileNode(2);
        end

        function x = get.MobileNodeVelX(obj)
            x = obj.MobileNodeVel(1);
        end
        function y = get.MobileNodeVelY(obj)
            y = obj.MobileNodeVel(2);
        end
        
    % Main methods

    function obj = Update(obj, NewTubLocation, tubVel)         % Get the new tub velocity and displacement. Update self velocities accordingly.
            obj.MobileNode = NewTubLocation + obj.NodeOffset;
            obj.MobileNodeVel = tubVel;
        end
            
    end

    methods (Abstract)
        f = Force(obj)
    end


end

