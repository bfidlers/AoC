package main
	
import (
    "bufio"
    "fmt"
    "os"
    "strconv"
)

func main() {
  var number int = 50
  var count int = 0

  file, _ := os.Open("input.txt")
  defer file.Close()
  scanner := bufio.NewScanner(file)

  for scanner.Scan() {
    line := scanner.Text()
    if line[0] == 'L' {
      incr, _ := strconv.Atoi(line[1:])
      number = (number - incr + 100) % 100
    }
    if line[0] == 'R' {
      incr, _ := strconv.Atoi(line[1:])
      number = (number + incr) % 100
    }
    if number == 0 {
      count += 1
    }
  }
    fmt.Println(count)
}
