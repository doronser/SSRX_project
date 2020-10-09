% ############################################## %
%         Final Project -  2019-2020             %
%         Inbal Rimon Doron Serebro              %
% ############################################## %
%Input: HSI cube
%Output: statistical parameters Needed for running Matched Filter target detection
function [X_MINUS_M,phi]=HSI_MF_params(data)
[x_size,y_size, num_of_bands]=size(data);
%% Create local mean matrix
M = zeros(size(data));
data_sum = zeros(size(data));
sum_filter = ones(3); %filter for using convolution as sum of neighbors

%build a matrix to normalize each summed element back to original scale
normalize=build_norm_mat(x_size,y_size);

for z=1:num_of_bands
    curr_band=squeeze(data(:,:,z));
    data_sum(:,:,z) = conv2(curr_band,sum_filter,'same') ; %sum up all neighbors in a matrix (including the center pixel)
    M(:,:,z)=(data_sum(:,:,z)-curr_band)./normalize; % our mean is the sum of negihbors only
end

%% Create Phi and X_MINUS_M
X_MINUS_M=data-M;
phi = cov( reshape(X_MINUS_M,x_size*y_size,num_of_bands) );
end