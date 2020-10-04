Mstructure M = BinaryMapFn(struct
    type ord_key = int
    val compare = Int.compare
end)

structure M = BinaryMapFn(struct  (*functor that defines a type for both map and its keys*)
  type ord_key = int * int
  fun compare ((x1,y1),(x2,y2)) =
    if x1<x2 then LESS else if x1>x2 then GREATER else if y1<y2 then LESS else if y1>y2 then GREATER else EQUAL
    end)

fun colors file =
      let
      	fun min (a,b) =
      		if a < b then a
      		else b

      	fun parse file =
      		let
      			fun readInt input =
      				Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
      				val inStream = TextIO.openIn file
      				val n = readInt inStream
      				val k = readInt inStream
      				val _ = TextIO.inputLine inStream
      				fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
      					| readInts i acc = readInts (i - 1) (readInt inStream :: acc)
      		in
      				(n, k, readInts n [])
      		end;
      	
      	fun len ([],acc) = acc
      		| len ((h::t),acc) = len (t,acc+1)		(*tail recursion*)


        fun ithing ([],ma) = ([],ma)		(*not recursive*)
            | ithing ((x::xs),ma) = 
            let
                val value = M.find(ma,x)
                val (ma,_) = M.remove(ma,x)
            in
            	(*print "In ithing!\n";*)
                if valOf(value) = 1 then (xs,ma)
                else (xs,M.insert(ma,x,valOf(value)-1)) (**check an mporoume na vazoume ston idio harti*)
            end


        fun jthing ([],ma) = ([],ma)		(*not recursive*)
            | jthing ((x::xs),ma) = 
            let
                val value = M.find(ma,x)
            in
            	(*print "In jthing!\n";*)
                if isSome(value) then
                    let
                        val (ma,_) = M.remove(ma,x) 
                    in
                        (xs,M.insert(ma,x,valOf(value)+1))
                    end
                else (xs,M.insert(ma,x,1))
            end

        fun loop (counter,k,[],[],res,leni,lenj) =
            
            if res = 1000100 then print("0" ^ "\n")
            else print(Int.toString(res) ^ "\n")

            | loop (counter,k,ilist,[],res,leni,lenj) = (*i can move only the i pointer*)

            	if M.numItems counter = k then 
            		let
            			val (ilist,counter) = ithing (ilist,counter) 
            		in
            			loop (counter,k,ilist,[],min(res,leni),leni-1,lenj)
            		end
              else
                	loop (counter,k,[],[],res,leni-1,lenj)

            
            | loop (counter,k,ilist,jlist,res,leni,lenj) = (*i can move both pointers*)
                
                if  M.numItems counter = k then
                    let
                    	val res = min(res,leni-lenj)
                      val (ilist, counter) = ithing (ilist,counter)
                    in
                        loop (counter,k,ilist,jlist,res,leni-1,lenj)
                    end

                else
                    let
                        val (jlist,counter) = jthing (jlist,counter)
                    in
                        loop (counter,k,ilist,jlist,res,leni,lenj-1)
                    end

            val (N, K, colors) = parse file
            (*val ilist = colors
            val jlist = colors
            val counter = M.empty*)
        in
            loop (M.empty,K,colors,colors,1000100, N, N)
        end    