% mainPlotter
clc; clear; close all;
pList=[0,1,2];
lList=[-2,-1,0,1,2];
sigmaList=[-1,0,1];
N=200; % Grid Points
savePath='plots/';  mkdir(savePath);

total=length(pList)*length(lList)*length(sigmaList);
idx=1;
for i=1:length(pList)
    for j=1:length(lList)
        for k=1:length(sigmaList)
            p=pList(i);
            l=lList(j);
            sigma=sigmaList(k);
            if l==0 && p>0
                idx=idx+1;
                continue
            end
            close all;
            funcCalc(l,p,sigma,N, savePath);
            clc;
            disp(['p=', num2str(p), ', l=', num2str(l), ', sigma=',num2str(sigma),', '  num2str(idx/total*100, '%2.2f'),'% complete'])
            idx=idx+1;
        end
    end
end
