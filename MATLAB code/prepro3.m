function prepro3(soundfile,name)
%preprocessing
[y,fs]=audioread(soundfile');
t=(0:(length(y)-1))/fs;

%Short Time Fourier Transform variables
ylen = length(y);                   % length of the signal
wlen = 1024;                        % window length (recomended to be power of 2)
hop = wlen/4;                       % hop size (recomended to be power of 2)
nfft = 4096;                        % number of fft points (recomended to be power of 2)

% represent x as column-vector
y = y(:);

% form a periodic hamming window
win = hamming(wlen, 'periodic');

% stft matrix estimation and preallocation
rown = ceil((1+nfft)/2);            % calculate the total number of rows
coln = 1+fix((length(y)-wlen)/hop);      % calculate the total number of columns
S = zeros(rown, coln);           % form the stft matrix

% initialize the signal time segment index
indx = 0;

% perform STFT
for col = 1:coln
    % windowing
    xw = y(indx+1:indx+wlen).*win;
    % FFT
    X = fft(xw, nfft);
    % update the stft matrix
    S(:, col) = X(1:rown);
    % update the index
    indx = indx + hop;
end

% define the coherent amplification of the window
K = sum(hamming(wlen, 'periodic'))/wlen;

% take the amplitude of fft(x) and scale it, so not to be a
% function of the length of the window and its coherent amplification
S = abs(S)/wlen/K;

% correction of the DC & Nyquist component
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    S(2:end, :) = S(2:end, :).*2;
else                                % even nfft includes Nyquist point
    S(2:end-1, :) = S(2:end-1, :).*2;
end

% convert amplitude spectrum to dB (min = -120 dB)
S = 20*log10(S + 1e-6);
S =  (S+120)/2;
S = flip(S,1);
%% Normalisation of matrix
normA = S - min(S(:)); %first, normalise spec
normA = normA ./ max(normA(:));
caxis([0 1]);
%% Median clipping
clipped = normA;
rowmedian = median(clipped,2);
columnmedian = median(clipped,1);
for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > 1.15*rowmedian(i,1) && clipped(i,j) > 1.15*columnmedian(1,j)
        else clipped(i,j) = NaN;
        end
    end
end

stdclipped = std(clipped(:),'omitnan');
maxclippedmat=max(clipped,[],'omitnan');
avgmax=mean(maxclippedmat(:),'omitnan');
avgwhole=mean(clipped(:),'omitnan');
%% Mean Clipping

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > (avgmax-(1*stdclipped))
        else clipped(i,j) = NaN;
        end
    end
end
%% ReNormalisation of matrix
normA = clipped - min(clipped(:)); %first, normalise spec
newnormA = normA ./ max(normA(:));
caxis([0 1]);
clipped=newnormA;
%% third time
thirdstdclipped = std(clipped(:),'omitnan');
thirdmaxclippedmat=max(clipped,[],'omitnan');
thirdavgmax=mean(thirdmaxclippedmat(:),'omitnan');
thirdavgwhole=mean(clipped(:),'omitnan');

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > (thirdavgmax-(1*thirdstdclipped))
        else clipped(i,j) = NaN;
        end
        
    end
end
 %% ReNormalisation of matrix
normA = clipped - min(clipped(:)); %first, normalise spec
newnormA = normA ./ max(normA(:));
caxis([0 1]);
clipped=newnormA;

%% fourth time
frthstdclipped = std(clipped(:),'omitnan');
frthmaxclippedmat=max(clipped,[],'omitnan');
frthavgmax=mean(frthmaxclippedmat(:),'omitnan');
frthavgwhole=mean(clipped(:),'omitnan');

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > (frthavgmax-(1*frthstdclipped))
        else clipped(i,j) = NaN;
        end
    end
end
%% ReNormalisation of matrix
normA = clipped - min(clipped(:)); %first, normalise spec
newnormA = normA ./ max(normA(:));
caxis([0 1]);
clipped=newnormA;

%% Minimum Filter (Figure 1)
sixstdclipped = std(clipped(:),'omitnan');
sixminclippedmat=min(clipped,[],'omitnan');
sixavgmin=mean(sixminclippedmat(:),'omitnan');
sixavgwhole=mean(clipped(:),'omitnan');
sixminwhole=min(clipped(:),[],'omitnan');

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) < (sixminwhole+(0.5*sixstdclipped));
           clipped(i,j) = NaN;
        end
    end
end

figure(1);
imshow(clipped);
colormap bone;

