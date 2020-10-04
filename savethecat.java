import java.util.LinkedList;
import java.util.Queue;
import java.io.*;

class node{
    public int x, y, time, cat_time;
    public char type;
    public char move;
    public node previous;
    node(int x, int y, char type){
        this.x = x;
        this.y = y;
        this.type = type;
        this.time = -1;
        this.previous = null;
    }
    
    public int getx(){
        return x;
    }
    public int gety(){
        return y;
    }
    public int gettime(){
        return time;
    }
    public int getcattime(){
        return cat_time;
    }
    public char gettype(){
        return type;
    }
    public char getmove(){
        return move;
    }
    public node getprevious(){
        return previous;
    }

    public void settime(int time){
        this.time = time;
    }
    public void setcattime(int time){
        this.cat_time=time;
    }
    public void settype(char type){
        this.type=type;
    }
    public void setmove(char move){
        this.move=move;
    }
    public void setprevious(node previous){
        this.previous=previous;
    }
}

public class savethecat{

    static private char[][] basement;
    static private node[][] basement2;
    static private  Queue<node> CatQueue;
    static private  Queue<node> WaterQueue;
    static private boolean[][] visited;
    static private int maxTime = -10;
    static private int resX, resY;
    static private node resnode;

    public static void printf(node pos){
        //if (pos.getprevious() == null) System.out.print(basement2[resX][resY].getmove());
        if (pos.getprevious() != null) {
            printf(pos.getprevious());
            System.out.print(pos.getmove());
        }
    }

