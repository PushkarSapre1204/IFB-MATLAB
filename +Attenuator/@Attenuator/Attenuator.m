classdef Attenuator
    properties (SetAccess = immutable)
        Constant
    end
    properties  (SetAccess = immutable, GetAccess = protected)
        FixedNode = [0,0];
        NodeOffset
    end
    properties  (Access = protected)
        MobileNode = [0,0];
        MobileNodeVel = [0,0];
    end
    properties (Dependent)
        FixedNodeX          % Xf
        FixedNodeY          % Yf
        MobileNodeX         % Xm
        MobileNodeY         % Ym 
        MobileNodeVelX      % Xm_dot
        MobileNodeVelY      % Ym_dot
    end

    properties ( Dependent)
        Fx
        Fy
    end
    
    %% Methods
    
    % Constructor
    methods                 
        function obj = Attenuator(Args)
            arguments
                Args.FNode (0,0)
                Args.MNode (0,0)
                Args.tubCenter 
            end
            obj.FixedNode = Args.FNode;
            obj.MobileNode = Args.MNode;
            obj.NodeOffset = obj.MobileNode - Args.tubCenter;
        end
    end

    % Get set methods
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
        
    % Set methods:
        function obj = set.MobileNode(obj, tubCenter)
            obj.MobileNode = tubCenter; % + obj.NodeOffset;
        end
        
    end

%     methods (Abstract)
%         f = Force(obj)
%     end


end

