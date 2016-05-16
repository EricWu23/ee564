%% EE564 - Design of Electrical Machines
%% Project-2: Traction Motor Design
%% Name: Mesut U�ur
%% ID: 1626753

%%
% Specifications
%%
% Traction asynchronous squirrel cage induction motor
%%
% Rated Power Output: 1280 kW
%%
% Line-to-line voltage: 1350 V
%%
% Number of poles: 6
%%
% Rated Speed: 1520 rpm (72 km/h) (driven with 78 Hz inverter)
%%
% Rated Motor Torque: 7843 Nm
%%
% Cooling: Forced Air Cooling
%%
% Insulating Class: 200
%%
% Train Wheel Diameter: 1210 mm
%%
% Maximum Speed: 140 km/h
%%
% Gear Ratio: 4.821
%%
% Duty: ?
%%
% Enclosure: ?
%%
% Efficiency: IE3, premium efficiency: 96 %
%%
% Efficiency: IE4, super premium efficiency: 97 %
%%
% Power factor: ?
%%
% IP54??
%%
% Class 200
%%
% N
%%
% Average winding temp rise: 130 degree C
%%
% Hot spot temp rise: 160 degree C
%%
% Maximum winding temp: 200 degree C


%%
% Design Inputs
Prated = 1280e3; % watts
pole = 6;
pole_pair = pole/2;
phase = 3;
Vrated = 1350; % volts line-to-line
Nrated = 1520; % rpm
frated = 78; % Hz
vrated = 72; % km/h
vmax = 140; % km/h
Trated = 7843; % Nm
wheel_dia = 1.21; % m
gear_ratio = 4.821;
power_factor = 0.86; % assumed (not a given data)
efficiency = 0.965; % assumed (not a given data)


%%
% Main dimensions: length, diameter, electrical and magnetic loading
Vphase = Vrated/sqrt(3); % volts
Nsync = 120*frated/pole; % rpm
wrated = Nrated*2*pi/60; % rad/sec
torque = Prated/wrated; % Nm
% Cmech is between 310 and 250 from graph
% choose Cmech = 300
Cmech = 300; % kWs/m^3
fsync = 2*frated/pole; % Hz
d2l = Prated*1e-3/(Cmech*fsync); % m^3
aspect_ratio = (pi/pole)*(pole_pair)^(1/3);
inner_diameter = (d2l/aspect_ratio)^(1/3); % m
length = inner_diameter*aspect_ratio; % m
inner_radius = inner_diameter/2; % m
Ftan = torque/inner_radius; % N
surface_area = pi*inner_diameter*length; % m^2
sheer_stress = 1e-3*Ftan/surface_area; % kPa
outer_diameter = 1.87*inner_diameter; % for 6 pole
% %60 increase for heavy duty
air_gap_distance = 1.6*(0.18+0.006*Prated^0.4); % mm
circumference = pi*inner_diameter; % m

magnetic_loading = 0.9; % T
electric_loading = sheer_stress/magnetic_loading; % kA/m

% Electrical loading is checked from Table 6.2 of book
% Tangential stress is checked from Table 6.3 of book


%%
% Choose:
inner_diameter = 0.6; % m
outer_diameter = 1.12; % m
length = 0.45; % m
air_gap_distance = 3; % mm
surface_area = pi*inner_diameter*length; % m^2
inner_volume = inner_diameter^2*length*pi/4; % m^3
circumference = pi*inner_diameter; % m


%%
% Check
Ftan = torque/inner_radius; % N
tan_stress = Ftan/surface_area; % p
Cmech = Prated*1e-3/(inner_diameter^2*length*fsync); % kWs/m^3
electric_loading = tan_stress/magnetic_loading*1e-3; % kA/m


%%
% Slot number selection:
% slot_pitchs are 7-45 mm for asynchronous m/cs
maximum_slot = circumference/0.007;
minimum_slot = circumference/0.045;

integer_multiple = phase*pole;
for k = 1:10
    Qs = integer_multiple*k;
    qs = Qs/(pole*phase);
    if Qs<maximum_slot && Qs>minimum_slot 
        fprintf('%d number of stator slots is available, qs = %d\n',Qs,qs);
    end
end

% Select Qs = 90 for the first iteration
Qs = 90;
qs = Qs/(pole*phase);
stator_slot_pitch = circumference/Qs; % m

% stator will be double layer for harmonic elimination
stator_layer = 2;
% Select pitch factor as 4/5pi electrical for 5th harmonic elimination
pitch_angle = 4*pi/5; % radians electrical
slot_angle = pi/qs/phase; % radians electrical


