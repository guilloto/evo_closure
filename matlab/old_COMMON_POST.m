% Code commun  toutes les transitions

% Océane Guillot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = COMMON_POST(transition)
global PN
global global_info

% ATTENTION AVEC CETTE METHODE UNE CONTRAINTE PEUT DEVENIR UN PROCESSUS ET
% INV, ET L AUTO-CONTRAINTE N EST PAS PRISE EN COMPTE

% % tirer ou non des variations selon le taux de variation
% if rand<global_info.v %v taux de variation
if length(transition.name)~=0 && rand<global_info.v % && PN.Loop_Nr>50

%     nv = sum(randsample([0,1], size(Wi,1),true,[1-G,G])) ; % Tirer le nombre de transitions contraintes par la place (nb de 1 sur une colonne)
%     
%     et selon le type de variation? (gradualisme - saltationnisme)

    % Nombre de variations
    nv = randi(size(PN.incidence_matrix,2),1) ; % !!!! nombre de variation max défini arbitrairement !!!!!!!!

    % Tirer emplacement des variations
    idx_row = randi(size(PN.incidence_matrix,1),nv,1) ;  % size -1 si puits dans reseau
    idx_col = randi(size(PN.incidence_matrix,2),nv,1) ; % size -1 si puits dans reseau
    
    for i = 1:length(idx_row)
        if PN.incidence_matrix(idx_row(i),idx_col(i)) == 0
            PN.incidence_matrix(idx_row(i),idx_col(i)) = 1 ;
        else
            PN.incidence_matrix(idx_row(i),idx_col(i)) = 0 ;
        end
    end
    
end



end

 % Update list of enabled trans after token removal
%             for j = 1:No_of_enabledTrans %check events one by one 
%                 t2 = set_of_ordered_enabledTrans(j); 
%                 PN.Enabled_Transitions(t2) = enabled_transition(t2); % recheck 
%             end      

% Ressources (old)
%    release(transition.name); % after firing, transitions release resources

%version développée
% switch transition.name
%     case 'T11'
%         release('T11'); %relache tt les ressources acquises
%     case 'T12'
%         release('T12');
%     case 'T21'
%         release('T21');
%     case 'T22'
%         release('T22');
%     otherwise % si aucun cas n'est rempli
