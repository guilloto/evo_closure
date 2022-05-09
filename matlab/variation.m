%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code pour la variation dans le sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[network_var]=variation(reseau)
global global_info
Ai = reseau.Ai ;
Ao = reseau.Ao ;
clone = reseau.clone ;
process = Ao - clone ;

% Processus => ao - clone
% Nombre de variations selon le taux de variation
nv = binornd(size(Ao,2),global_info.v) ;% n = nombre de variation max p = taux de variation  % !!!! nombre de variation max défini arbitrairement !!!!!!!!

% Tirer emplacement des variations
idx_row = randsample(size(process,1),nv) ;  % without replacement
idx_col = randsample(size(process,2),nv) ; % 
    
    for i = 1:length(idx_row)
        if process(idx_row(i),idx_col(i)) == 0
            process(idx_row(i),idx_col(i)) = 1 ;
        else
            process(idx_row(i),idx_col(i)) = 0 ;
        end
    end

% Sur les possibilisations => clo

 nv = binornd(global_info.Np,global_info.v) ;% n = nombre de variation max p = taux de variation  % !!!! nombre de variation max défini arbitrairement !!!!!!!!
    
    % Tirer emplacement des variations
    idx_row = randsample(size(Ai,1),nv) ;  % without replacement
    idx_col = randsample(size(Ai,2),nv) ; % 

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