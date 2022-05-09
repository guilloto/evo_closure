%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc

%% PARAMETRES %%
Np = 10 ; % Nombre de places (d'entités)
Nt = 10 ; % Nb transitions total  % Nt>1 (sinon pb dans randsample, a changer)
nb_rep = 5;

sp = 3 ; % Specificité = nombre moyen de lien [0;+inf)(diviser par 2) % POUR POISSON
             % sp doit être plus petit que le minimum de Nt ou Np
sp=sp/2 ;           
% sp = 1 ;   % sp = exposant de la loi puissance. Plus il est grand plus la spécificité est forte

% m = 2 ; % paramtre de degradation des contraintes (poids des arcs) 
m_loop = 0:.2:1 ; % taux de dégradation des contraintes (pour postprocess)
v = 0 ; % taux de variation

j_init = Np ; % nombre de jetons initial


% Initialisation rdp
global global_info
% global_info.STOP_AT = 10 ;
global_info.MAX_LOOP = 100 ; % limiter le nombre de cycles de simu
global_info.PRINT_LOOP_NUMBER = 0 ; %afficher le nombre de loop
global_info.v = v ; % taux de variation
global_info.Np = Np;

%% INITIALISATION D UN RESEAU
% Génerer le réseau
reseau_init = generate(Np,Nt,sp) ; %structure avec les matrices Ai et Ao

% Définir le marquage initial / les conditions de possibilités initiales

% Marquage de partout
marquage = ones(Np,1);

% % tirer marquage
% idx_marques = randi([1 Np],j_init,1); % tirer l'emplacement des jetons dans les places
% marquage = zeros(Np,1);
% marquage(idx_marques) = 1 ;

reseau = reseau_init ;
global_info.reseau = reseau ;

Evo_jetons = cell(nb_rep,length(m_loop)); % pre_alloc de la variable où stocker evo_jetons 

pdf_auto(reseau.Ai,reseau.Ao,reseau.clone) ; % crée automatiquement le pdf à partir des matrices incidentes inputs et output
pns = pnstruct('pdf_clo') ; % indiquer le rdp défini dans le pdf file
places_name = {pns.global_places.name};

% test viabilité pour réseau initial
cyc = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
cyc_vrai = sum(cyc.cycles>0,2);
viab = any(cyc_vrai>=3); %grandeur minimale de cycle
%%
for a = 1:length(m_loop)
    m = m_loop(a);
    global_info.m = m ; % taux de dégradation des contraintes
    for rep = 1:nb_rep
        marquage = ones(Np,1);
        if viab == 1
            %%  INITIALISATION RDP %%%%%
            % Initialisation du marquage (marquage final de l'itération précédente)
            j=1 ;
            for i = 1:length(marquage) % = 1:length idx
                dyn.m0{j} = places_name{i} ; % atttention verifier que l'ordre dans places name ne change pas!!!!!!!!!!! sinon traiter avec le nom de la place
                dyn.m0{j+1} = marquage(i) ;
                j = j+2 ;
            end
            
            pni = initialdynamics(pns,dyn) ; % combine infos statiques et dynamiques
            
            %% Simu
            sim = gpensim(pni) ; % start and run simulations
            % Variation: dans common_post
            % Degradation: common_pre
            
            %% Visualisation resultats (extraction matrice) %%%%
            % prnss(sim) ; % afficher l'espace des états
            %         figure()
            evo_jetons = plotp(sim,places_name) ; % matrice de suivi des jetons (nombre de jetons dans les places) ATT 1e colonne = temps 1e ligne = n° place
            idx_viab = find(evo_jetons(end,2:end)~=0) ;
            place_jetons = places_name(idx_viab) ;
            n_final_jeton = sum(evo_jetons(end,2:end)) ;
            % Places qui possèdent encore des jetons
            
            %% Viabilité
            % Multiplication des jetons
            %                 viab = n_final_jeton > j_init ;
            cyc = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
            cyc_vrai = sum(cyc.cycles>0,2);
            idx_cyc_vrai = find(cyc_vrai>=3); %grandeur minimale de cycle
            %         cyc_vrai(idx_cyc_vrai);
            c = {cyc.nodes.name};
            Val = [];
            for i = 1:length(idx_cyc_vrai)
                val = cyc.cycles(idx_cyc_vrai(i),:);
                val(val==0) = [];
                Val = [Val, val];
            end
            %        c(cyc.cycles(idx_cyc_vrai,:))
            %        cyc.nodes.name(cyc.cycles(idx_cyc_vrai,1))
            names = c(unique(Val));
            
            test = [];
            for i = 1:length(place_jetons)
                test(i) = sum(strcmp(names,place_jetons{i}));
            end
            viab = sum(test)>0 ;
            
            %% Récupérer le marquage
            marquage = evo_jetons(end,2:end) ;%
            
            %% Variations
            %         reseau_new = variation(reseau) ;
            %         reseau = reseau_new ;
            %         global_info.reseau = reseau ;
            
            
        end %if
        evo_jetons_cut = evo_jetons(2:end,2:end);
        Evo_jetons{rep,a} = evo_jetons_cut;
    end
end %for



%% POSTPROCESS

% load('effect_of_degradation.mat')
m_loop = 0:0.2:1;

evo_jetons_mean = cellfun(@mean, Evo_jetons, 'UniformOutput', false);
evo_jetons_mean = cellfun(@mean, evo_jetons_mean, 'UniformOutput', false);
evo_jetons_mean = cell2mat(evo_jetons_mean);

boxplot(evo_jetons_mean);
xlabel('degradation','interpreter','latex','FontSize',25)
ylabel('nombre de jetons','interpreter','latex','FontSize',25)
xticklabels(m_loop);





