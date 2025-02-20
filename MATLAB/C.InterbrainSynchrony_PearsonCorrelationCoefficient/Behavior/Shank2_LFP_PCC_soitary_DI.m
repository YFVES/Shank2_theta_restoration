clear all;
close all;
clc;

main = cd;
files = dir('2023-*');
foldernames = char(files.name);


% This matlab script is used to filter out noise in LFP.ncs files.
%  You need custom function 'CommonElemTol.m' in order to run this code.

PCC_all= {};

for ii =  1:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19);
    cd(files(ii).name);

    struct_name = foldern(1:19)
    mouse1ID = foldern(end-8:end-5);
    mouse2ID = foldern(end-3:end);


    if isfile (strcat(struct_name,'_LFP_m1solitary.mat'))
        load(strcat(struct_name,'_LFP_m1solitary.mat'))





        %% calcualte power per band (Theta, low gamma, high gamma)


        Fs = SamplingFreq;
        % Fs = 2000;
        params.Fs = SamplingFreq;
        %params.Fs = 2000; %2023:1875 / 2021:1875 / 2020:2000 recordings
        params.tapers   = [3 5]; %[TWprod numTapers]; %[T*W (2*T*W)-1] the higher the tapers, the smoother the spectrum looks and the poorer the freq. resolution
        params.fpass    = [4 12]; % the frequency range over which to compute the spectrum
        params.trialave = 0; % whether to average across the LFP epochs (1), or to calculate spectra for each trial (0) NOTE: plotting while params.trialavg=0 will plot each trial
        params.pad      = 1;
        params.err      = [2 0.05];

        stepwin = [5 1]; %second, [window winstep]


        % Define notch filter centered at 60 Hz
        notch_freq = 60;
        notch_width = 2; % Bandwidth of the notch filter
        [b, a] = butter(2, [(notch_freq - notch_width/2)/(Fs/2), (notch_freq + notch_width/2)/(Fs/2)], 'stop');




        % Initialize variables
        mouse1_LFP_slidingwindow = [];
        mouse2_LFP_slidingwindow = [];

        for jj = 1:8
            data =raw_signal_final{1,1}(:,jj);

            % Apply notch filter to remove 60 Hz power line noise
            data_filtered = filtfilt(b, a, data);
            [S,t,f,Serr] = mtspecgramc(data_filtered, stepwin, params);

            %             S_norm = zeros(size(S));
            %             for i = 1:size(S, 2)
            %                 S_norm(:, i) = S(:, i) / max(S(:, i)); % Peak normalization
            %             end
            %             mouse1_LFP_slidingwindow(:,jj) = mean(S_norm,2);
            mouse1_LFP_slidingwindow(:,jj) = sum(S,2);
            %plot (mouse1_LFP_slidingwindow(:,jj),'r')

        end

        %mouse 2 sliding window


        for jj = 1:8
            data = raw_signal_final{1,2}(:,jj);
            data_filtered = filtfilt(b, a, data);
            [S,t,f,Serr] = mtspecgramc(data_filtered, stepwin, params);
            %             S_norm = zeros(size(S));
            %             for i = 1:size(S, 2)
            %                 S_norm(:, i) = S(:, i) / max(S(:, i)); % Peak normalization
            %             end
            %
            %             mouse2_LFP_slidingwindow(:,jj) = mean(S_norm,2);
            mouse2_LFP_slidingwindow(:,jj) = sum(S,2);
        end

        mouse1 = mean(mouse1_LFP_slidingwindow,2);
        mouse2 = mean(mouse2_LFP_slidingwindow,2);
        %
        %     plot (mouse1, 'r')
        %     hold on
        %     plot (mouse2, 'bl')
        %     xlim([0 600])


        PCC = abs(min(min(corr(mouse1,mouse2,'type','Pearson'))));

        PCC_all{ii,1} = struct_name;
        PCC_all{ii,2} = PCC;

        PCC_all{ii,3} = mouse1ID;
        PCC_all{ii,4} = mouse2ID;

        PCC_all{ii,5} = mouse1;
        PCC_all{ii,6} = mouse2;

        PCC_all{ii,7} = PCC; 
        

    else
    end

    if isfile (strcat(struct_name,'_LFP_m2solitary.mat'))
        load(strcat(struct_name,'_LFP_m2solitary.mat'))





        %% calcualte power per band (Theta, low gamma, high gamma)


        Fs = 1875;
        % Fs = 2000;
        params.Fs = 1875; %2023:1875 / 2021:1875 / 2020:2000 recordings
        %params.Fs = 2000; %2023:1875 / 2021:1875 / 2020:2000 recordings
        params.tapers   = [3 5]; %[TWprod numTapers]; %[T*W (2*T*W)-1] the higher the tapers, the smoother the spectrum looks and the poorer the freq. resolution
        params.fpass    = [30 50]; % the frequency range over which to compute the spectrum
        params.trialave = 0; % whether to average across the LFP epochs (1), or to calculate spectra for each trial (0) NOTE: plotting while params.trialavg=0 will plot each trial
        params.pad      = 1;
        params.err      = [2 0.05];

        stepwin = [2 0.5]; %second, [window winstep]


        % Define notch filter centered at 60 Hz
        notch_freq = 60;
        notch_width = 2; % Bandwidth of the notch filter
        [b, a] = butter(2, [(notch_freq - notch_width/2)/(Fs/2), (notch_freq + notch_width/2)/(Fs/2)], 'stop');




        % Initialize variables
        mouse1_LFP_slidingwindow = [];
        mouse2_LFP_slidingwindow = [];

        for jj = 1:8
            data =raw_signal_final{1,1}(:,jj);

            % Apply notch filter to remove 60 Hz power line noise
            data_filtered = filtfilt(b, a, data);
            [S,t,f,Serr] = mtspecgramc(data_filtered, stepwin, params);

            %             S_norm = zeros(size(S));
            %             for i = 1:size(S, 2)
            %                 S_norm(:, i) = S(:, i) / max(S(:, i)); % Peak normalization
            %             end
            %             mouse1_LFP_slidingwindow(:,jj) = mean(S_norm,2);
            mouse1_LFP_slidingwindow(:,jj) = sum(S,2);
            %plot (mouse1_LFP_slidingwindow(:,jj),'r')

        end

        %mouse 2 sliding window


        for jj = 1:8
            data = raw_signal_final{1,2}(:,jj);
            data_filtered = filtfilt(b, a, data);
            [S,t,f,Serr] = mtspecgramc(data_filtered, stepwin, params);
            %             S_norm = zeros(size(S));
            %             for i = 1:size(S, 2)
            %                 S_norm(:, i) = S(:, i) / max(S(:, i)); % Peak normalization
            %             end
            %
            %             mouse2_LFP_slidingwindow(:,jj) = mean(S_norm,2);
            mouse2_LFP_slidingwindow(:,jj) = sum(S,2);
        end

        mouse1 = mean(mouse1_LFP_slidingwindow,2);
        mouse2 = mean(mouse2_LFP_slidingwindow,2);
        %
        %     plot (mouse1, 'r')
        %     hold on
        %     plot (mouse2, 'bl')
        %     xlim([0 600])


        PCC = abs(min(min(corr(mouse1,mouse2,'type','Pearson'))));



        PCC_all{ii,8} = mouse1;
        PCC_all{ii,9} = mouse2;

        PCC_all{ii,10} = PCC;

    else
    end


    cd(main)
    %cd('H:\')
end


% get rid of empty row
PCC_all(all(cellfun(@isempty, PCC_all),2),:) = [];


for ii = 1:length(PCC_all)

    mouse1 = PCC_all{ii,5};
    mouse2 = PCC_all{ii,9};
    if length(mouse1)>length(mouse2)
        mouse1_edit = mouse1(1:length(mouse2));
        mouse2_edit = mouse2;
    elseif length(mouse1)<length(mouse2)
        mouse1_edit = mouse1;
        mouse2_edit = mouse2(1:length(mouse1));
    else
        mouse1_edit = mouse1;
        mouse2_edit = mouse2;
    end

    PCC = abs(min(min(corr(mouse1_edit,mouse2_edit,'type','Pearson'))));
    PCC_all{ii,11} = PCC;
end

  





