%% change detection 
file1='G:\My Drive\Project\SSRX Project\ChangeDetectionDataset\bayArea\mat\Bay_Area_2013.mat';
dataX=load(file1);
dataX=dataX.HypeRvieW;
file2='G:\My Drive\Project\SSRX Project\ChangeDetectionDataset\bayArea\mat\Bay_Area_2015.mat';
dataY=load(file2);
dataY=dataY.HypeRvieW;
[x_size,y_size, num_bands]=size(dataX);


%compute Chronochrome parameters for original data
[X_MINUS_M,phi_x]=HSI_MF_params(dataX);
[Y_MINUS_M,phi_y]=HSI_MF_params(dataY);
X2D = reshape(X_MINUS_M,x_size*y_size,num_bands);
Y2D = reshape(X_MINUS_M,x_size*y_size,num_bands);
phi_xy = (X2D-mean(X2D))' * (Y2D-mean(Y2D))./(num_bands-1);

% % The 2 ways to compute the coavriance matrix are the same except one is
% % multiplied by roughly 1345 (not sure why, but it's a constant so it's ok)
% dataX2D=reshape(dataX,x_size*y_size,num_bands);
% dataY2D=reshape(dataY,x_size*y_size,num_bands);
% phi_x_cov = cov(dataX2D);
% phi_x_test = (dataX2D-mean(dataX2D))' * (dataX2D-mean(dataX2D))./(num_bands-1);
% phi_y_cov = cov(dataY2D);
% phi_y_test = (dataY2D-mean(dataY2D))' * (dataY2D-mean(dataY2D))./(num_bands-1);

phi_x_inv = pinv(phi_x);
phi_y_inv = pinv(phi_y);

%%
Yest2D =  (phi_xy*phi_x_inv*X2D')';
e2D = Yest2D-Y2D;
e = reshape(e2D,x_size,y_size, num_bands);
[E_MINUS_M,phi_e]=HSI_MF_params(e);
phi_e_inv = pinv(phi_e);
CC = zeros(x_size,y_size);

%delete 5 highest variance dimensions
[V, D] = eigs(phi_e,num_bands);
V = V(:,201:end);
e_pca2D = reshape(X_MINUS_M,x_size*y_size,num_of_bands) * V;
e_pca = hyperConvert3d(e_pca2D', x_size,y_size,num_of_bands);

%compute RX parameters for the projected data
[E_PCA_MINUS_M,phi_e_pca]=HSI_MF_params(e_pca);
phi_e_pca_inv = pinv(phi_e_pca);
SSCC = zeros(x_size,y_size);


%Compute RX scores
for x = 1:x_size
    for y = 1:y_size
        e_minus_m = squeeze(E_MINUS_M(x,y,:));
        CC(x,y) = e_minus_m' * phi_e_inv * e_minus_m;
        
        e_pca_minus_m = squeeze(E_PCA_MINUS_M(x,y,:));
        SSCC(x,y) = e_pca_minus_m' * phi_e_pca_inv * e_pca_minus_m;
    end
end

CC_norm=(CC-min(CC(:)) )/(max(CC(:))-min(CC(:)));
SSCC_norm=(SSCC-min(SSCC(:)) )/(max(SSCC(:))-min(SSCC(:)));

CC_filt = CC_norm > mean(CC_norm(:)) + 3*std(CC_norm(:));
SSCC_filt = SSCC_norm > mean(SSCC_norm(:)) + 3*std(SSCC_norm(:));
figure;
imshow(dataY(:,:,70),[]);
hold on;
spy(CC_filt,'og');
spy(SSCC_filt,'xr');
legend('CC','SSCC')
title('Spatial Distribution - CC vs SSCC50')

figure;
scatter(CC_norm(:),SSCC_norm(:));
xlabel('CC Score')
ylabel('SSCC Score')
