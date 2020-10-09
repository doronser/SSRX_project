load ssrx_results.mat
th=0.4;
PCs_dropped= [5 10 20 50 75 100 120];
SSRX_cube = cat(3,SSRX05,SSRX20,SSRX50,SSRX75,SSRX100,SSRX120);
SSRX_mat = zeros(size(SSRX_cube,3),numel(RX));
RX_vect = (RX(:) - min(RX(:)) )/(max(RX(:))- min(RX(:)) );
for i =1:size(SSRX_cube,3)
    vect = SSRX_cube(:,:,i); 
    SSRX_mat(i,:) = (vect(:) - min(vect(:)) )/(max(vect(:))- min(vect(:)) );
end

%%
RX_filt = RX > mean(RX) + 3*std(RX);
iSSRX05_filt = iSSRX05 > mean(iSSRX05(:)) + 3*std(iSSRX05(:));
iSSRX50_filt = iSSRX50 > mean(iSSRX50(:)) + 3*std(iSSRX50(:));
iSSRX120_filt = iSSRX120 > mean(iSSRX120(:)) + 3*std(iSSRX120(:));
figure;
spy(RX_filt,'or'); 
hold on;
spy(iSSRX120_filt,'xg');
legend('RX','iSSRX120');

figure;
histogram(SSRX100(:))
title('SSRX100')
xlim([0, 1000])
%% Scatter Plots
figure;
for i =1:size(SSRX_cube,3)
    subplot(2,3,i)
    SSRX_vect = SSRX_mat(i,:)';
    SSRX_vect = (SSRX_vect - min(SSRX_vect))/(max(SSRX_vect)- min(SSRX_vect));
    color_vect =(RX_vect>SSRX_vect);
    scatter(RX_vect,SSRX_vect,[],color_vect); 
    hold on;
    plot(RX_vect,RX_vect,'k')
    xlabel('RX Score');
    ylabel('SSRX Score');
    title_str = sprintf('RX vs SSRX%d', PCs_dropped(i));
    title(title_str)
    xlim([0, th]);
    ylim([0, th]);
    colormap jet;
end


%% Same for SSCC
% load sscc_results.mat
th =0.2;
PCs_dropped= [50 100 150 200];
CC_vect = (CC(:) - min(CC(:)) )/(max(CC(:))- min(CC(:)) );SSCC_cube = cat(3,SSCC50,SSCC100,SSCC150,SSCC200);
SSCC_mat = zeros(size(SSCC_cube,3),numel(CC));
for i =1:size(SSCC_cube,3)
    vect = SSCC_cube(:,:,i); 
    SSCC_mat(i,:) = (vect(:) - min(vect(:)) )/(max(vect(:))- min(vect(:)) );
end

%Scatter Plots Again
figure;
for i =1:size(SSCC_cube,3)
    subplot(2,2,i)
    SSCC_vect = SSCC_mat(i,:)';
    SSCC_vect = (SSCC_vect - min(SSCC_vect))/(max(SSCC_vect)- min(SSCC_vect));
    color_vect =(CC_vect>SSCC_vect);
    scatter(CC_vect,SSCC_vect,[],color_vect); 
    hold on;
    plot(CC_vect,CC_vect,'k')
    xlabel('CC Score');
    ylabel('SSCC Score');
    title_str = sprintf('CC vs SSCC%d', PCs_dropped(i));
    title(title_str)
    xlim([0, th]);
    ylim([0, th]);
    colormap jet;
end