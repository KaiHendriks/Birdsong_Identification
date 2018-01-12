%% Check Spectrogram

function checkspectrogram(soundfile)

[y,fs]=audioread(soundfile);


sg = 400;
ov = 300;
hold on

figure
spectrogram(y,sg,ov,[],fs,'yaxis')
colormap bone