load sscc_results.mat
imgX = imread('G:\My Drive\Project\SSRX Project\ChangeDetectionDataset\bayArea\rgb\bayArea2013rgb.png');
th=0.05;
vis_th=0.2;
CC_norm = (CC - min(CC(:)) )/(max(CC(:))- min(CC(:)) );
CC_vect = CC_norm(:);
SSCC = SSCC200;
SSCC_norm = (SSCC - min(SSCC(:)) )/(max(SSCC(:))- min(SSCC(:)) );
SSCC_vect = SSCC_norm(:);
color_vect =(double(CC_vect>th) + 2*double(SSCC_vect>th));
figure;
scatter(CC_vect,SSCC_vect,[],color_vect); 
hold on;
plot( (0:0.01:1),th*ones(1,101),'--r')
plot(th*ones(1,101),(0:0.01:1),'--g')
legend('scores','SSCC=0.05','CC=0.05');
xlabel('CC Score');
ylabel('SSCC Score');
title('CC vs SSCC200')
xlim([0, vis_th]);
ylim([0, vis_th]);
colormap jet;

%% plot the spatial distribution of the thersholded anomalies
CC_filt = CC_norm > th;
SSCC_filt = SSCC_norm > th;
both = CC_filt & SSCC_filt;
figure; 
imshow(0.6*imgX,[]);
hold on;
spy(CC_filt-both,'oc',10);
spy(SSCC_filt-both,'*y',10);
legend('Only CC>th','Only SSCC>th');
title('Spatial Distribution - CC vs SSCC200');

figure;
imshow(0.6*imgX,[]);
hold on;
spy(both,'*r',10);
legend('Both>th');