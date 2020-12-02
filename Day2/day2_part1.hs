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
parseLine (x:y:ys) = Input (fst seperatedInt) (snd seperatedInt) (head y) (countNbInstances (head y) (head ys)) (head ys)
    where seperatedInt = seperateInt x '-'
    
countNbInstances :: Eq a => a -> [a] -> Int
countNbInstances el = length. filter (\ x -> x == el)

-- Input consists of min max character and password
data Input = Input Int Int Char Int String
            deriving (Eq, Show)

inputMin :: Input -> Int
inputMin (Input min _ _ _ _) = min

inputMax :: Input -> Int
inputMax (Input _ max _ _ _) = max
            
inputChar :: Input -> Char
inputChar (Input _ _ char _ _) = char
            
inputNbChars :: Input -> Int
inputNbChars (Input _ _ _ nbChars _) = nbChars

inputPassword :: Input -> String
inputPassword (Input _ _ _ _ password) = password

checkInput :: [Input] -> [Input]
checkInput = filter (\ x -> inputMin x <= inputNbChars x && inputMax x >= inputNbChars x)
