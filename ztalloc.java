import java.io.*;
import java.util.*; 


class MyInterval{
    
    public int L, R;

    public MyInterval(int x, int y){
        this.L = x;
        this.R = y;
    }
    
    public int getL(){
        return L;
    }
    public int getR(){
        return R;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        MyInterval other = (MyInterval) obj;

        if ((L+R)/(double) 2 == (other.L+other.R)/(double) 2 && L<other.L)
            return true;
        if (L != other.L)
            return false;
        if (R != other.R)
            return false;
        return true;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + (L+R)/ 2;
        //result = prime * result + R;
        return result;
    }
}


class Node{
    public int theL, theR;
    public String path;

    // constructor needed
    public Node(int x, int y, String str){
        this.theL = x;
        this.theR = y;
        this.path = str;
    }

    public int getL(){
        return theL;
    }
    public int getR(){
        return theR;
    }

    public String getpath(){
        return path;
    }
}

class MyIntervals{
    
    public int Lin, Rin, Lout, Rout;

    public MyIntervals(int x, int y, int z, int w){
        this.Lin = x;
        this.Rin = y;
        this.Lout = z;
        this.Rout = w;
    }
    
    public int getLin(){
        return Lin;
    }
    public int getLout(){
        return Lout;
    }
    public int getRin(){
        return Rin;
    }
    public int getRout(){
        return Rout;
    }
}

public class Ztalloc{

    static public ArrayList <MyIntervals> questions = new ArrayList <MyIntervals> (); 

    static public int Q;

    static public boolean changed;

    public static void main (String[] args){

        //System.out.println("Hola");

        // read the input
        try {

            Scanner scanner = new Scanner(new File(args[0]));

            int Lin, Rin, Lout, Rout;

            Q = scanner.nextInt();

            for (int i = 0; i < Q; i++){
                Lin = scanner.nextInt();
                Rin = scanner.nextInt();
                Lout = scanner.nextInt();
                Rout = scanner.nextInt();
                MyIntervals temp = new MyIntervals(Lin, Rin, Lout, Rout);                               
                questions.add(temp);
                //System.out.println(Lin + " " + Rin + " " + Lout + " " + Rout);
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }


        for (int i = 0; i < Q; i++){    

            changed = false;

            String answer = "";
            
            Set<MyInterval> visited = new HashSet <MyInterval>();           // used to check visited in BFS
            LinkedList<Node> queue = new LinkedList<Node>();                // the queue for BFS

            int lin = questions.get(i).getLin();
            int rin = questions.get(i).getRin();
            int lout = questions.get(i).getLout();
            int rout = questions.get(i).getRout();

            Node temp_interv = new Node(lin,rin,answer);        // here might be a prob
            queue.add(temp_interv);

            MyInterval temp_hash = new MyInterval(lin, rin);
            visited.add(temp_hash);


            while (queue.size() != 0){
                
                //int ll = temp_interv.getL();
                //int rr = temp_interv.getR();

                temp_interv = queue.poll();     // get and remove the peek element of the queue

                MyInterval temp_hash_h = new MyInterval(temp_interv.getL()/2, temp_interv.getR()/2);

                MyInterval temp_hash_t = new MyInterval(3*temp_interv.getL()+1, 3*temp_interv.getR()+1);

                if(temp_interv.getL()>=lout && temp_interv.getL()<=rout && temp_interv.getR()>=lout && temp_interv.getR()<=rout){
                    answer = temp_interv.getpath();
                    changed = true;
                    break;  // answer found
                }
                //boolean pleasework = false;

                /*outerloop:
                for(int k = ll/2;k++;k<=rr/2){
                    for (int l = rr/2;l--;l>=ll/2){
                        MyInterval teeeemp = new MyInterval(k, l);
                        if (visited.contains(teeeemp)){
                            pleasework=true;
                            break outerloop;
                        }
                    }
                }*/

                if(!visited.contains(temp_hash_h)){

                    Node x = new Node(temp_hash_h.getL(), temp_hash_h.getR(), temp_interv.getpath() + "h");
                    queue.add(x);
                    visited.add(temp_hash_h);

                }

                /*pleasework = false;

                outerloop2:
                for(int k = ll*3+1;k++;k<=rr*3+1){
                    for (int l = rr*3+1;l--;l>=ll*3+1){
                        MyInterval teeeemp = new MyInterval(k, l);
                        if (visited.contains(teeeemp)){
                            pleasework=true;
                            break outerloop2;
                        }
                    }
                }*/

                if(temp_hash_t.getL() < 1000000 && temp_hash_t.getR() < 1000000 && !visited.contains(temp_hash_t)){
                    Node x = new Node(temp_hash_t.getL(), temp_hash_t.getR(), temp_interv.getpath() + "t");
                    queue.add(x);
                    visited.add(temp_hash_t);
                }

            }

            if(!changed){
                System.out.println("IMPOSSIBLE");

            }
            else if(answer.toString().equals("")){
                System.out.println("EMPTY");
            }
            else{
                System.out.println(answer);
            }

        }
    }

}       