

%male

male_WT_cortex = LFPsexgenotypecontinuousS2{:,:};
mean_male_WT_cortex = mean(male_WT_cortex,1);


sem = zeros(size(male_WT_cortex,2),1); 

for yy = 1:size(male_WT_cortex,2)
    
    sem(yy) = std(male_WT_cortex(:,yy))/sqrt(size(male_WT_cortex,1));
end


sem_male_WT_cortex = sem';
shadedErrorBar([],mean_male_WT_cortex, sem_male_WT_cortex ,'lineprops', '-k')
xlim([1 200])



male_HT_cortex = LFPsexgenotypecontinuousS3{:,:};
mean_male_HT_cortex = mean(male_HT_cortex,1);


sem = zeros(size(male_HT_cortex,2),1); 

for yy = 1:size(male_HT_cortex,2)
    
    sem(yy) = std(male_HT_cortex(:,yy))/sqrt(size(male_HT_cortex,1));
end


sem_male_HT_cortex = sem';
shadedErrorBar([],mean_male_HT_cortex, sem_male_HT_cortex ,'lineprops', '-g')
xlim([1 200])




male_HO_cortex = LFPsexgenotypecontinuousS4{:,:};
mean_male_HO_cortex = mean(male_HO_cortex,1);


sem = zeros(size(male_HO_cortex,2),1); 

for yy = 1:size(male_HO_cortex,2)
    
    sem(yy) = std(male_HO_cortex(:,yy))/sqrt(size(male_HO_cortex,1));
end


sem_male_HO_cortex = sem';
shadedErrorBar([],mean_male_HO_cortex, sem_male_HO_cortex ,'lineprops', '-r')
xlim([1 200])


%female
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
female_WT_cortex = LFPsexgenotypecontinuousS5{:,:};
mean_female_WT_cortex = mean(female_WT_cortex,1);


sem = zeros(size(female_WT_cortex,2),1); 

for yy = 1:size(female_WT_cortex,2)
    
    sem(yy) = std(female_WT_cortex(:,yy))/sqrt(size(female_WT_cortex,1));
end


sem_female_WT_cortex = sem';
shadedErrorBar([],mean_female_WT_cortex, sem_female_WT_cortex ,'lineprops', '-k')
xlim([1 200])


female_HT_cortex = LFPsexgenotypecontinuousS6{:,:};
mean_female_HT_cortex = mean(female_HT_cortex,1);


sem = zeros(size(female_HT_cortex,2),1); 

for yy = 1:size(female_HT_cortex,2)
    
    sem(yy) = std(female_HT_cortex(:,yy))/sqrt(size(female_HT_cortex,1));
end


sem_female_HT_cortex = sem';
shadedErrorBar([],mean_female_HT_cortex, sem_female_HT_cortex ,'lineprops', '-g')
xlim([1 200])




female_HO_cortex = LFPsexgenotypecontinuousS7{:,:};
mean_female_HO_cortex = mean(female_HO_cortex,1);


sem = zeros(size(female_HO_cortex,2),1); 

for yy = 1:size(female_HO_cortex,2)
    
    sem(yy) = std(female_HO_cortex(:,yy))/sqrt(size(female_HO_cortex,1));
end


sem_female_HO_cortex = sem';
shadedErrorBar([],mean_female_HO_cortex, sem_female_HO_cortex ,'lineprops', '-r')
xlim([1 200])