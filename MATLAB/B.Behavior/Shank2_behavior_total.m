clear all
f=findfiles('xml');
Total={};

for l=1:length(f)

x=xml2struct(f{l});
% 
%2023
%  ExpDate = f{1,l}(end-36:end-18)
%     ExPSubject = f{1,l}(end-16:end-13);

    %optostim
 ExpDate = f{1,l}(end-34:end-16)
    ExPSubject = f{1,l}(end-13:end-11);

%     %2021
%     ExpDate = f{1,l}(end-27:end-9)
%     ExPSubject = f{1,l}(end-7:end-4);


%body contact
if length(x.xmeml{1, 2}.sequence.media.video.track)>1
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,2},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    bodycontact(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem.in));
                    bodycontact(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem.out));
                    bodycontact(n,3)=(bodycontact(n,2)-bodycontact(n,1))/29.97;
                else
                    bodycontact(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem{1, n}.in));
                    bodycontact(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem{1, n}.out));
                    bodycontact(n,3)=(bodycontact(n,2)-bodycontact(n,1))/29.97;
                end
            end
            bodycontact_dat(l,2)=length(bodycontact(:,1));
            bodycontact_dat(l,1)=sum(bodycontact(:,3));
            bodycontactraw{l}=bodycontact;
        else
            bodycontact_dat(l,2)=0;
            bodycontact_dat(l,1)=0;
            bodycontact=[0,0,0];
            bodycontactraw{l}=bodycontact;
        end
    else
        bodycontact_dat(l,2)=0;
        bodycontact_dat(l,1)=0;
        bodycontact=[0,0,0];
        bodycontactraw{l}=bodycontact;
    end
else
    bodycontact_dat(l,2)=0;
    bodycontact_dat(l,1)=0;
    bodycontact=[0,0,0];
    bodycontactraw{l}=bodycontact;
end

%uni lateral sniffing (unisniffing)
if length(x.xmeml{1, 2}.sequence.media.video.track)>2
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,3},'clipitem')==1
        clipitem=length(x.xmeml{1, 2}.sequence.media.video.track{1, 3}.clipitem);

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    unisniffing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem.in));
                    unisniffing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem.out));
                    unisniffing(n,3)=(unisniffing(n,2)-unisniffing(n,1))/29.97;
                else
                    unisniffing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem{1, n}.in));
                    unisniffing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1,3}.clipitem{1, n}.out));
                    unisniffing(n,3)=(unisniffing(n,2)-unisniffing(n,1))/29.97;
                end
            end
            unisniffing_dat(l,2)=length(unisniffing(:,1));
            unisniffing_dat(l,1)=sum(unisniffing(:,3));
            unisniffingraw{l}=unisniffing;
        else
            unisniffing_dat(l,2)=0;
            unisniffing_dat(l,1)=0;
            unisniffing=[0,0,0];
            unisniffingraw{l}=unisniffing;
        end
    else
        unisniffing_dat(l,2)=0;
        unisniffing_dat(l,1)=0;
        unisniffing=[0,0,0];
        unisniffingraw{l}=unisniffing;
    end
else
    unisniffing_dat(l,2)=0;
    unisniffing_dat(l,1)=0;
    unisniffing=[0,0,0];
    unisniffingraw{l}=unisniffing;
end

%bi-directional sniffing (bisniffing)
if length(x.xmeml{1, 2}.sequence.media.video.track)>3
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,4},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1,4}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    bisniffing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem.in));
                    bisniffing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem.out));
                    bisniffing(n,3)=(bisniffing(n,2)-bisniffing(n,1))/29.97;
                else
                    bisniffing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem{1, n}.in));
                    bisniffing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem{1, n}.out));
                    bisniffing(n,3)=(bisniffing(n,2)-bisniffing(n,1))/29.97;
                end
            end
            bisniffing_dat(l,2)=length(bisniffing(:,1));
            bisniffing_dat(l,1)=sum(bisniffing(:,3));
            bisniffingraw{l}=bisniffing;
        else
            bisniffing_dat(l,2)=0;
            bisniffing_dat(l,1)=0;
            bisniffing=[0,0,0];
            bisniffingraw{l}=bisniffing;
        end
    else
        bisniffing_dat(l,2)=0;
        bisniffing_dat(l,1)=0;
        bisniffing=[0,0,0];
        bisniffingraw{l}=bisniffing;
    end
