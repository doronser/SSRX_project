function [img] = hyperConvert3d(img, h, w, numBands)
% HYPERCONVERT2D Converts an 2D matrix to a 3D data cube
% Converts a 2D matrix (p x N) to a 3D data cube (m x n x p)
% where N = m * n
% 
% Usage
%   [M] = hyperConvert3d(M)
% Inputs
%   M - 2D data matrix (p x N)
% Outputs
%   M - 3D data cube (m x n x p)


if (~ismatrix(img))
    error('Input image must be p x N.');
end

[numBands, N] = size(img);

if (N == 1)
    img = reshape(img, h, w);
else
    img = reshape(img.', h, w, numBands); 
end

return;