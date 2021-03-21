classdef classA3
    properties
        imgSize
        theta;
        numAngles;
        projectionSize;
        trans;
    end
    methods
        function A = classA3(imgSize, angles, projectionSize)
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
                b1 = beta(1:sz/3);
                b2 = beta(sz/3+1:2*sz/3);
                b3 = beta(2*sz/3+1:end);
                
                b1 = reshape(b1,A.imgSize, A.imgSize);
                b2 = reshape(b2,A.imgSize, A.imgSize);
                b3 = reshape(b3,A.imgSize, A.imgSize);
                
                R1Ub1 = radon(idct2(b1),A.theta(:,:,1));
                R2Ub1 = radon(idct2(b1),A.theta(:,:,2));
                R2Ub2 = radon(idct2(b2),A.theta(:,:,2));
                R3Ub1 = radon(idct2(b1),A.theta(:,:,3));
                R3Ub2 = radon(idct2(b2),A.theta(:,:,3));
                R3Ub3 = radon(idct2(b3),A.theta(:,:,3));
                
                res = [R1Ub1(:); R2Ub1(:) + R2Ub2(:); R3Ub1(:) + R3Ub2(:) + R3Ub3(:)];
            else
                sz = size(beta,1);
                b1 = beta(1:sz/3);
                b2 = beta(sz/3+1:2*sz/3);
                b3 = beta(2*sz/3+1:end);
                
                b1 = reshape(b1,A.projectionSize,A.numAngles/3);
                b2 = reshape(b2,A.projectionSize,A.numAngles/3);
                b3 = reshape(b3,A.projectionSize,A.numAngles/3);
                
                Aty1 = dct2(iradon(b1,A.theta(:,:,1),'linear','Ram-Lak',1,A.imgSize));
                Aty2 = dct2(iradon(b2,A.theta(:,:,2),'linear','Ram-Lak',1,A.imgSize));
                Aty3 = dct2(iradon(b3,A.theta(:,:,3),'linear','Ram-Lak',1,A.imgSize));
                res = [Aty1(:) + Aty2(:) + Aty3(:); Aty2(:) + Aty3(:); Aty3(:)];
            end
        end
        function At = ctranspose(A)
            % ' operator overloading 
            A.trans = ~A.trans;
            At = A;
        end
    end
end