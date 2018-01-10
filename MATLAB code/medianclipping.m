function [ clipped ] = medianclipping( spec )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%% Normalisation of matrix
normA = spec - min(spec(:)); %first, normalise spec
normA = normA ./ max(normA(:));
figure
image(normA)
colorbar
caxis([0 1])

%% Median clipping
clipped = normA;
rowmedian = median(clipped,2);
columnmedian = median(clipped,1);
for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > 1.5*rowmedian(i,1) && clipped(i,j) > 1.5*columnmedian(1,j)
            clipped(i,j) = 60;
        else clipped(i,j) = 0;
        end
        
    end
end
figure
image(clipped);
colormap bone;


end

