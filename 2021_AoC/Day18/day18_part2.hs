import Data.Char
import Data.List
import Data.List.Split

main :: IO ()
main = do input <- readFile "input.txt"
          print . f . parse $ input 

-- types

data SnailNumber = S SnailNumber SnailNumber | N Int
    deriving Show

leftRight :: SnailNumber -> (Int,Int)
leftRight (S (N n1) (N n2)) = (n1,n2)

-- functions 

f :: [SnailNumber] -> Int 
f input = maximum . map (mag . reduce . (\(x,y) -> add x y)) $ pairs
    where pairs = [(input!!i,input!!j) | i <- [0..len], j <- [0..len]]
          len = length input - 1

add :: SnailNumber -> SnailNumber -> SnailNumber
add n1 n2 = S n1 n2

reduce :: SnailNumber -> SnailNumber
reduce s
    | depth s > 4 = reduce . snd . explode d $ s
    | contains (>9) s = reduce . splitNb $ s
    | otherwise = s
    where d = depth s

depth :: SnailNumber -> Int
depth (N _)   = 0
depth (S l r) = 1 + max (depth l) (depth r) 

contains :: (Int -> Bool) -> SnailNumber -> Bool
contains f (N nb)  = f nb
contains f (S l r) = contains f l || contains f r

explode :: Int -> SnailNumber -> ((Int,Int),SnailNumber) 
explode d (S n1 n2)
    | depth n1 == 1 && d == 2 = ((l1,0), S (N 0) (addLeft r1 n2))
    | depth n2 == 1 && d == 2 = ((0,r2), S (addRight l2 n1) (N 0))
    | depth n1 == d - 1 = ((el1,0), S e1 (addLeft er1 n2))
    | depth n2 == d - 1 = ((0,er2), S (addRight el2 n1) e2)
    where (l1,r1) = leftRight n1
          (l2,r2) = leftRight n2
          ((el1,er1),e1) = explode (d-1) n1
          ((el2,er2),e2) = explode (d-1) n2

addLeft :: Int -> SnailNumber -> SnailNumber
addLeft 0 s        = s
addLeft nb (N n)   = N (nb + n)
addLeft nb (S l r) = S (addLeft nb l) r 
    
addRight :: Int -> SnailNumber -> SnailNumber
addRight 0 s        = s
addRight nb (N n)   = N (nb + n)
addRight nb (S l r) = S l (addRight nb r) 

splitNb :: SnailNumber -> SnailNumber
splitNb (N nb)
    | nb > 9 = S (N (floor d)) (N (ceiling d))
    | otherwise = N nb
    where d = (fromIntegral nb) / 2
splitNb (S n1 n2)
    | contains (>9) n1 = S (splitNb n1) n2
    | otherwise = S n1 (splitNb n2)

mag :: SnailNumber -> Int
mag (N nb)    = nb
mag (S n1 n2) = 3 * mag n1 + 2 * mag n2

-- parsing

parse :: String -> [SnailNumber]
parse = map parseSNumber . lines 

parseSNumber :: String -> SnailNumber
parseSNumber (x:xs)
    | isDigit x = N (digitToInt x)
    | x == '[' = S (parseSNumber l) (parseSNumber r)
    | x == ',' = parseSNumber xs
    where (l,r) = closing xs 1

closing :: String -> Int -> (String,String)
closing (x:xs) nb
    | nb == 1 && x == ',' = ("",init xs)
    | x == ']'  = (\(a,b) -> (x:a,b)) (closing xs (nb+1))
    | x == '['  = (\(a,b) -> (x:a,b)) (closing xs (nb-1))
    | otherwise = (\(a,b) -> (x:a,b)) (closing xs nb)

