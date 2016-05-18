%% EM564 SECOND PROJECT:TRAIN MOTOR DESIGN
%% ID
%%
% *NAME :* Seda K�L
%  
% *E-mail :* sedakul@gazi.edu.tr

%% Specification and Design Parameter
%
% This project is relevant to design is a traction asynchronous squirrel cage induction motor with the following specifications:
%
% *Rated Power Output: 1280 kW
%
% *Line-to-line voltage: 1350 V
%
% *Number of poles: 6
%
% *Rated Speed: 1520 rpm (72 km/h) (driven with 78 Hz inverter)
%
% *Rated Motor Torque: 7843 Nm
%
% *Cooling: Forced Air Cooling
%
% *Insulating Class: 200
%
% *Train Wheel Diameter: 1210 mm
%
% *Maximum Speed: 140 km/h
%
% *Gear Ratio: 4.821
%
% The main idea of design motor is to obtain the dimensions of all parts of
% the motor in order to supply these data to the manufacturer. The outcome
% of the project are like this:
%
% *Material Properties, Frame size etc.
%
% *Magnetic Circuit Details (flux density calculations at various points: air-gap, teeth, back-core etc, magnetic loading)
%
% *Electric Circuit (Winding selection, electric loading, fill factor, phase resistance, winding factors (for fundamentalsn and for harmonics))
%
% *Rough thermal calculations (cooling method, operating temperature, ways to improve cooling)
%
% *Efficiency, current, torque characteristics
%
% *Mass Calculations (structural mass, copper mass, steel mass etc)
%
P=1280000;
V=1350;
Vph=V/sqrt(3);
 pole=6;
 pole_p=pole/2;
 m=3; % phase number
 q=4;
 Nr=1520;
 f=78;
 Nsyn=f/(pole/2); % synchronous rotor speed in hertz
 Tr=7843;
 Ns=120*f/(pole);
s=(Ns-Nr)/Ns;
power_factor=0.85;
efficiency=0.91; 
%%
% Since January 1, 2015: The legally specified minimum efficiency IE3 must be maintained for power ratings from 7.5 kW to 375 kW or an IE2 motor plus frequency inverter. 


eff = imread('efficiency_table.png');
figure;
imshow(eff);
title('Efficiency Table','FontSize',18,'FontWeight','Bold');


%% Main Dimension of Stator Core

cmec = imread('Cmech.png');
figure;
imshow(cmec);
title('Motor constant:Cmec','FontSize',18,'FontWeight','Bold');

Cmec=280; 
x=(pi*(pole_p^(1/3)))/pole;
Din=((P/1000)/(Cmec*Nsyn*x))^(1/3); %m
L=x*Din;  %m

ratio = imread('Do-Di value.png');
figure;
imshow(ratio);
title('Inner and outer diameter proportion','FontSize',14,'FontWeight','Bold');

Dout=Din/0.7;
Qs=q*m*pole;

Ftan=Tr/(Din/2);
surface_area=pi*Din*L; %m^2
sheer_stress=Ftan*10^-3/surface_area; %kPa
magnetic_loading=0.85; %Magnetic loading
electric_loading=(sheer_stress/magnetic_loading);

airgap=(0.18+0.006*P^(0.4));

%% Stator Winding

slot_number = imread('stator and rotor slot number.png');
figure;
imshow(slot_number);
title('Commen stator rotor slot combination ','FontSize',18,'FontWeight','Bold');

Qs=q*m*pole;

electrical_angle=(2*pi*pole_p)/Qs;
format rat
electrical_angle_rad=electrical_angle/pi;
format short

%%
%
% Total winding factor (kw) consist of distribution factor (kd) and pitch
% factor (kp). To eliminate 5.harmonik chording factor is selected 5/6
% under pitch
chording_factor=5/6;
Kd=sin(pi/(2*m))/(q*sin(pi/(2*m*q)));
Kp=sin((pi/2)*chording_factor);   
Kw=Kd*Kp;

pole_pitch=pi*Din/pole; %m
slot_pitch=pole_pitch/(3*q);

mag_flux= imread('magnetic_flux_value.png');
figure;
imshow(mag_flux);
title('Magnetic flux value for the different part of the motor ','FontSize',14,'FontWeight','Bold');

