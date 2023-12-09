classdef Damper < Attenuator.Attenuator
    properties (SetAccess = immutable)
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
                Args.C
                Args.FNode
                Args.MNode
                Args.tubCenter
            end
            obj@Attenuator.Attenuator("FNode", Args.FNode, "MNode", Args.MNode, "tubCenter", Args.tubCenter)
            if Args.C == 0
                disp("Warning: Force constant is zero!")
            end
            obj.Constant = Args.C;
        end
    end
    
    methods         
        % Main properties
        function C = DamperConstant(obj) % Not used
            C = obj.Constant;
        end

        function v = get.DamperVelocity(obj)
            Dir = obj.FixedNode-obj.MobileNode;
            v = dot(obj.MobileNodeVel,  Dir)*Dir/norm(Dir);
        end
    end

    % Definition of Attenuator abstract methods
    methods    
        function f = Force(obj)
            f = obj.Constant*obj.DamperVelocity;
        end
    end
end