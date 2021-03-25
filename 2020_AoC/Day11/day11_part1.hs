import Data.Matrix

main :: IO ()
main = do input <- readFile "input.txt"
          print . countSeats . toList . compute . fromLists . words $ input
   
countSeats :: [Char] -> Int 
countSeats [] = 0 
countSeats (x:xs) 
    | x == '#' = 1 + countSeats xs
    | otherwise = countSeats xs    
          
compute :: Matrix Char -> Matrix Char
compute begin = (\ result -> if begin == result then result else compute result) (iteration begin)    

iteration :: Matrix Char -> Matrix Char
iteration matrix = (\ result -> fromList n m result) [checkElem r c matrix | r <- [1..n], c <- [1..m]]
    where n = nrows matrix
          m = ncols matrix
          
checkElem :: Int -> Int -> Matrix Char -> Char
checkElem row col matrix 
    | elem == 'L' && cond == 0 = '#'
    | elem == '#' && cond >= 4 = 'L'
    | otherwise = elem 
        where elem = getElem row col matrix
              cond = checkNeighbours neighbours matrix
              neighbours = getNeighbourPos row col (nrows matrix) (ncols matrix)
          
checkNeighbours :: [(Int, Int)] -> Matrix Char -> Int 
checkNeighbours [] matrix = 0
checkNeighbours (x:xs) matrix 
    | getElem (fst x) (snd x) matrix == '#' = 1 + checkNeighbours xs matrix
    | otherwise = checkNeighbours xs matrix 
    
-- arguments are row, col, max_row, max_col
getNeighbourPos :: Int -> Int -> Int -> Int -> [(Int, Int)] 
getNeighbourPos row col maxRow maxCol = realNeighbourPos maxRow maxCol (neighbourPos row col)

neighbourPos :: Int -> Int -> [(Int, Int)]
neighbourPos row col = (row - 1, col -1) : 
                       (row - 1, col) : 
                       (row - 1, col + 1) : 
                       (row, col - 1) :
                       (row, col + 1) : 
                       (row + 1, col -1 ) : 
                       (row + 1, col) : 
                       (row + 1, col + 1) : 
                       [] 

realNeighbourPos :: Int -> Int -> [(Int, Int)] -> [(Int, Int)]
realNeighbourPos row col [] = []
realNeighbourPos row col (x:xs)
    | fst x > row || snd x > col || fst x < 1 || snd x < 1 = realNeighbourPos row col xs
    | otherwise = x : realNeighbourPos row col xs 
