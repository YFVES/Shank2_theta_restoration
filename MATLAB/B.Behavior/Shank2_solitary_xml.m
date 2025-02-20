x=xml2struct(xml_filename);


    %rest
    if length(x.xmeml{1, 2}.sequence.media.video.track)>1
        if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,1},'clipitem')==1
            clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem));

            if clipitem>0
                for n=1:clipitem
                    if clipitem==1
                        rest(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem.in));
                        rest(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem.out));
                         rest(n,3)=( rest(n,2)- rest(n,1))/29.97;
                    else
                         rest(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem{1, n}.in));
                         rest(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem{1, n}.out));
                         rest(n,3)=(rest(n,2)- rest(n,1))/29.97;
                    end
                end
                 rest_dat(l,2)=length(rest(:,1));
                 rest_dat(l,1)=sum(rest(:,3));
                 restraw{l}= rest;
            else
                 rest_dat(l,2)=0;
                 rest_dat(l,1)=0;
                 rest=[0,0,0];
                 restraw{l}= rest;
            end
        else
             rest_dat(l,2)=0;
             rest_dat(l,1)=0;
             rest=[0,0,0];
             restraw{l}= rest;
        end 
    else
         rest_dat(l,2)=0;
         rest_dat(l,1)=0;
         rest=[0,0,0];
         restraw{l}= rest;
    end 

    %grooming
    if length(x.xmeml{1, 2}.sequence.media.video.track)>1
        if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,2},'clipitem')==1
            clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem));

            if clipitem>0
                for n=1:clipitem
                    if clipitem==1
                        grooming(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem.in));
                        grooming(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem.out));
                        grooming(n,3)=(grooming(n,2)-grooming(n,1))/29.97;
                    else
                        grooming(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem{1, n}.in));
                        grooming(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem{1, n}.out));
                        grooming(n,3)=(grooming(n,2)-grooming(n,1))/29.97;
                    end
                end
                grooming_dat(l,2)=length(grooming(:,1));
                grooming_dat(l,1)=sum(grooming(:,3));
                groomingraw{l}=grooming;
            else
                grooming_dat(l,2)=0;
                grooming_dat(l,1)=0;
                grooming=[0,0,0];
                groomingraw{l}=grooming;
            end
        else
            grooming_dat(l,2)=0;
            grooming_dat(l,1)=0;
            grooming=[0,0,0];
            groomingraw{l}=grooming;
        end 
    else
        grooming_dat(l,2)=0;
        grooming_dat(l,1)=0;
        grooming=[0,0,0];
        groomingraw{l}=grooming;
    end 
    
    %rearing
    if length(x.xmeml{1, 2}.sequence.media.video.track)>2
        if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,3},'clipitem')==1
            clipitem=length(x.xmeml{1, 2}.sequence.media.video.track{1, 3}.clipitem);

            if clipitem>0
                for n=1:clipitem
                    if clipitem==1
                        rearing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem.in));
                        rearing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem.out));
                        rearing(n,3)=(rearing(n,2)-rearing(n,1))/29.97;
                    else
                        rearing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem{1, n}.in));
                        rearing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem{1, n}.out));
                        rearing(n,3)=(rearing(n,2)-rearing(n,1))/29.97;
                    end 
                end
                rearing_dat(l,2)=length(rearing(:,1));
                rearing_dat(l,1)=sum(rearing(:,3));
                rearingraw{l}=rearing;
            else
                rearing_dat(l,2)=0;
                rearing_dat(l,1)=0;
                rearing=[0,0,0];
                rearingraw{l}=rearing;
            end   
        else
            rearing_dat(l,2)=0;
            rearing_dat(l,1)=0;
            rearing=[0,0,0];
            rearingraw{l}=rearing;
        end
    else
        rearing_dat(l,2)=0;
        rearing_dat(l,1)=0;
        rearing=[0,0,0];
        rearingraw{l}=rearing;
    end
    
    %jumping
    if length(x.xmeml{1, 2}.sequence.media.video.track)>3
        if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,4},'clipitem')==1
            clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1,4}.clipitem));

            if clipitem>0
                for n=1:clipitem
                    if clipitem==1
                        jumping(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem.in));
                        jumping(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem.out));
                        jumping(n,3)=(jumping(n,2)-jumping(n,1))/29.97;
                    else
                        jumping(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem{1, n}.in));
                        jumping(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem{1, n}.out));
                        jumping(n,3)=(jumping(n,2)-jumping(n,1))/29.97;
                    end
                end
                jumping_dat(l,2)=length(jumping(:,1));
                jumping_dat(l,1)=sum(jumping(:,3));
                jumpingraw{l}=jumping;
            else
                jumping_dat(l,2)=0;
                jumping_dat(l,1)=0;
                jumping=[0,0,0];
                jumpingraw{l}=jumping;
            end
        else
            jumping_dat(l,2)=0;
            jumping_dat(l,1)=0;
            jumping=[0,0,0];
            jumpingraw{l}=jumping;
        end 
    else
        jumping_dat(l,2)=0;
        jumping_dat(l,1)=0;
        jumping=[0,0,0];
        jumpingraw{l}=jumping;
    end 

    %circling
    if length(x.xmeml{1, 2}.sequence.media.video.track)>4
        if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,5},'clipitem')==1
            clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem));

            if clipitem>0
                for n=1:clipitem
                    if clipitem==1
                        circling(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem.in));
                        circling(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem.out));
                        circling(n,3)=(circling(n,2)-circling(n,1))/29.97;
                    else
                        circling(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem{1, n}.in));
                        circling(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem{1, n}.out));
                        circling(n,3)=(circling(n,2)-circling(n,1))/29.97;
                    end
                end
                circling_dat(l,2)=length(circling(:,1));
                circling_dat(l,1)=sum(circling(:,3));
                circlingraw{l}=circling;
            else
                circling_dat(l,2)=0;
                circling_dat(l,1)=0;
                circling=[0,0,0];
                circlingraw{l}=circling;
            end
        else
            circling_dat(l,2)=0;
            circling_dat(l,1)=0;
            circling=[0,0,0];
            circlingraw{l}=circling;
        end 
    else
        circling_dat(l,2)=0;
        circling_dat(l,1)=0;
        circling=[0,0,0];
        circlingraw{l}=circling;
    end 
    
   %exploring(moving inclulded)
   if length(x.xmeml{1, 2}.sequence.media.video.track)>5
        if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,6},'clipitem')==1
            clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem));

            if clipitem>0
                for n=1:clipitem
                    if clipitem==1
                        exploring(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem.in));
                        exploring(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem.out));
                        exploring(n,3)=(exploring(n,2)-exploring(n,1))/29.97;
                    else
                        exploring(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem{1, n}.in));
                        exploring(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem{1, n}.out));
                        exploring(n,3)=(exploring(n,2)-exploring(n,1))/29.97;
                    end
                end
                exploring_dat(l,2)=length(exploring(:,1));
                exploring_dat(l,1)=sum(exploring(:,3));
                exploringraw{l}=exploring;
            else
                exploring_dat(l,2)=0;
                exploring_dat(l,1)=0;
                exploring=[0,0,0];
                exploringraw{l}=exploring;
            end
        else
            exploring_dat(l,2)=0;
            exploring_dat(l,1)=0;
            exploring=[0,0,0];
            exploringraw{l}=exploring;
        end 
    else
        exploring_dat(l,2)=0;
        exploring_dat(l,1)=0;
        exploring=[0,0,0];
        exploringraw{l}=exploring;
    end 


