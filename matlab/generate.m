% Generer rdp sans pdf
function[network]=generate(Np,Nt,sp)

%% Generer réseau avec distribution de degré

% Matrice noeuds/places
mat_process = zeros(Nt,Np) ; % matrice d'incidence des processus 

%a verifier !!!
% Ndmax = Np*Nt ; %nombre de degré max: doit être inferieur à Np*Nt
                

              
% Tirer les degrés des noeuds

% % Dans une poisson
deg_place = poissrnd(sp,[(Np) 1]) ; %lambda, size % on tire 2 poissons
deg_trans = poissrnd(sp,[(Nt) 1]) ; %lambda, size 

% Parametres
% exposant d'invariance d'échelle = specificité 

% Pour les places

% % Calcul des proba élémentaires de la loi puissance
% prob_puissance = (1:(Np-1)).^(-sp) ;
% prob_puissance = prob_puissance/sum(prob_puissance) ;
% 
% deg_place = randsample(1:(Np-1),Np ,true, prob_puissance) ; %on tire n degrés dans 1:n-1 avec remplacement selon probas
% 
% % Pour les transitions
% prob_puissance = (1:(Nt-1)).^(-sp) ;
% prob_puissance = prob_puissance/sum(prob_puissance) ;
% 
% deg_trans = randsample(1:(Nt-1),Nt ,true, prob_puissance) ; %on tire n degrés dans 1:n-1 avec remplacement selon probas



%%
% quand il n'y a plus de degré dans place ou processu, probleme si bcp plus de place que processus

d_place = deg_place ;
d_trans = deg_trans ;
%rq: avec conditions de possibiltiés + processus, on a le double en espérance de notre distribution de degré


% Matrice des processus
% pb on peut reconnecter indéfiniment les memes 
while sum(d_place)~=0 && sum(d_trans)~=0 && ~all(mat_process,"all")==1 %arrete si manque des degres ou matrice remplie de 1
idx_place = find(d_place>0);
idx_trans = find(d_trans>0);

idx_samp_p = idx_place(randi([1 length(idx_place)]) ) ; %sampled couple of place-transition linked
idx_samp_t = idx_trans(randi([1 length(idx_trans)]) ) ;

mat_process(idx_samp_t,idx_samp_p)=1;  % declarer le lien dans la matrice %si deja un 1, remet un 1 par dessus

d_place(idx_samp_p)= d_place(idx_samp_p)-1;
d_trans(idx_samp_t)= d_trans(idx_samp_t)-1;
end


% Matrice des conditions de possibilités  %attention fait qu'il y a
% forcément des contraintes ?
d_place = deg_place ;
d_trans = deg_trans ;
mat_possib = zeros(Nt,Np) ; % matrice avec transitions en ligne et places en colonne


while sum(d_place)~=0 && sum(d_trans)~=0 && ~all(mat_possib,"all")==1 %arrete si manque des degres ou matrice remplie de 1
idx_place = find(d_place>0);
idx_trans = find(d_trans>0);

idx_samp_p = idx_place(randi([1 length(idx_place)]) ) ; %sampled couple of place-transition linked
idx_samp_t = idx_trans(randi([1 length(idx_trans)]) ) ;

mat_possib(idx_samp_t,idx_samp_p)=1;  % declarer le lien dans la matrice %si deja un 1, remet un 1 par dessus

d_place(idx_samp_p)=d_place(idx_samp_p)-1;
d_trans(idx_samp_t)=d_trans(idx_samp_t)-1;
end  


%% Visualisation
% transfo en matrice d'adjacence
% processus
% adj_process = zeros(size(mat_process,1)+size(mat_process,2),size(mat_process,1)+size(mat_process,2)) ;
% adj_process(Np+1:Np+Nt,1:Np) = mat_process ; % adj_process(Np+2:Np+1+Nt,1:Np+1) = mat_process ;
% % G = graph(adj_process)
% pp = digraph(adj_process);
% plot(pp) ;

% condi de possibilités
% adj_contr = zeros(size(mat_process,1)+size(mat_process,2),size(mat_process,1)+size(mat_process,2)) ;
% adj_process(Np+1:Np+Nt,1:Np) = mat_possib ;
% pc = digraph(adj_process);
% hold on
% plot(pc) ;

%% Sorties pour réseau de Petri
ai = mat_possib ; % matrice d'adjacence input = flèches entrant dans transitions (flèche des contraintes)
ao = mat_process + mat_possib; % matrice d'adjacence sortante. = fleches sortant des transitions = processus + flèche contrainte

% Detecter si deux fleches ont la mm entree et la meme sortie (contrainte + processus ) 
clone = ao==2; % 1 = fleches à ajouter dans pdf_clo quand une transition + 1 contrainte entre mêmes noeuds
% clone = [ao==2, zeros(size(ao,1),1)]; % ajout de la ligne si puit dans reseau

ao(ao==2) = 1 ;% ramener à 1 dans la marice d'adjacence pour RdP

% % Ajouter le puit (dégradation des contraintes)
% % = 1 place qui n'a pas de sorties et qui est reliée à toutes les autres places
% % Matrice output : relier toutes les places au puit
% Ao = [ao, repmat(m,size(ao,1),1)] ;f
% Ai = [ai, zeros(size(ai,1),1)] ; 
Ai = ai ;
Ao = ao ;


network.Ai = Ai ;
network.Ao = Ao ;
network.clone = clone ;

%