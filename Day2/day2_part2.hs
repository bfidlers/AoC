main :: IO ()
main = do input <- readFile "input.txt"
          print . length . checkInput . parseInput. words' . lines $ input
               
words' :: [String] -> [[String]]
words' [] = []
words' (x:xs) = words x : words' xs

splitBy :: Eq a => a -> [a] -> [[a]]
splitBy seperator [] = []
splitBy seperator (x:xs) 
  | null xs = [[x]]
  | x == seperator = [[]] ++ (splitBy seperator xs)
  | otherwise = (\ (y:ys) -> (x:y):ys) (splitBy seperator xs)
                              
seperateInt :: String -> Char -> (Int, Int)
seperateInt x seperator = (\ (a:b:c) -> (a,b)) . map (\ x -> read x :: Int) $ (splitBy seperator x)

parseInput :: [[String]] -> [Input]
parseInput [] = []
parseInput (x:xs) = parseLine x : parseInput xs

parseLine :: [String] -> Input
parseLine (x:y:ys) = Input (fst seperatedInt) (snd seperatedInt) (head y) (getCharOnPos (fst seperatedInt) (head ys)) (getCharOnPos (snd seperatedInt) (head ys)) (head ys)
    where seperatedInt = seperateInt x '-'
    
getCharOnPos :: Int -> [a] -> a
getCharOnPos 1 (x:xs) = x
getCharOnPos n (x:xs) = getCharOnPos (n-1) xs

-- Input consists of first occurunce of the character, second occurenct of the character, the character, 
-- the actual character on pos 1, the actual character on pos 2 and password
data Input = Input Int Int Char Char Char String
            deriving (Eq, Show)

inputFirst :: Input -> Int
inputFirst (Input fst _ _ _ _ _) = fst

inputSecond :: Input -> Int
inputSecond (Input _ snd _ _ _ _) = snd
            
inputChar :: Input -> Char
inputChar (Input _ _ char _ _ _) = char
            
inputFrstChar :: Input -> Char
inputFrstChar (Input _ _ _ frstChar _ _) = frstChar

inputSndChar :: Input -> Char
inputSndChar (Input _ _ _ _ sndChar _) = sndChar

inputPassword :: Input -> String
inputPassword (Input _ _ _ _ _ password) = password

checkInput :: [Input] -> [Input]
checkInput = filter (\ x -> inputChar x == inputFrstChar x && inputChar x /= inputSndChar x || inputChar x /= inputFrstChar x && inputChar x == inputSndChar x )