Bg=0.7;  % for p=6 Bg=0.7-0.82

Le=L+(2*airgap)/1000;
area_of_one_pole=pi*Din*Le/pole;  %m^2

%%
% Induction motors, both the stator and rotor teeth are saturated at the peak value of the flux density.
% This leads to a higher reluctance of these teeth when compared with other teeth, and thus
% ai takes notably higher values than the value corresponding to a sinusoidal distribution. The
% factor ai (2/pi)has to be iterated gradually to the correct value during the design process. The value
% ai = 0.64 of an unsaturated machine can be employed as an initial value, unless it is known
% at the very beginning of the design process that the aim is to design a strongly saturating machine,
% in which case a higher initial value can be selected.
%
% After calculate magnetic flux using the below equation we can find turn number
%
% E=4.44*f*N*kw*magnetic_flux

fundamental_magnetic_flux=(2/pi)*pole_pitch*Bg*L; %Wb
flux=pole_pitch*Le*Bg;
alfa_u=pole*pi/Qs;

format rat
alfa_u_rad=alfa_u/pi;
format short

Kf=1.085;
Ke=0.97;
N=(Ke*Vph)/(4*Kf*Kw*f*fundamental_magnetic_flux);


a1=1;  %number of current path in parallel
conductor_per_slot=a1*N/(pole_p*q);
number_of_conductor_per_slot=fix(conductor_per_slot); %(ns)
if mod(number_of_conductor_per_slot,2)==0
    number_of_conductor_per_slot_n=number_of_conductor_per_slot;
else
        number_of_conductor_per_slot_n=number_of_conductor_per_slot-1;
end

N_new=number_of_conductor_per_slot*Qs/pole;

%%
% Number of conductors per slot should be an even number as there are two distinct coils per slot in a double layer winding,
% Due to changing number of turns per phase we have to recalculate the actual airgap flux density Bg.
Bg_new=Bg*N/N_new

Irated=P/(efficiency*power_factor*V*sqrt(3));

%%
% J=5-8 A/mm^2 for 2p=6,8

J=6.5;

Ac=Irated/J; 
d_copper=sqrt(4*Ac/pi);

% because of the skin effect we use paralel conductors. 
parallel_branch=12;

d_copper_new=sqrt(4*Ac/(pi*parallel_branch)); 

awg_area=[107,85,67.4,53.5 42.4,33.6,26.7,21.2,16.8,13.3,10.6,8.37,6.63,5.26,4.17,3.31,2.63,2.08,1.65,1.31,1.04,0.82,0.653,0.518];%tablo
prop=(awg_area*parallel_branch/Ac);
[M,I]=min(prop(prop>1));
awg_size=[11.684,10.405,9.266,8.251,7.348,6.544,5.827,5.189,4.621,4.115,3.665,3.264,2.906,2.588,2.305,2.053,1.828,1.628,1.450,1.291,1.150,1.024,0.912,0.812,0.723,0.644,0.573,0.511]
wire_cross_section=awg_area(I);
d_co_new=awg_size(I);

%%
% Skin Effect
mu=4*pi*10^-7;
cop_mu=1.256629*10^-6;
cop_res=1.68*10^-8; % resistivity of the copper for 20C
w=2*pi*f/pole_p;
skin_dept=sqrt((2*cop_res)/(cop_mu*w))*1000; %mm

%%
% Skin depth is bigger than the wire size and frequency is not very high so we can ignore the skin effect.

%% Stator Slot Sizing

stator_slot= imread('stator_slot_geometry.png');
figure;
imshow(stator_slot);
title('Stator slot geometry','FontSize',18,'FontWeight','Bold');

%%
% Above 10kW Kfill=0.4-0.44
Kfill=0.44;  
slot_area=pi*d_co_new^2*parallel_branch*number_of_conductor_per_slot_n/(4*Kfill); %mm^2

Bts=1.65;
Kfe=0.96; % stator stacking factor
bts=Bg_new*slot_pitch/(Bts*Kfe);   %tooth width
bos=0.0025;  
hos=0.001; 
hw=0.002;  