    public static void main (String[] args){

        basement = new char[1000][];
        basement2 = new node[1000][1000];
        node temp = new node(0, 0, 'X');

        int N =0;
        int M =0;

        String Line = null;
        try {
              BufferedReader br = new BufferedReader(new FileReader(args[0]));
              while ((Line = br.readLine()) != null) {
                          basement[N] = Line.toCharArray();
                          N++;

              }
              M = basement[0].length;
        } catch(Exception e) {
              e.printStackTrace();
        }

        WaterQueue = new LinkedList<node>();
        CatQueue = new LinkedList<node>();
     
        for(int i=0;i<N;i++){
            for(int j=0;j<M;j++){
            
                basement2[i][j] = new node(i, j, basement[i][j]);
                
                if (basement2[i][j].type == 'W') {
                    basement2[i][j].settime(0);
                    WaterQueue.add(basement2[i][j]);
                }

                if (basement2[i][j].type == 'A') {
                    basement2[i][j].setcattime(0);
                    CatQueue.add(basement2[i][j]);
                }
            }
        }


        while (! WaterQueue.isEmpty() ){
            temp = WaterQueue.remove();

            if(temp.type == 'W'){
                int i = temp.getx();
                int j = temp.gety();
            
                if (i>0 && basement2[i-1][j].gettype() != 'W' && basement2[i-1][j].gettype() != 'X'){
                    basement2[i-1][j].settype('W');
                    basement2[i-1][j].settime (basement2[i][j].gettime()+1);
                    WaterQueue.add(basement2[i-1][j]);
                }

                if (j>0 && basement2[i][j-1].gettype() != 'W' && basement2[i][j-1].gettype() != 'X'){
                    basement2[i][j-1].settype('W');
                    basement2[i][j-1].settime (basement2[i][j].gettime()+1);
                    WaterQueue.add(basement2[i][j-1]);
                }

                if (j<M-1 && basement2[i][j+1].gettype() != 'W' && basement2[i][j+1].gettype() != 'X'){
                    basement2[i][j+1].settype('W');
                    basement2[i][j+1].settime (basement2[i][j].gettime()+1);
                    WaterQueue.add(basement2[i][j+1]);
                }

                if (i< N-1 && basement2[i+1][j].gettype() != 'W' && basement2[i+1][j].gettype() != 'X'){
                    basement2[i+1][j].settype('W');
                    basement2[i+1][j].settime (basement2[i][j].gettime()+1);
                    WaterQueue.add(basement2[i+1][j]);
                }
            }
        }   

        node a = CatQueue.element();
        //System.out.println(a.getx() + " " + a.gety());

        visited = new boolean[N][M];
        for(int i=0;i<N;i++){
            for(int j=0;j<M;j++){
                visited[i][j]= false;
            }
        }

        while (! CatQueue.isEmpty() ){
            temp = CatQueue.remove();

            int i = temp.getx();
            int j = temp.gety();

            visited[i][j] = true;

        //  System.out.println("temp.gettime() = " + temp.gettime());
        //    System.out.println("maxTime = " + maxTime);
        //    System.out.println("i and j = " + i + " " + j);
        //    System.out.println("resX + resY = " + resX + " " + resY);
            

            if (temp.gettime() > maxTime || (temp.gettime() == maxTime && i<resX) || (temp.gettime() == maxTime && i==resX && j<resY)){
                maxTime = temp.gettime();
                resnode = temp;
                resX = i;
                resY = j;
            }

            if(i < N-1 && (basement2[i+1][j].gettime()  > basement2[i][j].getcattime()+1) && !visited[i+1][j] && basement2[i+1][j].gettype() != 'X'){
                visited[i+1][j] = true; //set that I visited it 
                basement2[i+1][j].setcattime (basement2[i][j].getcattime() + 1);
                basement2[i+1][j].setprevious (basement2[i][j]);
                basement2[i+1][j].setmove ('D');
                CatQueue.add(basement2[i+1][j]);
                //System.out.println("MPHKAAA");
            }

        //  System.out.println("basement2[i][j-1].gettime() = " + basement2[i][j-1].gettime());
        //    System.out.println("basement2[i][j].getcattime()+1 = " + basement2[i][j].getcattime()+1);

            
            if(j > 0 && (basement2[i][j-1].gettime()  > basement2[i][j].getcattime()+1 || basement2[i][j-1].gettime()==-1) && !visited[i][j-1] && basement2[i][j-1].gettype() != 'X'){
                visited[i][j-1] = true; //set that I visited it 
                basement2[i][j-1].setcattime (basement2[i][j].getcattime() + 1);
                basement2[i][j-1].setprevious (basement2[i][j]);
                basement2[i][j-1].setmove ('L');
                CatQueue.add(basement2[i][j-1]);
                //System.out.println("MPHKAAA");
            }

            if(j < M-1 && (basement2[i][j+1].gettime()  > basement2[i][j].getcattime()+1) && !visited[i][j+1] && basement2[i][j+1].gettype() != 'X'){
                visited[i][j+1] = true; //set that I visited it 
                basement2[i][j+1].setcattime (basement2[i][j].getcattime() + 1);
                basement2[i][j+1].setprevious (basement2[i][j]);
                basement2[i][j+1].setmove ('R');
                CatQueue.add(basement2[i][j+1]);
                //System.out.println("MPHKAAA");
            }

            if(i > 0 && (basement2[i-1][j].gettime()  > basement2[i][j].getcattime()+1 || basement2[i-1][j].gettime()==-1) && !visited[i-1][j] && basement2[i-1][j].gettype() != 'X'){
                visited[i-1][j] = true; //set that I visited it 
                basement2[i-1][j].setcattime (basement2[i][j].getcattime() + 1);
                basement2[i-1][j].setprevious (basement2[i][j]);
                basement2[i-1][j].setmove('U');
                CatQueue.add(basement2[i-1][j]);
                //System.out.println("MPHKAAA");
            }

        }

        if (basement2[a.getx()][a.gety()].gettime() != -1) System.out.println(maxTime-1);
        else System.out.println("infinity");

        /*System.out.println("a.getx = " + a.getx());
        System.out.println("a.gety = " + a.gety());
        System.out.println("resX = " + resX);
        System.out.println("resY = " + resY);
        */
        if(a.getx()==resX && a.gety() == resY) System.out.println("stay");
        else printf(resnode);

        System.out.println("");
    }




}        