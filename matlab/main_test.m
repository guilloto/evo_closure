% Main simulation file
% Contient la dynamique initiale du réseau (marques,..) et les simus
%by Oceane Guillot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù

% voir pour utiliser "global"
global global_info
% global_info.STOP_AT = 10 ;
global_info.MAX_LOOP = 2 ; % limiter le nombre de cycles de simu

pns = pnstruct('pn_def_test') ; % indiquer le rdp défini dans le pdf file

% dyn.m0 = {'F1',1, 'E1',1} ; % Definir les jetons initiaux
dyn.m0 = {'E1',1, 'F1',1} ; % Definir les jetons initiaux
% dyn.m0 = {'F1',1, 'E1',1, 'S2',1, 'S1',1,} ; % Definir les jetons initiaux

% dyn.ft = {'T11',10,'T12',10} ; % Si on utilise un rdp temporel, temps de la transition

% dyn.re = {'S1',5,1} ; %  {ressource, nb d'instance, temps/nb utilisation permise}

pni = initialdynamics(pns,dyn) ; % combine infos statique et dynamique

sim = gpensim(pni) ; % start and run simulations

prnss(sim) ; % afficher l'espace des états 
plotp(sim,{'E1','F1'}) ; % graph de suivi des jetons (nombre de jetons dans les places)

% prnschedule(sim)
% occupancy(sim, {'T11','T2'});
% plotGC(sim)
