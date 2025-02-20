
clear all

Total_WT={};
Total_KO={};
omitted = 0; 
folder=dir('2023-*');

for n=[1:10,12:length(folder)]
    cd(folder(n).name);

    struct_name = folder(n).name(1:19)



    load(struct_name,'-mat')


    di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
    di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second



    Firing_animal_1 =K.SPK(:,1);
    Firing_animal_1 = Firing_animal_1(~cellfun('isempty',Firing_animal_1));


    Firing_rate=Firing_animal_1;

    m=size(Total_WT,1);
    o=size(Total_KO,1);


    for i=1:length(Firing_rate)

        last=find(Firing_rate{i,1}>di_start&Firing_rate{i,1}<di_finish);

        if ~isempty(last)

            Hz(i)=length(last)/(di_finish-di_start);
            if sum(K.ID{1,1}(3:4) == 'WT') == 2
                Total_WT{m+i,1}=K.ID{1,1}(3:4);
                Total_WT{m+i,2}=K.date;
                Total_WT{m+i,3}=Hz(i);
            else
                Total_KO{o+i,1}=K.ID{1,1}(3:4);
                Total_KO{o+i,2}=K.date;
                Total_KO{o+i,3}=Hz(i);
            end
        else
            omitted = omitted + 1;
        end

    end
    if size(K.SPK)>1
        Firing_animal_2 =K.SPK(:,2);
        Firing_animal_2 = Firing_animal_2(~cellfun('isempty',Firing_animal_2));


        Firing_rate=Firing_animal_2;

        m=size(Total_WT,1);
        o=size(Total_KO,1);

        for i=1:length(Firing_rate)

            last=find(Firing_rate{i,1}>di_start&Firing_rate{i,1}<di_finish);

            if ~isempty(last)

                Hz(i)=length(last)/(di_finish-di_start);
                if sum(K.ID{1,2}(3:4) == 'WT') == 2
                    Total_WT{m+i,1}=K.ID{1,2}(3:4);
                    Total_WT{m+i,2}=K.date;
                    Total_WT{m+i,3}=Hz(i);
                else
                    Total_KO{o+i,1}=K.ID{1,2}(3:4);
                    Total_KO{o+i,2}=K.date;
                    Total_KO{o+i,3}=Hz(i);
                end
            else
                omitted = omitted + 1;
            end

        end
    else
    end

    cd('H:\')
    %cd('F:\Dual interaction - sorted')
end

