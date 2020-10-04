//Save the cat!

#include <iostream>
#include <stdio.h>
#include <fstream>
#include <queue>
#include <bitset>
using namespace std;

struct Position{
	int x;
	int y;
	char type;	//can take values 'A','W','X','.'
	int time=-1;
	int cat_time;
	Position *previous = nullptr;
	string move;
	//Position(int a, int b, char input): x(a), y(b), type(input), time(0) {};
	//Position (int t): time(t) {}; 
	//Position() {};
};

Position basement[1000][1000]; //see if I can implement it with vectors
int resX, resY;

//find when it's position will be filled by water (Flood fill algorithm)
void floodFill (Position map[1000][1000], int N, int M, queue <Position> & water){
	
	Position temp;
	int i,j;

	while(!water.empty()){
		
		temp = water.front();
		water.pop();
		
		if(temp.type == 'W'){

			//insert the neighbors D,L,R,U, i,j
			i = temp.x;
			j = temp.y;

			if(i > 0 && map[i-1][j].type != 'W' && map[i-1][j].type != 'X'){
				map[i-1][j].type = 'W';
				map[i-1][j].time = map[i][j].time + 1;
				water.push(map[i-1][j]);
			}

			if(j > 0 && map[i][j-1].type != 'W' && map[i][j-1].type != 'X'){
				map[i][j-1].type = 'W';
				map[i][j-1].time = map[i][j].time + 1;
				water.push(map[i][j-1]);
			}

			if(j < M-1 && map[i][j+1].type != 'W' && map[i][j+1].type != 'X'){
				map[i][j+1].type = 'W';
				map[i][j+1].time = map[i][j].time + 1;
				water.push(map[i][j+1]);
			}

			if(i < N-1 && map[i+1][j].type != 'W' && map[i+1][j].type != 'X'){
				map[i+1][j].type = 'W';
				map[i+1][j].time = map[i][j].time + 1;
				water.push(map[i+1][j]);
			}



			

		}
	}
}

//BFS starting from the cat position
int catBFS (Position map[1000][1000], int N, int M, queue <Position> & cat){

	Position temp;
	bool visited[N][M] = {false};
	int maxTime = -10;
	int i,j;
	
	while(!cat.empty()){		
		
		temp = cat.front();
		//need to print somehow how I came here
		i = temp.x;
		j = temp.y;
		//cout << "TEEEMP " << temp.x <<" " << temp.y << endl;
		cat.pop();
		
		visited[i][j]= true;

		if(temp.time > maxTime || (temp.time == maxTime && i<resX) || (temp.time == maxTime && i==resX && j<resY)){
			maxTime = temp.time;
			resX = temp.x;
			resY = temp.y;
		}

		//check neighbors in D,L,R,U that can be visited by the cat
		
		if(i < N-1 && (map[i+1][j].time  > map[i][j].cat_time+1) && !visited[i+1][j] && map[i+1][j].type != 'X'){
				visited[i+1][j] = true;	//set that I visited it 
				map[i+1][j].cat_time = map[i][j].cat_time + 1;
				map[i+1][j].previous = &map[i][j];
				map[i+1][j].move='D';
				cat.push(map[i+1][j]);
				//cout << "PUSHED1 " << map[i+1][j].x <<" " << map[i+1][j].y << " FROM " << map[i][j].x <<" " << map[i][j].y << endl;
		}

		if(j > 0 && (map[i][j-1].time > map[i][j].cat_time+1 || map[i][j-1].time==-1) && !visited[i][j-1] && map[i][j-1].type != 'X'){
				visited[i][j-1] = true;
				map[i][j-1].cat_time = map[i][j].cat_time + 1;
				map[i][j-1].previous = &map[i][j];
				map[i][j-1].move='L';
				cat.push(map[i][j-1]);
				//cout << "PUSHED2 " << map[i][j-1].x <<" " << map[i][j-1].y << " FROM " << map[i][j].x <<" " << map[i][j].y << endl;
		}

		if(j < M-1 && (map[i][j+1].time > map[i][j].cat_time+1) && !visited[i][j+1] && map[i][j+1].type != 'X'){
				visited[i][j+1] = true;
				map[i][j+1].cat_time = map[i][j].cat_time + 1;
				map[i][j+1].previous = &map[i][j];
				map[i][j+1].move='R';
				cat.push(map[i][j+1]);
				//cout << "PUSHED3 " << map[i][j+1].x <<" " << map[i][j+1].y << " FROM " << map[i][j].x <<" " << map[i][j].y <<  endl;
		}

		if(i > 0 && (map[i-1][j].time > map[i][j].cat_time+1 || map[i-1][j].time==-1) && !visited[i-1][j] && map[i-1][j].type != 'X'){
				visited[i-1][j] = true;
				map[i-1][j].cat_time = map[i][j].cat_time + 1;
				map[i-1][j].previous = &map[i][j];
				map[i-1][j].move='U';
				cat.push(map[i-1][j]);
				//cout << "PUSHED4 " << map[i-1][j].x <<" " << map[i-1][j].y << " FROM " << map[i][j].x <<" " << map[i][j].y << endl;
		}




	}

	//for (int i = 0; i < sizeof(visited)/sizeof(int); i++)
	//	cout << visited[i] << " ";
	//cout << "\n";

	return maxTime;
}


void print_path(Position node){
	if (node.previous==nullptr) cout << node.move;
	
	else{
		print_path(*node.previous);
		cout << node.move;
	}

}

int main(int argc, char **argv){

	queue <Position> water;	//add the water places while reading the input
	queue <Position> cat;
	int N = 0;
	int M = 0;
	int i = 0;

	//read the input
	FILE *file;
	file = fopen(argv[1], "r");
	char c = fgetc(file);

	while (!feof(file)) {
		if (c == '\n') {
			N++; 
			i = 0;
		}
		else {
			basement[N][i].x = N;
			basement[N][i].y = i;
			basement[N][i].type = c;
			if (basement[N][i].type == 'W') {
				basement[N][i].time = 0;
				water.push(basement[N][i]);
			}
			else if (basement[N][i].type == 'A') {
				basement[N][i].cat_time=0;
				cat.push(basement[N][i]);
			}			
			i++;
		}
		if (N == 0) M++;
		c = fgetc(file);
	}
	
	//cout << N << "\n";
	//cout << M << "\n";
	
	floodFill(basement, N, M, water);
	/*for (int i = 0; i < N; i++) {
		for (int j = 0; j < M; j++) {
			cout << basement[i][j].time << " ";
		}
		cout << "\n";
	}

	cout << "\n";*/
	Position a = cat.front();
	int result = catBFS(basement, N, M, cat) - 1;

	
	if (basement[a.x][a.y].time!=-1) cout << result << endl; //cout << "The max time for saving is: " << result << " and the position: (" << resX << "," << resY <<")\n";
	else cout << "infinity" << endl;

	if(a.x == resX && a.y == resY) cout << "stay" << endl;
	else{
		print_path (basement[resX][resY]);
		cout << endl;
	}
	//check corner cases about the queues
	return 0;
}