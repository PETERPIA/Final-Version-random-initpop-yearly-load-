function mpc = mp_case(X)
%CASE69  Power flow data for 69 bus distribution system
%   Please see CASEFORMAT for details on the case file format.
%
%   Data from ...
%       M. E. Baran and F. F. Wu, "Optimal capacitor placement on radial
%       distribution systems," in IEEE Transactions on Power Delivery,
%       vol. 4, no. 1, pp. 725-734, Jan. 1989, doi: 10.1109/61.19265.
%       https://doi.org/10.1109/61.19265
%
%   Derived "from a portion of the PG&E distribution system".
%
%   Also in ...
%       D. Das, Optimal placement of capacitors in radial distribution
%       system using a Fuzzy-GA method, International Journal of Electrical
%       Power & Energy Systems, Volume 30, Issues 6–7, July–September 2008,
%       Pages 361-367
%       https://doi.org/10.1016/j.ijepes.2007.08.004
%
%   Modifications:
%     v2 - 2020-09-30 (RDZ)
%         - Cite original source (Baran & Wu)
%         - Specify branch parameters in Ohms, loads in kW.
%         - Added code for explicit conversion of loads from kW to MW and
%           branch parameters from Ohms to p.u.
%         - Set BASE_KV to 12.66 kV (instead of 12.7)
%         - Slack bus Vmin = Vmax = 1.0
%         - Gen Qmin, Qmax, Pmax magnitudes set to 10 (instead of 999)
%         - Branch flow limits disabled, i.e. set to 0 (instead of 999)
%         - Add gen cost.
%%
 % .bus matrix is pre-determined in main.m, for load is assumed not changeable 

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 10;

%% add generators
[DGen,DGencost] = makeGen(X);

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
 % 1 meaning spring/fall weekday
DLoad = makeLoad(1);
mpc.bus = DLoad; 

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = DGen;

