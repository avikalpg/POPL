declare Barrieraux Barrier
proc {Barrieraux Zs P}
   local Q  in
      case Zs
      of H|T then
	 thread
	    {H}
	    Q=P
	 end
	 {Barrieraux T Q}
      [] nil then
	 if P==1 then skip end
      end
   end
end

proc{Barrier Zs}
   local P in
      P=1
      {Barrieraux Zs P}
   end
end

local Barrier Zs Add Multiply Divide in

   proc{Add X Y}
      {Browse X+Y}
   end
   
   proc{Multiply X Y}
      {Browse X*Y}
   end
   
   proc{Divide X Y}
      {Browse X/Y}
   end

   proc{Ab}
      {Browse 'ab'}
   end

   proc{Cd}
      {Browse 'asds'}
   end
   
   
   %Zs= {Add 4 2}|{Multiply 4 2}|{Divide 4 2}
   Zs = [Ab Cd]
   {Barrier Zs}
end
  