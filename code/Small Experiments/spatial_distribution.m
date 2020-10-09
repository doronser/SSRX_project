load ssrx_results.mat
load ritRGB2.mat
th=0.2;
vis_th=0.4;
RX_norm = (RX - min(RX(:)) )/(max(RX(:))- min(RX(:)) );
RX_vect = RX_norm(:);
SSRX = SSRX100;
SSRX_norm = (SSRX - min(SSRX(:)) )/(max(SSRX(:))- min(SSRX(:)) );
SSRX_vect = SSRX_norm(:);
color_vect =(double(RX_vect>th) + 2*double(SSRX_vect>th));
figure;
scatter(RX_vect,SSRX_vect,[],color_vect); 
hold on;
plot( (0:0.01:1),th*ones(1,101),'--r')
plot(th*ones(1,101),(0:0.01:1),'--g')
legend('scores','SSRX=0.2','RX=0.2');
xlabel('RX Score');
ylabel('SSRX Score');
title('RX vs SSRX100')
xlim([0, vis_th]);
ylim([0, vis_th]);
colormap jet;

%% plot the spatial distribution of the thersholded anomalies
RX_filt = RX_norm > th;
SSRX_filt = SSRX_norm > th;
both = RX_filt & SSRX_filt;

figure; 
imshow(rit_RGB2+0.2);
hold on;
spy(RX_filt-both,'og');
spy(SSRX_filt-both,'*r');
legend('Only RX>th','Only SSRX>th')
title('Spatial Distribution - RX vs SSRX100')

figure;
imshow(rit_RGB2+0.2);
hold on;
spy(both,'vy')
legend('Both>th')