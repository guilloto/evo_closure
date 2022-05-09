% Ancienne version où les contraintes étaient définies après les processus
% selon généralité et redondance. ATTENTION erreur pour la redondance.

Np = 20 ; % Nombre de places (d'entités)
Nt = 20 ; %Nb transitions total 


Wi = zeros(Nt,Np) ; % input incidence matrix pour les contraintes %peut on pré-allouer?
Wo = zeros(Nt,Np) ; % output incidence matrix pour les contraintes
Wp = zeros(Nt,Np) ; % matrice pour les processus (entrante)


% Conditions initiales


% Tirer le nombre de transitions contraintes par la place (nb de 1 sur une colonne)
Wi(:,1)= (randsample([0,1],Nt,true,[1-G,G]))' ; % on ne dépend pas de la redondance car 1 seule place
Wo(:,1) = Wi(1,:) ; % double flèche de contrainte

% Tirer les transitions entrantes (nb colonne de la matrice)
% Plus simple: tirer le nombre de transitions total du réseau
% dépend de quoi? quel max?


% Création du réseau de processus

% Réseau de contraintes
% Généralité
% proba de tirer un grand nombre de contrainte pour UNE place  = proba qu'il y ait plusieurs 1 sur la meme ligne
G = 0.5 ; % G=1 : très généraliste

% Redundancy
% proba de relier à une transition sachant qu'elle est déjà reliée = proba de tirer plusieurs 1 ds mm colonne 
% parametres: [-1,1]. 0 = autant de proba de relier que de ne pas relier 
R = 0.8 ; 

for i = 2:Np % 1 iteration = 1 place
% Tirer les transitions entrantes (processus)

% peut etre une existante ou une nouvelle. Si nouvelle, matrice grandit

%tirage nombre de processus produisant la place = 1 dans les flux entrants
Nt = 3 ;
% 


% Tirer les contraintes
% doivent pouvoir être tirées dans les transitions reliées plus tôt. 

% transitions activées plus tôt = 1 sur la ligne précédente
% chercher transitions déjà reliées sur lesquelles peuvent agir les
% contraintes
find(any(Wi(:,1:i-1)==1,2)) %donne l'indice des lignes non nulles à gauche de la colonne en cours


Wi(:,1:i)==1 ;

ncmax = size(Wi,1) + size(Wi,2) ; % nb max de contrainte = nombre de place + nb transition déjà activées soit car processus de celle ci soit car processus d'un autre
                             % auto-contrainte permise

                             
                             % selon generalité
nc = sum(randsample([0,1], size(Wi,1),true,[1-G,G])) ; % Tirer le nombre de transitions contraintes par la place (nb de 1 sur une colonne)

% tirer emplacement des 1 selon redondance
vf = 1/size(Wi,1) + R * sum(Wi,2) ; %1/n : meme proba de partout au début
alloc = datasample(1:size(vf,2),nc, 'Replace', false, 'Weights', vf) ; %Datasample normalise

ligne = zeros(Nt) ;
Wi(alloc,i+1) = 1 ;


% mettre à jour matrice
Wo(:,i) = vf ;
Wo(:,i) = Wi(:,i) ; % double flèche de contrainte

end