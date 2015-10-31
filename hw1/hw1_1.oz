local Length Take Drop in
   fun{Length Xs}
      case Xs
      of nil then 0
      [] _|T then 1+{Length T}
      end
   end
   
   fun{Drop Xs N}
      if {Or (N < 1) (N == {Length Xs})} then Xs
      else if N > {Length Xs} then nil
	   else case Xs
		of H|T then {Drop T N}
		end
	   end
      end
   end
   % Testing the Drop Function
   {Browse '1.2'}
   {Browse {Drop [1 3 5 7 9 11 13] 3}}
   {Browse {Drop [1 3 5 7 9 11 13] 0}}
   {Browse {Drop [1 3 5 7 9 11 13] ~3}}
   {Browse {Drop [1 3 5 7 9 11 13] 10}}
   
   % The definition of Take function uses the Drop function
   fun{Take Xs N}
      if N < 1 then nil
      else if N >= {Length Xs} then Xs
	   else case {Reverse Xs}
		of H|T then {Reverse {Drop T N}}
		else "Something went wrong!"
		end
	   end
      end
   end
   % Testing the Take function
   {Browse '1.1'}
   {Browse {Take [1 2 3 45 2345] 4}}
   {Browse {Take [1 2 3 45 2345] 0}}
   {Browse {Take [1 2 3 45 2345] ~3}}
   {Browse {Take [1 2 3 45 2345] 7}}
end

local Merge in
   fun{Merge L R}
      case L
      of nil then R
      [] H|T then case R
		  of nil then L
		  [] F|B then if(H<F) then H|{Merge T R}
			      else F|{Merge L B}
			      end
		  end
      end
   end
   % Testing the Merge Function
   {Browse '1.3'}
   {Browse {Merge [1 2 3 4] [~3 ~2 2 4 6]}}
   {Browse {Merge [~3 ~2 2 4 6] [1 2 3 4]}}
   {Browse {Merge [1 2 3] [3 1 2]}}
end
