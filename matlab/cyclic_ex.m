% Example-33: Large Cyclic example
% testing “createPDF” that can automatically create a PDF.
clear all; clc;

m = 1000; % number of places; 
n = 1000; % number of transitions

% input incidence matrix
Ai = eye(n, m);

% output incidence matrix
Ao = zeros(m, n); 
for i = 1: n-1, 
    Ao(i, i+1) = 1; 
end; 
Ao(n,1)=1;

% optional: name for the PDF to be created
PDF_Filename = 'ex_33_pdf.m';    

% optional: name for the Petri net 
PN_name = 'Example-33: (Cyclic PN) for automatic PDF creation';

% call the functio to create the PDF file
createPDF(Ai, Ao, PDF_Filename, PN_name);

