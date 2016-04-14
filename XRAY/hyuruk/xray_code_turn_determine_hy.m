% The calculation of primary and secondary turns
% and the wire size selection
% Np = Vp * 10^8 / (4 * B * Ac * f)
% Ns = (Vs / Vp ) * Np
% Ip = Pin / Vp_rms 
% Is = Po / Vs_rms
% where
% Np = number of turns on the primary
% Ns = number of turns on the secondary
% Ip = primary current
% Is = secondary current
% Ac = core area in cm^2
Vin = 417;               % input parameter
Vout = 12.5 * 10^3;      % input parameter
Vp_peak = Vin * 4 / pi();    % 1st harmonic peak value
Vs_peak = Vout * 4 / pi();    % 1st harmonic peak value
B = 0.2 * 10^4;             % operating B value
n_eff = 0.98;               % 98% efficiency assumed
Vp_rms = Vp_peak / sqrt(2);    % rms value
Vs_rms = Vs_peak / sqrt(2);   % rms value
Np = Vp_peak * 10^8 / (4*B*Ac*f); %[-]
Ns = (Vs_rms / Vp_rms) * Np;    % [-] this is theoritical 
H_field = B * 10^-4 / (mu_r*mu0);   % [A] H_field should be satisfied to get B 
Ns_desired = ((round(Np)*Ip)-H_field) / Is; %[-] to get desired H_field
H_field_result = (round(Np)*Ip) - (ceil(Ns_desired)*Is); %[A] with new Ns
B_result = H_field_result * (mu_r*mu0) / 10^-4; % [gauss] with new H
Ns = Ns_desired;
Pin = Po / n_eff;           
Ip = Pin / Vp_rms;
Is = Po / Vs_rms;

%%%%%%