else
    bisniffing_dat(l,2)=0;
    bisniffing_dat(l,1)=0;
    bisniffing=[0,0,0];
    bisniffingraw{l}=bisniffing;
end

%chasing

if length(x.xmeml{1, 2}.sequence.media.video.track)>4
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,5},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    chasing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem.in));
                    chasing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem.out));
                    chasing(n,3)=(chasing(n,2)-chasing(n,1))/29.97;
                else
                    chasing(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem{1, n}.in));
                    chasing(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem{1, n}.out));
                    chasing(n,3)=(chasing(n,2)-chasing(n,1))/29.97;
                end
            end
            chasing_dat(l,2)=length(chasing(:,1));
            chasing_dat(l,1)=sum(chasing(:,3));
            chasingraw{l}=chasing;
        else
            chasing_dat(l,2)=0;
            chasing_dat(l,1)=0;
            chasing=[0,0,0];
            chasingraw{l}=chasing;
        end
    else
        chasing_dat(l,2)=0;
        chasing_dat(l,1)=0;
        chasing=[0,0,0];
        chasingraw{l}=chasing;
    end
else
    chasing_dat(l,2)=0;
    chasing_dat(l,1)=0;
    chasing=[0,0,0];
    chasingraw{l}=chasing;
end

%approach
if length(x.xmeml{1, 2}.sequence.media.video.track)>5
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,6},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    approach(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem.in));
                    approach(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem.out));
                    approach(n,3)=(approach(n,2)-approach(n,1))/29.97;
                else
                    approach(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem{1, n}.in));
                    approach(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem{1, n}.out));
                    approach(n,3)=(approach(n,2)-approach(n,1))/29.97;
                end
            end
            approach_dat(l,2)=length(approach(:,1));
            approach_dat(l,1)=sum(approach(:,3));
            approachraw{l}=approach;
        else
            approach_dat(l,2)=0;
            approach_dat(l,1)=0;
            approach=[0,0,0];
            approachraw{l}=approach;
        end
    else
        approach_dat(l,2)=0;
        approach_dat(l,1)=0;
        approach=[0,0,0];
        approachraw{l}=approach;
    end
else
    approach_dat(l,2)=0;
    approach_dat(l,1)=0;
    approach=[0,0,0];
    approachraw{l}=approach;
end

%escape
if length(x.xmeml{1, 2}.sequence.media.video.track)>6
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,7},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1,7}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    escape(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 7}.clipitem.in));
                    escape(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 7}.clipitem.out));
                    escape(n,3)=(escape(n,2)-escape(n,1))/29.97;
                else
                    escape(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 7}.clipitem{1, n}.in));
                    escape(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 7}.clipitem{1, n}.out));
                    escape(n,3)=(escape(n,2)-escape(n,1))/29.97;
                end
            end
            escape_dat(l,2)=length(escape(:,1));
            escape_dat(l,1)=sum(escape(:,3));
            escaperaw{l}=escape;
        else
            escape_dat(l,2)=0;
            escape_dat(l,1)=0;
            escape=[0,0,0];
            escaperaw{l}=escape;
        end
    else
        escape_dat(l,2)=0;
        escape_dat(l,1)=0;
        escape=[0,0,0];
        escaperaw{l}=escape;
    end
else
    escape_dat(l,2)=0;
    escape_dat(l,1)=0;
    escape=[0,0,0];
    escaperaw{l}=escape;
end



Total{l,1}=ExpDate;
Total{l,2} = ExPSubject;

%m1
%approach
Total{l,3}=approach_dat(l,1);
Total{l,4}=approach_dat(l,2);
Total{l,5}=mean(approachraw{1,l}(:,3));

%bisniffing
Total{l,6}=bisniffing_dat(l,1);
Total{l,7}=bisniffing_dat(l,2);
Total{l,8}=mean(bisniffingraw{1,l}(:,3));

%unisniffing
Total{l,9}=unisniffing_dat(l,1);
Total{l,10}=unisniffing_dat(l,2);
Total{l,11}=mean(unisniffingraw{1,l}(:,3));

%chasing
Total{l,12}=chasing_dat(l,1);
Total{l,13}=chasing_dat(l,2);
Total{l,14}=mean(chasingraw{1,l}(:,3));

%escape
Total{l,15}=escape_dat(l,1);
Total{l,16}=escape_dat(l,2);
Total{l,17}=mean(escaperaw{1,l}(:,3));

bodycontact=[]; unisniffing=[]; bisniffing=[]; chasing = []; approach = []; escape = [];

end

