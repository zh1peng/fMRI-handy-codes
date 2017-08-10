function padded_id=pad0(input)
if iscell(input)
    tmp=cell2mat(input);
else
    tmp=input;
end

 for n=1:length(tmp)
        stridtemp=num2str(tmp(n,1));
        num0s= 12-size(stridtemp,2);
        if num0s==9
            pad0s=['000000000'];
        elseif num0s==8
            pad0s=['00000000'];
        elseif num0s==7
            pad0s=['0000000'];
        elseif num0s==6
            pad0s=['000000'];
        elseif num0s==5
            pad0s=['00000'];
        elseif num0s==4
            pad0s=['0000'];
        elseif num0s==3
            pad0s=['000'];
        elseif num0s==2
            pad0s=['00'];
        elseif num0s==1
            pad0s=['0'];
        elseif num0s==0
            pad0s=[];
        end
        subid_pad{n}=[pad0s stridtemp];
        clear num0s pad0s stridtemp;
    end
    padded_id=subid_pad';
end