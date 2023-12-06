#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

using namespace std;

vector<string> splitString(const string input, const char delimiter) {
  vector<string> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    elements.push_back(elem);
  }

  return elements;
}

long calculateNbWins(long time, long dist) {
  long count = 0;
  for (int speed = 0; speed < time; speed++) {
    if (speed * (time - speed) > dist) {
      count += 1;
    }
  }
  return count;
}


int main() {
  string line;
  vector<string> input;
  int result;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      if (line != "") {
        input.push_back(line);
      }
    }
    myfile.close();
  }
  
  string timeStr = splitString(input[0], ':')[1];
  timeStr.erase(remove(timeStr.begin(), timeStr.end(), ' '), timeStr.end());
  cout << timeStr << endl;
  string distStr = splitString(input[1], ':')[1];
  distStr.erase(remove(distStr.begin(), distStr.end(), ' '), distStr.end());
  cout << distStr << endl;

  result = calculateNbWins(stol(timeStr), stol(distStr));
  
  cout << result << endl;
}
