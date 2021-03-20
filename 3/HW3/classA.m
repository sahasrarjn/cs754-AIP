classdef classA
    properties
        imgSize
        theta;
        numAngles;
        projectionSize;
        trans;
    end
    methods
        function A = classA(imgSize, angles, projectionSize)
            A.imgSize = imgSize;
            A.theta = angles;
            A.projectionSize = projectionSize;
            A.numAngles = numel(angles);
            A.trans=0;
        end
        function res = mtimes(A, beta)
            if A.trans == 0 
                x = reshape(beta,A.imgSize, A.imgSize);
                RUb = radon(idct2(x),A.theta);
                res = RUb(:);
            else
                x = reshape(beta,A.projectionSize,A.numAngles);
                Atx = dct2(iradon(x,A.theta,'linear','Ram-Lak',1,A.imgSize));
                res = Atx(:);
            end
        end
        function At = ctranspose(A)
            A.trans = xor(A.trans,1);
            At = A;
        end
    end
end