bs1=(pi*(Din+2*hos+2*hw)/Qs)-bts;  %slot lower width m
bs2 = sqrt(4*slot_area*10^-6*tan(pi/Qs)+(bs1^2));
hs=2*slot_area*10^-6/(bs2+bs1); %m

MMF_airgap=(1.2*airgap*10^-3)*Bg_new/mu;  %airgap mmf

%%
% From the B-H curve table H values are selected 

B_H= imread('magnetization_curve.png');
figure;
imshow(B_H);
title('B-H Magnetization curve','FontSize',18,'FontWeight','Bold');

Hts=3460;  %Bts=1.6T ya kar��l�k olarak tablodan se�ilmi�tir
MMF_stator_tooth=Hts*(hs+hos+hw);
Kst=0.4;
Fmtr=Kst*MMF_airgap-MMF_stator_tooth;  % E�er Fmtr<<Fmts (yada negatif) olsayd� 1+Kst nin Bg de�erinden k���k olmas� gerekiyor.
bcs=(Dout-(Din+2*(hos+hw+hs)))/2; %stator back iron height
Bcs=fundamental_magnetic_flux/(2*L*bcs);  % back core flux density

%%
% Evidently Bcs is too low. There are three main ways to solve this problem.
% One is to simply decrease the stator outer diameter until Bcs=1.4 to 1.7 T. The second solution consists in going back to the design start and
% introducing a minor stack aspect ratio which eventually would result in a bigger Dis, and, finally, a narrower back iron height bcs and thus a bigger Bcs. 
% The third solution is to decrease current density and thus increase slot height hs.
% However, if high efficiency is the target, such a solution is to be used cautiously.

Dout_n=0.818;
bcs_n=(Dout_n-(Din+2*(hos+hw+hs)))/2;
Bcs_n=Bcs*bcs_n/(bcs_n+(Dout_n-Dout)/2);  

%% Rotor Slot

rotor_slot= imread('rotor_slot_geometry.png');
figure;
imshow(rotor_slot);
title('Rotor slot geometry','FontSize',18,'FontWeight','Bold');

% From the common combination Qr =88 is selected
Qr=56;
hor=0.0005; %m
bor=0.0015;  %m

%%
% Ki= 1, the rotor and stator mmf would have equal magnitudes. In reality, the stator mmf is slightly larger.
Ki=0.8*power_factor+0.2;
I_rotor_bar=(Ki*2*m*N_new*Kw/Qr)*Irated;
J_r = 5; % A/mm^2;  %rotor current density
Ar=I_rotor_bar/(J_r*10^6);   %10^-6 m^2

rotor_slot_area =I_rotor_bar/J_r; % mm^2
I_end_ring=I_rotor_bar/(2*sin(pole_p*pi/Qr));

%%
% The current density in the end ring Jer = (0.75 � 0.8)Jb. The higher values correspond to end rings attached to the rotor stack as part of the heat is
% transferred directly to rotor core.

J_er = 0.78*J_r; % A/mm^2 end ring
A_end_ring = I_end_ring/(J_er*10^6); % mm^2
T_rotor_slot = pi*(Din-2*airgap*1e-3)/Qr; % m
B_rotor_tooth = 1.6; 
H_tr=2460;
btr = Bg_new*T_rotor_slot/(Kfe*B_rotor_tooth); % m

D_r=Din-2*airgap*10^-3;  %rotor diameter

hw_r=0.003;  
br1=(pi*(Din+2*hor+2*hw_r)/Qr)-btr;  %slot lower width m
br2 = sqrt(4*rotor_slot_area*10^-6*tan(pi/Qr)+br1^2);
hr=2*rotor_slot_area*10^-6/(br2+br1); %m

rotor_slot_area = ((pi/8)*(br1^2+br2^2))+((br1+br2)*hr/2); % m^2
Bcr = 1.65; % T
hcr = fundamental_magnetic_flux/(2*L*Bcr); % m
MMF_rotor_teeth=H_tr*(hr+hor+(br1+br2)/2);  %Aturns

Dshaftmax = Din-(2*airgap*(10^-3))-2*(hor+hr+hcr+(br1+br2)/2); % mm

Tar = 200*atan(2*(hw-hos)/(bs1-bos))/pi; % grad

