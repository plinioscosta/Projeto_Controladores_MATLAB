%% Criar TXT LabView
function salva_matrix(Sys,K,Kpi)
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
fprintf(fid, '%g\n',Sys.ts);
fprintf(fid, '\n');
%% Plant
for aux1 = 1:size(AA,1)
    for aux2 = 1:(size(AA,2)-1)
        fprintf(fid, '%g\t',AA(aux1,aux2));
    end
    fprintf(fid, '%g',AA(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BB,1)
    for aux2 = 1:(size(BB,2)-1)
        fprintf(fid, '%g\t',BB(aux1,aux2));
    end
    fprintf(fid, '%g',BB(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CC,1)
    for aux2 = 1:(size(CC,2)-1)
        fprintf(fid, '%g\t',CC(aux1,aux2));
    end
    fprintf(fid, '%g',CC(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DD,1)
    for aux2 = 1:(size(DD,2)-1)
        fprintf(fid, '%g\t',DD(aux1,aux2));
    end
    fprintf(fid, '%g',DD(aux1,aux2+1));
    fprintf(fid, '\n');
end

%% K robust
fprintf(fid, '\n');
for aux1 = 1:size(AAk,1)
    for aux2 = 1:(size(AAk,2)-1)
        fprintf(fid, '%g\t',AAk(aux1,aux2));
    end
    fprintf(fid, '%g',AAk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BBk,1)
    for aux2 = 1:(size(BBk,2)-1)
        fprintf(fid, '%g\t',BBk(aux1,aux2));
    end
    fprintf(fid, '%g',BBk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CCk,1)
    for aux2 = 1:(size(CCk,2)-1)
        fprintf(fid, '%g\t',CCk(aux1,aux2));
    end
    fprintf(fid, '%g',CCk(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DDk,1)
    for aux2 = 1:(size(DDk,2)-1)
        fprintf(fid, '%g\t',DDk(aux1,aux2));
    end
    fprintf(fid, '%g',DDk(aux1,aux2+1));
    fprintf(fid, '\n');
end
%% PI
fprintf(fid, '\n');
for aux1 = 1:size(AApi,1)
    for aux2 = 1:(size(AApi,2)-1)
        fprintf(fid, '%g\t',AApi(aux1,aux2));
    end
    fprintf(fid, '%g',AApi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(BBpi,1)
    for aux2 = 1:(size(BBpi,2)-1)
        fprintf(fid, '%g\t',BBpi(aux1,aux2));
    end
    fprintf(fid, '%g',BBpi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(CCpi,1)
    for aux2 = 1:(size(CCpi,2)-1)
        fprintf(fid, '%g\t',CCpi(aux1,aux2));
    end
    fprintf(fid, '%g',CCpi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fprintf(fid, '\n');
for aux1 = 1:size(DDpi,1)
    for aux2 = 1:(size(DDpi,2)-1)
        fprintf(fid, '%g\t',DDpi(aux1,aux2));
    end
    fprintf(fid, '%g',DDpi(aux1,aux2+1));
    fprintf(fid, '\n');
end

fclose(fid);
