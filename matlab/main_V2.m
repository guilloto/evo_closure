% Main simulation file
% Contient la génération d'un réseau, sa dynamique initiale (marques,..) et les simus
% by Oceane Guillot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc

%% PARAMETRES %%
Np = 10 ; % Nombre de places (d'entités)
Nt = 10 ; % Nb transitions total  % Nt>1 (sinon pb dans randsample, a changer)
z = 10 ;


sp = 3 ; % Specificité = nombre moyen de lien [0;+inf)(diviser par 2) % POUR POISSON
             % sp doit être plus petit que le minimum de Nt ou Np
sp=sp/2 ;           
% sp = 1 ;   % sp = exposant de la loi puissance. Plus il est grand plus la spécificité est forte

% m = 2 ; % paramtre de degradation des contraintes (poids des arcs) 
m = 0.5 ; % taux de dégradation des contraintes (pour postprocess)
v = 0.5 ; % taux de variation

j_init = Np ; % nombre de jetons initial


% Initialisation rdp
global global_info
% global_info.STOP_AT = 10 ;
global_info.MAX_LOOP = 100 ; % limiter le nombre de cycles de simu
global_info.PRINT_LOOP_NUMBER = 0 ; %afficher le nombre de loop
global_info.v = v ; % taux de variation
global_info.m = m ; % taux de dégradation des contraintes
global_info.Np = Np;

%% INITIALISATION D UN RESEAU
% Génerer le réseau
reseau_init = generate(Np,Nt,sp,m) ; %structure avec les matrices Ai et Ao

% Définir le marquage initial / les conditions de possibilités initiales

% Marquage de partout
marquage = ones(Np,1);

% % tirer marquage
% idx_marques = randi([1 Np],j_init,1); % tirer l'emplacement des jetons dans les places
% marquage = zeros(Np,1);
% marquage(idx_marques) = 1 ;


reseau = reseau_init ;
global_info.reseau = reseau ;

Evo_jetons = []; % pre_alloc de la variable où stocker evo_jetons 
Time = [];
pdf_auto(reseau.Ai,reseau.Ao,reseau.clone) ; % crée automatiquement le pdf à partir des matrices incidentes inputs et output
pns = pnstruct('pdf_clo') ; % indiquer le rdp défini dans le pdf file
places_name = {pns.global_places.name};

% test viabilité pour réseau initial
    cyc = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
        cyc_vrai = sum(cyc.cycles>0,2);
        viab = any(cyc_vrai>=3); %grandeur minimale de cycle
%%
for a = 1:z
    if viab == 1
        %%  INITIALISATION RDP %%%%%
        % Create pdf file for petrinet simulation
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
        
        %% Visualisation résulats
%         figure() 
%         imagesc(fig(1:200,2:end)')
        % colormap(autumn(256))
        % colormap(parula(256))
%         colormap(hot(200))
%         colorbar


        %% Récupérer le marquage
        marquage = evo_jetons(end,2:end) ;% 
        
        %% Variations 
        reseau_new = variation(reseau) ;
        reseau = reseau_new ;
        global_info.reseau = reseau ;
        
        %% Aggregation de la variable evo_jetons
        evo_jetons_cut = evo_jetons(2:end,2:end);
        Evo_jetons = [Evo_jetons;evo_jetons_cut];
%         Evo_jetons = Evo_jetons(1:2:end,:) ; % pour ne pas voir quand les jetons vont dans les transitions
        Time = [Time, size(evo_jetons,1)]; % pour savoir le T de chaque phase de variation
%         Time = [Time, size(evo_jetons,1)/2]; % pour savoir le T de chaque phase de variation

    end %if
end %for

%%
% col = jet(10);
% for i = 1:size(Evo_jetons,2)
%     plot(Evo_jetons(:,i),'LineWidth',4,'Color',col(i,:));
%     hold on
% end
plot(Evo_jetons,'LineWidth',3);
xlabel('temps','interpreter','latex','Fontsize',25)
% semilogx(Evo_jetons,'LineWidth',4)
% xlabel('temps (\''echelle log)','interpreter','latex','Fontsize',25)
ylabel('nombre de jetons','interpreter','latex','Fontsize',25)

hold on
time_tot = 0;
for i = 1:length(Time)
    time_tot = time_tot + Time(i);
    h = plot([time_tot,time_tot],[0,max(max(Evo_jetons))],'--k','LineWidth',0.5);
end
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
hold off
legend(places_name,'interpreter','latex','Fontsize',15,'Location','northwest')
% 
% xlim([0 51500])
% ylim([0 13000])
% 

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



cyc = cycles(pns); % sortie: cycles: 1 ligne = 1 circuit
                % A incidence matrix
                % nodes.d = discovered time
                % nodes.f = finished time
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