%%
% The shaft diameter corresponds to the rated torque and is given in tables
% based on mechanical design and past experience. The rated torque is
% approximately

Ten=(P)/(2*pi*(f/pole_p)*(1-s));%rated torque Nm

Der=D_r-3.5*10^-3;
b=1.0*(hr+hor+(br1+br2)/2);
a=A_end_ring/b;

%% Magnetization Current

Y1=bos*bos/(5*airgap*10^-3+bos); 
Y2=bor*bor/(5*airgap*10^-3+bor); 
Kc1=slot_pitch/(slot_pitch-Y1);
Kc2=T_rotor_slot/(T_rotor_slot-Y2);
Kc=Kc1*Kc2; %Total Carter coefficient

%%
% Kc is close to 1.2 which is assumed initially when calculating Fmg.
% Back core mmfs Fmcs and Fmcr are calculated as follows:
%
% Stator back core flux intensity in A/m Bcs=1.43 from the table � choose for the Bcs=1.45 
Hcs=1050; 
Hcr=3460; %Rotor back core flux intensity in A/m
Fmcs=0.88*exp(-0.4*Bcs^2)*(pi*(Dout-bcs)/(2*pole_p))*Hcs; %Stator back core mmf in Aturns
Fmcr=0.88*exp(-0.4*Bcr^2)*(pi*(Dshaftmax+hcr)/(2*pole_p))*Hcr; %Rotor back core mmf in Aturns


MMF_magnetization=2*(Kc*airgap*10^-3*Bg_new/mu+MMF_stator_tooth+MMF_rotor_teeth+Fmcs+Fmcr); %Magnetization mmf in Aturns
Ks=MMF_magnetization/(2*MMF_airgap)-1; %Total saturation factor

%%
% The total saturation factor Ks takes like this
Ks = 0.97;

Imu=(pi*pole_p*MMF_magnetization/2)/(3*sqrt(2)*N_new*Kw); %Magnetization current in A
i_mu=Imu/Irated; %Relative (p.u.) value of Iu

%%  Resistances and Inductances

y=chording_factor*pole_pitch;    %Coil span in m
L_end=pi/2*y+0.018; %End connection length for 2*pole_p=6
L_coil=2*(L+L_end); %Coil length in m
resis_cu=1.78e-8; %Copper resistivity at 20 degrees 
resis_cu_80=resis_cu*(1+1/273*(80-20)); %Copper resistivity at 80 degrees 
Rs=resis_cu_80*L_coil*N_new/(Ac*1e-6*a1);

L_er=pi*(Der-b)/Qr; %End ring segment length in m
Beta_s=sqrt(2*pi*f*mu/(2*resis_cu));
S=1;
eta=Beta_s*hr*sqrt(S);
%%
% Kr the skin effect resistance coefficient for the bar is approximately:
Kr=eta*(sinh(2*eta)+sin(2*eta))/(cosh(2*eta)-cos(2*eta)); 
R_be = resis_cu_80*(L/slot_area*Kr+L_er/(2*A_end_ring*(sin(pi*pole_p/Qr))^2)); %Rotor bar/end ring segment equivalent resistance in Ohm
Rrc=(4*m/Qr)*(N_new*Kw)^2*R_be; %Rotor cage resistance reduced to the stator in Ohm

lambda_s=(2/3*hs/(bs1+bs2)+2*hw/(bos+bs1)+hos/bos)*(1+3*chording_factor)/4; %Stator slot connection coefficient
Cs=1-0.033*bos*bos/(airgap*10^-3*slot_pitch);
phi=pi*(6*chording_factor-5.5);
gamma_ds=(0.14*sin(phi)+0.76)*1e-2;  % for q=4
lambda_ds=0.9*slot_pitch*q^2*Kw^2*Cs*gamma_ds/(Kc*airgap*10^-3*(1.0+Kst)); %Stator differential connection coefficient
lambda_ec=0.34*q/L*(L_end-0.64*chording_factor*pole_pitch); %Stator end connection specific geometric permeance coefficient
Xsl=2*mu*2*pi*f*L*N_new^2/(pole_p*q)*(lambda_s+lambda_ds+lambda_ec); %Stator phase reactance in Ohm

