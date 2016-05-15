% Based on the The Induction Machine Handbook Chapter 14 & 15
% rotor slot sizing will be determined
Nr = 60; % [-] rotor slot number
         % http://keysan.me/presentations/ee564_basic_machine_design2.html#32
         % 17/23 slayt table 7.5 most advantageous slot numbers for rotors
         % with slots skewed for a stator slot pitch 1-2
Ki = 0.8*pwr_factor+0.2; % [-] (eq. 15.35)
Ib = Ki*(2*m*N_per_ph_req*Kw1/Nr)*Iph_rated_rms; 
                         % [A] rated rotor bar current (eq. 15.34)
Jb = 3.42; % [A/mm] current density in the rotor bar
Ab = Ib/(Jb*10^6);       % [m^2]rotor slot area (eq. 15.36)
Ier = Ib/(2*sin(pi*p1/Nr)); % [A] end ring current (eq. 15.37)
Jer = 0.75*Jb*10^6;  % [A/m^2] current density in the end ring 
Aer = Ier / Jer;     % [m^2] end ring cross section (eq. 15.38) 
hor = 1*10^-3;       % [m] refer to figure 15.7
hwr = 4*10^-3;       % [m] refer to figure 15.5
bor = 2.5*10^-3;     % [m] refer to figure 15.7
rot_slot_pitch = pi*(Dis-2*g*10^-3)/Nr; % [m] rotor slot pitch (eq. 15.39)
Btr = 1.675;           % [Tesla] rotor tooth flux density
btr = Bg_req*rot_slot_pitch/(Kfe*Btr); % [m] rotor tooth width (eq. 15.40)
% Let me calculate rotor slot dimensions like stator slot
br1 = pi*(Dis-2*hor-2*hwr)/Nr - btr; % [m] changed from (eq. 15.23)
br2 = sqrt(4*Ab*tan(pi/Nr)+br1^2);   % [m] changed from (eq. 15.27)    
hr = 2*Ab/(br1+br2);                 % [m] changed from (eq. 15.24) 
Htr = 4200;                          % [A/m] from table 15.4 interpolation
Fmtr_res = Htr*(hr+hor+hwr); % [Aturns] rotor teeth mmf changed from(eq. 15.30)
Bcr = 1.65;                  % [Tesla] rotor back core flux density
hcr = flux_airgap/(2*L*Bcr); % [m] rotor back core height (eq. 15.46)
Dshaft_max = Dis-2*g*10^-3-2*(hor+hwr+hr+hcr); 
                             % [m] max. shaft diameter (eq. 15.47)                             
b = 1.0*(hr+hor+hwr);        % [m] end rind cross section b (eq. 15.50)
a = Aer/b;                   % [m] end rind cross section a (eq. 15.51)
 