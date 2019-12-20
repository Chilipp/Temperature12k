%make new paico structure from arc2k data


all=importdata('~/Dropbox/ML_Scripts/Sami/Arc2k.csv');
load ProxyData

%this way doesn't get sample support quite right (probably, improved now)
year=all.data(:,1);
annNames=all.textdata(2,2:37);
nonannNames=all.textdata(2,38:2:end);
annData=all.data(:,2:37);
nonannData=all.data(:,38:2:end);
nonannsupport=all.data(:,39:2:end);

%process ann data
for i=1:size(annData,2)
    arc.proxy{i,1}.id=annNames{i};
    
    if strcmp(arc.proxy{i,1}.id,'Bird2009')
        good=find(year>=730 & ~isnan(year) & ~isnan(annData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{i,1}.id,'DArrigo2009 Cop')
        good=find(year>=1288 & ~isnan(year) & ~isnan(annData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{i,1}.id,'HaltiaHovi2007')
        good=find(year<=1800 & ~isnan(year) & ~isnan(annData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{i,1}.id,'Kirchhefer2001 For')
        good=union(find(year>=1254 & year<=1271 & ~isnan(year) & ~isnan(annData(:,i))),find(year>=1277 & year<=1993 & ~isnan(year) & ~isnan(annData(:,i))));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{i,1}.id,'MacDonald1998')
        good=find(year>=1490 & ~isnan(year) & ~isnan(annData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{i,1}.id,'Ojala2005')
        good=find(year<=1800 & ~isnan(year) & ~isnan(annData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{i,1}.id,'Tiljander2003')
        good=find(year<=1720 & ~isnan(year) & ~isnan(annData(:,i)));
        arc.proxy{i,1}.id
  
    else
        good=find(~isnan(year) & ~isnan(annData(:,i)));
    end
    
    
    arc.proxy{i,1}.times= year(good)';
    arc.proxy{i,1}.data= annData(good,i)';
    oldi=find(strcmp(annNames{i},P.Arc.RecNames));
    % if P.Arc.TempRelate(oldi)==-1 & ~strcmp(annNames{i},'Larsen2011')
    if P.Arc.TempRelate(oldi)==-1
        arc.proxy{i,1}.data= arc.proxy{i,1}.data*-1;
        annNames{i}
    end
    
    arc.proxy{i,1}.locations=[P.Arc.Lat(oldi) P.Arc.Lon(oldi)];
end
%process nonann data
nonanni=(size(annData,2)+1:size(nonannData,2)+size(annData,2));
for i=1:size(nonannData,2)
    arc.proxy{nonanni(i),1}.id=nonannNames{i};
    
    if strcmp(arc.proxy{nonanni(i),1}.id,'Bird2009')
        good=find(year>=730 & ~isnan(year) & ~isnan(nonannData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{nonanni(i),1}.id,'DArrigo2009 Cop')
        good=find(year>=1288 & ~isnan(year) & ~isnan(nonannData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{nonanni(i),1}.id,'HaltiaHovi2007')
        good=find(year<=1800 & ~isnan(year) & ~isnan(nonannData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{nonanni(i),1}.id,'Kirchhefer2001 For')
        good=union(find(year>=1254 & year<=1271 & ~isnan(year) & ~isnan(nonannData(:,i))),find(year>=1277 & year<=1993 & ~isnan(year) & ~isnan(nonannData(:,i))));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{nonanni(i),1}.id,'MacDonald1998')
        good=find(year>=1490 & ~isnan(year) & ~isnan(nonannData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{nonanni(i),1}.id,'Ojala2005')
        good=find(year<=1800 & ~isnan(year) & ~isnan(nonannData(:,i)));
        arc.proxy{i,1}.id
    elseif strcmp(arc.proxy{nonanni(i),1}.id,'Tiljander2003')
        good=find(year<=1720 & ~isnan(year) & ~isnan(nonannData(:,i)));
        arc.proxy{i,1}.id
    else
        good=find(~isnan(year) & ~isnan(nonannData(:,i)));
    end
    arc.proxy{nonanni(i),1}.times= year(good)';
    arc.proxy{nonanni(i),1}.data= nonannData(good,i)';
    oldi=find(strcmp(nonannNames{i},P.Arc.RecNames));
    if P.Arc.TempRelate(oldi)==-1
        arc.proxy{nonanni(i),1}.data=arc.proxy{nonanni(i),1}.data*-1;
        nonannNames{i}
    end
    arc.proxy{nonanni(i),1}.locations=[P.Arc.Lat(oldi) P.Arc.Lon(oldi)];
    arc.proxy{nonanni(i),1}.lower= (year(good)-nonannsupport(good,i)./2)';
    arc.proxy{nonanni(i),1}.upper= (year(good)+nonannsupport(good,i)./2)';
    %check on lower and upper
    %make sure no overlap
    ovc=arc.proxy{nonanni(i),1}.lower(2:end)-arc.proxy{nonanni(i),1}.upper(1:end-1);
    ovci=find(ovc<.5);
    arc.proxy{nonanni(i),1}.upper(ovci)=arc.proxy{nonanni(i),1}.upper(ovci)+ovc(ovci)-1;
    
    %support
    newsupport=arc.proxy{nonanni(i),1}.upper-arc.proxy{nonanni(i),1}.lower+1;
    sd=newsupport-nonannsupport(good,i)';
    ws=find(sd~=0);
    arc.proxy{nonanni(i),1}.upper(ws)=arc.proxy{nonanni(i),1}.upper(ws)-sd(ws);
    newsupport=arc.proxy{nonanni(i),1}.upper-arc.proxy{nonanni(i),1}.lower+1;
    sd=newsupport-nonannsupport(good,i)';
    suppdiff(nonanni(i),1)=max(abs(sd));
    
end
load arcinstrumental.mat
arc.instrumental=arcinst;
arc.instrumental.data=arc.instrumental.WM;
arc.target.times=0:2000;
save ~/Dropbox/ArcPaicoData.mat arc
%%
%try building from P
clear arc
load ProxyData.mat
t=1;
clear compname
for i=1:size(P.Arc.DatMat,2)
    arc.proxy{i,1}.locations=[P.Arc.Lat(i) P.Arc.Lon(i)];
    arc.proxy{i,1}.id=P.Arc.RecNames{i};
    if strcmp(arc.proxy{i,1}.id,'Vinther2008 Aga')
        cX=P.Arc.Year; cY=P.Arc.DatMat(:,i); cXmax=cX; cXmin=cX; cflag=0;
    else
        [cX,cY,cXmax,cXmin,cflag]=compress_record(P.Arc.Year,P.Arc.DatMat(:,i),.3);
    end
    if cflag
        compname{t,1}=P.Arc.RecNames{i};
        t=t+1;
    end
    if 1
        %truncate records that need truncating (based on email from sami with
        %transforms)
        if 0%strcmp(arc.proxy{i,1}.id,'Bird2009')
            good=find(cX>=730);
            arc.proxy{i,1}.id
        elseif 0%strcmp(arc.proxy{i,1}.id,'DArrigo2009 Cop')
            good=find(cX>=1288);
            arc.proxy{i,1}.id
        elseif strcmp(arc.proxy{i,1}.id,'HaltiaHovi2007')
            good=find(cX<=1800);
            arc.proxy{i,1}.id
        elseif 0%strcmp(arc.proxy{i,1}.id,'Kirchhefer2001 For')
            good=union(find(cX>=1254 & cX<=1271),find(cX>=1277 & cX<=1993));
            arc.proxy{i,1}.id
        elseif 0%strcmp(arc.proxy{i,1}.id,'MacDonald1998')
            good=find(cX>=1490);
            arc.proxy{i,1}.id
        elseif strcmp(arc.proxy{i,1}.id,'Ojala2005')
            good=find(cX<=1800);
            arc.proxy{i,1}.id
        elseif strcmp(arc.proxy{i,1}.id,'Tiljander2003')
            good=find(cX<=1720);
            arc.proxy{i,1}.id
        else
            good=find(~isnan(cX));
        end
    else
        good=find(~isnan(cX));
    end
    cX=cX(good);
    cY=cY(good);
    cXmax=cXmax(good);
    cXmin=cXmin(good);
    
    %invert proxies that need inverting
    if strcmp(arc.proxy{i,1}.id,'Serjup2011') | strcmp(arc.proxy{i,1}.id,'Tiljander2003') | strcmp(arc.proxy{i,1}.id,'Linge2009') | strcmp(arc.proxy{i,1}.id,'Sha2011')% | strcmp(arc.proxy{i,1}.id,'Larsen2011')
        cY=cY*-1;
        arc.proxy{i,1}.id
    end
    
    %assign to structure
    arc.proxy{i,1}.times=cX';
    arc.proxy{i,1}.data=cY';
    if cflag
        arc.proxy{i,1}.upper=cXmax';
        arc.proxy{i,1}.lower=cXmin';
    end
    
end
load arcinstrumental.mat
arc.instrumental=arcinst;
arc.target.times=0:2000;





%%

nicksARC=result.signal;%-mean(result.signal(find(result.times>=1961 & result.times<=1990)));
%correctedARC=result.signal-mean(result.signal(find(result.times>=1961 & result.times<=1990)));

figure(2)
clf
subplot(211)
plot(OrigRecon.Arc.Temp,'k')
hold on
plot(nicksARC,'r')
legend('Original (Pages 2k 2013)','Updated')
xlim([0 2000])
xlabel('Year AD')
ylabel('Temperature Anomaly (\circC)')
set(gca,'TickDir','out')


subplot(223)
plot(OrigRecon.Arc.Temp,nicksARC,'k.')
axis square
xlim([-2.5 1.5])
ylim(xlim)
hold on
plot([-2.5 1.5],[-2.5 1.5],'r')
xlabel('Original Temperature Anomaly (\circC)')
ylabel('Updated Temperature Anomaly (\circC)')
set(gca,'TickDir','out')

subplot(224)
plot(nicksARC'-OrigRecon.Arc.Temp,'k')
xlim([0 2000])
ylim([-.6 1])
hold on
plot([0 2000],[0 0],'r')
set(gca,'TickDir','out')
xlabel('Year AD')
ylabel('Temperature difference (Updated - Original; \circC)')
fsize=12;
fixfonts
%saveas(gcf,'~/Dropbox/Arc2k/NDS/Figs/PaicoRevisions.pdf')

%%
plotstack2(3,[0 2000])
plot(ph(1),OrigRecon.Arc.Year,OrigRecon.Arc.Temp,'k')
plot(ph(2),0:2000,nicksARC,'k')
%plot(ph(3),0:2000,correctedARC,'k')
plot(ph(3),K09Year,K09Temp,'k')
set(ph,'XDir','normal')
ylim(ph(1),[-2 1])
ylim(ph(2),[-2 1])
ylim(ph(3),[-1 .5])

binCR=bin_x((0:2000)',nicksARC',0:10:2000);

hold on
plot(ph2(3),5:10:1995,binCR,'r')
ylim(ph2(3),[-2 1])
set(ph2,'XDir','normal')

ylabel(ph(1),'Arc2k 1.0 (\circC)')
ylabel(ph(2),'Arc2k 1.1 (\circC)')
ylabel(ph2(3),'Arc2k 1.1 (\circC)')
ylabel(ph(3),'K09 (\circC)')
xlabel(ph(3),'Year AD')
 set(ph2(1),'YTick',[])
set(ph2(2),'YTick',[])






