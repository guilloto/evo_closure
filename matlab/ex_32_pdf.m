% This PDF file was generated by "createPDF" function on 
% On 21-Apr-2022   at 15:59:9
% PDF: ex_32_pdf.m

function [png] = ex_32_pdf()

png.PN_name = 'Example 32 for automatic PDF creation';
png.set_of_Ps = {'p1','p2','p3','p4','p5','p6'};
png.set_of_Ts = {'t1','t2','t3','t4'};
png.set_of_As = {'p2','t1',1, 't1','p1',1, 't1','p5',1, ... % t1
                 'p1','t2',1, 'p6','t2',1, 't2','p2',1, ... % t2
                 'p4','t3',1, 'p5','t3',1, 't3','p3',1, ... % t3
                 'p3','t4',1, 't4','p4',1, 't4','p6',1, ... % t4
               };