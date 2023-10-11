classdef Damper < Attenuator
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
    end
    
    % Get Set methods
    methods         
        % Main properties
        function C = DamperConstant(obj)
            C = obj.Constant;
        end

        function v = get.DamperVelocity(obj)
            X0 = obj.FixedNodeX;
            Y0 = obj.FixedNodeY;
            X2 = obj.MobileNodeX;
            Y2 = obj.MobileNodeY;
            X2_dot = obj.MobileNodeVelX;
            Y2_dot = obj.MobileNodeVelY;

            v = 1/2 * (2*(X0 - X2)*(X2_dot) + 2*(Y0 - Y2)*(Y2_dot))/sqrt((X0 - X2)^2 + (Y0 - Y2)^2);
        end
    end

    % Definition of Attenuator abstract methods
    methods    
        function f = Force(obj)
            f = obj.Constant*obj.DamperVelocity;
        end
    end
end