%%
% Stator winding factor (fundamental)
[kd,kp,kw] = winding_factor_calc(slot_angle,qs,pitch_angle);
kd1 = kd(1);
kp1 = kp(1);
kw1 = kw(1);


%%
% selected flux densities (book, page: 283)
Bgap = 0.9; % T
Bsyoke = 1.6; % T
Bstooth = 1.9; % T
Bryoke = 1.6; % T
Brtooth = 2.0; % T


%%
% stator slot current
Iu = stator_slot_pitch*electric_loading*1000; % amps
% number of turns per phase
Erms = Vphase; % volts
flux_per_pole = 4*inner_radius*length*Bgap/pole; % weber
Nph = Erms/(4.44*frated*flux_per_pole*kw1);

% number of turns/soil side
for k = 1:5
    zQ = k;
    pos_Nph = qs*pole*stator_layer*zQ/2;
    fprintf('Possible Nph = %d, zQ = %d\n',pos_Nph,k);
end

% Among the alternatives, the closest turn number is 30 with zQ = 1
% if 30 turns per phase is used, either of l,r or Bgap should be increased
% if 60 turns per phase is used, either of l,r or Bgap should be decreased
% in the first design, Nph = 30 is selected

Nph = 30;
% stator number of turns/coil side
zQ = 2*Nph/(qs*pole*stator_layer); % turns

flux_per_pole = Erms/(4.44*frated*Nph*kw1); % weber
Bgap = flux_per_pole*pole/(4*inner_radius*length); % Tesla

% The resultant Bgap is a little bit higher (0.9143 Tesla).
% To decrease it, radius or length should be increased.
selected_Bgap = 0.9; % Tesla

rl_multip_old = inner_radius*length; % m^2
rl_multip = Erms*pole/(4.44*Nph*frated*kw1*4*selected_Bgap); % m^2

new_length = 0.46; % m
new_Bgap = Erms*pole/(4.44*Nph*frated*kw1*4*new_length*inner_radius); % Tesla
new_surface_area = pi*inner_diameter*new_length; % m^2
new_inner_volume = inner_diameter^2*new_length*pi/4; % m^3
new_tan_stress = Ftan/new_surface_area; % p
new_Cmech = Prated*1e-3/(inner_diameter^2*new_length*fsync); % kWs/m^3
new_magnetic_loading = new_Bgap; % Tesla
new_electric_loading = new_tan_stress/new_magnetic_loading*1e-3; % kA/m

Bgap = new_Bgap; % Tesl
flux_per_pole = Bgap*4*inner_radius*new_length/pole;


%%
% Rotor slot number

Qr = (6*qs+4)*pole_pair; % eqn 7.115 of the book
avoid_rotor_slot(Qr,Qs,pole_pair);
for k = 1:10
    Qr = k*pole*phase;
    a = avoid_rotor_slot(Qr,Qs,pole_pair);
    if a == 1
        fprintf('%d rotor slot number is usable\n',Qr);
    end
end

% In the book, 96,90,84 and 54 are suggested with one stator slot skew
% Table 7.5
Qr = 72;
qr = Qr/(pole*phase);
% harmful synchronous torque at steady state


%%
% Stator winding selection
fmax = vmax/vrated*frated; % Hz
% Normally, since the motor is to be driven by an inverter, the switching
% frequency and corresponding harmonics should be taken into account for
% skin effect. In this 1st iteration, only fundamental frequency will be
% considered.
Pin = Prated/efficiency; % watts
Irated = Pin/(sqrt(3)*Vrated*power_factor); % amps
% from awg wire table: AWG gauge starting from 000 is suitable considering
% the frequency constraint (skin effect)
% Select AWG wire gauge 000 which has a current rating of 239 amps
wire_current = 239; % amps
wire_diameter = 10.404; % mm
stator_strand = ceil(Irated/wire_current);
% three strands are required
wire_area = (wire_diameter/2)^2*pi; % mm^2
stator_current_density = Irated/wire_area; % A/mm^2
% for a 6-pole machine, J = 7.76 is in the acceptable limits

% With this current density, forced air cooling will be sufficienct


%%
% Stator slot sizing
stator_fill_factor = 0.44; % selected from the design example notes
useful_slot_area = wire_area*stator_strand*zQ*stator_layer; % mm^2
%stator_slot_area = useful_slot_area/stator_fill_factor; % mm^2
stator_stacking_factor = 0.96; % design example
Kfe = stator_stacking_factor;
Tus = stator_slot_pitch*1e3; % mm 
bts = (Bgap*Tus)/(Bstooth*Kfe); % mm

