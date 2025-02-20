

%male

male_WT_DG = LFPsexgenotypecontinuousS14{:,:};
mean_male_WT_DG = mean(male_WT_DG,1);


sem = zeros(size(male_WT_DG,2),1); 

for yy = 1:size(male_WT_DG,2)
    
    sem(yy) = std(male_WT_DG(:,yy))/sqrt(size(male_WT_DG,1));
end


sem_male_WT_DG = sem';
shadedErrorBar([],mean_male_WT_DG, sem_male_WT_DG ,'lineprops', '-k')
xlim([0 150])



male_HT_DG = LFPsexgenotypecontinuousS15{:,:};
mean_male_HT_DG = mean(male_HT_DG,1);


sem = zeros(size(male_HT_DG,2),1); 

for yy = 1:size(male_HT_DG,2)
    
    sem(yy) = std(male_HT_DG(:,yy))/sqrt(size(male_HT_DG,1));
end


sem_male_HT_DG = sem';
shadedErrorBar([],mean_male_HT_DG, sem_male_HT_DG ,'lineprops', '-g')
xlim([0 150])




male_HO_DG = LFPsexgenotypecontinuousS16{:,:};
mean_male_HO_DG = mean(male_HO_DG,1);


sem = zeros(size(male_HO_DG,2),1); 

for yy = 1:size(male_HO_DG,2)
    
    sem(yy) = std(male_HO_DG(:,yy))/sqrt(size(male_HO_DG,1));
end


sem_male_HO_DG = sem';
shadedErrorBar([],mean_male_HO_DG, sem_male_HO_DG ,'lineprops', '-r')
xlim([0 150])
set(gca, 'XTick', [])


%female
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
female_WT_DG = LFPsexgenotypecontinuousS17{:,:};
mean_female_WT_DG = mean(female_WT_DG,1);


sem = zeros(size(female_WT_DG,2),1); 

for yy = 1:size(female_WT_DG,2)
    
    sem(yy) = std(female_WT_DG(:,yy))/sqrt(size(female_WT_DG,1));
end


sem_female_WT_DG = sem';
shadedErrorBar([],mean_female_WT_DG, sem_female_WT_DG ,'lineprops', '-k')
xlim([0 150])


female_HT_DG = LFPsexgenotypecontinuousS18{:,:};
mean_female_HT_DG = mean(female_HT_DG,1);


sem = zeros(size(female_HT_DG,2),1); 

for yy = 1:size(female_HT_DG,2)
    
    sem(yy) = std(female_HT_DG(:,yy))/sqrt(size(female_HT_DG,1));
end


sem_female_HT_DG = sem';
shadedErrorBar([],mean_female_HT_DG, sem_female_HT_DG ,'lineprops', '-g')
xlim([0 150])




female_HO_DG = LFPsexgenotypecontinuousS19{:,:};
mean_female_HO_DG = mean(female_HO_DG,1);


sem = zeros(size(female_HO_DG,2),1); 

for yy = 1:size(female_HO_DG,2)
    
    sem(yy) = std(female_HO_DG(:,yy))/sqrt(size(female_HO_DG,1));
end


sem_female_HO_DG = sem';
shadedErrorBar([],mean_female_HO_DG, sem_female_HO_DG ,'lineprops', '-r')
xlim([0 150])
set(gca, 'XTick', [])