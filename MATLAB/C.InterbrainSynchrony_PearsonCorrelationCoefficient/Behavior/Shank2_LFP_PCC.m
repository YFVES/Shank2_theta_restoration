clear all;
close all;
clc;

main = cd;
files = dir('2024-*');
foldernames = char(files.name);


% This matlab script is used to filter out noise in LFP.ncs files.
%  You need custom function 'CommonElemTol.m' in order to run this code.

PCC_all= {};

for ii =  1%:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19);
    cd(files(ii).name);

    struct_name = foldern(1:19)
    mouse1ID = foldern(end-8:end-5);
    mouse2ID = foldern(end-3:end);

    %if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
        if isfile (strcat(struct_name,'_LFP.mat'))
            load(strcat(struct_name,'_LFP.mat'))





            %% calcualte power per band (Theta, low gamma, high gamma)


            Fs = SamplingFreq;
            % Fs = 2000;
            params.Fs = SamplingFreq; %2023:1875 / 2021:1875 / 2020:2000 recordings
            %params.Fs = 2000; %2023:1875 / 2021:1875 / 2020:2000 recordings
            params.tapers   = [3 5]; %[TWprod numTapers]; %[T*W (2*T*W)-1] the higher the tapers, the smoother the spectrum looks and the poorer the freq. resolution
            params.fpass    = [2 4]; % the frequency range over which to compute the spectrum
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


            PCC = (min(min(corr(mouse1,mouse2,'type','Pearson'))));

            PCC_all{ii,1} = struct_name;
            PCC_all{ii,2} = PCC;

            PCC_all{ii,3} = mouse1ID;
            PCC_all{ii,4} = mouse2ID;

            PCC_all{ii,5} = mouse1;
            PCC_all{ii,6} = mouse2;

        else
        end


    %end
    cd(main)

end


% get rid of empty row
PCC_all(all(cellfun(@isempty, PCC_all),2),:) = [];




%find between LFP trials (same mouse, different other)
mouse1_IDinfo = PCC_all(:,3);
mouse2_IDinfo = PCC_all(:,4);

for ii = 1:length(PCC_all)

    mouse1ID = PCC_all{ii,3};
    mouse2ID = PCC_all{ii,4};


    mouse1_indices_m2 = findMatchingCells(mouse2_IDinfo,mouse1ID);

    if ~isempty(mouse1_indices_m2)
        randnum = randi(length(mouse1_indices_m2));

        if length(mouse1_indices_m2)>1
            PCC_all{ii,7} = PCC_all{mouse1_indices_m2(randnum),5};
        else
            mouse1_indices_m2 = findMatchingCells(mouse2_IDinfo,mouse1ID);
            PCC_all{ii,7} = PCC_all{mouse1_indices_m2(1),5};
        end



    else
        mouse1_indices_m1 = findMatchingCells(mouse1_IDinfo,mouse1ID);

        randnum = randi(length(mouse1_indices_m1));
        if length(mouse1_indices_m1)>1
            randnum = randi(length(mouse1_indices_m1));
            if ii == mouse1_indices_m1(randnum)
                PCC_all{ii,7} = PCC_all{mouse1_indices_m1(ceil(randnum*0.5)),6};
            else
                PCC_all{ii,7} = PCC_all{mouse1_indices_m1(randnum),6};
            end
        else
        end





    end




    mouse2_indices_m1 = findMatchingCells(mouse1_IDinfo,mouse2ID);

    if  length(mouse2_indices_m1)>1


        randnum = randi(length(mouse2_indices_m1));

        if length(mouse2_indices_m1)>1

            PCC_all{ii,8} = PCC_all{mouse2_indices_m1(randnum),6};
        else
            mouse2_indices_m1 = findMatchingCells(mouse1_IDinfo,mouse2ID);
            PCC_all{ii,8} = PCC_all{mouse2_indices_m1(1),6};
        end

    else

        mouse2_indices_m2 = findMatchingCells(mouse2_IDinfo,mouse2ID);
        if length(mouse2_indices_m2)>1
            randnum = randi(length(mouse2_indices_m2));
            if ii == mouse2_indices_m2(randnum)
                PCC_all{ii,8} = PCC_all{mouse2_indices_m2(ceil(randnum*0.5)),5};
            else
                PCC_all{ii,8} = PCC_all{mouse2_indices_m2(randnum),5};
            end
        else
        end




    end


end


for jj = 1:size(PCC_all,1)
    if ~isempty(PCC_all{jj,7})

        mouse1 = PCC_all{jj,5};
        mouse3 = PCC_all{jj,7};

        m1_length = length(mouse1);
        m3_length = length(mouse3);

        if m1_length>m3_length
            mouse1_cut = mouse1(1:m3_length);
            mouse3_cut = mouse3;
        elseif m1_length<m3_length
            mouse1_cut = mouse1;
            mouse3_cut = mouse3(1:m1_length);
        else
            mouse1_cut = mouse1;
            mouse3_cut = mouse3;
        end

        PCC = (min(min(corr(mouse1_cut,mouse3_cut,'type','Pearson'))));
        PCC_all{jj,9} = PCC;
    else
    end

end


for jj = 1:size(PCC_all,1)
    if ~isempty(PCC_all{jj,8})
        mouse2 = PCC_all{jj,6};
        mouse4 = PCC_all{jj,8};
        m2_length = length(mouse2);
        m4_length = length(mouse4);

        if m2_length>m4_length
            mouse2_cut = mouse2(1:m4_length);
            mouse4_cut = mouse4;
        elseif m2_length<m4_length
            mouse2_cut = mouse2;
            mouse4_cut = mouse4(1:m2_length);
        else
            mouse2_cut = mouse2;
            mouse4_cut = mouse4;
        end

        PCC = (min(min(corr(mouse2_cut,mouse4_cut,'type','Pearson'))));

        PCC_all{jj,10} = PCC;
    else
    end
end




