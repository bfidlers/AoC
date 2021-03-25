import Data.Matrix
import Data.Maybe
import qualified Debug.Trace as T

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
iteration matrix =  (\ result -> fromList n m result) [checkElem r c matrix | r <- [1..n], c <- [1..m]]
    where n = nrows matrix
          m = ncols matrix
          
checkElem :: Int -> Int -> Matrix Char -> Char
checkElem row col matrix 
    | elem == 'L' && cond == 0 = '#'
    | elem == '#' && cond >= 5 = 'L'
    | otherwise = elem 
        where elem = getElem row col matrix
              cond = checkDirections row col matrix
          
checkDirections :: Int -> Int -> Matrix Char -> Int 
checkDirections row col matrix = left + right + up + down + leftup + rightup + leftdown + rightdown
    where left = checkLeft row (col - 1) matrix 
          right = checkRight row (col + 1) matrix
          up = checkUp (row - 1) col matrix
          down = checkDown (row + 1) col matrix
          leftup = checkLeftUp (row - 1) (col - 1) matrix
          rightup = checkRightUp (row - 1) (col + 1) matrix
          leftdown = checkLeftDown (row + 1) (col - 1) matrix
          rightdown = checkRightDown (row + 1) (col + 1) matrix
 
checkLeft :: Int -> Int -> Matrix Char -> Int
checkLeft row col matrix = if isNothing elem 
                               then 0 
                           else if (fromJust elem) == '.'
                               then checkLeft row (col - 1) matrix
                           else if (fromJust elem) == 'L'
                               then 0
                           else 1
    where elem = safeGet row col matrix
    
checkRight :: Int -> Int -> Matrix Char -> Int
checkRight row col matrix = if isNothing elem 
                                then 0 
                            else if (fromJust elem) == '.'
                                then checkRight row (col + 1) matrix
                            else if (fromJust elem) == 'L'
                                then 0
                            else 1
    where elem = safeGet row col matrix
    
checkUp :: Int -> Int -> Matrix Char -> Int
checkUp row col matrix = if isNothing elem 
                            then 0 
                         else if (fromJust elem) == '.'
                            then checkUp (row - 1) col matrix
                         else if (fromJust elem) == 'L' 
                            then 0
                         else 1
    where elem = safeGet row col matrix
    
checkDown :: Int -> Int -> Matrix Char -> Int
checkDown row col matrix = if isNothing elem 
                               then 0 
                           else if (fromJust elem) == '.'
                               then checkDown (row + 1) col matrix
                           else if (fromJust elem) == 'L' 
                               then 0
                           else 1
    where elem = safeGet row col matrix
    
checkLeftUp :: Int -> Int -> Matrix Char -> Int
checkLeftUp row col matrix = if isNothing elem 
                                then 0 
                             else if (fromJust elem) == '.'
                                then checkLeftUp (row - 1) (col - 1) matrix
                             else if (fromJust elem) == 'L' 
                                then 0
                             else 1
    where elem = safeGet row col matrix
    
checkRightUp :: Int -> Int -> Matrix Char -> Int
checkRightUp row col matrix = if isNothing elem 
                                  then 0 
                              else if (fromJust elem) == '.'
                                  then checkRightUp (row - 1) (col + 1) matrix
                              else if (fromJust elem) == 'L' 
                                  then 0
                              else 1
    where elem = safeGet row col matrix
    
checkLeftDown :: Int -> Int -> Matrix Char -> Int
checkLeftDown row col matrix = if isNothing elem 
                                   then 0 
                               else if (fromJust elem) == '.'
                                   then checkLeftDown (row + 1) (col - 1) matrix
                               else if (fromJust elem) == 'L' 
                                   then 0
                               else 1
    where elem = safeGet row col matrix
    
checkRightDown :: Int -> Int -> Matrix Char -> Int
checkRightDown row col matrix = if isNothing elem 
                                    then 0 
                                else if (fromJust elem) == '.'
                                    then checkRightDown (row + 1) (col + 1) matrix
                                else if (fromJust elem) == 'L' 
                                    then 0
                                else 1
    where elem = safeGet row col matrix

-- arguments are row, col, max_row, max_col
checkPosition :: Int -> Int -> Int -> Int -> Bool 
checkPosition row col maxRow maxCol
    | row > maxRow || col > maxCol || row < 1 || col < 1 = False
    | otherwise = True 
