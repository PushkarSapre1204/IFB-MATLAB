classdef Subclass < TestPackage.SuperClass
    properties
        b
    end

    methods
        function obj = Subclass(In)
            obj.b = In;
        end
    end
end
