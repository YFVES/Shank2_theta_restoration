clc
clear all
close all

main = cd;



folder = dir('2021-*');

for ii =  1:length(folder)

         cd(folder(ii).name);
         struct_name = folder(ii).name(1:19)
    
         load(struct_name,'-mat')

    
    current_data_folder = cd;

    K.NonSocialBehavior{1,2}(:,4:5) = []; 

%     %% K.Social Behavior
%     di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
%     di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second
% 
%     current_data_folder = cd;
% 
%     cd C:\Users\USER\Desktop\Social\2021_backup
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,1},'.xml');
% 
%     l = 1;
% 
%     Shank2_socialbehavior_boutcreation_mouse1
%     K.SocialBehavior{:,1} = {'unisniffing','bisniffing','chasing','approach','escape'};
%     K.SocialBehavior{:,2} = {unisniffing_data,bisniffing_data,chasing_data,approach_data,escape_data};
% 
% 
%     cd (current_data_folder);
% 
% 
% 
%     cd C:\Users\USER\Desktop\Social\2021_backup
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,2},'.xml');
% 
%     l = 1;
% 
%     Shank2_socialbehavior_boutcreation_mouse1
% 
%     K.SocialBehavior{:,3} = {unisniffing_data,bisniffing_data,chasing_data,approach_data,escape_data};
% 
% 
%     cd (current_data_folder);

%     %% K.Non Social Behavior
% 
% 
% 
%     cd C:\Users\USER\Desktop\NonSocial\2021
% 
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,1},'_nonsocial','.xml');
%     l = 1;
% 
%     Shank2_nonsocialbehavior_boutcreation_2021
% 
%     K.NonSocialBehavior{:,1} = {'grooming','rearing','jumping'};
%     K.NonSocialBehavior{:,2} = {grooming_data,rearing_data,jumping_data};
% 
% 
%     cd (current_data_folder);
% 
% 
% 
%     cd C:\Users\USER\Desktop\NonSocial\2021
% 
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,2},'_nonsocial','.xml');
%     l = 1;
% 
%     Shank2_nonsocialbehavior_boutcreation_2021
% 
% 
%     K.NonSocialBehavior{:,3} = {grooming_data,rearing_data,jumping_data};
% 
% 
%     cd (current_data_folder);

%     %% K.Exploring
% 
% 
% 
%     cd C:\Users\USER\Desktop\NonSocial\2021
% 
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,1},'_nonsocial','.xml');
%     l = 1;
% 
%     Shank2_nonsocialbehavior_boutcreation_2021
% 
% 
%     K.Exploring{:,1} = {'movement','circling_counter','circling_clock'};
%     K.Exploring{:,2} = {circling_data,exploring_data, []};
% 
% 
%     cd (current_data_folder);
% 
% 
% 
%     cd C:\Users\USER\Desktop\NonSocial\2021
% 
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,2},'_nonsocial','.xml');
%     l = 1;
% 
%     Shank2_nonsocialbehavior_boutcreation_2021
% 
% 
%     K.Exploring{:,3} = {circling_data,exploring_data, []};
% 
%     cd (current_data_folder);


%     %% K.Immobile(rest)
% 
% 
% 
%     cd C:\Users\USER\Desktop\NonSocial\2021
% 
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,1},'_nonsocial','.xml');
%     l = 1;
% 
%     Shank2_auROC_immobile_2021
% 
%     K.Immobile{:,2} = {immobile_data};
% 
%     cd (current_data_folder);
% 
% 
% 
%     cd C:\Users\USER\Desktop\NonSocial\2021
% 
% 
%     xml_filename = strcat(K.date, '_',K.ID{1,2},'_nonsocial','.xml');
%     l = 1;
% 
%     Shank2_auROC_immobile_2021
% 
%     K.Immobile{:,3} = {immobile_data};
% 
%     cd (current_data_folder);





    save(K.date, 'K');
    cd(main);

end
