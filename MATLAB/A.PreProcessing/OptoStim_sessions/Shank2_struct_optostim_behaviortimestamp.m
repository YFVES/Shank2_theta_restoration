clc
clear all
close all

main = cd;



folder = dir('2024-*');

for ii = 18:length(folder)

    cd(folder(ii).name);
    struct_name = folder(ii).name(1:19)

    load(struct_name,'-mat')


    current_data_folder = cd;

    

    
    current_data_folder = cd;

    cd G:\Shank2\Optostim_chronic\social_rest

    xml_filename = strcat(K.date, '_',K.ID{1,1},'_social','.xml');

    l = 1;

    Shank2_optostim_boutcreation

    K.SocialBehavior{:,1} = {'unisniffing','bisniffing','chasing','approach','escape'};
    K.SocialBehavior{:,2} = {unisniffing_data,bisniffing_data,chasing_data,approach_data,escape_data};

    K.NonSocialBehavior{:,1} = {'nonsocial'};
    K.NonSocialBehavior{:,2} = {nonsocial_data};

    K.Immobile{:,1} = {'immobile'};
    K.Immobile{:,2} = {immobile_data};



    cd (current_data_folder);



    cd G:\Shank2\Optostim_chronic\social_rest

    xml_filename = strcat(K.date, '_',K.ID{1,2},'_social','.xml');


    l = 1;

    Shank2_optostim_boutcreation

    K.SocialBehavior{:,3} = {unisniffing_data,bisniffing_data,chasing_data,approach_data,escape_data};
    K.NonSocialBehavior{:,3} = {nonsocial_data};
    K.Immobile{:,3} = {immobile_data};


    cd (current_data_folder);



    save(K.date, 'K');


    cd(main);

end