% Select the other parameters:
bos = 4; % mm
hos = 2; % mm
hw = 3; % mm

bs1 = pi*(inner_diameter*1e3+2*hos+2*hw)/Qs-bts; % mm
bs2 = sqrt(4*useful_slot_area*tan(pi/Qs)+bs1^2); % mm
hs = 2*useful_slot_area/(bs1+bs2); % mm
hcs = (1e3*outer_diameter-(1e3*inner_diameter+2*(hos+hw+hs)))/2; % mm

Bcs = flux_per_pole/(2*new_length*hcs*1e-3); % T
% The resultant yoke flux density is too low. Decrease outer diameter and
% so that decrease hcs:
Bcs_new = 1.45; % Tesla
hcs_new = flux_per_pole/(2*length*Bcs_new)*1e3; % mm
outer_diameter_new = (2*hcs_new+(1e3*inner_diameter+2*(hos+hw+hs)))*1e-3; % m

Tas = 200*atan(2*(hw-hos)/(bs1-bos))/pi; % grad


%%
% Rotor slot sizing
rotor_slot_pitch = pi*(1e3*inner_diameter-2*air_gap_distance)/Qr; % mm
Tur = rotor_slot_pitch; % mm

KI = 0.8*power_factor+0.2;
rotor_bar_current = KI*2*phase*Nph*kw1*Irated/Qr; % amps
Ib = rotor_bar_current; % amps
Jrotor = 6; % A/mm^2
Aru = Ib/Jrotor; % mm^2
Ier = Ib/(2*sin(2*pi/Qr)); % A
Jer = 0.78*Jrotor; % A/mm^2
Aer = Ier/Jer; % mm^2

btr = Bgap*Tur/(Kfe*Brtooth); % mm

% Select the other parameters:
hor = 2; % mm
bor = 4; % mm

d1 = (pi*(1e3*inner_diameter-2*air_gap_distance-2*hor)-Qr*btr)/(pi+Qr); % mm
d2 = 3; % mm
hr = (d1-d2)/(2*tan(pi/Qr)); % mm
rotor_slot_area = (pi/8)*(d1^2+d2^2)+(d1+d2)*hr/2; % mm^2
Ab = rotor_slot_area; % mm^2

hcr = 1e3*flux_per_pole/(2*length*Bryoke); % mm

Dshaftmax = inner_diameter*1e3-2*air_gap_distance-2*(hor+hr+hcr+(d1+d2)/2); % mm


%%
% Equivalent core length with cooling ducts
nv = 10; % number of cooling ducts
bv = 5; % length of cooling duct, mm
g = air_gap_distance; % mm
k = (bv/g)/(5+bv/g);
bve = k*bv; % mm
eqv_length = length-1e-3*nv*bve+1e-3*2*g; % m


%%
% Carter's factor
b1 = bs1; % mm
k = (b1/g)/(5+b1/g);
be = k*b1; % mm
kcs = Tus/(Tus-be);

k = (d1/g)/(5+d1/g);
be = k*d1; % mm
kcr = Tur/(Tur-be);

geff = g*kcs*kcr; % mm


%%
% Peak MMF
F = (phase/2)*(4/pi)*(Nph*Irated*sqrt(2)/pole)*kw1; % amps
u0 = 4*pi*1e-7;
Bgapp = F*u0/(geff*1e-3);
% ?????????


%%
% Magnetizing inductance
Lm = (phase/2)*inner_diameter*u0*eqv_length*(kw1*Nph)^2/(pole_pair^2*geff*1e-3); % Henries
Xm = 2*pi*frated*Lm; % Ohms
Imag = Vphase/Xm; % amps


%%
% Stator Leakage inductance
P1 = u0*eqv_length*((hos/bos)+(hs/(3*bs2))); % permeance
Lph = P1*4*(Nph*kw1)^2*phase/Qs; % Henries
Xph = 2*pi*frated*Lph; % ohms


%%
% Rotor Leakage inductance
Pr = 0.66 + 2*hr/(3*(d1+d2)) + hor/bor; % permeance
Pdr = 0.9*Tur/(kcs*g)*1e-2; % permeance
Kx = 1; % skin effect coefficient
P2 = u0*eqv_length*(Kx*Pr+Pdr); % permeance
Lrp = P2*4*(Nph*kw1)^2*phase/Qr; % Henries
Xrp = 2*pi*frated*Lrp; % ohms


