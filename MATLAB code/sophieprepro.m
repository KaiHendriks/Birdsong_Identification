function sophieprepro(soundfile)
%preprocessing
[y,fs]=audioread('marshtit3.wav');
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

%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
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
            %clipped(i,j) = clipped(i,j);
        else clipped(i,j) = NaN;
%             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
%              clipped(i,j) = 0;
%             else clipped(i,j)=clipped(i,j);
        end
        
    end
end
figure(1)
imshow(clipped);
colormap bone;

%nanclipped=clipped;

%nanclipped(nanclipped==0)=NaN;
%mean(A,'omitnan')

% nanrowmean = mean( clipped,2, 'omitnan');
% nancolumnmean = mean( clipped,1, 'omitnan');
stdclipped = std(clipped(:),'omitnan');
% maxnanclipped=max(clipped(:),[],'omitnan');
maxclippedmat=max(clipped,[],'omitnan');
% medianmax=median(maxclippedmat,'omitnan');
avgmax=mean(maxclippedmat(:),'omitnan');
avgwhole=mean(clipped(:),'omitnan');
%% Mean Clipping

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > (avgmax-(1*stdclipped))
            %nanclipped(i,j) = 60;
        else clipped(i,j) = NaN;
%             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
%              clipped(i,j) = 0;
%             else clipped(i,j)=clipped(i,j);
        end
        
    end
end

figure(2)
imshow(clipped);
colormap bone;

%% ReNormalisation of matrix
normA = clipped - min(clipped(:)); %first, normalise spec
newnormA = normA ./ max(normA(:));
caxis([0 1]);
clipped=newnormA;
%% third time

% nanrowmean = mean( clipped,2, 'omitnan');
% nancolumnmean = mean( clipped,1, 'omitnan');
thirdstdclipped = std(clipped(:),'omitnan');
% maxnanclipped=max(clipped(:),[],'omitnan');
thirdmaxclippedmat=max(clipped,[],'omitnan');
thirdavgmax=mean(thirdmaxclippedmat(:),'omitnan');
thirdavgwhole=mean(clipped(:),'omitnan');

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > (thirdavgmax-(1*thirdstdclipped))
           % clipped(i,j) = 60;
        else clipped(i,j) = NaN;
%             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
%              clipped(i,j) = 0;
%             else clipped(i,j)=clipped(i,j);
        end
        
    end
end

figure(3)
imshow(clipped);
colormap bone;

 %% ReNormalisation of matrix
normA = clipped - min(clipped(:)); %first, normalise spec
newnormA = normA ./ max(normA(:));
caxis([0 1]);
clipped=newnormA;

%% fourth time

% nanrowmean = mean( clipped,2, 'omitnan');
% nancolumnmean = mean( clipped,1, 'omitnan');
frthstdclipped = std(clipped(:),'omitnan');
% maxnanclipped=max(clipped(:),[],'omitnan');
frthmaxclippedmat=max(clipped,[],'omitnan');
frthavgmax=mean(frthmaxclippedmat(:),'omitnan');
frthavgwhole=mean(clipped(:),'omitnan');

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) > (frthavgmax-(1*frthstdclipped))
           % clipped(i,j) = 1;
        else clipped(i,j) = NaN;
%             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
%              clipped(i,j) = 0;
%             else clipped(i,j)=clipped(i,j);
        end
        
    end
end

figure(4)
imshow(clipped);
colormap bone;

%% ReNormalisation of matrix
normA = clipped - min(clipped(:)); %first, normalise spec
newnormA = normA ./ max(normA(:));
caxis([0 1]);
clipped=newnormA;

%% figure 5 Minimum Filter
% % nanrowmean = mean( clipped,2, 'omitnan');
% % nancolumnmean = mean( clipped,1, 'omitnan');
% sixstdclipped = std(clipped(:),'omitnan');
% % maxnanclipped=max(clipped(:),[],'omitnan');
% sixmaxclippedmat=max(clipped,[],'omitnan');
% sixavgmax=mean(frthmaxclippedmat(:),'omitnan');
% sixavgwhole=mean(clipped(:),'omitnan');

%min stuff
sixstdclipped = std(clipped(:),'omitnan');
% maxnanclipped=max(clipped(:),[],'omitnan');
sixminclippedmat=min(clipped,[],'omitnan');
sixavgmin=mean(sixminclippedmat(:),'omitnan');
sixavgwhole=mean(clipped(:),'omitnan');
sixminwhole=min(clipped(:),[],'omitnan');

for i = 1:size(clipped,1)
    for j = 1:size(clipped,2)
        if clipped(i,j) < (sixminwhole+(0.5*sixstdclipped));
           clipped(i,j) = NaN;
        else %clipped(i,j) = NaN;
%             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
%              clipped(i,j) = 0;
%             else clipped(i,j)=clipped(i,j);
        end
        
    end
end

figure(5)
imshow(clipped);
colormap bone;

%% ReNormalisation of matrix
% normA = clipped - min(clipped(:)); %first, normalise spec
% fnewnormA = normA ./ max(normA(:));
% caxis([0 1]);
% triclipped=fnewnormA;

