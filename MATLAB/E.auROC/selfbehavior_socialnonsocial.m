clear all
clc
close all
timestep=0.05;
windowlength=0.5;
totallength=3;

matfilepath='/MATLAB Drive/Optostim_matfiles';
matfilelist=dir(fullfile(matfilepath,'*.mat'));
matfilelist=fullfile(matfilepath,{matfilelist.name});
WT_auROC_FR={};
KO_auROC_FR={};
WTnum=0;
KOnum=0;
num=0;
for x=matfilelist
    K=load(x{1}).K;
    
    if endsWith(K.ID{1,1},'WT')
        num=WTnum;
        type='WT';
    else
        num=KOnum;
        type='KO';
    end
    for indx=1:size(K.SPK,1)
        x=K.SPK{indx,1};
        if length(x)>0
            x=x-K.Event{1,4}(1)/1000000;
            num=num+1;
            sbehavior=vertcat(K.SocialBehavior{1,2}{1,1},K.SocialBehavior{1,2}{1,2},K.SocialBehavior{1,2}{1,3},K.SocialBehavior{1,2}{1,4});
            nsbehavior=K.NonSocialBehavior{1,2}{1,1};
            S=[];
            C=[];
            z=0;
            for y=1:size(sbehavior,1)
                if sbehavior(y,3)>0
                    
                    t=sbehavior(y,1);
                    for timeS=t:timestep:t+totallength-windowlength
                        z=z+1;
                        S(end+1)=length(find(x<=timeS+windowlength & x>timeS))*10;
                    end
                end

            end
            for y=1:size(nsbehavior,1)
                if nsbehavior(y,3)>0
                    
                    t=nsbehavior(y,1);
                    for timeS=t:timestep:t+totallength-windowlength
                        z=z+1;
                        C(end+1)=length(find(x<=timeS+windowlength & x>timeS))*10;
                    end
                end

            end 
            if strcmp(type,'WT')
                WT_auROC_FR(end+1,:)={K.date,K.ID{1,1},'WT',(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,C',S'};
            
                WTnum=num;
            else
                KO_auROC_FR(end+1,:)={K.date,K.ID{1,1},'KO',(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,C',S'};
                KOnum=num;
            end            
        end
        
    end
    if endsWith((K.ID{1,2}),'WT')
        num=WTnum+1;
        type='WT';
    else
        num=KOnum;
        type='KO';
    end
    for indx=1:size(K.SPK,1)
        x=K.SPK{indx,2};
        if length(x)>0
            x=x-K.Event{1,4}(1)/1000000;
            num=num+1;
            sbehavior=[K.SocialBehavior{1,3}{1,1};K.SocialBehavior{1,3}{1,2};K.SocialBehavior{1,3}{1,3};K.SocialBehavior{1,3}{1,4}];
            nsbehavior=[K.NonSocialBehavior{1,3}{1,1}];
            S=[];
            C=[];
            z=0;
            for y=1:size(sbehavior,1)
                if sbehavior(y,3)>0
                    
                    t=sbehavior(y,1);
                    for timeS=t:timestep:t+totallength-windowlength
                        z=z+1;
                        S(end+1)=length(find(x<=timeS+windowlength & x>timeS))*10;
                    end
                end

            end
            for y=1:size(nsbehavior,1)
                if nsbehavior(y,3)>0
                    
                    t=nsbehavior(y,1);
                    for timeS=t:timestep:t+totallength-windowlength
                        z=z+1;
                        C(end+1)=length(find(x<=timeS+windowlength & x>timeS))*10;
                    end
                end

            end 
            if strcmp(type,'WT')
                WT_auROC_FR(end+1,:)={K.date,K.ID{1,2},'WT',(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,C',S'};
            
                WTnum=num;
            else
                KO_auROC_FR(end+1,:)={K.date,K.ID{1,2},'KO',(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,C',S'};
                KOnum=num;
            end
        end
        
    end
end


%%

% Code written by Kim WH adapted to Shank2 dual interaction experiment
% last edited by E Hwang 2023-06-14

Iteration=1000;

%load('Total_auROC_v1.mat')
%load('KO_auROC_FR_v5.mat')

%filter out neurons with FR <0.5
WT_session_avg = cell2mat(WT_auROC_FR(:,4));
KO_session_avg = cell2mat(KO_auROC_FR(:,4));


WT_auROC_FR(find(WT_session_avg<0.5),:)=[];
KO_auROC_FR(find(KO_session_avg<0.5),:)=[];

%% WT social neuron auROC
figure
hold on
for n= 1:size(WT_auROC_FR,1)
    C=WT_auROC_FR{n,5}; % NonSocial FR for neuron A
    S=WT_auROC_FR{n,6}; % Social FR for neuron A
    if length(C)>=500 && length(S)>=500 % 10 trial 보다 많은지
        for n_Iter=1:Iteration

            C_temp=(randsample(C,20)');
            S_temp=(randsample(S,20)');
            C_temp=C_temp(:);
            S_temp=S_temp(:);
            if ~(var(C_temp) == 0 && var(S_temp)==0)

                bin=linspace(min([C_temp;S_temp]),max([C_temp;S_temp]),200); %CtempStemp min - step size - CtempStemp max
                for b=1:length(bin)
                    S_larger_than_criteria(n_Iter,b)=length(find(S_temp>=bin(b)))/length(S_temp); % ratio of FR that is larger than criteria (threshold) 1000 x 100
                    C_larger_than_criteria(n_Iter,b)=length(find(C_temp>=bin(b)))/length(C_temp); % ratio of FR that is larger than criteria (threshold)
                end
                AUC_temp(n,n_Iter)=trapz(C_larger_than_criteria(n_Iter,:),S_larger_than_criteria(n_Iter,:))*(-1);


                %% random sampling
                rand_C_temp=[C_temp(1:10);S_temp(1:10)];
                rand_S_temp=[C_temp(11:20);S_temp(11:20)];


                for b=1:length(bin)
                    rand_S_larger_than_criteria(n_Iter,b)=length(find(rand_S_temp>=bin(b)))/length(rand_S_temp);
                    rand_C_larger_than_criteria(n_Iter,b)=length(find(rand_C_temp>=bin(b)))/length(rand_C_temp);
                end
                rand_AUC_temp(n,n_Iter)=trapz(rand_C_larger_than_criteria(n_Iter,:),rand_S_larger_than_criteria(n_Iter,:))*(-1);
            else
                continue
            end

       
    
        end

        plot(mean(C_larger_than_criteria),mean(S_larger_than_criteria),'k')
        plot(mean(rand_C_larger_than_criteria),mean(rand_S_larger_than_criteria),'b')
        WT_S_larger_than_criteria(n,:)=mean(S_larger_than_criteria);
        WT_C_larger_than_criteria(n,:)=mean(C_larger_than_criteria);
        WT_rand_S_larger_than_criteria(n,:)=mean(rand_S_larger_than_criteria);
        WT_rand_C_larger_than_criteria(n,:)=mean(rand_C_larger_than_criteria);
        WT_AUC(n,1)=mean(AUC_temp(n,:));
        if WT_AUC(n,1)>=quantile(rand_AUC_temp(n,:),0.95)
            WT_AUC(n,2)=1;
        elseif WT_AUC(n,1)<=quantile(rand_AUC_temp(n,:),0.05)
            WT_AUC(n,2)=-1;
        else
            WT_AUC(n,2)=0;
        end

    end

end
title('WT auROC Social vs. NonSocial')
ylabel('Probability(Social> threshold)')
xlabel('Probability(NonSocial > threshold)')
legend('WT auROC','WT shuffled auROC')

WT_rand_AUC_temp=rand_AUC_temp;
WT_AUC_temp=AUC_temp;



%% KO social neuron auROC
figure
hold on
for n=1:length(KO_auROC_FR(:,1))
    C=KO_auROC_FR{n,5}; % NonSocial FR for neuron A
    S=KO_auROC_FR{n,6}; % Social FR for neuron A

    if length(C)>=500 && length(S)>=500
        for n_Iter=1:Iteration
            C_temp=(randsample(C,20)');
            S_temp=(randsample(S,20)');     
            C_temp=C_temp(:);
            S_temp=S_temp(:);
            if ~(var(C_temp) == 0 && var(S_temp)==0)

                bin=linspace(min([C_temp;S_temp]),max([C_temp;S_temp]),200);
                for b=1:length(bin)
                    S_larger_than_criteria(n_Iter,b)=length(find(S_temp>=bin(b)))/length(S_temp); % ratio of FR that is larger than criteria (threshold) 1000 x 100
                    C_larger_than_criteria(n_Iter,b)=length(find(C_temp>=bin(b)))/length(C_temp); % ratio of FR that is larger than criteria (threshold)
                end
                AUC_temp(n,n_Iter)=trapz(C_larger_than_criteria(n_Iter,:),S_larger_than_criteria(n_Iter,:))*(-1);


                %% random sampling
                rand_C_temp=[C_temp(1:10);S_temp(1:10)];
                rand_S_temp=[C_temp(11:20);S_temp(11:20)];

                for b=1:length(bin)
                    rand_S_larger_than_criteria(n_Iter,b)=length(find(rand_S_temp>=bin(b)))/length(rand_S_temp);
                    rand_C_larger_than_criteria(n_Iter,b)=length(find(rand_C_temp>=bin(b)))/length(rand_C_temp);
                end
                rand_AUC_temp(n,n_Iter)=trapz(rand_C_larger_than_criteria(n_Iter,:),rand_S_larger_than_criteria(n_Iter,:))*(-1);
            else
            end

        end

        plot(mean(C_larger_than_criteria),mean(S_larger_than_criteria),'Color',[0.6350 0.0780 0.1840])
        plot(mean(rand_C_larger_than_criteria),mean(rand_S_larger_than_criteria),'b')
        KO_S_larger_than_criteria(n,:)=mean(S_larger_than_criteria);
        KO_C_larger_than_criteria(n,:)=mean(C_larger_than_criteria);
        KO_rand_S_larger_than_criteria(n,:)=mean(rand_S_larger_than_criteria);
        KO_rand_C_larger_than_criteria(n,:)=mean(rand_C_larger_than_criteria);
        KO_AUC(n,1)=mean(AUC_temp(n,:));
        if KO_AUC(n,1)>=quantile(rand_AUC_temp(n,:),0.95)
            KO_AUC(n,2)=1;
        elseif KO_AUC(n,1)<=quantile(rand_AUC_temp(n,:),0.05)
            KO_AUC(n,2)=-1;
        else
            KO_AUC(n,2)=0;
        end

    end
end
title('KO auROC (Social vs. NonSocial)')
ylabel('Probability(Social FR > threshold)')
xlabel('Probability(NonSocial FR > threshold)')
legend('KO auROC','KO shuffled auROC')

KO_rand_AUC_temp=rand_AUC_temp;
KO_AUC_temp=AUC_temp;

%% neuron proportion

WT_social_neuron=[find(WT_AUC(:,2)==1);find(WT_AUC(:,2)==-1)];
WT_pos_social_neuron=[find(WT_AUC(:,2)==1)];
WT_neg_social_neuron=[find(WT_AUC(:,2)==-1)];

KO_social_neuron=[find(KO_AUC(:,2)==1);find(KO_AUC(:,2)==-1)];
KO_pos_social_neuron=[find(KO_AUC(:,2)==1)];
KO_neg_social_neuron=[find(KO_AUC(:,2)==-1)];
WT_auROC_FR(:,7)=num2cell(WT_AUC(:,2));
KO_auROC_FR(:,7)=num2cell(KO_AUC(:,2));
WT_social_neuron=WT_auROC_FR([find(WT_AUC(:,2)==1);find(WT_AUC(:,2)==-1)],:);
WT_pos_social_neuron=WT_auROC_FR([find(WT_AUC(:,2)==1)],:);
WT_neg_social_neuron=WT_auROC_FR([find(WT_AUC(:,2)==-1)],:);

KO_social_neuron=KO_auROC_FR([find(KO_AUC(:,2)==1);find(KO_AUC(:,2)==-1)],:);
KO_pos_social_neuron=KO_auROC_FR([find(KO_AUC(:,2)==1)],:);
KO_neg_social_neuron=KO_auROC_FR([find(KO_AUC(:,2)==-1)],:);
save('auROC__social_neuron_self_auROC','WT_auROC_FR','KO_auROC_FR','WT_AUC', 'WT_rand_AUC_temp', 'WT_AUC_temp', 'KO_AUC', 'KO_rand_AUC_temp', 'KO_AUC_temp','WT_social_neuron','WT_pos_social_neuron','WT_neg_social_neuron','KO_social_neuron','KO_pos_social_neuron','KO_neg_social_neuron','WT_S_larger_than_criteria', 'WT_C_larger_than_criteria', 'WT_rand_S_larger_than_criteria', 'WT_rand_C_larger_than_criteria', 'KO_S_larger_than_criteria', 'KO_C_larger_than_criteria', 'KO_rand_S_larger_than_criteria', 'KO_rand_C_larger_than_criteria')

WT_proportion=[shape(WT_social_neuron,1),length(find(WT_AUC(:,1)~=0))]
KO_proportion=[shape(KO_social_neuron,1),length(find(KO_AUC(:,1)~=0))]
%% auROC imaging (only social neurons)
figure
hold on
for n=1:length(WT_social_neuron)
    plot(WT_C_larger_than_criteria(WT_social_neuron(n),:),WT_S_larger_than_criteria(WT_social_neuron(n),:),'k')
    plot(WT_rand_C_larger_than_criteria(WT_social_neuron(n),:),WT_rand_S_larger_than_criteria(WT_social_neuron(n),:),'b')
end
title('WT social neuron auROC (Social vs. NonSocial)')
ylabel('Probability(Social FR > threshold)')
xlabel('Probability(NonSocial FR > threshold)')
legend('WT auROC','WT shuffled auROC')

figure
hold on
for n=1:length(KO_social_neuron)
    plot(KO_C_larger_than_criteria(KO_social_neuron(n),:),KO_S_larger_than_criteria(KO_social_neuron(n),:),'Color',[0.6350 0.0780 0.1840])
    plot(KO_rand_C_larger_than_criteria(KO_social_neuron(n),:),KO_rand_S_larger_than_criteria(KO_social_neuron(n),:),'b')
end
title('KO social neuron auROC (Social vs. NonSocial)')
ylabel('Probability(Social FR > threshold)')
xlabel('Probability(NonSocial FR > threshold)')
legend('KO auROC','KO shuffled auROC')


%% draw minimum/maximum social neuron auROCs 
WT_score = WT_AUC(:,1); 
max(WT_score)

find(WT_score==max(WT_score))

m=min(WT_score(WT_score>0));

find(WT_score==m) 



KO_score = KO_AUC(:,1); 

max(KO_score)

find(KO_score==max(KO_score))

m=min(KO_score(KO_score>0));

find(KO_score==m) 



