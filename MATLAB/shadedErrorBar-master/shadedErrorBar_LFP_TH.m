

%male

male_WT_TH = LFPsexgenotypecontinuousS20{:,:};
mean_male_WT_TH = mean(male_WT_TH,1);


sem = zeros(size(male_WT_TH,2),1); 

for yy = 1:size(male_WT_TH,2)
    
    sem(yy) = std(male_WT_TH(:,yy))/sqrt(size(male_WT_TH,1));
end


sem_male_WT_TH = sem';
shadedErrorBar([],mean_male_WT_TH, sem_male_WT_TH ,'lineprops', '-k')
xlim([0 150])



male_HT_TH = LFPsexgenotypecontinuousS21{:,:};
mean_male_HT_TH = mean(male_HT_TH,1);


sem = zeros(size(male_HT_TH,2),1); 

for yy = 1:size(male_HT_TH,2)
    
    sem(yy) = std(male_HT_TH(:,yy))/sqrt(size(male_HT_TH,1));
end


sem_male_HT_TH = sem';
shadedErrorBar([],mean_male_HT_TH, sem_male_HT_TH ,'lineprops', '-g')
xlim([0 150])



male_HO_TH = LFPsexgenotypecontinuousS22{:,:};
mean_male_HO_TH = mean(male_HO_TH,1);


sem = zeros(size(male_HO_TH,2),1); 

for yy = 1:size(male_HO_TH,2)
    
    sem(yy) = std(male_HO_TH(:,yy))/sqrt(size(male_HO_TH,1));
end


sem_male_HO_TH = sem';
shadedErrorBar([],mean_male_HO_TH, sem_male_HO_TH ,'lineprops', '-r')
xlim([0 150])
set(gca, 'XTick', [])


%female
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
female_WT_TH = LFPsexgenotypecontinuousS23{:,:};
mean_female_WT_TH = mean(female_WT_TH,1);


sem = zeros(size(female_WT_TH,2),1); 

for yy = 1:size(female_WT_TH,2)
    
    sem(yy) = std(female_WT_TH(:,yy))/sqrt(size(female_WT_TH,1));
end


sem_female_WT_TH = sem';
shadedErrorBar([],mean_female_WT_TH, sem_female_WT_TH ,'lineprops', '-k')
xlim([0 150])


female_HT_TH = LFPsexgenotypecontinuousS24{:,:};
mean_female_HT_TH = mean(female_HT_TH,1);


sem = zeros(size(female_HT_TH,2),1); 

for yy = 1:size(female_HT_TH,2)
    
    sem(yy) = std(female_HT_TH(:,yy))/sqrt(size(female_HT_TH,1));
end


sem_female_HT_TH = sem';
shadedErrorBar([],mean_female_HT_TH, sem_female_HT_TH ,'lineprops', '-g')
xlim([0 150])




female_HO_TH = LFPsexgenotypecontinuousS25{:,:};
mean_female_HO_TH = mean(female_HO_TH,1);


sem = zeros(size(female_HO_TH,2),1); 

for yy = 1:size(female_HO_TH,2)
    
    sem(yy) = std(female_HO_TH(:,yy))/sqrt(size(female_HO_TH,1));
end


sem_female_HO_TH = sem';
shadedErrorBar([],mean_female_HO_TH, sem_female_HO_TH ,'lineprops', '-r')
xlim([0 150])
set(gca, 'XTick', [])