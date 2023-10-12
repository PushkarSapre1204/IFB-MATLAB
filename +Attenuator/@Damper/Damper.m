classdef Damper < Attenuator.Attenuator
    properties  (SetAccess = immutable)
        Constant 
    end
    properties (Dependent)
        DamperVelocity
    end
    
    %% Methods
    
    % Constructors
    methods 
        function obj = Damper(Args)
            arguments
                Args.C = 0;
                Args.FNode 
                Args.MNode 
            end
            obj@Attenuator.Attenuator("FNode", Args.FNode, "MNode", Args.MNode)
            obj.Constant = Args.C;
        end
    end
    
    % Get Set methods
    methods         
        % Main properties
        function C = DamperConstant(obj) % Not used
            C = obj.Constant;
        end

        function v = get.DamperVelocity(obj)
            X0 = obj.FixedNodeX;
            Y0 = obj.FixedNodeY;
            X2 = obj.MobileNodeX;
            Y2 = obj.MobileNodeY;
            X2_dot = obj.MobileNodeVelX;
            Y2_dot = obj.MobileNodeVelY;
            
            v = 1/2* (2*(obj.FixedNode-obj.MobileNode).*obj.MobileNodeVel) / sqrt(sum((obj.FixedNode-obj.MobileNode).^2));

            %v = 1/2 * (2*(X0 - X2)*(X2_dot) + 2*(Y0 - Y2)*(Y2_dot))/sqrt((X0 - X2)^2 + (Y0 - Y2)^2);
        end
    end

    % Definition of Attenuator abstract methods
    methods    
        function f = Force(obj)
            f = obj.Constant.*obj.DamperVelocity;
        end
    end
end