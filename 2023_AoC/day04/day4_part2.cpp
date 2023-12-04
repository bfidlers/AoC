#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <cmath>

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

vector<int> parseNumbers(const vector<string> &nbs) {
  vector<int> parsedNbs;
  for (string s: nbs) {
    if (s.length() > 0) {
      parsedNbs.push_back(stoi(s));
    }
  }
  return parsedNbs;
}

int countScore(vector<int> &winning, const vector<int> &drawed) {
  int count = 0;
  std::vector<int>::iterator it; 
  std::vector<int> test = {30, 40, 50}; 
  for (int nb: drawed) {
    it = find(winning.begin(), winning.end(), nb);
    if (it != winning.end()) {
      count += 1;
    }
  }
  return count;
}

int main() {
  string line;
  int result = 0;
  vector<int> copies;
  int i = 0;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      vector<string> split = splitString(line, ':');
      vector<string> splitNumbers = splitString(split[1], '|');

      vector<string> winningNumbers = splitString(splitNumbers[0], ' ');
      vector<string> drawedNumbers = splitString(splitNumbers[1], ' ');
      
      vector<int> winningNbsParsed = parseNumbers(winningNumbers); 
      vector<int> drawedNbsParsed = parseNumbers(drawedNumbers); 

      int nb_copies = (copies.size() > i) ? copies[i] + 1 : 1;
      if (copies.size() <= i) { copies.push_back(1); }
      result += nb_copies;

      int score = countScore(winningNbsParsed, drawedNbsParsed);

      for (int j = 1; j <= score; j++) {
        if (copies.size() > i + j) {
          copies[i + j] = copies[i + j] + nb_copies; 
        } else {
          copies.push_back(nb_copies);
        }
      }
      i++;
    }
    myfile.close();
  }
  cout << result << endl;

}