%% figure 6 time - binary
triclipped=clipped;
% nanrowmean = mean( clipped,2, 'omitnan');
% nancolumnmean = mean( clipped,1, 'omitnan');
fifstdclipped = std(triclipped(:),'omitnan');
% maxnanclipped=max(clipped(:),[],'omitnan');
fifmaxclippedmat=max(triclipped,[],'omitnan');
fifavgmax=mean(fifmaxclippedmat(:),'omitnan');
fifavgwhole=mean(triclipped(:),'omitnan');

for i = 1:size(triclipped,1)
    for j = 1:size(triclipped,2)
        if triclipped(i,j) > (fifavgmax-(3*fifstdclipped))
            triclipped(i,j) = 1;
       % elseif triclipped(i,j) > (frthavgmax-frthstdclipped);
            %triclipped(i,j) = 0.5;
        else triclipped(i,j) = NaN;
%             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
%              clipped(i,j) = 0;
%             else clipped(i,j)=clipped(i,j);
        end
        
    end
end

figure(6)
imshow(triclipped);
colormap bone;

%% Karls thing

% [y,fs] = audioread('XC395249 - Willow Tit - Poecile montanus.wav');
% sg=400;
% ov=300;
% 
% spectrogram(y,sg,ov,[],fs,'yaxis');
% colormap bone
% [s,f,t,p] = spectrogram(y,sg,ov,[],fs,'yaxis');
% hold on
% % f1 = f > 100;
% % t1 = t  0.75;
% 
% m1 = medfreq(p(f1,t1),f(f1));
% f2 = f > 2500;
% t2 = t > 3.5 & t < 7.0;
% 
% m2 = medfreq(p(f2,t2),f(f2));
% hold on
% plot(t(t1),m1/1000,'linewidth',4)
% plot(t(t2),m2/1000,'linewidth',4)
% hold off

%% Test

% newstdnanclipped = std(nanclipped(:),'omitnan');
% newmaxnanclipped=max(nanclipped(:),[],'omitnan');
% 
% for i = 1:size(nanclipped,1)
%     for j = 1:size(nanclipped,2)
%         if nanclipped(i,j) > (newmaxnanclipped-(3*newstdnanclipped))
%             nanclipped(i,j) = 60;
%         else nanclipped(i,j) = 0;
% %             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
% %              clipped(i,j) = 0;
% %             else clipped(i,j)=clipped(i,j);
%         end
%         
%     end
% end


% for i = 1:size(nanclipped,1)
%     for j = 1:size(nanclipped,2)
%         if nanclipped(i,j) > 1.2*nanrowmean(i,1) && nanclipped(i,j) > 1.2*nancolumnmean(1,j)
%             nanclipped(i,j) = 60;
%         else nanclipped(i,j) = 0;
% %             if clipped(i,j) > 1.3*rowmedian(i,1) && clipped(i,j) > 1.3*columnmedian(1,j)
% %              clipped(i,j) = 0;
% %             else clipped(i,j)=clipped(i,j);
%         end
%         
%     end
% end



% %% closing
% columns = length(clipped); 
% rows = size(clipped,1);
% 
% ma1 = zeros (rows,columns);
% for c = 1:columns
%     for r = 1:rows
%         if clipped(r,c)== 60
%             for nc = -1 :1
%                 for nr = -1 :1
%                     if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
%                     else
%                     ma1(r+nr,c+nc) = 60;
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% 
% ma2 = ones (rows,columns);
% for c = 1:columns
%     for r = 1:rows
%         if ma1(r,c)== 0
%             for nc = -1 :1
%                 for nr = -1 :1
%                     if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
%                     else
%                     ma2(r+nr,c+nc) = 0;
%                     end
%                 end
%             end
%         else
%             ma2(r,c) = 60;
%         end
%     end
% end
% 
% %% dilation
% ma3 = zeros (rows,columns);
% for c = 1:columns
%     for r = 1:rows
%         if ma2(r,c) == 60
%             for mc = -1 :1
%                 for mr = -1 :1
%                     if (r+mr < 1) || (c+mc < 1) || (r+mr > rows) || (c+mc > columns);
%                     else
%                     ma3(r+mr,c+mc) = 60;
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% %% Median filter
% 
% meds = zeros (1,9);
% ma4 = zeros (rows,columns);
% for c = 1:columns
%     for r = 1:rows
%         for nr = -1 :1
%             for nc = -1 :1
%                     if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
%                         meds(1,(nr+2)*(nc+2)) = ma3(r,c);
%                     else
%                     meds(1,(nr+2)*(nc+2)) = ma3(r+nr,c+nc); 
%                     end
%             end
%         end
%         a = median(meds);
%         ma4(r,c) = a;
%     end
% end
% figure (2)
% image(ma3);
% colormap bone;
% 
% %% remove noises
% K = mat2gray(ma3);
% min_image = min(K(:));
% 
% max_image = 1;
% 
% imwrite(K,'phoneme.png')
% BW = imread( 'phoneme.png');
% 
% BW2 = bwareaopen(BW,100);
% figure
% imshow(BW2);
% colormap bone;
% end
