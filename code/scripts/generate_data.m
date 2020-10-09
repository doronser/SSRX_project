%% Intro & Preprocessing
% this script compares between RX algorithm and SSRX algorithm
% where the number of deleted PCs is 5.

%load the data
file = 'G:\My Drive\Project\self_test\HyMap\self_test_rad.img';
[mat,hdr] = auto_load_HS(file);
data=double(permute(mat,[2,1,3]));
[x_size,y_size, num_of_bands]=size(data);

%compute RX parameters for original data
[X_MINUS_M,phi]=HSI_MF_params(data);
phi_inv = pinv(phi);
RX = zeros(x_size,y_size);

%delete 5 highest variance dimensions
[V, D] = eigs(phi,126);
V = V(:,1:120);% using only the first 5 PCs
data_pca2D = reshape(X_MINUS_M,x_size*y_size,num_of_bands) * V;
data_pca = hyperConvert3d(data_pca2D', x_size,y_size,num_of_bands);

%compute RX parameters for the projected data
[X_PCA_MINUS_M,phi_pca]=HSI_MF_params(data_pca);
phi_pca_inv = pinv(phi_pca);
SSRX = zeros(x_size,y_size);

%% RX & SSRX
%Compute RX scores
for x = 1:x_size
    for y = 1:y_size
        x_minus_m = squeeze(X_MINUS_M(x,y,:));
        RX(x,y) = x_minus_m' * phi_inv * x_minus_m;
        
        x_pca_minus_m = squeeze(X_PCA_MINUS_M(x,y,:));
        SSRX(x,y) = x_pca_minus_m' * phi_pca_inv * x_pca_minus_m;
    end
end

%apply the 3 sigma threshold
RX= RX';
RX_filt = RX > mean(RX(:)) + 3*std(RX(:));

SSRX= SSRX';
SSRX_filt = SSRX > mean(SSRX(:)) + 3*std(SSRX(:));

%% Analyzing Results
% SSRX_gain = SSRX_filt.*(1-RX_filt); % anomalies found in SSRX and not in RX
% SSRX_miss = (1-SSRX_filt).*RX_filt; % anomalies found in RX and not in SSRX
% intersec = SSRX_filt.*RX_filt;
% figure ;
% hold on; 
% spy(SSRX_gain,'og');
% spy(SSRX_miss,'xr');
% legend('Unique to SSRX','Unique to RX')
% title('Anomalies Not Shared Between RX & SSRX')
% 
% figure ;
% spy(intersec,'ob');
% title('Anomalies Shared Between RX & SSRX')
% 
% ssrx_in_rx = length(nonzeros(intersec)) / length(nonzeros(RX_filt));
% rx_in_ssrx = length(nonzeros(intersec)) / length(nonzeros(SSRX_filt));

%% scatter plots
RX_vect = (RX(:) - min(RX(:)) )/(max(RX(:))- min(RX(:)) );
SSRX_vect = (SSRX(:) - min(SSRX(:)) )/(max(SSRX(:))- min(SSRX(:)) );
color_vect =(RX_vect>SSRX_vect);
figure; 
hold on;
scatter(RX_vect,SSRX_vect,[],color_vect); 
plot(RX_vect,RX_vect,'k')
xlabel('RX Score');
ylabel('iSSRX120 Score');
title('RX vs iSSRX120 - Scatter Plot')
colormap jet;
xlim([0, 0.4]);
ylim([0, 0.4]);

% figure;
% hold on;
% scatter(RX_vect.*RX_filt(:),SSRX_vect.*SSRX_filt(:),[],color_vect)
% plot(RX_vect,RX_vect,'r')
% xlabel('RX Score');
% ylabel('iSSRX5 Score');
% title('RX vs iSSRX5 - Only Anomalies')
% colormap jet;

% [~, idxs] = maxk(RX(:), 10);
% [row,col] = ind2sub(size(RX),idxs);