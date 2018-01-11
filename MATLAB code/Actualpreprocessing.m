
function Actualpreprocessing(soundfile)
%preprocessing
[y,fs]=audioread(soundfile);
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

figure(2);
image(S);
colormap bone;
colorbar;

%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%% Normalisation of matrix
normA = S - min(S(:)); %first, normalise spec
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
figure(3)
image(clipped);
colormap bone;

%closing
columns = length(clipped); 
rows = size(clipped,1);

ma1 = zeros (rows,columns);
for c = 1:columns
    for r = 1:rows
        if clipped(r,c)== 60
            for nc = -1 :1
                for nr = -1 :1
                    if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
                    else
                    ma1(r+nr,c+nc) = 60;
                    end
                end
            end
        end
    end
end
figure (4)
image(ma1);
colormap bone;

ma2 = ones (rows,columns);
for c = 1:columns
    for r = 1:rows
        if ma1(r,c)== 0
            for nc = -1 :1
                for nr = -1 :1
                    if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
                    else
                    ma2(r+nr,c+nc) = 0;
                    end
                end
            end
        else
            ma2(r,c) = 60;
        end
    end
end
figure(5)
image(ma2);
colormap bone;
%dilation


ma3 = zeros (rows,columns);
for c = 1:columns
    for r = 1:rows
        if ma2(r,c)== 60
            for mc = -1 :1
                for mr = -1 :1
                    if (r+mr < 1) || (c+mc < 1) || (r+mr > rows) || (c+mc > columns);
                    end
                    ma3(r+mr,c+mc) = 60;
                end
            end
        end
    end
end
figure (6)
image(ma3);
colormap bone;

end

