
%%
%phoneme extraction colormap bone;
function phonemeextract(name,image)
image = int64(image);
CC =(bwconncomp(image));
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
    phoneme = zeros(ymax-ymin,xmax-xmin);
    
    for c = 1:size(positionarray,2)
        phoneme(positionarray(2,c),positionarray(1,c))=1;
    end
    formatSpec = '%s - phoneme %d.png';
    filename = sprintf(formatSpec,name,i);
    imwrite(phoneme,filename);
   
end
end