function  IDbird(soundfile)

[y,fs]=audioread(soundfile);
%sound(y,fs)
t=(0:(length(y)-1))/fs;
plot(t,y)

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
    
%get rid of the periodicity. take the 1st half of the data.
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
AvgF=mean(C) %%%%the average frequency of the king fisher!!!!

figure
plot(C,B) %plotting used to check work

%now the actual comparison
%runs the average frequency through the database. 
%It sees if the frequency is within the range of the first standard dev
%of the database's average. If so, returns 'compatible' and the 
%column number of the compatible species.


database = 'birddatabase.xlsx';
[num,text,~] = xlsread(database,2);

%made sheet 2 of the excel database into a numerical matrix. 
%loop checks to see which column is compatible.


for j = 1:size(num,2)
    if and(AvgF<(num(1,j)+num(2,j)), AvgF>(num(1,j)-num(2,j)))
   % if and(num(i,j)>Minus, num(i,j)<Plus)
        
        %display(j)
        display('Compatible Match')
        display(text(1,(j+1)));
        
        
    else 
        %display('Incompatible')
        
end
        
end
end