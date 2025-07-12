
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% PBCT_RenommeFeuilleExcel                                    %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%
% This Matlab script has been developped by Marc Thevenet.2021 %
%"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""%

function PBCT_RenommeFeuilleExcel(NomFicExcel, NbNom, ListeNom, ListePage)

% Rename Excel sheets using ActiveX function call
%=======================================================
e = actxserver('Excel.Application');
ewb = e.Workbooks.Open(NomFicExcel);
for i=1:NbNom
    ewb.Worksheets.Item(ListePage(i)).Name = ListeNom{i};
end
ewb.Save
ewb.Close(false)
e.Quit

end
