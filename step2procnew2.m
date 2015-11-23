% function FFRTtable()
clear; clc; close all;
% restsrc(resrowcnt,:)=[ep, na, Psb, Pfttls(ipf), ns, Pf1s(ipf), ns2(ipf), Pssub2, Pf2req, themu2(ns,i),thefixrate2(ns,i), thefailrate2(ns,i)];%Pfix1,

Pfttls=[0.001,0.01]';
Pfttlslen=length(Pfttls);

Pf2s=[0.0001:0.0001:0.001,0.002:0.001:0.01,0.02:0.01:0.1]';
Pf2slen=length(Pf2s);

% tsrcclnep=1;tsrcclnna=2;tsrcclnPsb=3;tsrcPfttl=4;
tsrcclnns1=5;tsrcclnPf1req=6;
% tsrcclnns2=7;
% tsrcclnPssub2=8;tsrcclnPf2req=9;tsrcclnmu2=10; tsrcclnPfix2=11;
% tsrcclnPf2=12;

tsrcclnep=1;tsrcclnna=2;tsrcclnPsb=3;tsrcclnPfttl=4;tsrcclnns=5;tsrcclnPf1=6;tsrcclnPfix1=7;
tsrcclnns2=8;tsrcclnPssub2=9;tsrcclnPf2req=10;tsrcclnmu2=11;tsrcclnPfix2=12; tsrcclnPf2=13;

load('options.mat');
% PfPfixns=cell(Pfslen,maxns);
maxns=66;
Pfttl=0.001;
% for filei=[122:5:137,302:5:317]
maxna=0;
% minns2=40;
% resns1s=cell(70,1);
resns2s=cell(maxns,1);

Pfix1s=cell(maxns,1);
respsall=[];
for i=1:maxns, resns2s{i,1}=[]; end
for filei=[1:155,157:540]%[142:5:157,322:5:337]
    % for filei=[162:5:177,342:5:357]
    filei
    filename=opts(filei).filename;%fgetl(fidfs)
    filenametxt=strcat('TSRC_',filename,'.txt');
    if ~exist(filenametxt,'file')
        display(strcat(filenametxt,' not found!'));
        continue;
    end
    resep=load(filenametxt);
    if size (resep,1)==0
        display(strcat(filenametxt, ' empty!'));
        continue;
    end
    
    
    indx=resep(:,tsrcclnPfttl)==Pfttl;
    resepa=resep(indx,:); clear resep;
    if isempty(resepa)
        continue;
    end
    for ns2=1:maxns
        indx=resepa(:,tsrcclnns1)==ns2;
        resepb=resepa(indx,:);
        
        indx=resepb(:,tsrcclnPsb)>=0.8;%Psb>0.8
        
        %         indx=resepb(:,tsrcclnPfix2)>=0.05;%10^3 samples at least
        resepc=resepb(indx,:);
        
        idx1=resepc(:,tsrcclnmu2)==0;
        idx2=resepc(:,tsrcclnPfix1)>=0.90;
        idx=idx1&idx2;
        resepc(idx,:)=[];
        
        
        resns2s{ns2,1}=[resns2s{ns2,1};resepc];
        
    end
    
end
fontsize=15;

resepall=[];
resforfit=cell(maxns,1);
for i=1:length(resns2s)
    resepall=[resepall;resns2s{i,1}];
    minmus=nan(Pf2slen,1);
    for j=1:Pf2slen
        idx=abs(resns2s{i,1}(:,tsrcclnPf2req)-Pf2s(j))<1E-4;%Pf2s(j);
        tmparray=resns2s{i,1}(idx,tsrcclnmu2);
        if ~isempty(tmparray)
            minmus(j)=min(tmparray);
        end
    end
    idx=isnan(minmus);
    minmus(idx)=[];
    tmpxbins=Pf2s;
    tmpxbins(idx)=[];
    resforfit{i}=[minmus,tmpxbins];
end
save('resns2s001.mat','resns2s');
save('resforfit001.mat','resforfit');
% remove the result of mu2=0 caused by too high Pfix1.
% idx1=resepall(:,tsrcclnmu2)==0;
% idx2=resepall(:,tsrcclnPfix1)>=0.90;
% idx=idx1&idx2;
% resepall(idx,:)=[];


%    figure(100);
%    subplot(2,1,1);
%     scatter(resepall(:,tsrcclnPf2req),resepall(:,tsrcclnmu2),5,resepall(:,tsrcclnns2),'filled'); colorbar; colormap hsv;%jet%hold on;
%    subplot(2,1,2);
%     scatter(resepall(:,tsrcclnPf2req),resepall(:,tsrcclnmu2),5,resepall(:,tsrcclnPfix1),'filled'); colorbar; colormap hsv%jet%hold on; Pfix1
figure(101);
%    subplot(2,1,1);
scatter(resepall(:,tsrcclnPf2),resepall(:,tsrcclnmu2),5,resepall(:,tsrcclnns2),'filled'); colorbar; colormap hsv;%jet%hold on;
%     title('\mu_2 against P_f_,_2^t^o^l');
title('P_f_,_t_t_l^t^o^l=0.001, P_f_,_1^t^o^l=0.0009');

xlabel('P_f_,_2^t^o^l','FontSize',fontsize+5);
ylabel('\mu_2','FontSize',fontsize+5);
set(gca,'FontSize',fontsize+5);
