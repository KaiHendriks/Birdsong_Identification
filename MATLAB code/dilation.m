function dilation (matrixfile)

num = xlsread(matrixfile);
columns = length(num); 
rows = size(num,1);

ma = zeros (rows,columns);
for c = 1:columns
    for r = 1:rows
        if num(r,c)== 1
            for nc = -1 :1
                for nr = -1 :1
                    if (r+nr < 1) || (c+nc < 1) || (r+nr > rows) || (c+nc > columns);
                    end
                    ma(r+nr,c+nc) = 1;
                end
            end
        end
    end
end

end
