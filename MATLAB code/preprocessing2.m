function preprocessing2(soundfile)

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
end