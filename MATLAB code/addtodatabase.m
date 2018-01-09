function addtodatabase(soundfile, latincolumn)
%This function calculates the mean frequency of a bird sound and adds it to
%the database of bird sounds. Additionally, the function calculates the
%mean frequency of all different recordings per bird species, together with
%the standard deviation.
%FUNCTION INPUTS: this function has as input the recording of the known
%bird as a WAVE file, and the column number (in the database) of the Latin
%name of the recorded bird species. NOTE: IF YOU ADD A NEW BIRD, YOU NEED TO MANUALLY
%INSERT THE LATIN NAME OF THE BIRD IN BOTH SHEETS OF THE EXCEL FILE



birds = xlsread('birddatabase.xlsx',1);
[~,txt,~] = xlsread('birddatabase.xlsx',1);
if isempty(birds) == 1
    birds = zeros(1,size(txt,2));
end
if size(txt,2)~= size(birds,2)
    newcolumn = zeros(size(birds,1),1);
    birds = [birds, newcolumn];
end
    
%First: perform fourier analysis and return 1 frequency value

[y,fs]=audioread(soundfile);
%sound(y,fs)
t=(0:(length(y)-1))/fs;

S=fft(y); %fast fourier transform
    Sabs = abs(S);
    halved=0.5*length(Sabs);
	f = (0:length(S)-1)*fs/length(S);
   
    %plotting used for checking our work
  %figure
  %plot(f(1:halved),Sabs(1:halved)) 
    %plot(f,Sabs)
	%title('magnitude spectrum of sig')
	%xlabel('frequency (Hz)')
    
%get rid of the periodicity. make a half of the data.
   Pyy = Sabs.*conj(Sabs)/length(Sabs); %normalise
   Pwant=Pyy(1:halved);
fp = fs/length(Sabs)*(1:halved); 
%figure
%plot(fp,Pwant) 
%title('Power spectral density')
%xlabel('Frequency (Hz)')

TPwant=transpose(Pwant); %want to make a matrix of the freqs& corresponding 
%powers to find what freq is to the max power.
A=[fp; TPwant];
maxP=max(TPwant);
[row,column] = find(A==maxP); %finding location of maxP
maxF=A(1,column); %putting same location in freq vector to find 
%corresponding frequency to the maxPower
cutoff=0.50*maxP; 
K=find(A(2,:)>cutoff); %removes all powers below 50% of the max power
B=A(2,K); %vector of powers larger than 0.5*maxpower
C=A(1,K);%vector of frequencies corresponding to wanted powers.
AvgF=mean(C); %%%%the average frequency of the bird!

%Add frequency to database
j = latincolumn;
for i = 1:size(birds,1)
    if birds(i,j) == 0
        birds(i,j) = AvgF;
        break
        if i == size(birds,1)
            newrow = zeros(1,size(txt,2));
            birds = [birds; newrow];
            break
        end   
    end
end

xlswrite('birddatabase.xlsx',birds,1,'A2')


%Calculate average frequency of all birds
birds(birds==0)=NaN;
totavgF = nanmean(birds,1);
xlswrite('birddatabase.xlsx',totavgF,2,'B2');

%Calculate standard deviation
stddev = std(birds,0,1,'omitnan');
xlswrite('birddatabase.xlsx',stddev,2,'B3');
end

