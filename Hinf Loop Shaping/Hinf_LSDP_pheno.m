clear all; clc; close all;

ts = 600;
Tend = ts*2;
Ts_fen=0.1;
Ts=1;

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
SYS_d = c2d(SYS_c,Ts_fen); 
%% Valores dos par�metros do sistema identificado discreto
Ai = [0.996064     0          0            0;
       0       0.993979      0            0;
       0          0       0.748874        0;
       0          0          0        0.773849];
    
Bi = [  0.0108245           -0.00278004;
      -0.0212829           -0.0119419;
       0.0407889           -0.00672807;
       0.0244862           -0.034738];
   

Ci = [-4.10149   -3.78303   -1.65082   2.54713; 
     -0.224847  -2.26579   -1.45963   0.206304]; 
 
Di = [0 0;
     0 0];
%plotar as barreiras
w=Barriers(); 
 
%% Projeto Controlador
% Compensador W1
% Kp = 15;
% Ki = 0.5;
Kp = 5;
Ki = 0.1;
s = tf('s');
W1 = 10*[(Kp +(Ki/s)) 0; 0 (Kp +(Ki/s))];
sys_W1_d = ss(c2d(W1,Ts_fen),'minimal');

% Compensador W2
W2 = (100/(s+30))*eye(2);
sys_W2_d = ss(c2d(W2,Ts_fen),'minimal');


SYS_d_amp = sys_W1_d*SYS_d;
Phi_amp = SYS_d_amp.a;
Gamma_amp = SYS_d_amp.b;
C_amp = SYS_d_amp.c;
D_amp = SYS_d_amp.d;

% Pgain=1;
% Igain=1;
% Phi_amp = [Igain*eye(2) zeros(2,4); SYS_d.b SYS_d.a];
% Gamma_amp = [[Pgain 0; 0 Pgain]; SYS_d.b*[1 0; 0 1]];
% C_amp = [zeros(2) SYS_d.c];
% SYS_amp = ss(Phi_amp,Gamma_amp,C_amp,Dc,Ts_fen);

sigma(w,SYS_d_amp);

%% Equações de Riccati

% A^TXA - E^TXE - (A^TXB + S)(B^TXB + R)^-1 (A^TXB + S)^T + Q = 0
%[X,K,L] = idare(A,B,Q,R,S,E)

%Primeira DARE
[P,Kp,Lp] = dare(Phi_amp,Gamma_amp,C_amp.'*C_amp);

%Segunda DARE
[Q,Kq,Lq] = dare(Phi_amp.',C_amp.',Gamma_amp*Gamma_amp.');

%Terceira DARE
gamma = 1000;
Xinf = (gamma*gamma*P)/(gamma*gamma*eye(6)-(eye(6) + Q*P)); 


%Controlador K
Z2 = chol(inv(eye(2) + C_amp*Q*C_amp.')).';

R = [ (-Z2^(-2) - gamma^2*eye(2))      zeros(2) ; 
                zeros(2)                eye(2) ];

H = -Phi_amp*Q*C_amp.'/(eye(2) + C_amp*Q*C_amp.');

F = -inv(R + [-Z2\H.'; Gamma_amp.']*Xinf*[-H/Z2 Gamma_amp])*([-Z2\C_amp; zeros(2,6)] + [-Z2\H.'; Gamma_amp.']*Xinf*Phi_amp);
F1 = [F(1,1) F(1,2) F(1,3) F(1,4) F(1,5) F(1,6);F(2,1) F(2,2) F(2,3) F(2,4) F(2,5) F(2,6)];
F2 = [F(3,1) F(3,2) F(3,3) F(3,4) F(3,5) F(3,6);F(4,1) F(4,2) F(4,3) F(4,4) F(4,5) F(4,6)];

Dk = (eye(2) + Gamma_amp.'*Xinf*Gamma_amp)\Gamma_amp.'*Xinf*H;
Bk = -H + Gamma_amp*Dk;
Ck = F2 - Dk*(C_amp + Z2\F1);
Ak = Phi_amp + H*C_amp + Gamma_amp*Ck;

K = [Ak Bk;
     Ck Dk];
 
SYS_k =  ss(Ak,Bk,Ck,Dk,Ts_fen);

sigma(SYS_k*SYS_d_amp);
 
%% Simulação 
 
t_run = 800;
hinicial=[7 7 0 0];