lambda_r=0.66+2*hr/(3*(br1+br2))+hor/bor; %Rotor slot connection coefficient
gamma_dr=9*((6*pole_p/Qr)^2)*1e-2;
lambda_dr=(0.9*T_rotor_slot*10^3*gamma_dr/(Kc*airgap*10^-3))*10^-2*(Qr/(6*pole_p))^2; %Rotor differential connection coefficient
lambda_er=2.3*(Der-b)/(Qr*L*4*(sin(pi*pole_p/Qr))^2)*log10(4.7*(Der-b)/(b+2*a));  %Stator end ring permeance coefficient
Kx=3/(2*eta)*(sinh(2*eta)-sin(2*eta))/(cosh(2*eta)-cos(2*eta)); %Skin effect coefficient for the leakage reactance
X_be=2*pi*f*mu*L*(lambda_r*Kx+lambda_dr+lambda_er); %Equivalent rotor bar leakage reactance in Ohm
Xrl=(4*m*(N_new*Kw)^2/Qr)*X_be; %Rotor leakage reactance in ohm

%%
% For zero speed (S = 1), both stator and rotor leakage reactances are reduced due to leakage flux path saturation. For the power levels of interest here, with semiclosed stator and rotor slots:

Xsl_sat=Xsl*0.75; %Stator leakage reactance at S=1 due to leakage flux path saturation 
Xrl_sat=Xrl*0.65; %Rotor leakage reactance at S=1 due to leakage flux path saturation 

%%
% For rated slip (speed), both skin and leakage saturation effects have to be eliminated (KR = Kx = 1)

Rbe_Sn=resis_cu_80*(L/Ar+L_er/(2*A_end_ring*(sin(pi*pole_p/Qr))^2)); %Rotor bar/end ring segment equivalent resistance at rated speed
Rrc_Sn=Rrc*Rbe_Sn/R_be; %Rotor cage resistance reduced to the stator at rated speed 
Xbe_Sn=2*pi*f*mu*L*(lambda_r+lambda_dr+lambda_er); %Equivalent rotor bar leakage reactance at rated speed 
Xrl_Sn=Xrl*Xbe_Sn/X_be; %Rotor leakage reactance at rated speed 

Xm=sqrt(((V/sqrt(3))/Imu)-Rs^2)-Xsl; %Magnetization reactance 

%%
% Skewing effect on reactances are considered in the design.

K_skew=sin(pi/(2*m*q))/(pi/(2*m*q)); %Skewing factor
Xm=Xm*K_skew; %Magnetization reactance including skewing
Xrl_skew=Xm*(1-(K_skew^2));
Xrl_sat_skew=Xrl_sat+Xrl_skew; %Final value of rotor leakage reactance at stand still, S=1
Xrl_Sn_skew=Xrl+Xrl_skew; %Final value of rotor leakage reactance at rated speed, S=Sn

equivalent= imread('equivalent_circuit.png');
figure;
imshow(equivalent);
title('Equivalent Circuit for the Motor','FontSize',18,'FontWeight','Bold');

%% Losses and Efficiency
% Total losses for the induction motor are copper losses on stator and rotor windings, core losses on the stator, mechanical/ventilation losses and stray losses.
% The mechanical/ventilation losses are considered as pmv = 0.03Pn for p1 = 1, 0.012Pn for p1 = 2, and 0.008Pn for p1 = 3,4.
% Here their standard value pstray = 0.01Pn is considered.
P_co_s=3*Irated^2*Rs; 
Pcur=3*Rrc_Sn*Ki^2*Irated^2; 
Pmv=0.008*P; 
Pstray=0.01*P; 

gamma_iron=7800; %Iron density in kg/m^3
Ky=1.7; %Influence of mechanical machining
Gt1=gamma_iron*Qs*bts*(hs+hw+hos)*L*Kfe; %Stator tooth weight in kg
Gy1=gamma_iron*pi/4*(Dout^2-(Dout-2*bcs)^2)*L*Kfe; %Yoke weight in kg

