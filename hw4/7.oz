declare Barrier
proc {Barrier Zs P}
   local Q  in
	 case Zs
	 [] H|T  then
	    thread
	       {H}
	       Q=P
	    end
	    {Barrier T Q 0}
	 of nil then
	    if P==1 then skip end
	 end
    end
end

local Barrier Zs
 {Barrier Zs 1}

   #test cases
   