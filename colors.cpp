#include <stdio.h>
#include <vector>
#include <iostream>
#include <fstream>
#include <stdio.h> 
#include <limits.h> 

using namespace std;


int main(int argc, char **argv){
	vector<int> colors, ribbon;

	int N, K, result, c;
	int i = 0, j = 0, color_count=0;

	FILE *col;
	col = fopen(argv[1], "r");
	fscanf(col, "%d", &N);
	fscanf(col, "%d", &K);

	for (int m=0; m<K; m++) colors.push_back(0);
	
	for (int m=0;m<N;m++) {
		//cin >> c;
		fscanf(col, "%d", &c);
		ribbon.push_back(c);
	}
	result = INT_MAX;

	if (N!=0) {
		colors[ribbon[j]-1]++;	
		color_count=1;
	}
	while(i !=N){

		if(color_count != K && j<N-1){
			j++;
			colors[ribbon[j]-1]++;
			if (colors[ribbon[j]-1]==1) color_count++;
		}
		else{
			colors[ribbon[i]-1]--;
			if (colors[ribbon[i]-1]==0) color_count--;
			i++;
		}

		if (color_count==K){
			if (result > j-i) result = j-i;
		}
	}
	if(result < INT_MAX) cout << result+1 << endl;
	else cout << 0 << endl;
	return 0;

}