Kt=1.7; %Core loss augmentation due to mechanical machining
p10=2.5; %Specific losses (W/kg) at 1.0 T and 50 Hz
Pt1=Kt*p10*(f/50)^(1.3)*(Bts)^(1.7)*Gt1; %Stator teeth fundamental losses (W)
Py1=Ky*p10*(f/50)^(1.3)*(Bcs)^(1.7)*Gy1; %Stator back iron (yoke) fundamental losses  (W)
P1_iron=Pt1+Py1; %Fundamental iron losses (W)

Kps=1/(2.2-Bts);
Kpr=1/(2.2-B_rotor_tooth);
Bps=(Kc2-1)*Bg_new; %Stator pulse flux density  (T)
Bpr=(Kc1-1)*Bg_new; %Rotor pulse flux density  (T)

Gtr=gamma_iron*L*Kfe*Qr*(hr+(br1+br2)/2)*btr; %Rotor teeth weight (kg)

Gts=Gt1;
Ps_iron=0.5e-4*((Qr*(f/pole_p)*Kps*Bps)^2*Gts+(Ns*(f/pole_p)*Kpr*Bpr)^2*Gtr); %Tooth flux pulsation core loss in W
Piron=P1_iron+Ps_iron; %Total iron losses W

Ploss= P_co_s+Pcur+Piron+Pmv+Pstray; %Total losses (W)

efficiency_new=P/(P+Ploss); %Efficiency

%% Operation Characteristics
% The operation characteristics are defined as active no load current I0a, rated slip Sn, rated torque Tn, breakdown slip and torque Sk, Tbk, current Is and power factor versus slip, starting current, and torque ILR, TLR

I_noload=(Piron+Pmv+3*Imu*Imu*Rs)/(3*V/sqrt(3)); %No load active current A
s_rated=Pcur/(P+Pcur+Pmv+Pstray); %Rated slip
Tn=P/(2*pi*(f/pole_p)*(1-s_rated)); %Rated shaft torque in Nm

Cm=1+Xsl/Xm;
T_breakdown=(3*pole_p/(2*w))*((V/sqrt(3))^2)/(Rs+sqrt(Rs^2+(Xsl+Cm*Xrl)^2)); 
I_starting=(V/sqrt(3))/(sqrt((Rs+Rrc)^2+(Xsl_sat+Xrl_sat)^2)); 
T_starting=(3*Rrc*I_starting^2/w)*pole_p; 
power_factor_new=P/(3*(V/sqrt(3))*Irated*efficiency_new); % power factor

Te=(3*pole_p/w)*((V/sqrt(3))^2*Rrc_Sn/s)/((Rs+Cm*Rrc_Sn/s)^2+(Xsl+Cm*Xrl_Sn_skew)^2); %Approximate torque vs. slip expression

tbk=T_breakdown/Tn;
tLR=T_starting/Ten;
iLR=I_starting/Irated;

%%
% Apparently the design does not need any iterations. This is pure coincidence �combined� with standard specifications. Higher breakdown or starting ratios
% tbk, tLR would, for example, need lower rotor leakage inductance and higher
% rotor resistance as influenced by skin effect. A larger stator bore diameter is
% again required. In general, it is not easy to make a few changes to get the desired operation characteristics.

 %% Temperature Rise

lambda_ins=0.25; %Insulation thermal conductivity in W/mK
h_ins=0.3e-3; %Total insulation thickness from the slot middle to teeth wall in m
alpha_cond=lambda_ins/h_ins; %The slot insulation conductivity plus its thickness lumped in W/m^2K
alpha_conv=40; %For 6 pole IMs with selfventilators placed outside the motor in W/m^2K

A_stator_slot=(2*hs+bs2)*L*Qs; %Stator slot lateral area in m^2
theta_co=P_co_s/(alpha_cond*A_stator_slot); %Temperature differential between the conductors in slots and the slot wall 

Kfin=3.0; %Finn coefficient
Aframe=pi*Dout*(L+pole_pitch)*Kfin; %Frame area in m^2
theta_frame=Ploss/(alpha_conv*Aframe); %Frame temperature rise with respect to ambient air in Celcius degrees

theta_amb=50; %Ambient temperature in Celcius degrees
theta_w=theta_amb+theta_co+theta_frame; %Winding temperature in Celcius degrees

