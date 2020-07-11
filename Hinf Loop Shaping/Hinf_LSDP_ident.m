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

SYS_c = ss(Ac,Bc,Cc,Dc);
SYS_d = c2d(SYS_c,Ts); 
%% Valores dos par�metros do sistema identificado discreto
%Ensaio de 8h, per�odo 6min e amplitude 0.5
Ai = [-0.0334957    -0.745077       0        0;
      0.745077     -0.0334957      0        0;
         0              0      0.998593     0;
         0              0          0     0.999334];
    
Bi = [  0.0638893         0.0367221;
      -0.0109006         0.0556748;
      -0.000417213      -0.0000154718;
      -0.000180197      -0.000299378];
   

Ci = [-0.328419  -0.444393     1.53754   -17.7295; 
     -1.28311    1.32663     -12.9599   -8.5944]; 
 
Di = [0 0;
     0 0];

%Ensaio de 2h, per�odo 2min e amplitude 0.5
% Ai = [-0.635042      0          0        0;
%        0         0.175049      0        0;
%        0            0      0.998634     0;
%        0            0          0     0.999309];
%     
% Bi = [ -0.00748007         0.0825176;
%        0.0488471          0.0136645;
%        0.000501004       -0.0000581847;
%       -0.000288367       -0.000459953];
%    
% 
% Ci = [-0.312637  -0.274487    -0.753989   -11.7856; 
%       1.0403    -3.03498      8.33751    -8.11532]; 
%  
% Di = [0 0;
%      0 0];

% Ai = [0.996064     0          0            0;
%        0       0.993979      0            0;
%        0          0       0.748874        0;
%        0          0          0        0.773849];
%     
% Bi = [  0.0108245           -0.00278004;
%       -0.0212829           -0.0119419;
%        0.0407889           -0.00672807;
%        0.0244862           -0.034738];
%    
% 
% Ci = [-4.10149   -3.78303   -1.65082   2.54713; 
%      -0.224847  -2.26579   -1.45963   0.206304]; 
%  
% Di = [0 0;
%      0 0];
 
SYS_d_i = ss(Ai,Bi,Ci,Di,Ts); 
%plotar as barreiras
w=Barriers(); 
 
%% Projeto Controlador
% Pre compensator + Post compensator
bothComp = true;
% W1 compansator
Kp = 1;
Ki = 1;
s = tf('s');
W1 = 0.1*[(Kp +(Ki/s)) 0; 0 (Kp +(Ki/s))];
sys_W1_d = ss(c2d(W1,Ts),'minimal');

% % Compensador W2
if(bothComp)
    W2 = (10/(s+10))*eye(2);
    sys_W2_d = ss(c2d(W2,Ts),'minimal');
else
    W2 = ss(zeros(2),zeros(2),zeros(2),eye(2));
end

SYS_d_amp = sys_W1_d*SYS_d_i*sys_W2_d;
Phi_amp = SYS_d_amp.a;
Gamma_amp = SYS_d_amp.b;
C_amp = SYS_d_amp.c;
D_amp = SYS_d_amp.d;

sigma(w,SYS_d_amp);

%% Equações de Riccati
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
gamma = 10;
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

sigma(SYS_k*SYS_d_amp);

%% txt com o controlador
Kf=minreal(ss(SYS_k,'minimal'),1e-4);
save_matrix(SYS_d, sys_W1_d, sys_W2_d, SYS_k);

%% Simulação
t_run = 200;
hinicial=[9 7 0 0];
sim('Sim_Hinf_ident.slx')

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

