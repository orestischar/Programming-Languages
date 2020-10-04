
structure M = BinaryMapFn(struct  (*functor that defines a type for both map and its keys*)
	type ord_key = int * int
	fun compare ((x1,y1),(x2,y2)) =
		if x1<x2 then LESS else if x1>x2 then GREATER else if y1<y2 then LESS else if y1>y2 then GREATER else EQUAL
		end)

fun fst (x,_) = x;
fun scd (_,x) = x;

fun savethecat fileName = (*each function returns a value*)
	
	let (*big let*)
		
		fun parse file = (*returns input in an array*)
			let (*parse let*)
				fun readlist (infile : string) = 
					let (*readList let*)
						val ins = TextIO.openIn infile
						fun loop ins =
							case TextIO.inputLine ins of
								SOME line => line :: loop ins
								| NONE      => []
					in
						loop ins before TextIO.closeIn ins
					end
			in (*parse let*)
				Array2.fromList(map explode (readlist file))
			end (*parse let*)

		fun inita (basement,wq,cq) =		(*returns the initialized queues*)
			let
				fun initWater (x,i,j,t,wq) = (*find the sources of water, needs to return the queue??*)
					if x = #"W" then Queue.enqueue(wq,(i,j,t))
					else ()
				fun initCat (x,i,j,t,cq) = (*find the cat position*)
					if x = #"A" then Queue.enqueue(cq,(i,j,t))
					else ()
				fun looparray (x,f,mq) =
				  	let
				  		val i = 0;
				  		val j = 0;
				  		val rows = Array2.nRows(x);
				  		val cols = Array2.nCols(x);
				  		fun loop (array, a, b, k, l) = (
				  			if (a+1 < k) then f(Array2.sub(array,a,b),a,b,0,mq) before loop(array,a+1,b,k,l)
				  			else if (a+1 >= k andalso b+1 < l) then f(Array2.sub(array,a,b),a,b,0,mq) before loop(array,0,b+1,k,l)
				  			else f(Array2.sub(array,a,b),a,b,0,mq)
				  			)
				  	in
				  		loop (x, i, j, rows, cols)
			  		end
			in
				looparray(basement,initWater,wq);
				looparray(basement,initCat,cq);
				(wq,cq)
			end

		fun check (x, i, j) =
			if i >= Array2.nRows(x) orelse j >= Array2.nCols(x) orelse i < 0 orelse j < 0 then false
			else if Array2.sub(x, i, j) = #"X" then false
			else if Array2.sub(x, i, j) = #"W" then false
			else if (Array2.sub(x,i,j) = #"\n" ) then false
			else true

		fun gamotokeratomou (myMap,i,j,t) =
			if isSome(M.find(myMap,(i,j))) then myMap
			else M.insert(myMap,(i,j),t)

		fun floodfill (wq,waterMap,basement)  =
			if (not (Queue.isEmpty(wq))) then (
				let
					val (cur_i,cur_j,cur_t) = Queue.head(wq)
                in
                		(*print (Int.toString(cur_i) ^ " " ^ Int.toString(cur_j) ^ "\n");
                		print "Before insert chicaaaas!\n";*)
                		if check(basement,cur_i-1,cur_j) andalso not(isSome(M.find(waterMap,(cur_i-1,cur_j)))) then (
	                    	Queue.enqueue(wq, (cur_i-1, cur_j, cur_t+1));
	                    	floodfill (wq,gamotokeratomou(waterMap,cur_i-1,cur_j,cur_t+1),basement)
	                    	)
	                    else if check(basement,cur_i,cur_j-1) andalso not(isSome(M.find(waterMap,(cur_i,cur_j-1)))) then (
                        	Queue.enqueue(wq, (cur_i, cur_j-1, cur_t+1));
                        	floodfill (wq,gamotokeratomou(waterMap,cur_i,cur_j-1,cur_t+1),basement)
                        	)
                        else if check(basement,cur_i,cur_j+1) andalso not(isSome(M.find(waterMap,(cur_i,cur_j+1)))) then (
                        	Queue.enqueue(wq, (cur_i, cur_j+1, cur_t+1));
                        	floodfill (wq,gamotokeratomou(waterMap,cur_i,cur_j+1,cur_t+1),basement)
                        	)
                        else if check(basement,cur_i+1,cur_j) andalso not(isSome(M.find(waterMap,(cur_i+1,cur_j)))) then (
                			Queue.enqueue(wq, (cur_i+1, cur_j, cur_t+1)) ;
                			floodfill (wq,gamotokeratomou(waterMap,cur_i+1,cur_j,cur_t+1),basement)
                			)
                		else (Queue.dequeue(wq);
                			floodfill (wq,waterMap,basement)
                			)
                end
	         )
	         else waterMap

	    fun catBFS (cq,waterMap,catMap,time,basement,resx,resy) = (*tn arhiki thesi tis gatas den tn vazoume st catMap*)
	    	if (not (Queue.isEmpty(cq))) then (
	    		let
	    			val (cur_i, cur_j, cur_t) = Queue.head(cq)
	    			val water_time = getOpt(M.find(waterMap,(cur_i,cur_j)), ~1)
	    		in
	    			if check(basement,cur_i+1,cur_j) andalso not(isSome(M.find(catMap,(cur_i+1,cur_j)))) andalso (getOpt(M.find(waterMap,(cur_i+1,cur_j)), ~1) > cur_t+1 orelse not(isSome(M.find(waterMap,(cur_i+1,cur_j))))) then
	    				(Queue.enqueue(cq, (cur_i+1, cur_j, cur_t+1));
	    				catBFS(cq, waterMap, M.insert(catMap, (cur_i+1,cur_j),(cur_i,cur_j,#"D")),time, basement, resx, resy)
	    				)
	    			else if check(basement,cur_i,cur_j-1) andalso not(isSome(M.find(catMap,(cur_i,cur_j-1)))) andalso (getOpt(M.find(waterMap,(cur_i,cur_j-1)), ~1) > cur_t+1 orelse not(isSome(M.find(waterMap,(cur_i+1,cur_j))))) then
	    				(Queue.enqueue(cq, (cur_i, cur_j-1, cur_t+1));
	    				catBFS(cq, waterMap, M.insert(catMap, (cur_i,cur_j-1),(cur_i,cur_j,#"L")),time, basement, resx, resy)
	    				)
	    			else if check(basement,cur_i,cur_j+1) andalso not(isSome(M.find(catMap,(cur_i,cur_j+1)))) andalso (getOpt(M.find(waterMap,(cur_i,cur_j+1)), ~1) > cur_t+1 orelse not(isSome(M.find(waterMap,(cur_i+1,cur_j))))) then
	    				(Queue.enqueue(cq, (cur_i, cur_j+1, cur_t+1));
	    				catBFS(cq, waterMap, M.insert(catMap, (cur_i,cur_j+1),(cur_i,cur_j,#"R")),time, basement, resx, resy)
	    				)
	    			else if check(basement,cur_i-1,cur_j) andalso not(isSome(M.find(catMap,(cur_i-1,cur_j)))) andalso (getOpt(M.find(waterMap,(cur_i-1,cur_j)), ~1) > cur_t+1 orelse not(isSome(M.find(waterMap,(cur_i+1,cur_j))))) then
	    				(Queue.enqueue(cq, (cur_i-1, cur_j, cur_t+1));
	    				catBFS(cq, waterMap, M.insert(catMap, (cur_i-1,cur_j),(cur_i,cur_j,#"U")),time, basement, resx, resy)
	    				)
	    			else if water_time > time orelse (water_time=time andalso cur_i<resx) orelse (water_time=time andalso cur_i=resx andalso cur_j<resy) then 
	    				(Queue.dequeue(cq);
	    				catBFS (cq, waterMap, catMap, water_time, basement,cur_i,cur_j)
	    				)
	                else (Queue.dequeue(cq);
	                	  catBFS (cq, waterMap, catMap, time, basement,resx,resy)
	                	  )
	    		end)
	    	else
	    		(
	    		if time = ~1 then print ("infinity" ^ "\n")
	    		else print (Int.toString(time-1) ^ "\n");
	    		(catMap,resx,resy)
	    		);


	    
	    fun whereTheHell (catMap,sx,sy,fx,fy,path) =
	    	let
			    fun findPath (catMap,sx,sy,fx,fy,path) =
			    	let
			    		val (prev_x,prev_y,dir) = valOf(M.find(catMap,(fx,fy)))
			    	in
			    		if fx=sx andalso fy=sy then
			    			path
			    		else
			    			findPath (catMap,sx,sy,prev_x,prev_y,dir::path)
			    	end
			    
			    fun printList [] = print "\n"
			    	| printList (h::t) = (print(Char.toString(h)); printList(t));

			    val path = findPath(catMap,sx,sy,fx,fy,path)
	    	in
	    		if path = [] then print "stay\n"
	    		else printList (path)
	    	end
	    		

	    fun printMap (myMap) =
	    	let
	    		fun printList [] = print "\n"
	    			| printList (h::t) = (print(Int.toString(h)); print " "; printList(t));
	    	in
	    		printList (M.listItems myMap)
	    	end

	    val basement = parse fileName
	    val (waterQueue,catQueue) = inita (basement,Queue.mkQueue (),Queue.mkQueue ())
	    val (xcat,ycat,rand) = Queue.head(catQueue)
	    val (catMap,resx,resy) = catBFS(catQueue,floodfill (waterQueue, M.empty, basement), M.empty, ~1, basement,xcat,ycat)

	in (*big let*)
		(*found the time that each one got flooded*)
		whereTheHell (catMap, xcat, ycat, resx, resy, [])
		(*printMap (floodfill(waterQueue,M.empty,basement))*)
		(*catBFS(catQueue,floodfill (waterQueue, M.empty, basement), M.empty, ~1, basement,xcat,ycat)*)
	end (*big let*)