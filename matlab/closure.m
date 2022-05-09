% fonction pour mesurer cloture

% ATTENTION les transitions des clotures doivent commencer par un T
% ne permet pas de checker des clotures émergeantes non définies

function[] = closure(SimResults)
% avec transitions permises
enabled_t = sim.Enabled_Trans_SET(:,2:end); %enlever la premiere colonne de temps
sim.global_transitions.name % noms des transitions

% a faire plus proprement pour tourner avec ts les reseaux
t_clo = contains({sim.global_transitions.name},"T") ; %prend les transitions nommées avec un T !!!!!!!!!!
enabled_trans = enabled_t(:,t_clo) ; % extrait les transitions permises des clotures. 1ligne = 1 loop

 col = 1:n_part:(n_clo*n_part) ;
 col1 = 2:n_part:(n_clo*n_part) ;
 
 is_clo = ones(size(enabled_trans,1),n_clo) ; % nombre de loop en ligne, cloture en colonne
 
for n = 1:n_clo
   is_clo(:,n) = all(enabled_trans(:,col(n):col1(n)),2) ; %check par ligne si tt transitions d'une cloture actives
% ajouter noms des clotures réalisées

end

% Transitions permises sur au moins 1 pas de temps 
any(is_clo,1)

% Transitions permises sur tous les pas de temps une fois activé
% !!!!!! %


%% avec transitions effectuées
sim.Firing_Trans_SET

