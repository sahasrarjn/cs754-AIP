classdef classA2
    properties
        imgSize
        theta;
        numAngles;
        projectionSize;
        trans;
    end
    methods
        function A = classA2(imgSize, angles, projectionSize)
            A.imgSize = imgSize;
            A.theta = angles;
            A.projectionSize = projectionSize;
            A.numAngles = numel(angles);
            A.trans=false;
        end
        function res = mtimes(A, beta)
            % * operator overloading 
            if A.trans == false
                sz = size(beta,1);
                b1 = beta(1:sz/2);
                b2 = beta(sz/2+1:sz);
                
                b1 = reshape(b1,A.imgSize, A.imgSize);
                b2 = reshape(b2,A.imgSize, A.imgSize);
                
                R1Ub1 = radon(idct2(b1),A.theta(:,:,1));
                R2Ub1 = radon(idct2(b1),A.theta(:,:,2));
                R2Ub2 = radon(idct2(b2),A.theta(:,:,2));
                
                res = [R1Ub1(:); R2Ub1(:) + R2Ub2(:)];
            else
                sz = size(beta,1);
                b1 = beta(1:sz/2);
                b2 = beta(sz/2+1:sz);
                
                b1 = reshape(b1,A.projectionSize,A.numAngles/2);
                b2 = reshape(b2,A.projectionSize,A.numAngles/2);
                
                Aty1 = dct2(iradon(b1,A.theta(:,:,1),'linear','Ram-Lak',1,A.imgSize));
                Aty2 = dct2(iradon(b2,A.theta(:,:,2),'linear','Ram-Lak',1,A.imgSize));
                res = [Aty1(:) + Aty2(:); Aty2(:)];
            end
        end
        function At = ctranspose(A)
            % ' operator overloading 
            A.trans = ~A.trans;
            At = A;
        end
    end
end