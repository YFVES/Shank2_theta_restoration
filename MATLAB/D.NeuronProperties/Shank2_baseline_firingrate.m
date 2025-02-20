
clear all

Total_WT={};
Total_KO={};

folder=dir('2023-*');

for n=1:length(folder)
    cd(folder(n).name);

    struct_name = folder(n).name(1:19)



    load(struct_name,'-mat')


    [Timestamps,TTL, EventStrings] = Nlx2MatEV('Events.nev', [1 0 1 0 1], 0, 1, [] );

    baseline_start = Timestamps(1,1)/1000000;
    baseline_finish = Timestamps(1,2)/1000000;

    if size(K.SPK,2)>0
        Firing_animal_1 =K.SPK(:,1);
        Firing_animal_1 = Firing_animal_1(~cellfun('isempty',Firing_animal_1));


        Firing_rate=Firing_animal_1;

        m=size(Total_WT,1);
        o=size(Total_KO,1);


        for i=1:length(Firing_rate)

            last=find(Firing_rate{i,1}>baseline_start&Firing_rate{i,1}<baseline_finish);

            if ~isempty(last)

                Hz(i)=length(last)/(baseline_finish-baseline_start);

               

                if sum(K.ID{1,1}(3:4) == 'WT') == 2
                    Total_WT{m+i,1} = struct_name;
                    Total_WT{m+i,2}=K.ID{1,1}(3:4);
                    Total_WT{m+i,3}=Hz(i);
                else
                    Total_KO{o+i,1} = struct_name;
                    Total_KO{o+i,2}=K.ID{1,1}(3:4);
                    Total_KO{o+i,3}=Hz(i);
                end


            else
            end

        end
    else
    end

    if size(K.SPK)>1
        Firing_animal_2 =K.SPK(:,2);
        Firing_animal_2 = Firing_animal_2(~cellfun('isempty',Firing_animal_2));


        Firing_rate=Firing_animal_2;

        m=size(Total_WT,1);
        o=size(Total_KO,1);

        for i=1:length(Firing_rate)

            last=find(Firing_rate{i,1}>baseline_start&Firing_rate{i,1}<baseline_finish);

            if ~isempty(last)

                Hz(i)=length(last)/(baseline_finish-baseline_start);
                if Hz(i)>0.5
                    if sum(K.ID{1,1}(3:4) == 'WT') == 2
                        Total_WT{m+i,1} = struct_name;
                        Total_WT{m+i,2}=K.ID{1,1}(3:4);
                        Total_WT{m+i,3}=Hz(i);
                    else
                        Total_KO{o+i,1} = struct_name;
                        Total_KO{o+i,2}=K.ID{1,1}(3:4);
                        Total_KO{o+i,3}=Hz(i);
                    end
                else
                end
            else
            end

        end
    else
    end

    cd('H:\')
    %cd('F:\Dual interaction - sorted')
end

