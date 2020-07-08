function [G] = Modelo(k,gamma)
%% Descrição do Sistema

% Variáveis de Estado : altura da coluna d`água nos tanques (0-30 cm)
% Entrada do sistema : voltagem nas válvulas (0-10 V)

d_maior =  [18 18 18 18]; % (sequencia 1, 2, 3, 4) em cm
d_menor = [0.77 0.77 0.66 0.66]; % (sequencia 1, 2, 3, 4) em cm

% Seção transversal dos tanques (cm)
area_maior=pi*(d_maior.^2)/4;

%Seção transversal dos buracos entre tanques (cm^2)
area_menor = pi*(d_menor.^2)/4;


%Aceleração da gravidade
g = 981; %cm/s^2

%Definição de kc
kc=1;

%% Ponto de Operação
%ponto de operação desejado em cm
hi1=15; hi2=15;

%variaveis nao controladas
hinicial=[hi1 hi2 0 0];

%determinar v
As=[gamma(1)*k(1)/area_maior(1) (1-gamma(2))*k(2)/area_maior(1); (1-gamma(1))*k(1)/area_maior(2) gamma(2)*k(2)/area_maior(2)];
Bs=[area_menor(1)/area_maior(1)*sqrt(2*g*hinicial(1)); area_menor(2)/area_maior(2)*sqrt(2*g*hinicial(2))];
vinicial=linsolve(As,Bs);

%determinar h
hinicial(3)=((1-gamma(2))*k(2))^2/(area_menor(3)^2*2*g)*vinicial(2);
hinicial(4)=((1-gamma(1))*k(1))^2/(area_menor(4)^2*2*g)*vinicial(1);
%% Modelo do sistema
%Constantes de tempo do sistema linearizado
T = (area_maior./area_menor) .*sqrt(2*hinicial/g);

% Matriz de estados
A = [-1/T(1) 0 area_maior(3)/(area_maior(1)*T(3)) 0 ; 0 -1/T(2) 0 area_maior(4)/(area_maior(2)*T(4)); 0 0 -1/T(3) 0; 0 0 0 -1/T(4)];

% Matriz de entrada
B = [gamma(1)*k(1)/area_maior(1) 0; 0 gamma(2)*k(2)/area_maior(2); 0 (1-gamma(2))*k(2)/area_maior(3); (1-gamma(1))*k(1)/area_maior(4) 0 ];

% Matriz de saída
C = [kc 0 0 0; 0 kc 0 0];

% Matriz de transferência direta
D = zeros(2);

G = ss(A,B, C, D);
