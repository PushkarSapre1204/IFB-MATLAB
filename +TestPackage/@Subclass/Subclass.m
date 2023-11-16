classdef Subclass < TestPackage.SuperClass
    properties
        b
    end

    methods
        function obj = Subclass(In)
            obj.b = In;
        end

        function TestFunction0(obj)
            obj.a = obj.b/2;
        end
    end
 
end
