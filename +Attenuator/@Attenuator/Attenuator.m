classdef Attenuator < handle
    properties (Abstract, SetAccess = immutable)
        Constant {mustBeNonmissing, mustBeNonnegative}
    end
    properties  (SetAccess = immutable, GetAccess = protected)
        FixedNode 
        NodeOffset 
    end
    properties  (Access = protected)
        MobileNode  {mustBeNonmissing}
        MobileNodeVel 
    end
    
    %% Methods
    
    % Constructor
    methods                 
        function obj = Attenuator(Args)
            arguments
                Args.FNode (1,3)
                Args.MNode (1,3)
                Args.tubCenter 
            end
            obj.FixedNode = Args.FNode;
            obj.MobileNode = Args.MNode;
            obj.NodeOffset = obj.MobileNode - Args.tubCenter;
        end
    end

    % Get methods
    methods
        function C = getConstant(obj)
            C = obj.Constant;
        end

        function fN = getFixedNode(obj)
            fN = obj.FixedNode;
        end

        function nOff = getNodeOffset(obj)
            nOff = obj.NodeOffset;
        end

        function MN = getMobileNode(obj)
            MN = obj.MobileNode;
        end

        function MNV = getMobileNodeVel(obj)
            MNV = obj.MobileNodeVel;
        end

        % Main methods

        function obj = Update(obj, NewTubLocation, tubVel)         % Get the new tub velocity and displacement. Update self velocities accordingly.
            obj.MobileNode = NewTubLocation + obj.NodeOffset;
            obj.MobileNodeVel = tubVel;
        end
        
        function obj = UdpateMNode(obj, NewLoc, NewVel)
            obj.MobileNode = NewLoc;
            obj.MobileNodeVel = NewVel;
        end
    end


    
    methods (Abstract)
        f = Force(obj)
    end


end

