% In this code, it is supposed to design a high-frequency, 
% high-voltage transformer that will be used in a X-Ray device.
%-----------------------------------------------------------------------  
% Huseyin YURUK
%----------------------------------------
% Following design guide is used:
% Magnetics Ferrite Power Design 2013
%----------------------------------------
% Core Selection by WaAc product
% The power handling capacity of a transformer core can also be determined 
% by its
% WaAc product, where Wa is the available core window area, and Ac is 
% the effective
% core cross-sectional area. 
% Area Product Distribution (WaAc)
% WaAc = (Po * Dcma) / (Kt * Bmax * f)
% where
% WaAc = Product of window area and core area (cm4)
% Po = Power Out (watts)
% Dcma = Current Density (cir. mils/amp)
% Bmax = Flux Density (gauss)
% � = frequency (hertz)
% Kt = Topology constant  (Full-bridge = 0.0014)
Po = 30 * 10^3;     % input parameter [W]
f = 100 * 10^3;     % input parameter [Hz]
Kt = 0.0014;        
% for cir. mils to mm^2 see below link
% conversion see http://www.convertunits.com/from/mm%5E2/to/circular+mil
% 1mm^2 ~1973.5 cir. mils
J = 2.5;            % current density [A/mm^2]
Dcma = 1973.5 / J;  % [cir. mils/A] 
Bmax = 0.47 * 10^4; % P type core has the 0.47T max. flux density
WaAc = Po * Dcma / (Kt * Bmax * f);     %[cm^4]

% core properties 49925UC
% selected core dimensions [mm]
% A_dim = 101.6;      
% B_dim = 57.1;
% C_dim = 25.4;
% D_dim = 31.7;
% E_dim = 50.8;
% radius_acoil = C_dim/2 + D_dim/2;   % [mm]
% Vol_core  = ((A_dim*2*B_dim*C_dim) - (2*D_dim*E_dim*C_dim)) * 10^-3;    %[cm^3]
% Ac = 645 * 10^-2;           % [cm^2] Ae effective are for the choosen ferrite
% Wa = 2 * D_dim*E_dim * 10^-2; % available core window area [cm^2]
% core_mass = 2*988*10^-3;    %[kg]
% le_dim = 2*245;             %[mm] effective length core
% Al = 6200;                  %[nH/1T^2]
% mu_r = 5000;                %[-]
% graph_core_loss_100deg = 350;   %[mW/cm^3]
% graph_core_loss_40deg = graph_core_loss_100deg * 2; %[mW/cm^3]
% price_core = 2*17.38;         % [$]


% core properties 48020EC
% selected core dimensions [mm]
A_dim = 80.0;      
B_dim = 38.1;
C_dim = 19.8;
D_dim = 28.2;
E_dim = 59.1;
F_dim = 19.8;
M_dim = 19.65;
radius_acoil = F_dim/2 + M_dim/2;   % [mm]
Vol_core  = ((A_dim*2*B_dim*C_dim) - (2*2*D_dim*M_dim*C_dim)) * 10^-3;    %[cm^3]
Ac = 645 * 10^-2;           % [cm^2] Ae effective are for the choosen ferrite
Wa = 2 * 2* D_dim*E_dim * 10^-2; % available core window area [cm^2]
core_mass = 2*357*10^-3;    %[kg]
le_dim = 2*184;             %[mm] effective length core
Al = 5080;                  %[nH/1T^2]
mu_r = 5000;                %[-]
mu0 = 4 * pi() * 10^-7;     %[-]
graph_core_loss_100deg = 350;   %[mW/cm^3]
graph_core_loss_40deg = graph_core_loss_100deg * 2; %[mW/cm^3]
price_core = 2*3.25;         % [$]


%%%%%%
