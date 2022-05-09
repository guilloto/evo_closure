% Main simulation file
% Contient la génération d'un réseau, sa dynamique initiale (marques,..) et les simus
% by Oceane Guillot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc
%% PARAMETRES %%%%%%
% Parametres du réseau
Np = 10 ; % Nombre de places (d'entités)
Nt = 10 ; %Nb transitions total  % Nt>1 (sinon pb dans randsample, a changer)


sp = 2/2 ; % Specificité = nombre moyen de lien [0;+inf)(diviser par 2) % POUR POISSON
             % sp doit être plus petit que le minimum de Nt ou Np
             
% sp = 1 ;   % sp = exposant de la loi puissance. Plus il est grand plus la spécificité est forte

% m = 2 ; % paramtre de degradation des contraintes (poids des arcs) 
m = 0 ; % taux de dégradation des contraintes (pour postprocess): à chaque transition 1 jeton est dégradé
v = 1 ;% taux de variation

j_init = Np ; % nombre de jetons initial

% Initialisation RdP
global global_info
% global_info.STOP_AT = 10 ;
global_info.MAX_LOOP = 1000 ; % limiter le nombre de cycles de simu
global_info.PRINT_LOOP_NUMBER = 0 ; %afficher le nombre de loop
global_info.v = v ; % taux de variation
global_info.m = m ; % taux de dégradation des contraintes

%% Generer le réseau
reseau = generate(Np,Nt,sp,m) ; %structure avec les matrices Ai et Ao

%%  INITIALISATION RDP %%%%%

 % Create pdf file for petrinet simulation
   pdf_auto(reseau.Ai,reseau.Ao,reseau.clone) ; % crée automatiquement le pdf à partir des matrices incidentes inputs et outpu
   pns = pnstruct('pdf_clo') ; % indiquer le rdp défini dans le pdf file

% Définir les conditions de possibilités initiales

idx_marques = randi([1 Np],j_init,1); % tirer l'emplacement des jetons dans les places
places_name = {pns.global_places.name};

% Definir les jetons initiaux pour rdp 

% j=1 ;
% for i = 1:length(idx_marques)
% dyn.m0{j} = places_name{i} ;
% dyn.m0{j+1} = 1 ;
% j = j+2 ;
% end

% En mettant des jetons de partout
j=1 ;
for i = 1:length(places_name)
    dyn.m0{j} = places_name{i} ;
    dyn.m0{j+1} = 1 ;
    j = j+2 ;
end


% dyn.ft = {'T11',10,'T12',10} ; % Si on utilise un rdp temporel, temps de la transition
% dyn.re = {'S1',1,1, 'S2',1,1} ; %  {ressource, nb d'instance, temps/nb utilisation permise}

pni = initialdynamics(pns,dyn) ; % combine infos statiques et dynamiques

%% Simu
sim = gpensim(pni) ; % start and run simulations

% Variation: dans common_post
% Degradation: common_pre

%% Visualisation resultats %%%%

% prnss(sim) ; % afficher l'espace des états 
figure()
figur = plotp(sim,places_name) ; % graph de suivi des jetons (nombre de jetons dans les places)
idx_vie = find(figure(end,2:end)~=0) ;
jetons_restants = places_name(idx_vie) ;
% Places qui possèdent encore des jetons

figure() 
imagesc(figur(1:200,2:end)')
% colormap(autumn(256))
% colormap(parula(256))
colormap(hot(200))
colorbar

%plotp(sim,{'E1'}) ; 

% prnschedule(sim) % pour ressources
% occupancy(sim, {'T11','T12'});
% plotGC(sim) % pour ressources
% cotree(pns,1,1) % graph d'atteignabilité

% vis = convert_PN_V(pns) ;

end

%% Visu dans R
% coller set_of_As
rstu = reshape(set_of_As,3,length(set_of_As)/3);
rstu= rstu(1:2,:);


%% ANALYSES %%%%

% systeme viable s'il reste des jetons ailleurs que dans les puits 

% Détecter les puits
siphons_minimal(pns) ; % 
siphons()


% Topologie du réseau



% cycle = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
                % A incidence matrix
                % nodes.d = discovered tome
                % nodes.f = dinished time
                % nodes.pi = predecessor
                % time = corrent step
                % 
print_cycles(cycle)

% remettre les noms sur les chiffres du cycle
cycle.nodes.name

%%%%%%%%% A FINIR %%%%%%%%%%


stronglyconn(pns) % composants fortement connectés

siphons_minimal(pns) ; % 
siphons()
traps_minimal()
traps()

timesfired() ; % nombre d'activation d'une transition

%%  
PI = pinvariant(pns); %
TI = tinvariant(pns); %
stronglyconn(pns) ; % trouver les composants fortement connectés

cy = cycles(pns); % 

is_enabled(T11)
ntokens("F1")
