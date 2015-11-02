declare NSelect Ls Append Len WrongInput Dummy1 Dummy2 Dummy3 A B C

fun {Append Xs P}
   case Xs
   of H|T then H|{Append T P}
   else [P]
   end      
end

proc {NSelect Ls}
   local TrueList NSelectAux Temp X Y Z Len Default in
      
      fun {NSelectAux Ls TrueList N}
	 %{Browse 'here'#Ls}
	 case Ls
	 of H|nil then
	    if N == Len-1 then
	       ~1
	    else
	       @TrueList
	    end
	 [] H|T then
	    %{Browse H.1}
	    if {Value.isFree H.1} then
	       {NSelectAux T TrueList N+1}
	    else
	       if H.1 == true then	       
	       TrueList := {Append @TrueList H}
	       %{Browse 'herhe'}
	       {NSelectAux T TrueList N}
	       else
		  {NSelectAux T TrueList N}
	       end
	    end
	 else
	    %{Browse 'Unbound'}
	    {NSelectAux Ls.2 TrueList N+1}
	 end
      end

      Len = {List.length Ls}
      Default = {List.last Ls}
      %Ls := {List.take Ls Len-1}
      TrueList = {NewCell nil}
      X = {NSelectAux Ls TrueList 0}
      %{Browse 'x'#X}
      case X
      of ~1 then
	 {Browse 'Hereeeee'}
	 {Delay 1000}
	 %Ls.2.1.1 = false
	 {NSelect Ls}
      [] nil then
	 %{Browse 'here'#Default.1}
	 if Default.1 == true then
	    {Default.2}
	 else
	    {WrongInput}
	 end
      [] H|T then
	 Y = {List.length X}
	 %{Browse 'len'#Y}
	 {OS.rand Z}
	 Temp = Z mod Y
	 %{Browse 'temp'#Temp}
	 {{List.nth X Temp+1}.2}
      end
   end
end

proc {WrongInput}
   {Browse 'Wrong syntax'}
end

proc {Dummy1}
   {Browse 'Dummy1'}
end

proc {Dummy2}
   {Browse 'Dummy2'}
end

proc {Dummy3}
   {Browse 'Dummy3'}
end

proc {Dummy4}
   {Browse 'Dummy4'}
end


%%Test cases
%Ls = [true#Dummy1 true#Dummy2 true#Dummy3 true#Dummy4]
%Ls = [false#Dummy1 false#Dummy2 false#Dummy3 true#Dummy4]
%Ls = [false#Dummy1 false#Dummy2 false#Dummy3 false#Dummy4]
%Ls = [false#Dummy1 true#Dummy2 false#Dummy3 true#Dummy4]
%Ls = [A#Dummy1 B#Dummy2 C#Dummy3 true#Dummy4]
{NSelect Ls}