%% Total Weight

Gs=Gt1+Gy1; %Stator iron weight in kg
Gyr=gamma_iron*pi/4*((D_r-2*(hor+(br1+br2)/2+hr))^2-(Dshaftmax)^2)*L*Kfe; %Rotor yoke weight
Gr=Gtr+Gyr; %Rotor iron weight in kg
Gcus=8940*L_coil*N_new*Ac*1e-6*m; %Stator copper weight in kg
Gcur=8940*(Ar*L+A_end_ring*L_er)*Qr; %Rotor copper weight in kg
Gshaft=gamma_iron*pi/4*Dshaftmax^2;%Shaft weight in kg
Gtotal=Gs+Gr+Gcus+Gcur+Gshaft; %Total motor weight excluding the enclosure, ventilation apparatus etc.

%% Motor Analysis
% After finishing motor analytical design, geometry and winding type are tried to get simulation result by using motoranalysis software. It is got some visual design: 

geometry= imread('motor_geometry_2nd.png');
figure;
imshow(geometry);
title('Motor geometry','FontSize',18,'FontWeight','Bold');

magn= imread('B-H_curve.png');
figure;
imshow(magn);
title('B-H curve value','FontSize',18,'FontWeight','Bold');

%% Conclusion
% The increase of the rotor slot number has as an impact the stronger magnetization of the rotor parts close to the neutral zones of the magnetic field.
% On the other hand, the motor which has more rotor slot number presents greater magnetic flux density on the surface of the rotor core opposite to the neutral zones of the magnetic field, compared to the motor with lower slot number
% In order to sufficiently compare the starting behavior of the motors, the starting torque and stator current were extracted for each case, the motor with 56 rotor slots is characterized by the least starting torque, whereas the motor with 88 rotor slots has the greatest. 
% The model with 88 rotor slots is also characterized by the least starting stator current amplitude. 
% When we compare generally especially motor starting torque and breakdown torque are effected
% considerably. its value decrease by changing rotor slot number. In the
% first design Tstarting=304.317751  Nm  and T_breakdown=24159.682886 Nm but now:

fprintf('T_starting: %f m\n',T_starting)
fprintf('T_breakdown: %f m\n',T_breakdown)

%% Outputs
% Main Dimension of Stator Core

fprintf('Stator bore diameter: %f m\n',Din)
fprintf('Stack length: %f m\n',L)
fprintf('Pole pitch: %f m\n',pole_pitch)
fprintf('Slot pitch: %f m\n',slot_pitch)
fprintf('Outer diameter: %f m\n',Dout_n)
fprintf('Rotor diameter: %d m\n',D_r)
fprintf('Airgap: %d mm\n',airgap)

%%
% Stator Winding
fprintf('Number of stator slot: %d\n',Qs)
fprintf('Distribution factor:%f \n',Kd)
fprintf('Pitch factor:%f \n',Kp)
fprintf('Winding factor:%f \n',Kw)
fprintf('Pole flux:%f  Wb\n',fundamental_magnetic_flux)
fprintf('Number of turns per phase:%f turns/phase\n',N_new)
fprintf('Number of conductor per slot:%f \n',number_of_conductor_per_slot_n)
fprintf('Rated current:%f  A\n',Irated)
fprintf('Magnetic wire cross section:%f mm^2\n',Ac)
fprintf('Wire gauge diameter:%f mm\n',d_co_new)


%%
% Stator Slot Sizing
fprintf('Slot area:%f mm^2\n',slot_area)
fprintf('Stacking factor:%f\n',Kfe)
fprintf('hos:%f mm\n',hos*1000)
fprintf('bos:%f mm\n',bos*1000)
fprintf('bts:%f mm\n',bts*1000)
fprintf('bs1:%f mm\n',bs1*1000)
fprintf('bs2:%f mm\n',bs2*1000)
fprintf('bcs:%f mm\n',bcs*1000)
fprintf('hs:%f mm\n',hs*1000)
fprintf('hw:%f mm\n',hw*1000)


