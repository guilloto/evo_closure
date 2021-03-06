% Fichier pour définir le RdP
function [pns] = pn_def_test()

pns.PN_name = '2 cloture à 2 parties reliées';

% set of places %
pns.set_of_Ps = {'E1' , 'F1' %, ... % parties de la cloture initiale 
%                  'E2' , 'F2' ... %
                 %, ... % puit
%                  'S1','S2' ... % substrats
                 }; 

% set of transitions %
% ATTENTION les transitions des clotures doivent commencer par un T
pns.set_of_Ts = {'T11', 'T12' %, ... % transitions/fonctions de la cloture initiale 
%                  'T21', 'T22' %, ...
%                  'VE12','VE21', ... 
%                  'VF12','VF21', ... 
%                  'TP' ... % puit
                 }; 
             
% set of arcs %
pns.set_of_As = {'E1'  , 'T11' ,1 , ... % cloture initiale E1-F1
                 'T11' , 'E1'  ,1
                 'T11' , 'F1'  ,1 , ...
                 'F1'  , 'T12' ,1 , ...  
                 'T12' , 'E1'  ,1 %, ...
                 ...
%                  'E1'  , 'VE12',1 , ... % reseau des variants
%                  'VE12', 'E2'  ,1 , ... 
%                  'E2'  , 'VE21',1 , ...  % variation inverse  
%                  'VE21', 'E1'  ,1 , ... 
%                  ...
%                  'F1'  , 'VF12',1 , ...
%                  'VF12', 'F2'  ,1 , ...
%                  'F2'  , 'VF21',1 , ...
%                  'VF21', 'F1'  ,1 , ...
%                  ...      
%                  'E2'  , 'T21' ,1 , ... % cloture E2-F2
%                  'T21' , 'E2'  ,1 , ...
%                  'T21' , 'F2'  ,1 , ...
%                  'F2'  , 'T22' ,1 , ...
%                  'T22' , 'F2'  ,1 , ...
%                  'T22' , 'E2'  ,1 , ... 
%                  ...
%                  'E1'  ,'TP' ,1 , ... % puits
%                  'F1'  ,'TP' ,1 , ...
%                  'E2'  ,'TP' ,1 , ...
%                  'F2'  ,'TP' ,1 , ...
%                  'TP'  ,'P'  ,1 %, ...
%                  'F1'  , 'VE12',1 , ...  % F1 contraint la variation d'E1
%                  'VE12', 'F1'  ,1 , ...
%                  'F2'  , 'VE21',1 , ...  % F2 contraint la variation d'E2
%                  'VE21', 'F2'  ,1  ... 
%                                          %E2 contraint la variation de F1
%                                          % .....
%                  'S1' , 'T11' ,1 , ...  % substrats en commun avec tt les clotures
%                  'S2' , 'T12' ,1  ...
                 }; 
end
% 
% function [pns] = pn_def_test()
% 
% % pns.PN_name = '2 cloture à 2 parties reliées';
% % 
% % % set of places %
% % pns.set_of_Ps = {'E1' , 'F1' , ... % parties de la cloture initiale 
% %                  }; 
% % 
% % % set of transitions %
% % % ATTENTION les transitions des clotures doivent commencer par un T
% % pns.set_of_Ts = {'T11' % puit
% %                  }; 
% %              
% % % set of arcs %
% % pns.set_of_As = {'T11'  , 'E1' ,1 , ... % cloture initiale E1-F1
% %                  'E1'  , 'T11' ,1 , ...
% %                  'T11' , 'E1'  ,1 , ...
% %                  'T11' , 'F1'  ,1 , ...
% %                  'F1'  , 'T11' , 1
% %                  }; 
% % end
% 
% % dans PNS:
% % global_Vplaces = jetons qui résident dans des transitions lancées
% 
% % Example-32: Testing automatic PDF creation
% % Ai: input incidence matrix
% Ai = [0 1 0 0 0 0; ...
% 1 0 0 0 0 1; ...
% 0 0 0 1 1 0; ...
% 0 0 1 0 0 0];
% % Ao: output incidence matrix
% Ao = [1 0 0 0 1 0; ...
% 0 1 0 0 0 0; ...
% 0 0 1 0 0 0; ...
% 0 0 0 1 0 1];
% % optional: name for the PDF to be created
% PDF_Filename = 'ex_32_pdf.m';
% % optional: name for the Petri net
% PN_name = 'Example 32 for automatic PDF creation';
% % call the functio to create the PDF file
% createPDF(Ai, Ao, PDF_Filename, PN_name);
% end