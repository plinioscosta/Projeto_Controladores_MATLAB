function [w]=Barreiras()
%% Modelo Nominal
% Determinar k
k=[18 18];

% Determinar gamma
gamma=[0.55 0.54];

% Determinar w
w=[logspace(-2,-1,50) logspace(-1,0,50) logspace(0,1,50) logspace(1,2,50)];

Gn = Modelo (k, gamma);
%% Singulares

sv=sigma(Gn,w);
sig1=sv(1,:); 
sig2=sv(2,:); 

%% Erro de Modelagem
% k1 e k2 variam em 20%
% gamma1 e gamma2 variam 7%
pc_k=0.2; pc_g=0.07;
k1(1)=(1-pc_k)*k(1); k2(1)=(1-pc_k)*k(2); g1(1)=(1-pc_g)*gamma(1); g2(1)=(1-pc_g)*gamma(2);
k1(2)=(1+pc_k)*k(1); k2(2)=(1+pc_k)*k(2); g1(2)=(1+pc_g)*gamma(1); g2(2)=(1+pc_g)*gamma(2);

% matriz de singulares para determinar o erro
sigr1=zeros(16,length(w));
sigr2=zeros(16,length(w));

aux=0;
 for a=1:2
     for b=1:2
         for c=1:2
             for d=1:2
                 % variavel auxiliar para a matriz de singulares
                 aux=aux+1;
                 % Contruir vetores de k e gamma, determinar os singulares
                 kr=[k1(a) k2(b)]; gammar=[g1(c) g2(d)];
                 Gr=Modelo(kr, gammar);
                 sr=sigma(Gr,w);
                 sigr1(aux,:)=sr(1,:); 
                 sigr2(aux,:)=sr(2,:); 
             end
         end
     end
 end

 % determinar o erro de modelagem
 erro1=zeros(1,length(w));
 erro2=zeros(1,length(w));
 
 for i=1:length(w)
     e1=0;
     e2=0;
     for f=1:16
         if(e1< abs((sigr1(f,i)-sig1(i))./sig1(i)))
             e1=abs((sigr1(f,i)-sig1(i))./sig1(i));
         end
         if(e2< abs((sigr2(f,i)-sig2(i))./sig2(i)))
             e2=abs((sigr2(f,i)-sig2(i))./sig2(i));
         end
     end
     erro1(i)=e1;
     erro2(i)=e2;
 end
 erro=max(erro1,erro2);
 
%% Barreiras de Robustez
% porcentagem para as barreiras
delta_r = 0.2;    wr = 0.05;
delta_m = 0.15;    wm = 50;
delta_p = 0.2;     wp = 0.1;

% definindo o tamanho dos vetores
bar_r=zeros(1,length(w));
bar_m=zeros(1,length(w));
bar_p=zeros(1,length(w));

% barreiras com o erro de modelagem
R=delta_r*(1-erro);
P=delta_p*(1-erro);
M=delta_m./(1+erro);

% construindo as barreiras
i=1;
while w(i)<wr
    bar_r(i)=20*log10(abs(1./R(i)));
    i=i+1;
end

i=1;
while w(i)<wp
    bar_p(i)=20*log10(abs(1./P(i)));
    i=i+1;
end


for i=1:length(w)
    if w(i)>wm
    bar_m(i)=20*log10(abs(M(i)));
    end
end

semilogx(w,20*log10(abs(1./erro)),'--');
hold on
semilogx(w,bar_r,':',w,bar_p,':',w,bar_m,':');
