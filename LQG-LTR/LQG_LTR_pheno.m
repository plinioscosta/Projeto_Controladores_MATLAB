clear all; clc; close all;

ts = 600;
Tend = ts*2;
Ts=0.1;

%% Valores dos par�metros do sistema fenomenológico contínuo
A1 = 254.469; A2 = 254.469; A3 = 254.469; A4 = 254.469;
a1 = 0.466; a2 = 0.466; %a3 = 0.466; a4 = 0.466; 
a3 = 0.3421; a4 = 0.3421; 
k1 = 18; k2 = 18;
gamma_1 = 0.6; gamma_2 = 0.6; 
g = 980;
h0_1 = 7; h0_2 = 7; h0_3 = 0.5; h0_4 = 0.5;
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

%plotar as barreiras
w=Barriers();

%% Projeto Controlador
z = tf('z'); 
z.Ts = Ts;
SYS = ss(Ac,Bc,Cc,Dc);
SYSd = c2d(SYS,Ts);
Phi = SYSd.a; Gamma = SYSd.b; Cd = SYSd.c; Dd = SYSd.d;

% Integrador
Kp = 1;
Ki = 1;
s = tf('s');
W1 = [(Kp +(Ki/s)) 0; 0 (Kp +(Ki/s))];
sys_W1_d = ss(c2d(W1,Ts),'minimal');

% Planta ampliada
Phi_amp = [eye(2) zeros(2,4); Gamma Phi] ;
Gamma_amp = [[1 0; 0 1]; Gamma*[1 0; 0 1]];
C_amp = [zeros(2) Cd];
SYS_amp = ss(Phi_amp,Gamma_amp,C_amp,Dc,Ts);

%Casamento dos singulares
LL=-(Cc*Ac^-1*Bc)^-1;
LH=-Ac^-1*Bc*LL;
L=[LL; LH];
% W1 = -Ts*inv(C_amp*inv(Phi_amp - eye(6))*Gamma_amp);
% LL=-inv(Phi_amp -eye(6))*Gamma_amp*W1;
% LH=W1;
% L=[LL; LH];

% Filtro de Kalman
Lc = dlqe(Phi_amp, L, C_amp, 5e-1*eye(2), eye(2));
sys_KF = ss(Phi_amp,Phi_amp*Lc,C_amp,0); sys_KF.Ts = Ts;
sig_end = sigma(w,sys_KF);
p1 = semilogx(w,20*log10(sig_end(1,:)),'r'); 
hold on;
set(p1,'LineWidth',1.5);
p2 = semilogx(w,20*log10(sig_end(2,:)),'r');
set(p2,'LineWidth',1.5);

% Controle LQR
Ro = 1e-6;
R_cheap = Ro*eye(2);
Q_cheap = transpose(C_amp)*C_amp;
K = dlqr(Phi_amp,Gamma_amp,Q_cheap,R_cheap);

% Controle Final
Kc = z*tf(ss((eye(6)-Lc*C_amp)*(Phi_amp-Gamma_amp*K),Lc,K,0,Ts));
sys_G = ss(Phi_amp,Gamma_amp,C_amp,0); sys_G.Ts = Ts; 
sys_G_Kc = minreal(sys_G*Kc);
sig_rec = sigma(w,sys_G_Kc); hold on;
p1 = semilogx(w,20*log10(sig_rec(1,:)),'b');
set(p1,'LineWidth',1.5);
p2 = semilogx(w,20*log10(sig_rec(2,:)),'b');
set(p2,'LineWidth',1.5);


% Componentes de Kc:
% Polos de Kc (iguais em todos os elementos de Kc):
Kcp = Kc(1,1).den{1,1};
% Zeros de Kc:
% Input 1 to Output 1 e 2:
Kc11z = Kc(1,1).num{1,1};
Kc21z = Kc(2,1).num{1,1};
% Input 2 to Output 1 e 2:
Kc12z = Kc(1,2).num{1,1};
Kc22z = Kc(2,2).num{1,1};

%% txt com o controlador
Kf=minreal(ss(Kc,'minimal'),1e-4);
save_matrix(SYSd, Kf, sys_W1_d);
% salva_TF(Kc);

%% Simulação
t_run = 700;
hinicial=[9 7 0 0];
sim('Sim_LQG_LTR_pheno.slx')

figure(12);
subplot(2,1,1);
plot(t,h1,t,r1,'r');
axis([0 t(end) 5 15]);grid on; hold on;
title('Tanque 1');
ylabel('altura do líquido (cm)');
xlabel('Tempo (s)');

subplot(2,1,2);
plot(t,h2,t,r2,'r');
axis([0 t(end) 5 15]);grid on; hold on;
title('Tanque 2');
ylabel('altura do líquido (cm)');
xlabel('Tempo (s)');

figure(13);
plot(t,v1,t,v2,'r');
title('Esforço de controle');
ylabel('Tensão da Bomba (V)');
xlabel('Tempo (s)');
legend('Bomba 1','Bomba 2');
