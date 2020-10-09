% How to generate an estimated RGB image from the RIT data
r_channel = 16;
g_channel = 7;
b_channel = 2;
r2=data(:,:,16)';
g2=data(:,:,7)';
b2=data(:,:,2)';
r2_norm =( r2 -min(r2(:)) ) /( max(r2(:)) - min(r2(:)) );
g2_norm =( g2 -min(g2(:)) ) /( max(g2(:)) - min(g2(:)) );
b2_norm =( b2 -min(b2(:)) ) /( max(b2(:)) - min(b2(:)) );
rit_RGB2 = cat(3,r2_norm,g2_norm,b2_norm);
figure;imshow(rit_RGB2);