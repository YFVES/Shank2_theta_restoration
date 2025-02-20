close all; clc; clearvars;

%Code written by Eunkyu Hwang
%Last edited: July 6th, 2022
%make sure the order of channels are correct (color of tether, yellow can
%be 1-32 in some cases

main = cd;
files = dir('2024-*');
foldernames = char(files.name);



Fs = 1875; %sampling frequency 2023 LFP
%Fs = 2000;

%Get subject information and trial information
for ii = 1:length(foldernames)
    %K = struct;
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19);

    cd(files(ii).name);

    struct_name = foldern(1:19)
    load(struct_name,'-mat')
    K.LFP = {};
%     currentdirectory = cd;
%     newdirectory = strcat('G:\Shank2\Optostim_chronic',K.date);
%     if isfolder (newdirectory)
%         cd (newdirectory)

        K.SPK = {};
        %% K.SPK = spike timing

        fn=FindFiles('*.t64');
        WV=FindFiles('*-wv.mat');
        CQ=FindFiles('*-CluQual.mat');
        if length(fn)>=1 % if there is isolated neuron

            for x=1:length(fn)
                filename = fn(x);
                tt_filename = filename{1,1};

                if length(tt_filename) == 67 %69 %52%43
                    tt_number = str2num(tt_filename(end-7));
                    if tt_number <9
                        S=LoadSpikes(fn(x));
                        K.SPK{x,1}=S{1,1}.T;
                        load(WV{x})
                        peak=max(mWV);
                        [tp,tpp]=find(mWV==max(peak));
                        if length(tpp)>1
                            tpp=tpp(1);
                        end
                        valley=min(mWV(:,tpp));
                        [tv,tvv]=find(mWV==valley);
                        if length(tvv)>1
                            tvv=tvv(1);
                        end
                        a=find(mWV(:,tvv)<=0.5*valley);
                        HVW=abs(min(a)-max(a))*30.25;
                        peaktovalley=abs(max(peak)/-min(valley));

                        if peaktovalley<1.6 && HVW <200
                            K.SPK{x,3}='I';
                        else
                            K.SPK{x,3}='E';
                        end
                    else
                        S=LoadSpikes(fn(x));
                        K.SPK{x,2}=S{1,1}.T;
                        load(WV{x})
                        peak=max(mWV);
                        [tp,tpp]=find(mWV==max(peak));
                        if length(tpp)>1
                            tpp=tpp(1);
                        end
                        valley=min(mWV(:,tpp));
                        [tv,tvv]=find(mWV==valley);
                        if length(tvv)>1
                            tvv=tvv(1);
                        end
                        a=find(mWV(:,tvv)<=0.5*valley);
                        HVW=abs(min(a)-max(a))*30.25;
                        peaktovalley=abs(max(peak)/-min(valley));
                        if peaktovalley<1.6 && HVW <200
                            K.SPK{x,4}='I';
                        else
                            K.SPK{x,4}='E';
                        end

                    end
                else
                    S=LoadSpikes(fn(x));

                    K.SPK{x,2}=S{1,1}.T;

                    load(WV{x})
                    peak=max(mWV);
                    [tp,tpp]=find(mWV==max(peak));
                    if length(tpp)>1
                        tpp=tpp(1);
                    end
                    valley=min(mWV(:,tpp));
                    [tv,tvv]=find(mWV==valley);
                    if length(tvv)>1
                        tvv=tvv(1);
                    end
                    a=find(mWV(:,tvv)<=0.5*valley);
                    HVW=abs(min(a)-max(a))*30.25;
                    peaktovalley=abs(max(peak)/-min(valley));

                    if peaktovalley<1.6 && HVW <200
                        K.SPK{x,4}='I';
                    else
                        K.SPK{x,4}='E';
                    end
                end
            end


        else

            % if there is no isolated neuron
            K.SPK={};


        end

       

%         cd(main)
         save(K.date, 'K');
%     else
%         save(K.date, 'K');
%         
% 
%     end
cd(main);
end

