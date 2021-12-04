import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . answer . play . parse $ input 

play :: ([Int], [Board]) -> (Int, Board)
play ((x:xs), boards) 
    | winningBoard == [] = play (xs, newBoards)
    | otherwise = (x, head winningBoard)
    where newBoards = draw x boards
          winningBoard = winner newBoards 

draw :: Int -> [Board] -> [Board]
draw nb = map (mark nb)

mark :: Int -> Board -> Board
mark _ [] = []
mark nb (x:xs)
    | notElem (Undrawn nb) x = x : (mark nb xs)
    | otherwise = map (\x -> if x == (Undrawn nb) then (Drawn nb) 
                             else x) x : (mark nb xs)
    
answer :: (Int, Board) -> Int
answer (nb, board) = nb * unmarked board

unmarked :: Board -> Int
unmarked board = sum nbs
    where concat = foldr (++) [] board
          filtered = filter (unDrawn) concat
          nbs = map fieldNb filtered

winner :: [Board] -> [Board]
winner [] = []
winner (x:xs)
    | checkBoard x = [x]
    | otherwise = winner xs

checkBoard :: Board -> Bool
checkBoard b = checkLines (b ++ transpose b) 

checkLines :: [[Field]] -> Bool
checkLines [] = False
checkLines (x:xs)
    | (length . filter unDrawn $ x) == 0 = True
    | otherwise = checkLines xs

type Board = [[Field]]

data Field = Drawn Int | Undrawn Int deriving (Show)

instance Eq Field where 
    (Drawn n0) == (Drawn n1) = n0 == n1
    (Undrawn n0) == (Undrawn n1) = n0 == n1
    _ == _ = False

fieldNb :: Field -> Int
fieldNb (Drawn nb) = nb
fieldNb (Undrawn nb) = nb

mkBoard :: [[Int]] -> Board
mkBoard = map (map Undrawn)

unDrawn :: Field -> Bool
unDrawn (Undrawn _) = True
unDrawn _ = False

parse :: String -> ([Int], [Board]) 
parse input = (numbers, boards) 
    where numbers = map (read) . splitOn "," $ blocks!!0
          blocks = splitOn "\n\n" input
          nbBoards = map (map (map read . words)) . map lines . tail $ blocks
          boards = map mkBoard nbBoards
