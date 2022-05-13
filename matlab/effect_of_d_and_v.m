%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc
tic
%% PARAMETRES %%
Np = 10 ; % Nombre de places (d'entités)
Nt = 10 ; % Nb transitions total  % Nt>1 (sinon pb dans randsample, a changer)
nb_rep = 1;
nb_var = 15;

sp = 2; % Specificité = nombre moyen de lien [0;+inf)(diviser par 2) % POUR POISSON
             % sp doit être plus petit que le minimum de Nt ou Np
sp = sp/2;

% m = 2 ; % paramtre de degradation des contraintes (poids des arcs) 
m_loop = .1:.2:1; % taux de dégradation des contraintes (pour postprocess)
v_loop = .1:.2:1; % taux de variation

j_init = Np; % nombre de jetons initial

% Initialisation rdp
global global_info
% global_info.STOP_AT = 10 ;
global_info.MAX_LOOP = 100 ; % limiter le nombre de cycles de simu
global_info.PRINT_LOOP_NUMBER = 0 ; %afficher le nombre de loop
global_info.Np = Np;

%% INITIALISATION D UN RESEAU
viab = 0;
while viab==0
    % Génerer le réseau
    reseau_init = generate(Np,Nt,sp) ; %structure avec les matrices Ai et Ao
    % Définir le marquage initial / les conditions de possibilités initiales
    % Marquage de partout
    pdf_auto(reseau_init.Ai,reseau_init.Ao,reseau_init.clone) ; % crée automatiquement le pdf à partir des matrices incidentes inputs et output
    pns = pnstruct('pdf_clo') ; % indiquer le rdp défini dans le pdf file
    places_name = {pns.global_places.name};
    trans_name = {pns.global_transitions.name};
    marquage = ones(Np,1);
    reseau = reseau_init ;
    global_info.reseau = reseau ;
    % test viabilité pour réseau initial
    cyc = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
    cyc_vrai = sum(cyc.cycles>0,2); % nb de places dans chaque cycle
    idx_cycle = find(cyc_vrai>=4); % grandeur minimale de cycle
    viab = ~isempty(idx_cycle);
end
% choisir un cycle au hasard
idx = randi(length(idx_cycle),1);
places_cyc = cyc.cycles(idx_cycle(idx),:);
places_cyc(places_cyc==0) = [];
c = {cyc.nodes.name};
names_cyc_nodes = c(places_cyc);
idx_places = [];
% for_loop = donne les colonnes des places du cycle initial dans mat incidence
for i = 1:length(names_cyc_nodes)
    idx_places = [idx_places,find(strcmp(places_name,names_cyc_nodes{i})==1)];     
end
% for_loop = donne les colonnes des trans du cycle initial dans mat incidence
idx_trans = [];
for i = 1:length(names_cyc_nodes)
    idx_trans = [idx_trans,find(strcmp(trans_name,names_cyc_nodes{i})==1)];     
end
% enlever tous les liens qui ne sont pas relies au cycle
Ai = reseau_init.Ai;
Ao = reseau_init.Ao;
clone = reseau_init.clone;
for i = 1:Np
    if ~ismember(i,idx_places) % si la place n'est pas dans le cycle
        for j = 1:Nt
            if ~ismember(j,idx_trans) % et si la trans n'est pas dans le cycle
                % supprimer lien
                Ai(j,i) = 0;
                Ao(j,i) = 0;
                clone(j,i) = 0;
            end
        end
    end
end
reseau_init.Ai = Ai;
reseau_init.Ao = Ao;
reseau_init.clone = clone;
reseau = reseau_init ;
global_info.reseau = reseau ;

%% LOOP
Nb_cycle = zeros(length(m_loop),length(v_loop));
for a = 1:length(m_loop)
    m = m_loop(a);
    global_info.m = m;
    for s = 1:length(v_loop)
        v = v_loop(s);
        global_info.v = v ; % taux de variation
        nb_cycle_rep = [];
        for rep = 1:nb_rep
            nb_cycle = 0;
            viab = 1;
            for jj = 1:nb_var
                if viab==1
                    % INITIALISATION RDP %%%%%
                    pdf_auto(global_info.reseau.Ai,global_info.reseau.Ao,global_info.reseau.clone) ; % crée automatiquement le pdf à partir des matrices incidentes inputs et output
                    pns = pnstruct('pdf_clo') ; % indiquer le rdp défini dans le pdf file
                    places_name = {pns.global_places.name};              
                    % Initialisation du marquage (marquage final de l'itération précédente)
                    j=1 ;
                    for i = 1:length(marquage) % = 1:length idx
                        dyn.m0{j} = places_name{i} ; % atttention verifier que l'ordre dans places name ne change pas!!!!!!!!!!! sinon traiter avec le nom de la place
                        dyn.m0{j+1} = marquage(i) ;
                        j = j+2 ;
                    end                
                    pni = initialdynamics(pns,dyn) ; % combine infos statiques et dynamiques                
                    % Simu
                    sim = gpensim(pni) ; % start and run simulations
                    % Variation: dans common_post
                    % Degradation: common_pr            
                    % Visualisation resultats (extraction matrice) %%%%
                    % prnss(sim) ; % afficher l'espace des états
                    %         figure()
                    evo_jetons = plotp(sim,places_name) ; % matrice de suivi des jetons (nombre de jetons dans les places) ATT 1e colonne = temps 1e ligne = n° place
                    idx_viab = find(evo_jetons(end,2:end)~=0) ;
                    place_jetons = places_name(idx_viab) ;
                    n_final_jeton = sum(evo_jetons(end,2:end)) ;
                    % Places qui possèdent encore des jetons                
                    % Viabilité
                    % Multiplication des jetons
                    %                 viab = n_final_jeton > j_init ;
                    cyc = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
                    cyc_vrai = sum(cyc.cycles>0,2);
                    idx_cyc_vrai = find(cyc_vrai>=4); %grandeur minimale de cycle
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
                    % Récupérer le marquage
                    marquage = evo_jetons(end,2:end) ;%               
                    % Variations
                    reseau_new = variation_2(reseau) ;
                    reseau = reseau_new ;
                    global_info.reseau = reseau ;       
                    nb_cycle = nb_cycle + 1;
                end
            end
            nb_cycle_rep = [nb_cycle_rep, nb_cycle];
        end
        nb_cycle = mean(nb_cycle_rep);
        Nb_cycle(a,s) = nb_cycle;
        save(['effect_of_d_and_v','.mat'],'Nb_cycle','m_loop','v_loop','sp')
    end
end



%% POSTPROCESS

% load('effect_of_degradation.mat')
% m_loop = 0:0.2:1;

% evo_jetons_mean = cellfun(@mean, Evo_jetons, 'UniformOutput', false);
% evo_jetons_mean = cellfun(@mean, evo_jetons_mean, 'UniformOutput', false);
% evo_jetons_mean = cell2mat(evo_jetons_mean);
% 
% boxplot(evo_jetons_mean);
% xlabel('degradation','interpreter','latex','FontSize',25)
% ylabel('nombre de jetons','interpreter','latex','FontSize',25)
% xticklabels(m_loop);



toc

