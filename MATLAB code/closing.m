function closing (matrixfile)

num = xlsread(matrixfile);
columns = length(num); 
rows = size(num,1);

ma1 = zeros (rows,columns);
for c = 1:columns
    for r = 1:rows
        if num(r,c)== 1
            for nc = -1 :1
                for nr = -1 :1
                    if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
                    else
                    ma1(r+nr,c+nc) = 1;
                    end
                end
            end
        end
    end
end
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
        end
    end
end
end
