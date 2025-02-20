timestep=0.1;
totallength=3;
lengthoftime=length(-totallength:timestep:totallength);
matfilepath='path_to_matfiles';
matfilelist=dir(fullfile(matfilepath,'*.mat'));
matfilelist=fullfile(matfilepath,{matfilelist.name});
SDF={};
WTnum=0;
KOnum=0;
num=0;
for x=matfilelist
    K=load(x{1}).K;
    slice1=0;
    slice2=0;
    for indx=1:size(K.SPK,1)
        x=K.SPK{indx,1};
        if length(x)>0
            x=x-K.Event{1,4}(1)/1000000;
            sbehavior=vertcat(K.SocialBehavior{1,2}{1,1},K.SocialBehavior{1,2}{1,2},K.SocialBehavior{1,2}{1,3},K.SocialBehavior{1,2}{1,4});
            nsbehavior=K.NonSocialBehavior{1,2}{1,1};
            if isempty(K.Immobile{1,2}{1,1})    
                rbehavior=[0,0,0]
            else
                rbehavior=K.Immobile{1,2}{1,1};
            end
            S=zeros(lengthoftime,1);
            NS=zeros(lengthoftime,1);
            R=zeros(lengthoftime,1);
            for y=1:size(sbehavior,1)
                if sbehavior(y,3)>0                    
                    t=sbehavior(y,1);
                    timestamp=t-totallength:timestep:t+totallength;
                    for index=1:length(timestamp)
                        timeS=timestamp(index);
                        S(index)=S(index)+(1/(sqrt(2*pi)*length(x)))*sum(exp((-(x-timeS).*(x-timeS))/(2*timestep*timestep)));
                    end
                end
            end
            for y=1:size(nsbehavior,1)
                if nsbehavior(y,3)>0                    
                    t=nsbehavior(y,1);
                    timestamp=t-totallength:timestep:t+totallength;
                    for index=1:length(timestamp)
                        timeS=timestamp(index);
                        NS(index)=NS(index)+(1/(sqrt(2*pi)*timestep*length(x)))*sum(exp((-(x-timeS).*(x-timeS))/(2*timestep*timestep)));
                    end
                end
            end
            if ~isempty(rbehavior)
                for y=1:size(rbehavior,1)
                    if rbehavior(y,3)>0                    
                        t=rbehavior(y,1);
                        timestamp=t-totallength:timestep:t+totallength;
                        for index=1:length(timestamp)
                            timeS=timestamp(index);
                            R(index)=R(index)+(1/(sqrt(2*pi)*timestep*length(x)))*sum(exp((-(x-timeS).*(x-timeS))/(2*timestep*timestep)));
                        end
                        
                    end
                end
    
            end
            slice1=slice1+1;
            if max(R)==0
                SDF(end+1,:)={K.date,K.ID{1,1},slice1,(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,NS/max(NS),S/max(S),R};
            else
                SDF(end+1,:)={K.date,K.ID{1,1},slice1,(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,NS/max(NS),S/max(S),R/max(R)};
           
            end

                      
        end
        
    end
    
    for indx=1:size(K.SPK,1)
        x=K.SPK{indx,2};
        if length(x)>0
            x=x-K.Event{1,4}(1)/1000000;
            sbehavior=vertcat(K.SocialBehavior{1,3}{1,1},K.SocialBehavior{1,3}{1,2},K.SocialBehavior{1,3}{1,3},K.SocialBehavior{1,3}{1,4});
            nsbehavior=K.NonSocialBehavior{1,3}{1,1};
            if isempty(K.Immobile{1,3}{1,1})    
                rbehavior=[0,0,0]
            else
                rbehavior=K.Immobile{1,3}{1,1};
            end
            S=zeros(lengthoftime,1);
            NS=zeros(lengthoftime,1);
            R=zeros(lengthoftime,1);
            for y=1:size(sbehavior,1)
                if sbehavior(y,3)>0                    
                    t=sbehavior(y,1);
                    timestamp=t-totallength:timestep:t+totallength;
                    for index=1:length(timestamp)
                        timeS=timestamp(index);
                        S(index)=S(index)+(1/(sqrt(2*pi)*timestep*length(x)))*sum(exp((-(x-timeS).*(x-timeS))/(2*timestep*timestep)));
                    end
                end
            end
            for y=1:size(nsbehavior,1)
                if nsbehavior(y,3)>0                    
                    t=nsbehavior(y,1);
                    timestamp=t-totallength:timestep:t+totallength;
                    for index=1:length(timestamp)
                        timeS=timestamp(index);
                        NS(index)=NS(index)+(1/(sqrt(2*pi)*timestep*length(x)))*sum(exp((-(x-timeS).*(x-timeS))/(2*timestep*timestep)));
                    end
                end
            end
            if ~isempty(rbehavior)
                for y=1:size(rbehavior,1)
                    if rbehavior(y,3)>0                    
                        t=rbehavior(y,1);
                        timestamp=t-totallength:timestep:t+totallength;
                        for index=1:length(timestamp)
                            timeS=timestamp(index);
                            R(index)=R(index)+(1/(sqrt(2*pi)*timestep*length(x)))*sum(exp((-(x-timeS).*(x-timeS))/(2*timestep*timestep)));
                        end
                        
                    end
                end
    
            end
            slice2=slice2+1;
            if max(R)==0
                SDF(end+1,:)={K.date,K.ID{1,2},slice2,(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,NS/max(NS),S/max(S),R};
            else
                SDF(end+1,:)={K.date,K.ID{1,2},slice2,(length(x)/(K.Event{1,4}(2)-K.Event{1,4}(1)))*10^6,NS/max(NS),S/max(S),R/max(R)};
           
            end 
        end
        
    end
end