%% branch data 
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
%   need rewrite in rate A rate B rate C
%   s = sqrt(p^2 + q^2)
mpc.branch = [  %% (r and x specified in ohms here, converted to p.u. below)
	1	2	0.0005	0.0012	0	0	0	0	0	0	1	-360	360;
	2	3	0.0005	0.0012	0	0	0	0	0	0	1	-360	360;
	3	4	0.0015	0.0036	0	0	0	0	0	0	1	-360	360;
	4	5	0.0251	0.0294	0	0	0	0	0	0	1	-360	360;
	5	6	0.366	0.1864	0	0	0	0	0	0	1	-360	360;
	6	7	0.381	0.1941	0	0	0	0	0	0	1	-360	360;
	7	8	0.0922	0.047	0	0	0	0	0	0	1	-360	360;
	8	9	0.0493	0.0251	0	0	0	0	0	0	1	-360	360;
	9	10	0.819	0.2707	0	0	0	0	0	0	1	-360	360;
	10	11	0.1872	0.0619	0	0	0	0	0	0	1	-360	360;
	11	12	0.7114	0.2351	0	0	0	0	0	0	1	-360	360;
	12	13	1.03	0.34	0	0	0	0	0	0	1	-360	360;
	13	14	1.044	0.34	0	0	0	0	0	0	1	-360	360;
	14	15	1.058	0.3496	0	0	0	0	0	0	1	-360	360;
	15	16	0.1966	0.065	0	0	0	0	0	0	1	-360	360;
	16	17	0.3744	0.1238	0	0	0	0	0	0	1	-360	360;
	17	18	0.0047	0.0016	0	0	0	0	0	0	1	-360	360;
	18	19	0.3276	0.1083	0	0	0	0	0	0	1	-360	360;
	19	20	0.2106	0.069	0	0	0	0	0	0	1	-360	360;
	20	21	0.3416	0.1129	0	0	0	0	0	0	1	-360	360;
	21	22	0.014	0.0046	0	0	0	0	0	0	1	-360	360;
	22	23	0.1591	0.0526	0	0	0	0	0	0	1	-360	360;
	23	24	0.3463	0.1145	0	0	0	0	0	0	1	-360	360;
	24	25	0.7488	0.2475	0	0	0	0	0	0	1	-360	360;
	25	26	0.3089	0.1021	0	0	0	0	0	0	1	-360	360;
	26	27	0.1732	0.0572	0	0	0	0	0	0	1	-360	360;
	3	28	0.0044	0.0108	0	0	0	0	0	0	1	-360	360;
	28	29	0.064	0.1565	0	0	0	0	0	0	1	-360	360;
	29	30	0.3978	0.1315	0	0	0	0	0	0	1	-360	360;
	30	31	0.0702	0.0232	0	0	0	0	0	0	1	-360	360;
	31	32	0.351	0.116	0	0	0	0	0	0	1	-360	360;
	32	33	0.839	0.2816	0	0	0	0	0	0	1	-360	360;
	33	34	1.708	0.5646	0	0	0	0	0	0	1	-360	360;
	34	35	1.474	0.4873	0	0	0	0	0	0	1	-360	360;
	3	36	0.0044	0.0108	0	0	0	0	0	0	1	-360	360;
	36	37	0.064	0.1565	0	0	0	0	0	0	1	-360	360;
	37	38	0.1053	0.123	0	0	0	0	0	0	1	-360	360;
	38	39	0.0304	0.0355	0	0	0	0	0	0	1	-360	360;
	39	40	0.0018	0.0021	0	0	0	0	0	0	1	-360	360;
	40	41	0.7283	0.8509	0	0	0	0	0	0	1	-360	360;
	41	42	0.31	0.3623	0	0	0	0	0	0	1	-360	360;
	42	43	0.041	0.0478	0	0	0	0	0	0	1	-360	360;
	43	44	0.0092	0.0116	0	0	0	0	0	0	1	-360	360;
	44	45	0.1089	0.1373	0	0	0	0	0	0	1	-360	360;
	45	46	0.0009	0.0012	0	0	0	0	0	0	1	-360	360;
	4	47	0.0034	0.0084	0	0	0	0	0	0	1	-360	360;
	47	48	0.0851	0.2083	0	0	0	0	0	0	1	-360	360;
	48	49	0.2898	0.7091	0	0	0	0	0	0	1	-360	360;
	49	50	0.0822	0.2011	0	0	0	0	0	0	1	-360	360;
	8	51	0.0928	0.0473	0	0	0	0	0	0	1	-360	360;
	51	52	0.3319	0.114	0	0	0	0	0	0	1	-360	360;
	9	53	0.174	0.0886	0	0	0	0	0	0	1	-360	360;
	53	54	0.203	0.1034	0	0	0	0	0	0	1	-360	360;
	54	55	0.2842	0.1447	0	0	0	0	0	0	1	-360	360;
	55	56	0.2813	0.1433	0	0	0	0	0	0	1	-360	360;
	56	57	1.59	0.5337	0	0	0	0	0	0	1	-360	360;
	57	58	0.7837	0.263	0	0	0	0	0	0	1	-360	360;
	58	59	0.3042	0.1006	0	0	0	0	0	0	1	-360	360;
	59	60	0.3861	0.1172	0	0	0	0	0	0	1	-360	360;
	60	61	0.5075	0.2585	0	0	0	0	0	0	1	-360	360;
	61	62	0.0974	0.0496	0	0	0	0	0	0	1	-360	360;
	62	63	0.145	0.0738	0	0	0	0	0	0	1	-360	360;
	63	64	0.7105	0.3619	0	0	0	0	0	0	1	-360	360;
	64	65	1.041	0.5302	0	0	0	0	0	0	1	-360	360;
	11	66	0.2012	0.0611	0	0	0	0	0	0	1	-360	360;
	66	67	0.0047	0.0014	0	0	0	0	0	0	1	-360	360;
	12	68	0.7394	0.2444	0	0	0	0	0	0	1	-360	360;
	68	69	0.0047	0.0016	0	0	0	0	0	0	1	-360	360;
];

mpc.branch(:,6) = 5; %unit MVA

%% convert branch impedances from Ohms to p.u.
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, ~, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

Vbase = mpc.bus(1, BASE_KV) * 1e3;      %% in Volts
Sbase = mpc.baseMVA * 1e6;              %% in VA
mpc.branch(:, [BR_R BR_X]) = mpc.branch(:, [BR_R BR_X]) / (Vbase^2 / Sbase);

%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = DGencost;

end