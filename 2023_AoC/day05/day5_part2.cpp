#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <limits>

using namespace std;

struct range {
  long start;
  long length;

  long end() {
    return start + length - 1;
  }
};

struct nbRange {
  long destStart;
  long sourceStart;
  long length;

  nbRange (vector<string> nbs) {
    destStart = stol(nbs[0]);
    sourceStart = stol(nbs[1]);
    length = stol(nbs[2]);
  }

  long sourceEnd() {
    return sourceStart + length - 1;
  }
  
  long destEnd() {
    return destStart + length - 1;
  }

  bool inRange(long nb) {
    if (nb >= sourceStart && nb <= sourceEnd()) {
      return true;
    }
    return false;
  }

  long getDest(long nb) {
    return (nb - sourceStart + destStart);
  }

  // Some edge cases are a bit wrong, since the length of all ranges decreases over time, 
  // but it doesn't really matter for the answer.
  void getRanges(vector<range> &source, vector<range> &dest) {
    vector<range> tmp;
    while (!source.empty()) {
      range current = source.back();
      source.pop_back();

      if (current.start < sourceStart) {
        if (current.end() < sourceStart) {
          tmp.push_back(current);
        } else if (current.end() >= sourceStart && current.end() <= sourceEnd()) {
          range newDestRange {destStart, current.end() - sourceStart};
          range newSourceRange {current.start, sourceStart - current.start};
          dest.push_back(newDestRange);
          tmp.push_back(newSourceRange);
        } else {
          range newDestRange {destStart, length};
          range newSourceRange1 {current.start, sourceStart - current.start};
          range newSourceRange2 {sourceEnd() + 1, current.end() - sourceEnd()}; 
          dest.push_back(newDestRange);
          tmp.push_back(newSourceRange1);
          tmp.push_back(newSourceRange2);
        }
      } else if (current.start > sourceEnd()) { 
        tmp.push_back(current);
      } else {
        if (current.end() <= sourceEnd()) {
          range newDestRange {current.start - sourceStart + destStart, current.length};
          dest.push_back(newDestRange);
        } else {
          range newDestRange {current.start - sourceStart + destStart, sourceEnd() - current.start};
          range newSourceRange {sourceEnd() + 1, current.end() - sourceEnd()}; 
          dest.push_back(newDestRange);
          tmp.push_back(newSourceRange);
        }
      }
    }
    
    source = tmp;
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

void getDestination(vector<range> &source, vector<range> &dest, vector<nbRange> ranges) {
  for (nbRange r: ranges) {
    r.getRanges(source, dest);
  }
  dest.insert(dest.end(), source.begin(), source.end());
}

void getLocation(vector<range> &source, vector<range> &dest, vector<vector<nbRange>> ranges) {
  for (vector<nbRange> m: ranges) {
    getDestination(source, dest, m);
    
    source = dest;
    dest.clear();
  }
}

int main() {
  string line;
  vector<vector<nbRange>> input;
  vector<string> seeds;
  vector<range> seeds2;
  bool start = true;
  bool firstLine = true;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    vector<nbRange> group;
    while (getline (myfile, line)) {
      if (start) {
        vector<string> split = splitString(line, ':');
        seeds = splitString(split[1], ' ');
        for (int i = 0; i < seeds.size() - 1; i+= 2) {
          range r = {stol(seeds[i]), stol(seeds[i+1])};
          seeds2.push_back(r);
        }
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

  long min = numeric_limits<long>::max();
  for (range seed: seeds2) {
    vector<range> source = {seed};
    vector<range> dest;
    getLocation(source, dest, input);

    for (range r: source) {
      if (r.start < min) {
        min = r.start;
      }
    }
  }
  
  cout << min << endl;
}
