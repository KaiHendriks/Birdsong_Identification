function medianfilter (matrixfile)

num = xlsread(matrixfile);
columns = length(num); 
rows = size(num,1);

meds = zeros (1,9);
ma1 = zeros (rows,columns);
for c = 1:columns
    for r = 1:rows
        for nr = -1 :1
            for nc = -1 :1
                    if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
                        meds(1,(nr+2)*(nc+2)) = num(r,c);
                    else
                    meds(1,(nr+2)*(nc+2)) = num(r+nr,c+nc); 
                    end
            end
        end
        a = median(meds);
        ma1(r,c) = a;
    end
    end
end