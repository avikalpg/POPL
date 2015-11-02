declare Barrieraux Barrier
proc {Barrieraux Zs P}
   local Q  in
	 case Zs
	 of H|T then
	    thread
	       {H 4 2}
	       Q=P
	    end
	    {Barrieraux T Q}
	 [] nil then
	    if P==1 then
	       {Browse 'Process Completed'}
	    else
	       {Browse 'Something went wrong yet again ;)'}
	    end
	 else
	    {Browse 'Something went wrong'#Zs}
	 end
    end
end

proc{Barrier Zs}
   local P in
         P=1
         {Barrieraux Zs P}
   end
end

local Zs Add Multiply Subtract Dummy Inf01 Inf02 in

   Add = proc{$ X Y}
	    {Browse X+Y}
	 end
   
   Multiply = proc{$ X Y}
		 {Browse X*Y}
	      end
   
   Subtract = proc{$ X Y}
	       {Browse X-Y}
	      end
   
   Dummy = proc{$ X Y}
	      local Newvar in
		 %Newvar = 1
		 if Newvar == 1 then {Browse 1}
		 else skip
		 end
	      end
	   end

/*   Inf01 = proc{$ X Y}
	      {Browse X}
	      {Inf01 X Y}
	   end
   Inf02 = proc{$ X Y}
	      {Browse Y}
	      {Inf02 X Y}
	   end*/
         
   Zs=Add|Dummy|Multiply|Subtract|Inf01|Inf02|nil
   {Barrier Zs}
end
  