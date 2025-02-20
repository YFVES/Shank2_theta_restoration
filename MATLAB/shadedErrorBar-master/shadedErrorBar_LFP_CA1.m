

%male

male_WT_CA1 = LFPsexgenotypecontinuousS8{:,:};
mean_male_WT_CA1 = mean(male_WT_CA1,1);


sem = zeros(size(male_WT_CA1,2),1); 

for yy = 1:size(male_WT_CA1,2)
    
    sem(yy) = std(male_WT_CA1(:,yy))/sqrt(size(male_WT_CA1,1));
end


sem_male_WT_CA1 = sem';
shadedErrorBar([],mean_male_WT_CA1, sem_male_WT_CA1 ,'lineprops', '-k')
xlim([0 150])



male_HT_CA1 = LFPsexgenotypecontinuousS9{:,:};
mean_male_HT_CA1 = mean(male_HT_CA1,1);


sem = zeros(size(male_HT_CA1,2),1); 

for yy = 1:size(male_HT_CA1,2)
    
    sem(yy) = std(male_HT_CA1(:,yy))/sqrt(size(male_HT_CA1,1));
end


sem_male_HT_CA1 = sem';
shadedErrorBar([],mean_male_HT_CA1, sem_male_HT_CA1 ,'lineprops', '-g')
xlim([0 150])



male_HO_CA1 = LFPsexgenotypecontinuousS10{:,:};
mean_male_HO_CA1 = mean(male_HO_CA1,1);


sem = zeros(size(male_HO_CA1,2),1); 

for yy = 1:size(male_HO_CA1,2)
    
    sem(yy) = std(male_HO_CA1(:,yy))/sqrt(size(male_HO_CA1,1));
end


sem_male_HO_CA1 = sem';
shadedErrorBar([],mean_male_HO_CA1, sem_male_HO_CA1 ,'lineprops', '-r')
xlim([0 150])
set(gca, 'XTick', [])

%female
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
female_WT_CA1 = LFPsexgenotypecontinuousS11{:,:};
mean_female_WT_CA1 = mean(female_WT_CA1,1);


sem = zeros(size(female_WT_CA1,2),1); 

for yy = 1:size(female_WT_CA1,2)
    
    sem(yy) = std(female_WT_CA1(:,yy))/sqrt(size(female_WT_CA1,1));
end


sem_female_WT_CA1 = sem';
shadedErrorBar([],mean_female_WT_CA1, sem_female_WT_CA1 ,'lineprops', '-k')
xlim([0 150])


female_HT_CA1 = LFPsexgenotypecontinuousS12{:,:};
mean_female_HT_CA1 = mean(female_HT_CA1,1);


sem = zeros(size(female_HT_CA1,2),1); 

for yy = 1:size(female_HT_CA1,2)
    
    sem(yy) = std(female_HT_CA1(:,yy))/sqrt(size(female_HT_CA1,1));
end


sem_female_HT_CA1 = sem';
shadedErrorBar([],mean_female_HT_CA1, sem_female_HT_CA1 ,'lineprops', '-g')
xlim([0 150])




female_HO_CA1 = LFPsexgenotypecontinuousS13{:,:};
mean_female_HO_CA1 = mean(female_HO_CA1,1);


sem = zeros(size(female_HO_CA1,2),1); 

for yy = 1:size(female_HO_CA1,2)
    
    sem(yy) = std(female_HO_CA1(:,yy))/sqrt(size(female_HO_CA1,1));
end


sem_female_HO_CA1 = sem';
shadedErrorBar([],mean_female_HO_CA1, sem_female_HO_CA1 ,'lineprops', '-r')
xlim([0 150])
set(gca, 'XTick', [])