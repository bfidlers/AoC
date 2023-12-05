#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

struct nbRange {
  long destinationRangeStart;
  long sourceRangeStart;
  long rangeLength;

  nbRange (vector<string> nbs) {
    destinationRangeStart = stoul(nbs[0]);
    sourceRangeStart = stoul(nbs[1]);
    rangeLength = stoul(nbs[2]);
  }

  void print() {
    cout << destinationRangeStart << endl;
    cout << sourceRangeStart << endl;
    cout << rangeLength << endl;
  }

  bool inRange(long nb) {
    if (nb >= sourceRangeStart && nb < sourceRangeStart + rangeLength) {
      return true;
    }
    return false;
  }

  long getDest(long nb) {
    return (nb - sourceRangeStart + destinationRangeStart);
  }
};

vector<string> splitString(const string input, const char delimiter) {
  vector<string> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    if (elem != "") {
      elements.push_back(elem);
    }
  }

  return elements;
}

long getDestination(long nb, vector<nbRange> ranges) {
  for (nbRange r: ranges) {
    if (r.inRange(nb)) {
      return r.getDest(nb);
    }
  }
  return nb;
}

long getLocation(long nb, vector<vector<nbRange>> mapping) {
  long value = nb;
  for (vector<nbRange> m: mapping) {
    value = getDestination(value, m);
  }
  return value;
}

int main() {
  string line;
  vector<vector<nbRange>> input;
  vector<string> seeds;
  bool start = true;
  bool firstLine = true;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    vector<nbRange> group;
    while (getline (myfile, line)) {
      if (start) {
        vector<string> split = splitString(line, ':');
        seeds = splitString(split[1], ' ');
        start = false;
        continue;
      }
      if (line == "" && group.size() != 0) {
        input.push_back(group);
        group.clear();
        firstLine = true;
      } else if (!firstLine) {
        nbRange range(splitString(line, ' '));
        group.push_back(range);
      } else if (line != "") {
          firstLine = false;
      }
    }
    input.push_back(group);
    myfile.close();
  }

  vector<long> locations;
  for (string seed: seeds) {
    locations.push_back(getLocation(stoul(seed), input));
  }

  vector<long>::iterator result = min_element(locations.begin(), locations.end());
  cout << *result << endl;
}
