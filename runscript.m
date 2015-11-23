% function runscript
close all; clear all;
load resforfit001;

% Pfs=[0.0005, 0.0006, 0.0007, 0.0008, 0.0009,...
%     0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, 0.01];
% Pfslen=length(Pfs);
nsttl=66;

fitfuncs= cell( nsttl, 1 );

for i=1:nsttl%11:13%2:41%length(myfitgroup);% 
    if isempty(resforfit{i}), continue;end
    Pf=resforfit{i}(:,2); 
    mu=resforfit{i}(:,1);
%     Pfix=resforfit{i}(:,3); 
    % To fit Pf and mu
    [fitresult, gof] = Fitsmu2Orig(Pf, mu,i);
%     select=2;
%     if i<12, select=1; else select=2; end
%     fitfuncs{i,j}=fitresult{select};
%     MyexperimentalFitsOrigPow(Pf, mu,i); 
%    To fit Pfix and Pf
%     FitFixrateRat02(Pf, Pfix,i);
%     close all;
end
% save('FitFuncsMuPfILS.mat','fitfuncs');