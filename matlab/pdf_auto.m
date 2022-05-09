function [] = pdf_auto(Ai, Ao, clone)
% optional: name for the PDF to be created
PDF_Filename = 'pdf_clo.m';    

% optional: name for the Petri net 
PN_name = 'no name';

% call the function to create the PDF file
createPDF_edit(Ai, Ao, clone, PDF_Filename, PN_name); % ajouter les flèches invisibles dans les matrices (quand il y a auto-contrainte)



