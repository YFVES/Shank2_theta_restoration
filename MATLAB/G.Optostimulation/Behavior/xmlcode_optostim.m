
%f=findfiles('xml');

%for l=1:length(f)
% x=xml2struct(f{l});
Total={};
x=xml2struct(xml_filename);


%nonsocial
if length(x.xmeml{1, 2}.sequence.media.video.track)>1
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,1},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    nonsocial(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem.in));
                    nonsocial(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem.out));
                    nonsocial(n,3)=(nonsocial(n,2)-nonsocial(n,1))/29.97;
                else
                    nonsocial(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem{1, n}.in));
                    nonsocial(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem{1, n}.out));
                    nonsocial(n,3)=(nonsocial(n,2)-nonsocial(n,1))/29.97;
                end
            end
            nonsocial_dat(l,2)=length(nonsocial(:,1));
            nonsocial_dat(l,1)=sum(nonsocial(:,3));
            nonsocialraw{l}=nonsocial;
        else
            nonsocial_dat(l,2)=0;
            nonsocial_dat(l,1)=0;
            nonsocial=[0,0,0];
            nonsocialraw{l}=nonsocial;
        end
    else
        nonsocial_dat(l,2)=0;
        nonsocial_dat(l,1)=0;
        nonsocial=[0,0,0];
        nonsocialraw{l}=nonsocial;
    end
else
    nonsocial_dat(l,2)=0;
    nonsocial_dat(l,1)=0;
    nonsocial=[0,0,0];
    nonsocialraw{l}=nonsocial;
end




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

%immobile
if length(x.xmeml{1, 2}.sequence.media.video.track)>7
    if isfield(x.xmeml{1, 2}.sequence.media.video.track{1,8},'clipitem')==1
        clipitem=(length(x.xmeml{1, 2}.sequence.media.video.track{1,8}.clipitem));

        if clipitem>0
            for n=1:clipitem
                if clipitem==1
                    immobile(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 8}.clipitem.in));
                    immobile(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 8}.clipitem.out));
                    immobile(n,3)=(immobile(n,2)-immobile(n,1))/29.97;
                else
                    immobile(n,1)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 8}.clipitem{1, n}.in));
                    immobile(n,2)=str2double(struct2cell(x.xmeml{1, 2}.sequence.media.video.track{1, 8}.clipitem{1, n}.out));
                    immobile(n,3)=(immobile(n,2)-immobile(n,1))/29.97;
                end
            end
            immobile_dat(l,2)=length(immobile(:,1));
            immobile_dat(l,1)=sum(immobile(:,3));
            immobileraw{l}=immobile;
        else
            immobile_dat(l,2)=0;
            immobile_dat(l,1)=0;
            immobile=[0,0,0];
            immobileraw{l}=immobile;
        end
    else
        immobile_dat(l,2)=0;
        immobile_dat(l,1)=0;
        immobile=[0,0,0];
        immobileraw{l}=immobile;
    end
else
    immobile_dat(l,2)=0;
    immobile_dat(l,1)=0;
    immobile=[0,0,0];
    immobileraw{l}=immobile;
end

nonsocial=[]; bodycontact=[]; unisniffing=[]; bisniffing=[]; chasing = []; approach = []; escape = []; immobile = []; 

%end


%{
if length(x.xmeml{1, 2}.sequence.media.video.track)>3
    save('raw','diggingraw','groomingraw','jumpingraw');
elseif length(x.xmeml{1, 2}.sequence.media.video.track)>2
    save('raw','diggingraw','groomingraw');
elseif length(x.xmeml{1, 2}.sequence.media.video.track)>1
    save('raw','diggingraw')
end
%}