clear all; clc; close all;

ts = 600;
Ts=0.1;

%% Valores dos par�metros do sistema fenomenológico contínuo
A1 = 254.469; A2 = 254.469; A3 = 254.469; A4 = 254.469;
a1 = 0.466; a2 = 0.466; %a3 = 0.466; a4 = 0.466; 
a3 = 0.3421; a4 = 0.3421; 
k1 = 10; k2 = 10;
gamma_1 = 0.75; gamma_2 = 0.74; 
g = 980;
h0_1 = 9.2; h0_2 = 6.2; h0_3 = 0.7; h0_4 = 0.7;
kc = 1;
%----------------------------------------------------------
T1 = (A1/a1)*sqrt(2*h0_1/g);
T2 = (A2/a2)*sqrt(2*h0_2/g);
T3 = (A3/a3)*sqrt(2*h0_3/g);
T4 = (A4/a4)*sqrt(2*h0_4/g);

Ac = [-1/T1     0     A3/(A1*T3)      0;
       0     -1/T2       0       A4/(A2*T4);
       0       0       -1/T3         0;
       0       0         0         -1/T4];
    
Bc = [  (gamma_1*k1)/A1              0;
             0             (gamma_2*k2)/A2;
             0           ((1-gamma_2)*k2)/A3;
     ((1-gamma_1)*k1)/A4            0];
   

Cc = [kc 0 0 0; 
     0 kc 0 0]; 
 
Dc = [0 0;
     0 0];

SYS_c = ss(Ac,Bc,Cc,Dc);
SYS_d = c2d(SYS_c,Ts); 

%plotar as barreiras
w=Barriers(); 
 
%% Projeto Controlador
% Pre compensator + Post compensator
bothComp = true;
% W1 compensator
Kp = 10;
Ki = 0.1;
s = tf('s');
W1 = 4*[(Kp +(Ki/s)) 0; 0 (Kp +(Ki/s))];
sys_W1_d = ss(c2d(W1,Ts),'minimal');

% W2 Compensator
if(bothComp)
    W2 = (10/(s+10))*eye(2);
    sys_W2_d = ss(c2d(W2,Ts),'minimal');
else
    W2 = ss(zeros(2),zeros(2),zeros(2),eye(2));
    sys_W2_d = ss(c2d(W2,Ts),'minimal');
end

SYS_d_amp = sys_W2_d*SYS_d*sys_W1_d;
Phi_amp = SYS_d_amp.a;
Gamma_amp = SYS_d_amp.b;
C_amp = SYS_d_amp.c;
D_amp = SYS_d_amp.d;

sig_end = sigma(w,SYS_d_amp);
p1 = semilogx(w,20*log10(sig_end(1,:)),'r'); 
hold on;
set(p1,'LineWidth',1.5);
p2 = semilogx(w,20*log10(sig_end(2,:)),'r');
set(p2,'LineWidth',1.5);
%% DAREs
if(bothComp)
   i=8; 
else
   i=6;
end

%Primeira DARE
[P,Kp,Lp] = dare(Phi_amp,Gamma_amp,C_amp.'*C_amp);

%Segunda DARE
[Q,Kq,Lq] = dare(Phi_amp.',C_amp.',Gamma_amp*Gamma_amp.');

%Terceira DARE
%Gamma0min
gamma = sqrt(1 + max(eig(Q*P))); 
% gamma = 10;
Xinf = (gamma*gamma*P)/(gamma*gamma*eye(i)-(eye(i) + Q*P)); 

%Controlador K
Z2 = chol(inv(eye(2) + C_amp*Q*C_amp.')).';

R = [ (-Z2^(-2) - gamma^2*eye(2))      zeros(2) ; 
                zeros(2)                eye(2) ];

H = -Phi_amp*Q*C_amp.'/(eye(2) + C_amp*Q*C_amp.');

F = -inv(R + [-Z2\H.'; Gamma_amp.']*Xinf*[-H/Z2 Gamma_amp])*([-Z2\C_amp; zeros(2,i)] + [-Z2\H.'; Gamma_amp.']*Xinf*Phi_amp);

F1 = F(1:2,1:i);
F2 = F(3:4,1:i);

Dk = (eye(2) + Gamma_amp.'*Xinf*Gamma_amp)\Gamma_amp.'*Xinf*H;
Bk = -H + Gamma_amp*Dk;
Ck = F2 - Dk*(C_amp + Z2\F1);
Ak = Phi_amp + H*C_amp + Gamma_amp*Ck;

K = [Ak Bk;
     Ck Dk];
 
SYS_k =  ss(Ak,Bk,Ck,Dk,Ts);

% sigma(SYS_k*SYS_d_amp);
sig_rec = sigma(w,sys_W1_d*SYS_k*sys_W2_d*SYS_d);
p3 = semilogx(w,20*log10(sig_rec(1,:)),'b');
set(p3,'LineWidth',1.5);
p4 = semilogx(w,20*log10(sig_rec(2,:)),'b');
set(p4,'LineWidth',1.5);
legend([p1 p4],{'Valores singulares de W_2.G.W_1','Valores singulares de K_s.W_2.G.W_1'})
set(gcf,'Position',[100 100 750 480])

% sysMF=feedback(SYS_d_amp*SYS_k,-1*eye(2));
% sysInv=ss(zeros(2),zeros(2),zeros(2),-1*eye(2),Ts);

% sysMF=feedback(SYS_d_amp*sysInv*SYS_k,-1*eye(2));
% sigma(sysMF);
%% txt com o controlador
Kf=minreal(ss(SYS_k,'minimal'),1e-4);
save_matrix(SYS_d, sys_W1_d, sys_W2_d,SYS_k);

%% Simulação
t_run = 700;
hinicial=[9 7 0 0];
sim('Sim_Hinf_pheno.slx')

figure(12);
subplot(2,1,1);
plot(t,h1,t,r1,'r');
axis([0 t(end) 4 14]);grid on; hold on;
title('Tanque 1');
ylabel('altura do líquido (cm)');
xlabel('Tempo (s)');
legend('Nível do tanque 1','Setpoint do tanque 1');

subplot(2,1,2);
plot(t,h2,t,r2,'r');
axis([0 t(end) 4 14]);grid on; hold on;
title('Tanque 2');
ylabel('altura do líquido (cm)');
xlabel('Tempo (s)');
legend('Nível do tanque 2','Setpoint do tanque 2');
set(gcf,'Position',[100 100 750 480])

figure(13);
plot(t,v1,t,v2,'r');
title('Esforço de controle');
ylabel('Tensão da Bomba (V)');
xlabel('Tempo (s)');
legend('Bomba 1','Bomba 2');
set(gcf,'Position',[100 100 750 480])