drawinglist=WT_pos_social_neuron;
drawingnumber=length(drawinglist);
WT_session_avg = cell2mat(SDF(:,4));
timestamp=-3:0.1:3;

SDF(find(WT_session_avg<0.5),:)=[];

S=[];
NS=[];
R=[];
num=0;
drawinglist
for l=drawinglist'
    array=SDF(l,:);
    array
    ns=array(1,5);
    s=array(1,6);
    r=array(1,7);
    if num==0
        S=s{:}';
        NS=ns{:}';
        R=r{:}';
        num=1
    else
        S=vertcat(S,s{:}');
        NS=vertcat(NS,ns{:}');
        R=vertcat(R,r{:}');
    end
end
S(isnan(S))=0;
NS(isnan(NS))=0;
R(isnan(R))=0;
smean=mean(S,1);
sstd=std(S,0,1);
ssem=sstd/sqrt(size(S,1));
nsmean=mean(NS,1);
nsstd=std(NS,0,1);
nssem=nsstd/sqrt(size(NS,1));
rmean=mean(R,1);
rstd=std(R,0,1);
rsem=rstd/sqrt(size(R,1));
us=smean+ssem;
ds=smean-ssem;
uns=nsmean+nssem;
dns=nsmean-nssem;
ur=rmean+rsem;
dr=rmean-rsem;
figure;
hold on;
ylim([0 1])
xlim([-2 2])
fill([timestamp,fliplr(timestamp)],[us,fliplr(ds)],'m','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[uns,fliplr(dns)],'yellow','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[ur,fliplr(dr)],[0.5,0.5,0.5],'FaceAlpha',0.2,'EdgeColor','none');
plot(timestamp,smean,'m','LineWidth',2);
plot(timestamp,nsmean,'yellow','LineWidth',2);
plot(timestamp,rmean,'Color',[0.5,0.5,0.5],'LineWidth',2);
xlabel('Time (s)');
ylabel('Normalized FR');
title('WT Social neuron (+)');
hold off;
drawinglist=WT_neg_social_neuron;
drawingnumber=length(drawinglist);
WT_session_avg = cell2mat(SDF(:,4));
timestamp=-3:0.1:3;

SDF(find(WT_session_avg<0.5),:)=[];

S=[];
NS=[];
R=[];
num=0;
drawinglist
for l=drawinglist'
    array=SDF(l,:);
    array
    ns=array(1,5);
    s=array(1,6);
    r=array(1,7);
    if num==0
        S=s{:}';
        NS=ns{:}';
        R=r{:}';
        num=1
    else
        S=vertcat(S,s{:}');
        NS=vertcat(NS,ns{:}');
        R=vertcat(R,r{:}');
    end
end
S(isnan(S))=0;
NS(isnan(NS))=0;
R(isnan(R))=0;
smean=mean(S,1);
sstd=std(S,0,1);
ssem=sstd/sqrt(size(S,1));
nsmean=mean(NS,1);
nsstd=std(NS,0,1);
nssem=nsstd/sqrt(size(NS,1));
rmean=mean(R,1);
rstd=std(R,0,1);
rsem=rstd/sqrt(size(R,1));
us=smean+ssem;
ds=smean-ssem;
uns=nsmean+nssem;
dns=nsmean-nssem;
ur=rmean+rsem;
dr=rmean-rsem;
figure;
hold on;
ylim([0 1])
xlim([-2 2])
fill([timestamp,fliplr(timestamp)],[us,fliplr(ds)],'m','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[uns,fliplr(dns)],'yellow','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[ur,fliplr(dr)],[0.5,0.5,0.5],'FaceAlpha',0.2,'EdgeColor','none');
plot(timestamp,smean,'m','LineWidth',2);
plot(timestamp,nsmean,'yellow','LineWidth',2);
plot(timestamp,rmean,'Color',[0.5,0.5,0.5],'LineWidth',2);
xlabel('Time (s)');
ylabel('Normalized FR');
title('WT Social neuron (-)');
hold off;

drawinglist=KO_pos_social_neuron;
drawingnumber=length(drawinglist);
WT_session_avg = cell2mat(SDF(:,4));
timestamp=-3:0.1:3;

SDF(find(WT_session_avg<0.5),:)=[];

S=[];
NS=[];
R=[];
num=0;
drawinglist
for l=drawinglist'
    array=SDF(l,:);
    array
    ns=array(1,5);
    s=array(1,6);
    r=array(1,7);
    if num==0
        S=s{:}';
        NS=ns{:}';
        R=r{:}';
        num=1
    else
        S=vertcat(S,s{:}');
        NS=vertcat(NS,ns{:}');
        R=vertcat(R,r{:}');
    end
end
S(isnan(S))=0;
NS(isnan(NS))=0;
R(isnan(R))=0;
smean=mean(S,1);
sstd=std(S,0,1);
ssem=sstd/sqrt(size(S,1));
nsmean=mean(NS,1);
nsstd=std(NS,0,1);
nssem=nsstd/sqrt(size(NS,1));
rmean=mean(R,1);
rstd=std(R,0,1);
rsem=rstd/sqrt(size(R,1));
us=smean+ssem;
ds=smean-ssem;
uns=nsmean+nssem;
dns=nsmean-nssem;
ur=rmean+rsem;
dr=rmean-rsem;
figure;
hold on;
ylim([0 1])
xlim([-2 2])
fill([timestamp,fliplr(timestamp)],[us,fliplr(ds)],'m','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[uns,fliplr(dns)],'yellow','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[ur,fliplr(dr)],[0.5,0.5,0.5],'FaceAlpha',0.2,'EdgeColor','none');
plot(timestamp,smean,'m','LineWidth',2);
plot(timestamp,nsmean,'yellow','LineWidth',2);
plot(timestamp,rmean,'Color',[0.5,0.5,0.5],'LineWidth',2);
xlabel('Time (s)');
ylabel('Normalized FR');
title('KO Social neuron (+)');
hold off;
drawinglist=KO_neg_social_neuron;
drawingnumber=length(drawinglist);
WT_session_avg = cell2mat(SDF(:,4));
timestamp=-3:0.1:3;

SDF(find(WT_session_avg<0.5),:)=[];

S=[];
NS=[];
R=[];
num=0;
drawinglist
for l=drawinglist'
    array=SDF(l,:);
    array
    ns=array(1,5);
    s=array(1,6);
    r=array(1,7);
    if num==0
        S=s{:}';
        NS=ns{:}';
        R=r{:}';
        num=1
    else
        S=vertcat(S,s{:}');
        NS=vertcat(NS,ns{:}');
        R=vertcat(R,r{:}');
    end
end
S(isnan(S))=0;
NS(isnan(NS))=0;
R(isnan(R))=0;
smean=mean(S,1);
sstd=std(S,0,1);
ssem=sstd/sqrt(size(S,1));
nsmean=mean(NS,1);
nsstd=std(NS,0,1);
nssem=nsstd/sqrt(size(NS,1));
rmean=mean(R,1);
rstd=std(R,0,1);
rsem=rstd/sqrt(size(R,1));
us=smean+ssem;
ds=smean-ssem;
uns=nsmean+nssem;
dns=nsmean-nssem;
ur=rmean+rsem;
dr=rmean-rsem;
figure;
hold on;
ylim([0 1])
xlim([-2 2])
fill([timestamp,fliplr(timestamp)],[us,fliplr(ds)],'m','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[uns,fliplr(dns)],'yellow','FaceAlpha',0.2,'EdgeColor','none');
fill([timestamp,fliplr(timestamp)],[ur,fliplr(dr)],[0.5,0.5,0.5],'FaceAlpha',0.2,'EdgeColor','none');
plot(timestamp,smean,'m','LineWidth',2);
plot(timestamp,nsmean,'yellow','LineWidth',2);
plot(timestamp,rmean,'Color',[0.5,0.5,0.5],'LineWidth',2);
xlabel('Time (s)');
ylabel('Normalized FR');
title('KO Social neuron (-)');
hold off;