import Data.Char
import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . parse $ input
          print . f . parse $ input
          print . sumVersion . f . parse $ input

-- types 

data Package = Lit Int Int Int
               | Op Int Int [Package]
    deriving Show

-- functions

sumVersion :: Package -> Int
sumVersion (Lit v _ _) = v
sumVersion (Op v _ p)  = v + (sum . map sumVersion $ p)

f :: String -> Package
f input = fst . parsePackage $ input

parsePackage :: String -> (Package,String)
parsePackage l
    | typeID == 4 = (Lit version typeID lit, restLit)
    | otherwise = case lengthID of
                     '0' -> (Op version typeID op0,restOp0)
                     '1' -> (Op version typeID op1,restOp1)
    where (part1,rest1) = splitAt 3 l
          (part2,rest2)  = splitAt 3 rest1
          version = binToInt part1
          typeID = binToInt part2
          (lit,restLit) = (\(a,b) -> (binToInt a,b)) . parseLit $ rest2
          lengthID = head rest2
          lengthOp0 = binToInt . take 15 . tail $ rest2
          lengthOp1 = binToInt . take 11 . tail $ rest2
          (partOp0,restOp0) = splitAt lengthOp0 . drop 16 $ rest2
          partOp1 = drop 12 rest2
          op0 = parseOp partOp0
          (op1,restOp1) = parseNbOp lengthOp1 partOp1

parseLit :: String -> (String,String)
parseLit lit 
    | h == '0' = (t,drop 5 lit)
    | otherwise = (\ (a,b) -> (t++a,b)) (parseLit (drop 5 lit))
    where (h:t) = take 5 lit

parseOp :: String -> [Package]
parseOp s
    | null s = []
    | otherwise = package : parseOp rest
    where (package,rest) = parsePackage s

parseNbOp :: Int -> String -> ([Package],String)
parseNbOp nb s 
    | nb == 0 = ([],s)
    | otherwise = (\(a,b) -> (package:a,b)) (parseNbOp (nb-1) rest)
    where (package,rest) = parsePackage s

binToInt :: String -> Int
binToInt = foldl (\acc b -> 2*acc + digitToInt b) 0

-- parsing 

parse :: String -> String 
parse = concat . map (size4 . digToBin . hexToDig) . head . words

size4 :: String -> String
size4 s = replicate (4 - length s) '0' ++ s

digToBin :: Int -> String
digToBin nb 
    | nb == 0 = [] 
    | otherwise = digToBin q ++ show r
    where (q,r) = quotRem nb 2

hexToDig :: Char -> Int
hexToDig c
    | c < 'A' = ord c - base
    | otherwise = ord c - base2 + 10
    where base = ord '1' - 1
          base2  = ord 'A'
