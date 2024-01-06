#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <utility>
#include <queue>
#include <map>
#include <set>
#include <climits>

using namespace std;

typedef pair<int, int> v2;

struct Node {
  v2 pos;
  v2 dir;
  int score;
  int nb_steps;

  Node(v2 pos, v2 dir, int score, int nb_steps)
    : pos(pos), dir(dir), score(score), nb_steps(nb_steps) {
  }

  bool operator> (Node const &other) const {
    return score > other.score;
  }

  string hash () const {
    ostringstream oss;
    oss << "pos: (" << pos.first << ", " << pos.second << "), dir: (" << dir.first << ", " << dir.second << "), nb steps: " << nb_steps;
    string h = oss.str();
    return h;
  }
};

bool outOfBounds(v2 pos, int height, int width) {
  if (pos.first < 0 | pos.second < 0 | pos.first >= height | pos.second >= width) {
    return true;
  }
  return false;
}

vector<v2> getNeighbours(const v2 pos) {
  vector<v2> neighbours = {
    {pos.first - 1, pos.second},
    {pos.first + 1, pos.second},
    {pos.first, pos.second - 1},
    {pos.first, pos.second + 1},
  };
  return neighbours;
}

void reconstructPath(map<v2, v2> &links, v2 current, vector<v2> &path) {
  path.push_back(current);
  while (current.first != 0 || current.second != 0) {
    current = links[current];
    path.insert(path.begin(), current);
  }
}

int main() {
  string line;
  vector<string> input;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      //cout << line << endl;
      input.push_back(line);
    }
    myfile.close();
  }

  const int height = input.size();
  const int width = input[0].length();

  vector<v2> path;

  v2 start(0, 0);
  v2 end(input.size() - 1, input[0].length() - 1);

  priority_queue<Node, vector<Node>, greater<Node>> open;
  //map<v2, v2> cameFrom;
  //map<v2, int> gScore;
  //gScore[start] = 0;

  Node s(start, start, 0, 0);
  open.push(s);

  auto cmp = [](Node a, Node b) { return a.hash() < b.hash(); };
  set<Node, decltype(cmp)> seen;

  while (!open.empty()) {
    Node current = open.top();
    open.pop();

    current.hash();

    if (current.pos == end && current.nb_steps >= 4) {
      cout << current.score << endl;
      break;
    }

    if (seen.count(current)) {
      continue;
    }
    seen.insert(current);

    vector<v2> neighbours = getNeighbours(current.pos);
    for (v2 neighbour: neighbours) {
      if (outOfBounds(neighbour, height, width)) {
        continue;
      }

      v2 new_dir (neighbour.first - current.pos.first, neighbour.second - current.pos.second);

      if (current.dir.first == -1 * new_dir.first && current.dir.second == -1 * new_dir.second) {
        continue;
      }

      int new_nb_steps = 1;
      if (current.dir == new_dir) {
        new_nb_steps = current.nb_steps + 1;
        if (new_nb_steps > 10) {
          continue;
        }
      } else if (current.nb_steps != 0) {
        if (current.nb_steps < 4) {
          continue;
        }
      }

      int new_gScore = current.score + (input[neighbour.first][neighbour.second] - '0');
      //int old_gScore = gScore.count(neighbour) ? gScore[neighbour] : INT_MAX;

      //if (new_gScore <= old_gScore) {
        //cameFrom[neighbour] = current.pos;
        //gScore[neighbour] = new_gScore;

        Node n(neighbour, new_dir, new_gScore, new_nb_steps);
        open.push(n);
      //}
    }
  }
}
