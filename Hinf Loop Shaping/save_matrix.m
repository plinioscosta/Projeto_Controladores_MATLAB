%% Criar TXT LabView
function save_matrix(Sys,Kw1,Kw2,K)
AA = Sys.a;
BB = Sys.b;
CC = Sys.c;
DD = Sys.d;

AAk = K.a;
BBk = K.b;
CCk = K.c;
DDk = K.d;

AAw1 = Kw1.a;
BBw1 = Kw1.b;
CCw1 = Kw1.c;
DDw1 = Kw1.d;

AAw2 = Kw2.a;
BBw2 = Kw2.b;
CCw2 = Kw2.c;
DDw2 = Kw2.d;

fid = fopen('ABCD.txt', 'wt');
fprintf(fid, '1\n'); %Value 1 means Hinf to controller code
fprintf(fid, '\n');
fprintf(fid, '%5.24f\n',Sys.ts);
fprintf(fid, '\n');
%% Plant
for aux1 = 1:size(AA,1)
    for aux2 = 1:(size(AA,2)-1)
        fprintf(fid, '%5.24f\t',AA(aux1,aux2));
    end
    fprintf(fid, '%5.24f',AA(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BB,1)
    for aux2 = 1:(size(BB,2)-1)
        fprintf(fid, '%5.24f\t',BB(aux1,aux2));
    end
    fprintf(fid, '%5.24f',BB(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CC,1)
    for aux2 = 1:(size(CC,2)-1)
        fprintf(fid, '%5.24f\t',CC(aux1,aux2));
    end
    fprintf(fid, '%5.24f',CC(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DD,1)
    for aux2 = 1:(size(DD,2)-1)
        fprintf(fid, '%5.24f\t',DD(aux1,aux2));
    end
    fprintf(fid, '%5.24f',DD(aux1,aux2+1));
    fprintf(fid, '\n');
end

%% W1
fprintf(fid, '\n');
for aux1 = 1:size(AAw1,1)
    for aux2 = 1:(size(AAw1,2)-1)
        fprintf(fid, '%5.24f\t',AAw1(aux1,aux2));
    end
    fprintf(fid, '%5.24f',AAw1(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BBw1,1)
    for aux2 = 1:(size(BBw1,2)-1)
        fprintf(fid, '%5.24f\t',BBw1(aux1,aux2));
    end
    fprintf(fid, '%5.24f',BBw1(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CCw1,1)
    for aux2 = 1:(size(CCw1,2)-1)
        fprintf(fid, '%5.24f\t',CCw1(aux1,aux2));
    end
    fprintf(fid, '%5.24f',CCw1(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DDw1,1)
    for aux2 = 1:(size(DDw1,2)-1)
        fprintf(fid, '%5.24f\t',DDw1(aux1,aux2));
    end
    fprintf(fid, '%5.24f',DDw1(aux1,aux2+1));
    fprintf(fid, '\n');
end

%% W2
fprintf(fid, '\n');
for aux1 = 1:size(AAw2,1)
    for aux2 = 1:(size(AAw2,2)-1)
        fprintf(fid, '%5.24f\t',AAw2(aux1,aux2));
    end
    fprintf(fid, '%5.24f',AAw2(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BBw2,1)
    for aux2 = 1:(size(BBw2,2)-1)
        fprintf(fid, '%5.24f\t',BBw2(aux1,aux2));
    end
    fprintf(fid, '%5.24f',BBw2(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CCw2,1)
    for aux2 = 1:(size(CCw2,2)-1)
        fprintf(fid, '%5.24f\t',CCw2(aux1,aux2));
    end
    fprintf(fid, '%5.24f',CCw2(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DDw2,1)
    for aux2 = 1:(size(DDw2,2)-1)
        fprintf(fid, '%5.24f\t',DDw2(aux1,aux2));
    end
    fprintf(fid, '%5.24f',DDw2(aux1,aux2+1));
    fprintf(fid, '\n');
end

%% K robust
fprintf(fid, '\n');
for aux1 = 1:size(AAk,1)
    for aux2 = 1:(size(AAk,2)-1)
        fprintf(fid, '%5.24f\t',AAk(aux1,aux2));
    end
    fprintf(fid, '%5.24f',AAk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BBk,1)
    for aux2 = 1:(size(BBk,2)-1)
        fprintf(fid, '%5.24f\t',BBk(aux1,aux2));
    end
    fprintf(fid, '%5.24f',BBk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CCk,1)
    for aux2 = 1:(size(CCk,2)-1)
        fprintf(fid, '%5.24f\t',CCk(aux1,aux2));
    end
    fprintf(fid, '%5.24f',CCk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DDk,1)
    for aux2 = 1:(size(DDk,2)-1)
        fprintf(fid, '%5.24f\t',DDk(aux1,aux2));
    end
    fprintf(fid, '%5.24f',DDk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fclose(fid);