%%
% Rotor Slot
fprintf('Number of stator slot: %f\n',Qr)
fprintf('Rated rotor bar current:%f A \n',I_rotor_bar)
fprintf('Rotor slot area:%f m^2 \n',Ar)
fprintf('End ring cross section:%f m^2\n',A_end_ring)
fprintf('Rotor slot pitch:%f mm \n',T_rotor_slot*1000)
fprintf('hor:%f mm\n',hor*1000)
fprintf('bor:%f mm\n',bor*1000)
fprintf('btr:%f mm\n',btr*1000)
fprintf('br1:%f mm\n',br1*1000)
fprintf('br2:%f mm\n',br2*1000)
fprintf('hcr:%f mm\n',hcr*1000)
fprintf('hr:%f mm\n',hr*1000)
fprintf('hw_r:%f mm\n',hw_r*1000)
fprintf('Maximum diameter of the shaft:%f mm\n',Dshaftmax*1000)


%%
% End Ring Cross Section
fprintf('End ring width:%f mm\n',a*1000)
fprintf('End ring heigth:%f mm\n',b*1000)

%%
% Magnetization Current
fprintf('Magnetization current:%f A\n',Imu)
fprintf('Airgap mmf:%f Aturns\n',MMF_airgap)
fprintf('Rotor teeth mmf:%f Aturns\n',MMF_rotor_teeth)
fprintf('Stator tooth mmf:%f Aturns\n',MMF_stator_tooth)
fprintf('Magnetization mmf:%f Aturns\n',MMF_magnetization)
fprintf('Carter coefficient:%f \n',Kc)

%%
% Flux Density & Magnetical and Electrical Loading
fprintf('Bg:%f T\n',Bg_new)
fprintf('Bcs:%f T\n',Bcs_n)
fprintf('Bcr:%f T\n',Bcr)
fprintf('Brt:%f T\n',B_rotor_tooth)
fprintf('Bts:%f T\n',Bts)
fprintf('Magnetic loading:%f T\n',magnetic_loading)
fprintf('Electrical loading:%f \n',electric_loading)

%% 
% Resistance and Inductance
fprintf('Stator phase reactance:%f ohm\n', Xsl)
fprintf('Stator phase resistance:%f ohm\n',Rs)
fprintf('Rotor leakage reactance:%f ohm\n', Xrl)
fprintf('Rotor phase resistance:%f ohm\n',Rrc_Sn)
fprintf('Magnetization:%f  ohm\n',Xm)


%%
% Current
fprintf('No load active current: %d m\n',I_noload)
fprintf('Rated current: %d m\n',Irated)
fprintf('Starting current: %d m\n',I_starting)
fprintf('End ring current: %d m\n',I_end_ring)

%%
% Losses & Efficiency
fprintf('Stator winding losses:%f  W\n',P_co_s)
fprintf('Rotor cage losses:%f W\n',Pcur)
fprintf('Mechanical/ventilation losses:%f  W\n',Pmv)
fprintf('Stray losses:%f W\n',Pstray)
fprintf('Total losses:%f W\n',Ploss)
fprintf('Efficiency:%f  \n',efficiency_new*100)

%%
% Operation Characteristic
fprintf('Starting torque:%f  Nm\n',T_starting)
fprintf('Breakdown torque:%f Nm\n',T_breakdown)
fprintf('Rated shaft torque:%f Nm\n',Tn)
fprintf('Stray losses:%f W\n',Pstray)
fprintf('Power factor:%f  \n',power_factor_new)

%%
% Mass
fprintf('Rotor iron weight:%f  kg\n',Gr)
fprintf('Shaft weight:%f  kg\n',Gshaft)
fprintf('Stator iron weight:%f  kg\n',Gs)
fprintf('Rotor yoke weight:%f  kg\n',Gyr)
fprintf('Stator copper weight:%f  kg\n',Gcus)
fprintf('Rotor copper weight:%f  kg\n',Gcur)
fprintf('Total motor weight:%f  kg\n',Gtotal)

%% References
%
% *I.Boldea and S.A. Nasar "The Induction Machine Handbook"
%
% *http://keysan.me/ee564
%
% *J. Pyrh�nen and T. Jokinen "Design of Rotating Electrical Machines"
%
% *http://energy.gov/sites/prod/files/2014/04/f15/amo_motors_handbook_web.pdf

