
WT_E_overall = [];
WT_E_baseline = [];
WT_E_openfield = [];
WT_E_di = [];

WT_I_overall = [];
WT_I_baseline = [];
WT_I_openfield = [];
WT_I_di = [];

KO_E_overall = [];
KO_E_baseline = [];
KO_E_openfield = [];
KO_E_di = [];

KO_I_overall = [];
KO_I_baseline = [];
KO_I_openfield = [];
KO_I_di = [];

%% for mouse 1
for ii = 1:size(ISI_proportions,1)
    if ~isempty(ISI_proportions{ii,2})
        mousegenotype = ISI_proportions{ii,2}(3:4);
        mouseISI = ISI_proportions{ii,4}(:,1);
        if size(ISI_proportions{ii,4},2)>1
            neurontypeS = ISI_proportions{ii,4}(:,2);
            for jj = 1:size(mouseISI,1)

                tempISI = mouseISI{jj,1};
                if ~isempty(tempISI)
                    neuron_type = neurontypeS{jj,1};
                    if strcmp(mousegenotype,'WT') == 1
                        if strcmp(neuron_type, 'E') == 1
                            WT_E_overall = [WT_E_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                WT_E_baseline = [ WT_E_baseline ; tempISI(2,:)];
                            else
                                WT_E_baseline = [ WT_E_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                WT_E_openfield = [WT_E_openfield ; tempISI(3,:)];
                            else
                                WT_E_openfield = [WT_E_openfield];
                            end

                            if sum(tempISI(4,:)) ~=0
                                WT_E_di = [ WT_E_di ; tempISI(4,:)];
                            else
                                WT_E_di = [ WT_E_di];
                            end
                        else
                            WT_I_overall = [WT_I_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                WT_I_baseline = [ WT_I_baseline ; tempISI(2,:)];
                            else
                                WT_I_baseline = [ WT_I_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                WT_I_openfield = [WT_I_openfield ; tempISI(3,:)];
                            else
                                WT_I_openfield = [WT_I_openfield];
                            end
                            if sum(tempISI(4,:)) ~=0
                                WT_I_di = [ WT_I_di ; tempISI(4,:)];
                            else
                                WT_I_di = [ WT_I_di];
                            end
                        end
                    else
                        if strcmp(neuron_type, 'E') == 1
                            KO_E_overall = [KO_E_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                KO_E_baseline = [ KO_E_baseline ; tempISI(2,:)];
                            else
                                KO_E_baseline = [ KO_E_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                KO_E_openfield = [KO_E_openfield ; tempISI(3,:)];
                            else
                                KO_E_openfield = [KO_E_openfield];
                            end

                            if sum(tempISI(4,:)) ~=0
                                KO_E_di = [ KO_E_di ; tempISI(4,:)];
                            else
                                KO_E_di = [ KO_E_di];
                            end
                        else
                            KO_I_overall = [KO_I_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                KO_I_baseline = [ KO_I_baseline ; tempISI(2,:)];
                            else
                                KO_I_baseline = [ KO_I_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                KO_I_openfield = [KO_I_openfield ; tempISI(3,:)];
                            else
                                KO_I_openfield = [KO_I_openfield];
                            end
                            if sum(tempISI(4,:)) ~=0
                                KO_I_di = [ KO_I_di ; tempISI(4,:)];
                            else
                                KO_I_di = [ KO_I_di];
                            end
                        end
                    end
                else
                end

            end
        else
        end
    else
    end

end

%% for mouse 2

for ii = 1:size(ISI_proportions,1)
    if ~isempty(ISI_proportions{ii,5})
        mousegenotype = ISI_proportions{ii,3}(3:4);
        mouseISI = ISI_proportions{ii,5}(:,1);
        if size(ISI_proportions{ii,5},2)>1
            neurontypeS = ISI_proportions{ii,5}(:,2);
            for jj = 1:size(mouseISI,1)

                tempISI = mouseISI{jj,1};
                if ~isempty(tempISI)
                    neuron_type = neurontypeS{jj,1};
                    if strcmp(mousegenotype,'WT') == 1
                        if strcmp(neuron_type, 'E') == 1
                            WT_E_overall = [WT_E_overall ; tempISI(1,:)];

                            if sum(tempISI(2,:)) ~=0
                                WT_E_baseline = [ WT_E_baseline ; tempISI(2,:)];
                            else
                                WT_E_baseline = [ WT_E_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                WT_E_openfield = [WT_E_openfield ; tempISI(3,:)];
                            else
                                WT_E_openfield = [WT_E_openfield];
                            end
                            if sum(tempISI(4,:)) ~=0
                                WT_E_di = [ WT_E_di ; tempISI(4,:)];
                            else
                                WT_E_di = [ WT_E_di];
                            end
                        else
                            WT_I_overall = [WT_I_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                WT_I_baseline = [ WT_I_baseline ; tempISI(2,:)];
                            else
                                WT_I_baseline = [ WT_I_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                WT_I_openfield = [WT_I_openfield ; tempISI(3,:)];
                            else
                                WT_I_openfield = [WT_I_openfield];
                            end
                            if sum(tempISI(4,:)) ~=0
                                WT_I_di = [ WT_I_di ; tempISI(4,:)];
                            else
                                WT_I_di = [ WT_I_di];
                            end
                        end
                    else
                        if strcmp(neuron_type, 'E') == 1
                            KO_E_overall = [KO_E_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                KO_E_baseline = [ KO_E_baseline ; tempISI(2,:)];
                            else
                                KO_E_baseline = [ KO_E_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                KO_E_openfield = [KO_E_openfield ; tempISI(3,:)];
                            else
                                KO_E_openfield = [KO_E_openfield];
                            end
                            if sum(tempISI(4,:)) ~=0
                                KO_E_di = [ KO_E_di ; tempISI(4,:)];
                            else
                                KO_E_di = [ KO_E_di];
                            end

                        else
                            KO_I_overall = [KO_I_overall ; tempISI(1,:)];
                            if sum(tempISI(2,:)) ~=0
                                KO_I_baseline = [ KO_I_baseline ; tempISI(2,:)];
                            else
                                KO_I_baseline = [ KO_I_baseline];
                            end
                            if sum(tempISI(3,:)) ~=0
                                KO_I_openfield = [KO_I_openfield ; tempISI(3,:)];
                            else
                                KO_I_openfield = [KO_I_openfield];
                            end
                            if sum(tempISI(4,:)) ~=0
                                KO_I_di = [ KO_I_di ; tempISI(4,:)];
                            else
                                KO_I_di = [ KO_I_di];
                            end
                        end
                    end
                else
                end

            end
        else
        end
    else
    end

end
WT_E = {WT_E_baseline,WT_E_openfield,WT_E_di};
WT_I = {WT_I_baseline,WT_I_openfield,WT_I_di};

KO_E = {KO_E_baseline,KO_E_openfield,KO_E_di};
KO_I = {KO_I_baseline,KO_I_openfield,KO_I_di};


ISIdata = {WT_E,WT_I,KO_E,KO_I};

% Total range
totalRange = 200;

% Number of intervals (39 intervals for 40 points)
numIntervals = 40 - 1;

% Calculate step size
stepSize = totalRange / numIntervals;


for ii = 1:4
    temptotal = ISIdata {1,ii};
    for jj = 1:3
        tempISI = temptotal{1,jj};

        % Example for calculating mean and SEM for one category
        meanISI = nanmean(tempISI, 1);
        semISI = nanstd(tempISI, 0, 1) / sqrt(size(tempISI, 1));  % Standard Error of the Mean


        % Define x-axis (assuming ISI bins)
        x = 0:stepSize:200;  % Or your specific bin centers

        % Define upper and lower bounds of the shaded area
        upper = meanISI + semISI;
        lower =  meanISI - semISI;

        % Plot shaded area

        fill([x fliplr(x)], [upper fliplr(lower)], [0.9 0.9 0.9], 'linestyle', 'none'); % Light grey fill
        hold on;

        % Plot mean line
        if jj == 1
            color = [0 0.4470 0.7410];
        elseif jj == 2
            color = [0.8500 0.3250 0.0980];
        else
            color = [0.4940 0.1840 0.5560];
        end

        plot(x, meanISI, 'Color',color, 'LineWidth', 2); % Black mean line
        ylim([0 0.12])


        hold on;
    end
end


