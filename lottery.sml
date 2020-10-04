local

structure M = BinaryMapFn(struct  (*functor that defines a type for both map and its keys*)
  type ord_key = int * int
  fun compare ((x1,y1),(x2,y2)) =
    if x1<x2 then LESS else if x1>x2 then GREATER else if y1<y2 then LESS else if y1>y2 then GREATER else EQUAL
    end)

fun create_set N = 
  let
    fun recur 0 map = M.insert(map, (2,0), IntInf.pow(2,0))
    | recur N map = 
      recur (N-1) (M.insert(map, (2,N), IntInf.pow(2,N)))
  in
    recur N M.empty
  end

  datatype trie = 
    Node of (trie ref) list * int * int | Empty (* change to set instead of list *)

  fun readInt inStream =
    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) inStream)

  fun returnthelist (ref (Node(a,_,_))) = a;

  fun returnthekids (ref (Node(_,_,a))) = a;


  fun exists_in x [] = false
    | exists_in x (hd_l::tl_l) = (*head is a ref node*)
    let
      val (Node(_,hd,_)) = !hd_l
    in
      if x = hd then true else exists_in x tl_l
    end 


  fun find_in x (a::tl) =
    let
      val ref (Node(b,hd,_)) = a
    in
      if x = hd then a else find_in x tl
    end
    

  fun parseInput (0, file, lista) = lista
    |  parseInput (N, file, lista) =
      let
        val new_n = N-1
        val newnum = valOf (TextIO.inputLine file)
        val new_list = newnum::lista
      in
        parseInput (new_n, file, new_list)
      end;


  fun printList [] = print "\n"
    | printList (h::t) = (print(Char.toString(h)); print " "; printList(t));
 
 fun printList2 [] = print "\n"
    | printList2 (h::t) = (print(h); print " "; printList2(t));

  exception HdEmpty ;


  fun insertTicket (ticket_str, daddy) = (* ticket is an int*)
    
    let
      val ticket_list = explode ticket_str
      val ticket_rev = rev ticket_list (*char list*)                                    

      (*val (daddyList,_) = daddy*)
      fun insertTrie2 [] = ref Empty
      | insertTrie2 digits =
        let
          val (oldhead::tail) = digits
          val head = Char.ord(oldhead)-48
        in
          (*print ("in insertTrie 2"^ "\n");*)
          ref (Node([insertTrie2 tail], head, 1))
        end


      and insertTrie nil daddy  = ref Empty

      | insertTrie digits (ref (Node(the_ref_list, the_int, the_kids))) = (* digits of the ticket and daddy list*)
        let
          val (oldhead::tail) = digits
          val head = Char.ord(oldhead)-48
        in
          (*print("in insert trie wtffffff"^ "\n");*)
          if not (exists_in head the_ref_list) then
            let
              val new_node = [ref (Node([insertTrie2 tail],head, 1))]
              val the_ref_list = the_ref_list @ new_node
            in
              (*print ("in insertTrie 3 if not"^ "\n");*)
              ref (Node(the_ref_list, the_int, the_kids + 1))
            end
          else (*if exists*)
            let
              val the_found_one_ref = find_in head the_ref_list (*ref Node (lista, int)*)
            in
              (*print ("in insertTrie 3 if yes"^ "\n");*)
              the_found_one_ref := !(insertTrie tail the_found_one_ref);
              ref (Node(the_ref_list, the_int, the_kids+1))
            end
        end
    in
      (*print ("in insert ticket"^ "\n");*)
      insertTrie (tl ticket_rev) daddy
    end


  fun ultimatesolution (ref the_perfect_trie_we_made_FROM_SCRATCH) luckyNum mymap= 
    let
      val num_list = explode luckyNum
      val num_rev2 = rev num_list
      val num_rev = tl num_rev2

      fun printtuple (a,b) = 
        print(Int.toString(a) ^ " " ^ Int.toString(b) ^ "\n");

      fun num_of_winning_tickets (ref (Node(the_ref_list, _, _))) head = 
        let
           val newhead = Char.ord(head)-48
         in
          if (exists_in newhead the_ref_list) then 
          let
             val ref (Node(_,_,the_kids_kids)) = find_in newhead the_ref_list
           in
             the_kids_kids
           end 
          else 0
         end

      fun solution _ [] depth mymap= 
        (( valOf(M.find(mymap,(2, depth))) - Int.toLarge(1)) mod 1000000007)

      | solution (ref (Node(the_ref_list, the_int, the_kids))) (head::tail) depth mymap=
        let
           val newhead = Char.ord(head)-48
         in
           if (exists_in newhead the_ref_list) then
            let
              val new_node = find_in newhead the_ref_list
              val add_to_the_solution = solution new_node tail (depth+1) mymap
            in
              (((valOf (M.find(mymap,(2, depth))) - Int.toLarge(1)) mod 1000000007) * Int.toLarge((the_kids - returnthekids new_node)) + add_to_the_solution)
            end
            
          else       
            (((valOf (M.find(mymap,(2, depth))) - Int.toLarge(1)) mod 1000000007) * Int.toLarge(the_kids)) 
            
         end 

         val apanthsh = (solution (ref the_perfect_trie_we_made_FROM_SCRATCH) num_rev 0 mymap) mod 1000000007

    in
      printtuple (num_of_winning_tickets  (ref the_perfect_trie_we_made_FROM_SCRATCH) (hd num_rev), IntInf.toInt(apanthsh))
    end

in

fun lottery file =
  
  let (*big let*)
    
    fun parse file =
      let
        val inStream = TextIO.openIn file
        val k = readInt inStream
        val n = readInt inStream
        val q = readInt inStream
        val _ = valOf(TextIO.inputLine inStream)
        val lotTickets = parseInput(n, inStream, [])
        val luckyNums = parseInput(q, inStream, [])
      in
        (k, n, q, lotTickets, luckyNums)
      end;

    val (k, n, q, lotTickets, luckyNums) = parse file
    val root = ref (Node([], ~1, 0))

    val daddy = (foldl insertTicket root lotTickets)

    val mymap = create_set k;

    fun mysolution lista = ultimatesolution daddy lista mymap;
  
  in
    (*foldl insertTicket root lotTickets gurnaei thn trie etoimh!!!*)
    (*ultimatesolution (foldl insertTicket root lotTickets) (hd luckyNums)*)
    map mysolution (rev luckyNums)
  
  
  end; (*end big let*)  
end         