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
Po = 30 * 10^3;     % input parameter
f = 100 * 10^3;     % input parameter
Kt = 0.0014;        
% for cir. mils to mm^2 see below link
% conversion see http://www.convertunits.com/from/mm%5E2/to/circular+mil
% 1mm^2 ~1973.5 cir. mils
J = 2.5;            % current density A/mm^2
Dcma = 1973.5 / J; 
Bmax = 0.47 * 10^4; % P type core has the 0.47T max. flux density
WaAc = Po * Dcma / (Kt * Bmax * f)

%%%%%%
