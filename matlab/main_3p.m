% Main simulation file
% Contient la dynamique initiale du réseau (marques,..) et les simus
%by Oceane Guillot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù

%%  Initialisation

% voir pour utiliser "global"
global global_info
% global_info.STOP_AT = 10 ;
global_info.MAX_LOOP = 20 ; % limiter le nombre de cycles de simu
global_info.PRINT_LOOP_NUMBER = 1 ;

n_part = 3; % nombre de parties (places) dans les clotures
n_clo = 2; % a changer si cloture generee


pns = pnstruct('pn_3p_def') ; % indiquer le rdp défini dans le pdf file

% dyn.m0 = {'F1',1, 'E1',1} ; % Definir les jetons initiaux
dyn.m0 = {'E1',1,'F1',1,'G1',1} ; % Definir les jetons initiaux
% dyn.m0 = {'F1',1, 'E1',1, 'S2',1, 'S1',1,} ; % Definir les jetons initiaux

% dyn.ft = {'T11',10,'T12',10} ; % Si on utilise un rdp temporel, temps de la transition

% dyn.re = {'S1',1,1, 'S2',1,1} ; %  {ressource, nb d'instance, temps/nb utilisation permise}

pni = initialdynamics(pns,dyn) ; % combine infos statiques et dynamiques

sim = gpensim(pni) ; % start and run simulations

%% Visualisation resultats %%%%

prnss(sim) ; % afficher l'espace des états 
plotp(sim,{'E1','E2','F1','F2','G1','G2'}) ; % graph de suivi des jetons (nombre de jetons dans les places)

% prnschedule(sim) % pour ressources
% occupancy(sim, {'T11','T12'});
% plotGC(sim) % pour ressources
% cotree(pns,1,1) % graph d'atteignabilité

vis = convert_PN_V(pns) ;

%% Analyse 
PI = pinvariant(pns); %
TI = tinvariant(pns); %
siphons_minimal(pns) ; % 
stronglyconn(pns) ; % trouver les composants fortement connectés
timesfired() ; % nombre d'activation d'une transition
traps_minimal()

cy = cycles(pns); % 


enab
is_enabled(T11)
ntokens("F1")