%%
% Stator winding resistance
pole_pitch = phase*stator_slot_pitch*qs; % m
pitch_factor = pitch_angle/pi;
y = pitch_factor*pole_pitch; % m
lend = pi*y/2+0.018; % m
le = 2*(length+lend); % m
% Use copper resistivity at 80 0C
rho_20 = 1.78*1e-8; % ohm*m
rho_80 = rho_20*(1+1/273*(80-20)); % ohm*m
Rsdc = rho_80*le*Nph/(1e-6*wire_area*stator_strand); % ohms
Rsac = Rsdc; % ohms
% There is no skin effect
Rph = Rsac; % ohms


%%
% Rotor bar resistance
rho_al = 3.1*1e-8; % ohm*m
rho_al_80 = rho_al*(1+1/273*(80-20)); % ohm*m
Kr = 1.74;

Dre = inner_radius-1e-3*g; % m
b = hr+hor+(d1+d2)/2; % mm
ler = 1e-3*pi*(Dre+b)/Qr; % m

Rbe = rho_al_80*((length*Kr/(Ab*1e-6))+(ler/(2*Aer*1e-6*(sin(3*pi/Qr))^2))); %ohms
R2p = Rbe*4*phase/Qr*(Nph*kw1)^2; % ohms


%%
% Base values
Vbase = Vrated; % volts
Sbase = Prated/power_factor; % VA
Zbase = Vrated^2/Sbase; % ohms


%%
% pu values
Xm_pu = 100*Xm/Zbase; % percent
Xph_pu = 100*Xph/Zbase; % percent
Xrp_pu = 100*Xrp/Zbase; % percent
Rph_pu = 100*Rph/Zbase; % percent
R2p_pu = 100*R2p/Zbase; % percent


%%
% Copper Losses
Pcus = 3*Irated^2*Rph; % watts
Pcur = 3*Irated^2*R2p; % watts
Pcu = Pcus + Pcur; % watts


%%
% Copper mass
copper_area = (1e-6*wire_area*stator_strand); % m^2
copper_length = phase*le*Nph; % m
copper_volume = copper_area*copper_length; % m^3
copper_density = 8.96; % gr/cm^3
copper_density = copper_density*1e3; % kg/m^3
copper_mass = copper_density*copper_volume; % kg


%%
% Aluminium mass
aluminium_area1 = (1e-6*Ab); % m^2
aluminium_area2 = (1e-6*Aer); % m^2
aluminium_length1 = Qr*length; % m
aluminium_length2 = Qr*ler; % m
aluminium_volume = aluminium_area1*aluminium_length1 + aluminium_area2*aluminium_length2; % m^3
aluminium_density = 2.70; % gr/cm^3
aluminium_density = aluminium_density*1e3; % kg/m^3
aluminium_mass = aluminium_density*aluminium_volume; % kg


%% Core losses
% stator teeth weight
density_iron = 7800; % kg/m^3
Gsteeth = density_iron*Qs*bts*1e-3*(hs+hw+hos)*1e-3*length*Kfe; % kg
% stator fundamental teeth core loss
Kt = 1.7;
p10 = 2;
Pc_stator_teeth1 = Kt*p10*(frated/50)^1.3*Bstooth^1.7*Gsteeth; % watts
% stator back iron weight
Gsyoke = density_iron*pi/4*(outer_diameter_new^2-(outer_diameter_new-2*hcs*1e-3)^2)*length*Kfe; % kg
% stator fundamental back iron core loss
Ky = 1.6;
Pc_stator_yoke1 = Ky*p10*(frated/50)^1.3*Bsyoke^1.7*Gsyoke; % watts
% stator total core loss (fundamental)
Pcs1 = Pc_stator_teeth1+Pc_stator_yoke1; % watts

% rotor teeth weight
Grteeth = density_iron*Qr*btr*1e-3*(hr+(d1+d2)/2)*1e-3*length*Kfe; % kg
% stray losses
Kps = 1/(2.2-Bstooth);
Kpr = 1/(2.2-Brtooth);
Bps = (kcs-1)*Bgap; % Tesla
Bpr = (kcr-1)*Bgap; % Tesla
Piron_s = 0.5*1e-4*(Gsteeth*(Qr*frated/pole_pair*Kps*Bps)^2 + Grteeth*(Qs*frated/pole_pair*Kpr*Bpr)^2); % watts

%Pc = Pcs1 + Piron_s; % watts
Pc = Pcs1; % watts


%% Other losses
Pfw = 0.008*Prated; % watts


%% Efficiency
Ptotal = Pcu + Pc + Pfw; % watts
efficiency = Prated/(Ptotal+Prated);


%%
% ??????????
Tar = 200*atan(2*(hw-hos)/(bs1-bos))/pi; % grad

