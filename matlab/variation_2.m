%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code pour la variation dans le sys
% VERSION NON-UNIFORME, LES VARIATIONS
% NE PEUVENT QUE SE FAIRE DEPUIS DES PLACES
% ET DES TRANSITIONS PRESENTES DANS LA CLOTURE INITIALE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[network_var] = variation_2(reseau)
    global global_info
    Ai = reseau.Ai ;
    Ao = reseau.Ao ;
    clone = reseau.clone ;
    process = Ao - clone ;
    
    % Processus => ao - clone
    % Nombre de variations selon le taux de variation
    nv = binornd(sum(sum(Ao,2)>0),global_info.v) ;% n = nombre de variation max / p = taux de variation 
    % nombre de variation max = nb de transitions dans la cloture
    
    % Tirer emplacement des variations
    idx_trans = find(sum(Ao,2)>0);
    idx_row = datasample(idx_trans,nv); % tirage random parmi les trans existantes dans la cloture
    idx_col = randsample(size(process,2),nv) ; % tirage parmi toutes les places (en dehors et en dedans de la cloture)
    
    for i = 1:length(idx_row)
        if process(idx_row(i),idx_col(i)) == 0
            process(idx_row(i),idx_col(i)) = 1 ;
        else
            process(idx_row(i),idx_col(i)) = 0 ;
        end
    end
    
    % Sur les possibilisations => clo
    nv = binornd(sum(sum(Ao,1)>0),global_info.v) ;% n = nombre de variation max / p = taux de variation  
    % nombre de variation max = nb de places dans la cloture
    
    % Tirer emplacement des variations
    idx_row = randsample(size(Ao,1),nv) ;  % without replacement
    idx_place = find(sum(Ao,1)>0); % tirage random parmi les places existantes dans la cloture
    idx_col = datasample(idx_place,nv); % tirage parmi toutes les trans (en dehors et en dedans de la cloture)

    for i = 1:length(idx_row)
        if Ai(idx_row(i),idx_col(i)) == 0
            Ai(idx_row(i),idx_col(i)) = 1 ;
        else
            Ai(idx_row(i),idx_col(i)) = 0 ;
        end
    end
    
Ao = process + Ai ; 

network_var.Ao = Ao ;
network_var.Ai = Ai ;
network_var.clone = Ao==2;
network_var.Ao(network_var.Ao==2) = 1 ;
end