%% ReNormalisation of matrix
% normA = clipped - min(clipped(:)); %first, normalise spec
% fnewnormA = normA ./ max(normA(:));
% caxis([0 1]);
% triclipped=fnewnormA;
%% Binary (Figure 2)
triclipped=clipped;
fifstdclipped = std(triclipped(:),'omitnan');
fifmaxclippedmat=max(triclipped,[],'omitnan');
fifavgmax=mean(fifmaxclippedmat(:),'omitnan');
fifavgwhole=mean(triclipped(:),'omitnan');

for i = 1:size(triclipped,1)
    for j = 1:size(triclipped,2)
        if triclipped(i,j) > (fifavgmax-(3*fifstdclipped))
            triclipped(i,j) = 1;
        else triclipped(i,j) = NaN;
        end     
    end
end

%% Highlighting (Figure 3
% 
% clipped2 = clipped;
% for i = 1:size(clipped,1)
%     for j = 1:size(clipped,2) 
%         if i>1 && i<size(clipped,1) && j>1 && j<size(clipped,2)
%             if (clipped2(i-1,j-1)+clipped2(i-1,j)+clipped2(i,j-1)+clipped2(i,j)+clipped2(i+1,j)+clipped2(i,j+1)+clipped2(i+1,j+1)+clipped2(i+1,j-1)+clipped2(i-1,j+1))>0
%                 clipped2(i,j) = (clipped2(i-1,j-1)+clipped2(i-1,j)+clipped2(i,j-1)+clipped2(i,j)+clipped2(i+1,j)+clipped2(i,j+1)+clipped2(i+1,j+1)+clipped2(i+1,j-1)+clipped2(i-1,j+1))/9;
%             clipped2(i,j) = 1;
%             end
%         end
%     end
% end
% 
% figure(3);
% imshow(clipped2);
% 
% nofvals = 0;
% avg = 0;
% display(avg);
% clipped2(isnan(clipped2)) = 0;
% for i = 1:size(clipped2,1)
%     for j = 1:size(clipped2,2)
%         if (clipped2(i,j) ~= 0) && (clipped2(i,j) ~= 1)
%             nofvals = nofvals + 1;
%             avg = avg + clipped2(i,j);
%         end
%     end
% end
% display(nofvals);
% display(avg);
% totalavg = avg/nofvals;
% display(totalavg);
% 
% for i = 1:size(clipped2,1)
%     for j = 1:size(clipped2,2)
%         if (clipped2(i,j) ~= 0) && (clipped2(i,j) ~= 1) 
%             if clipped2(i,j) < totalavg
%                 clipped2(i,j) = 0;
%             end
%         else if clipped2(i,j) > totalavg
%                 clipped2(i,j) = 1;
%             end
%         end
%     end
% end
% 
% figure(4);
% imshow(clipped2);
% 
% save clipped.mat
% save triclipped.mat
% save clipped2.mat
% colormap bone;

%%
%phoneme extraction colormap bone;
image = int64(triclipped);
BW2 = bwareaopen(image,100);

CC =(bwconncomp(BW2));
clipped(isnan(clipped)) = 0;

for i=1:(length(CC.PixelIdxList))
    indexarray = int64(cell2mat(CC.PixelIdxList(1,i)));
    positionarray =int64 (zeros(2,length(CC.PixelIdxList(1,i))));
    for c = 1 : length(indexarray)
        number = indexarray(c);
        y =mod(number, size(image,1));
        if y ==0
            y = size(image,1);
        end
        x = idivide((number-1), int64(size(image,1)), 'floor')+1;
        positionarray (1,c)=x;
        positionarray (2,c)=y;
    end
    xmax = int64(max(positionarray(1,:)));
    xmin = int64(min(positionarray(1,:)));
    ymax = int64(max(positionarray(2,:)));
    ymin = int64(min(positionarray(2,:)));
    %phoneme = NaN(ymax-ymin+1,xmax-xmin+1,'distributed');
    phoneme = zeros(ymax-ymin+1,xmax-xmin+1);
    
%     for c = 1:size(positionarray,2)
%         phoneme(positionarray(2,c)+1-ymin,positionarray(1,c)+1-xmin)=1;
    for row =1:length(phoneme)
        for column = 1:size(phoneme,1)
            phoneme(row,column) = clipped(ymin+row,xmin+column);
        end
    
    
    end
    formatSpec = '%s - phoneme %d.png';
    filename = sprintf(formatSpec,name,i);
    imwrite(phoneme,filename);
   
end
end