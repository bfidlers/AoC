#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

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

vector<int> splitStringToInt(const string input, const char delimiter) {
  vector<int> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    if (elem != "") {
      elements.push_back(stoi(elem));
    }
  }

  return elements;
}

int calculateNbWins(int time, int dist) {
  int count = 0;
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
  int result = 1;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      if (line != "") {
        input.push_back(line);
      }
    }
    myfile.close();
  }

  vector<int> time = splitStringToInt(splitString(input[0], ':')[1], ' ');
  vector<int> dist = splitStringToInt(splitString(input[1], ':')[1], ' ');

  for (int i = 0; i < time.size(); i++) {
    result *= calculateNbWins(time[i], dist[i]);
  }
  
  cout << result << endl;
}
