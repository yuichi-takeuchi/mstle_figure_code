%% Powerspectrum figure S8 compare successful trials and unsuccessful trials
% (C) LI QUN 2020
% combined 7 rats
%%
clc
clear
%loadcate pwrspctrm first
load('../data/Powerall.mat')
%%
xtick = [1,4,13,30,50,90,150];
nch = numel(chname);
for i = 1:nch
% for i = 1:1
    set(0,'DefaultFigureVisible','off')
    hfig = figure;   

    Y1(:,1) = powermean{1}(:,i);
    Y1(:,2) = powermean{2}(:,i);    
    Y1bar(:,1) = powerstd{1}(:,i);
    Y1bar(:,2) = powerstd{2}(:,i);        
%     hb1 = logshadedErrorBar_150(f',Y1(:,1)',Y1bar(:,1)','lineprops','-r');%suc
    logshadedErrorBar_150(f',Y1(:,1)',Y1bar(:,1)','lineprops','-r');%suc
    hold on
%     hb2 = logshadedErrorBar_150(f',Y1(:,2)',Y1bar(:,2)','lineprops','-b');%unsuc
    logshadedErrorBar_150(f',Y1(:,2)',Y1bar(:,2)','lineprops','-b');%unsuc
%     title(chname{i},'FontSize',20);
    xlabel('Frequency (Hz)','FontSize',20);
    ylabel('Power (a.u.)','FontSize',20);
    set(gca,'xtick',[]);        
    set(gca,'xlim',[1,3*10^2], ...
        'XTick',xtick); 
    % ======== add frequency line ======
%     xf = repmat(xtick,20,1);
%     ytick = get(gca,'Ylim');
%     yf = linspace(ytick(1),ytick(end),20);
%     yf = repmat(yf,length(xtick),1);
%     plot(xf,yf','m--');
%     hold off   
    clear Y1 Y1bar     
%     legend([hb1.mainLine,hb2.mainLine],{'suc','unsuc'})
    box off
%     ax2 = axes('Position',get(gca,'Position'),...
%                'XAxisLocation','top',...
%                'YAxisLocation','right',...
%                'Color','none',...
%                'XColor','k','YColor','k');
%     set(ax2,'YTick', []);
%     set(ax2,'XTick', []);
%     box on
    set(hfig,...
    'Unit', 'centimeters',...
    'PaperSize', [10 7],...
    'paperposition', [0 0 10 7],...
    'renderer','painters')
    print(gcf,'-dpdf',strcat(['../results/ch-' num2str(i) '-' chname{i}]));
    close gcf
end
disp('finished')
clear i Y1 hfig xf yf ystar ytick Y1bar xtick 
%% ===============================draw band pics==========================
band = [1,4;4,12;13,30;30,45;45,90];
[bandnum,n] = size(band);
xtext = cell(bandnum,1);
for i = 1:bandnum
    xtext{i} = [num2str(band(i,1)) '-' num2str(band(i,2)) 'Hz'];
end
for i = 1:nch
% for i = 1:1
    set(0,'DefaultFigureVisible','off')
    hfig = figure; 
    Y1 = [bandmean{1}(:,i),bandmean{2}(:,i)];
    errhigh = [bandstd{1}(:,i),bandstd{2}(:,i)]; 
    star = Stats_h{1}(:,i);
    pstar = Stats_p{1}(:,i);
    % bar              
    hb = bar(Y1,'FaceColor','flat');
    hb(1).CData(1,:) = [1 0 0];
    hb(1).CData(2,:) = [1 0 0];
    hb(1).CData(3,:) = [1 0 0];
    hb(1).CData(4,:) = [1 0 0];
    hb(1).CData(5,:) = [1 0 0];
    hb(2).CData(1,:) = [0 0 1];
    hb(2).CData(2,:) = [0 0 1];
    hb(2).CData(3,:) = [0 0 1];
    hb(2).CData(4,:) = [0 0 1];
    hb(2).CData(5,:) = [0 0 1];
    X = hb.XData;  
    hold on
    %error
    errorbar(X-0.15,Y1(:,1),errhigh(:,1),...
        'LineWidth',0.5,'CapSize',3,...
        'LineStyle','none','Color',[0 0 0]);
    errorbar(X+0.15,Y1(:,2),errhigh(:,2),...
        'LineWidth',0.5,'CapSize',3,...
        'LineStyle','none','Color',[0 0 0]);
    ylim = get(gca,'Ylim');
    set(gca,'YLim',[0,ylim(end)+ylim(end)/3])
    set(gca,'XTickLabel',xtext,'Fontsize',20);    
    ylabel('Power (a.u.)','FontSize',20);   
    title(chname{i},'FontSize',20);

    % ===== star ========
   for s = 1:bandnum
       if star{s}~=0
          if pstar(s)<=0.001
              txt = '***';
              text(X(s)+0.1,Y1(s,2)+errhigh(s,2)+ylim(end)/30,txt, 'FontSize', 20);
          else if pstar(s)<=0.01
                  txt = '**';
                  text(X(s)+0.1,Y1(s,2)+errhigh(s,2)+ylim(end)/30,txt, 'FontSize', 20);
              else if pstar(s)<=0.05
                      txt = '*';
                      text(X(s)+0.1,Y1(s,2)+errhigh(s,2)+ylim(end)/30,txt, 'FontSize', 20);
                  end
              end
          end    
       end
    end
    hold off
    legend([hb(1),hb(2)],{'suc','non-suc'},'Location','northwest')

    set(hfig,...
    'Unit', 'centimeters',...
    'PaperSize', [10 7],...
    'paperposition', [0 0 10 7],...
    'renderer','painters')
    print(gcf,'-dpdf',strcat(['../results/Band-ch-' num2str(i) '-' chname{i}]));
    close gcf
end
clear i j X Y1 hfig  hb xf yf1 yf2 xstar star s xlim ylim errhigh
disp('finished')
%% tide up stat results
t1 = zeros(5,8);
for i = 1:5
    for j = 1:8
%         t1(i,j) = Stats_stat{1}{i,j}.tstat;
%         t1(i,j) = Stats_stat{1}{i,j}.df;        
%         t1(i,j) = Stats_h{1}{i,j};         
    end
end
%%
t1 = Stats_p{1};
t1 = round(t1*1000)./1000;
t1(:,[4,6])=[];