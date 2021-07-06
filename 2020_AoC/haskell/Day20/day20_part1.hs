import Data.List
import Data.List.Split
import Debug.Trace
import Data.Maybe
import qualified Data.Map as Map


main :: IO ()
main = do input <- readFile "input.txt"
          print . result . findCorners . construct . parseInput $ input
          
parseInput :: String -> Map.Map Int Tile
parseInput input = mapping
    where 
       mapping = Map.fromList . map (\ x -> (getID x, x)) $ split2 
       split2 = foldr (\ x1 x2 -> (makeTile . splitOn "\n" $ x1) : x2) [] split
       split = splitOn "\n\n" input

data Tile = Tile 
            Int -- id
            String -- upper border
            String -- left border
            String -- right border
            String -- bottom border 
            Int -- upper neighbour 
            Int -- left neighbour 
            Int -- right neighbour 
            Int -- bottom neighbour                         
    deriving (Show)
    
getID :: Tile -> Int 
getID (Tile id _ _ _ _ _ _ _ _) = id 

upperBorder :: Tile -> String 
upperBorder (Tile _ upper _ _ _ _ _ _ _) = upper

leftBorder :: Tile -> String 
leftBorder (Tile _ _ left _ _ _ _ _ _) = left

rightBorder :: Tile -> String 
rightBorder (Tile _ _ _ right _ _ _ _ _) = right

bottomBorder :: Tile -> String 
bottomBorder (Tile _ _ _ _ bottom _ _ _ _) = bottom

setUpperNeighbour :: Int -> Tile -> Tile 
setUpperNeighbour u (Tile id upper left right bottom _ l r b) = Tile id upper left right bottom u l r b

setLeftNeighbour :: Int -> Tile -> Tile 
setLeftNeighbour l (Tile id upper left right bottom u _ r b) = Tile id upper left right bottom u l r b

setRightNeighbour :: Int -> Tile -> Tile 
setRightNeighbour r (Tile id upper left right bottom u l _ b) = Tile id upper left right bottom u l r b

setBottomNeighbour :: Int -> Tile -> Tile 
setBottomNeighbour b (Tile id upper left right bottom u l r _) = Tile id upper left right bottom u l r b

nbNeighbours :: Tile -> Int
nbNeighbours (Tile _ _ _ _ _ u l r b) = length . filter (/= 0) $ [u,l,r,b]
    
makeTile :: [String] -> Tile
makeTile (x:xs) = Tile name up left right bottom 0 0 0 0
    where name = read . drop 5 . init $ x
          up = head xs
          bottom = last xs
          left = foldr (\ x1 x2 -> head x1 : x2) [] xs
          right = foldr (\ x1 x2 -> last x1 : x2) [] xs

construct :: Map.Map Int Tile -> Map.Map Int Tile
construct mapping = constructOne (head keys) keys mapping
    where keys = Map.keys mapping
    
constructOne :: Int -> [Int] -> Map.Map Int Tile -> Map.Map Int Tile
constructOne id list mapping 
    | id == last list = (findNeighbours id list mapping) 
    | otherwise = constructOne (list!!(index + 1)) list (findNeighbours id list mapping)
        where index = fromJust . elemIndex id $ list

findNeighbours :: Int -> [Int] -> Map.Map Int Tile -> Map.Map Int Tile
findNeighbours id [] mapping = mapping
findNeighbours id (x:xs) mapping 
    | id == x = findNeighbours id xs mapping
    | otherwise = findNeighbours id xs . checkLeft . checkRight . checkUpper . checkBottom $ mapping
    where checkLeft m = if checkBorder left tile2
                           then Map.insert id (setLeftNeighbour x tile1) m
                        else m
          checkRight m = if checkBorder right tile2
                             then Map.insert id (setRightNeighbour x tile1) m
                         else m
          checkUpper m = if checkBorder upper tile2
                             then Map.insert id (setUpperNeighbour x tile1) m
                         else m
          checkBottom m = if checkBorder bottom tile2
                              then Map.insert id (setBottomNeighbour x tile1) m
                          else m
          tile1 = fromJust (Map.lookup id mapping)
          tile2 = fromJust (Map.lookup x mapping)
          upper = upperBorder tile1
          left = leftBorder tile1
          right = rightBorder tile1
          bottom = bottomBorder tile1
          
checkBorder :: String -> Tile -> Bool
checkBorder input tile = input == upper || 
                         input == reverse upper || 
                         input == bottom || 
                         input == reverse bottom || 
                         input == left ||                               
                         input == reverse left || 
                         input == right || 
                         input == reverse right
    where upper = upperBorder tile
          left = leftBorder tile
          right = rightBorder tile
          bottom = bottomBorder tile
          
findCorners :: Map.Map Int Tile -> Map.Map Int Tile
findCorners = Map.filter (\ x -> nbNeighbours x == 2) 

result :: Map.Map Int Tile -> Int
result = Map.foldr (\x1 x2 -> getID x1 * x2) 1
