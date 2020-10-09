% ############################################## %
%         Final Project -  2019-2020             %
%         Inbal Rimon Doron Serebro              %
% ############################################## %
function out= build_norm_mat(x, y)
%the normalization matrix is used to divide each pixel of the summed matrix
%by the number of summed elelments 
%center pixels have 8 neighbors, so 9 total elements summed
out=ones(x,y)*8;
%edge pixels have 5 neighbors, so 6 total elements summed
out(1,:)=5;
out(:,1)=5;
out(x,:)=5;
out(:,y)=5;
%corner pixels have 3 neighbors, so 4 total elements summed
out(1,1)=3;
out(1,y)=3;
out(x,1)=3;
out(x,y)=3;
end