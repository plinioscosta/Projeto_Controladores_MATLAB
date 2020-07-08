%% Criar TXT LabView
function save_matrix(Sys,K,Kpi)
AA = Sys.a;
BB = Sys.b;
CC = Sys.c;
DD = Sys.d;

AAk = K.a;
BBk = K.b;
CCk = K.c;
DDk = K.d;

AApi = Kpi.a;
BBpi = Kpi.b;
CCpi = Kpi.c;
DDpi = Kpi.d;

fid = fopen('ABCD.txt', 'wt');
fprintf(fid, '0\n'); %Value 1 means Hinf to controller code
fprintf(fid, '\n');
fprintf(fid, '%1.3f\n',Sys.ts);
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

%% PI
fprintf(fid, '\n');
for aux1 = 1:size(AApi,1)
    for aux2 = 1:(size(AApi,2)-1)
        fprintf(fid, '%5.24f\t',AApi(aux1,aux2));
    end
    fprintf(fid, '%5.24f',AApi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BBpi,1)
    for aux2 = 1:(size(BBpi,2)-1)
        fprintf(fid, '%5.24f\t',BBpi(aux1,aux2));
    end
    fprintf(fid, '%5.24f',BBpi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CCpi,1)
    for aux2 = 1:(size(CCpi,2)-1)
        fprintf(fid, '%5.24f\t',CCpi(aux1,aux2));
    end
    fprintf(fid, '%5.24f',CCpi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DDpi,1)
    for aux2 = 1:(size(DDpi,2)-1)
        fprintf(fid, '%5.24f\t',DDpi(aux1,aux2));
    end
    fprintf(fid, '%5.24f',DDpi(aux1,aux2+1));
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
