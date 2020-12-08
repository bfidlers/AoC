main :: IO ()
main = do input <- readFile "input.txt"
          print . runProgram 0 . mkNewProgram . parseLine . lines $ input
                         
parseLine :: [String] -> [(String, Int, Bool)]     
parseLine [] = []                
parseLine (x:xs) = (take 3 x, readInt (drop 4 x), False) : parseLine xs

readInt :: String -> Int 
readInt (x:xs) = if x == '+' then read xs else read (x:xs)

fst3 :: (a, b, c) -> a
fst3 (a, _, _) = a

snd3 :: (a, b, c) -> b
snd3 (_, b, _) = b

trd3 :: (a, b, c) -> c
trd3 (_, _, c) = c

runProgram :: Int -> Program -> Int
runProgram n program  
    | trd3 instr == True = runProgram new_index . tryNext n new_index . resetProgram $ program
    | fst3 instr == "end" = acc
    | fst3 instr == "nop" = runProgram n . setIndex (index + 1) . replaceInstruction index (fst3 instr, snd3 instr, True) $ program
    | fst3 instr == "jmp" = runProgram n . setIndex (index + snd3 instr) . replaceInstruction index (fst3 instr, snd3 instr, True) $ program
    | fst3 instr == "acc" = runProgram n . setIndex (index + 1) . setAcc (acc + snd3 instr) . replaceInstruction index (fst3 instr, snd3 instr, True) $ program
        where instr = getCurrentInstruction program
              index = getIndex program
              acc = getAcc program
              new_index = findNext n program
              
tryNext :: Int -> Int -> Program -> Program
tryNext 0 n2 program = flipInstruction n2 program
tryNext n n2 program = flipInstruction n . flipInstruction n2 $ program

findNext :: Int -> Program -> Int
findNext index (Program acc i instrs) 
    | fst3 instr == "nop" || fst3 instr == "jmp" = index + 1
    | otherwise = findNext (index + 1) (Program acc i instrs) 
    where instr = instrs!!(index+1)

--Program exists of acc, index and instructions
data Program = Program Int Int [(String, Int, Bool)]
    deriving Show

mkNewProgram :: [(String, Int, Bool)] -> Program
mkNewProgram instr = Program 0 0 (instr ++ [("end", 0, False)])

resetProgram :: Program -> Program
resetProgram program = Program 0 0 new_instrs
    where new_instrs = map (\(name, nb, _) -> (name, nb, False)) (getInstructions program)

getAcc :: Program -> Int
getAcc (Program acc _ _) = acc

getIndex :: Program -> Int 
getIndex (Program _ index _) = index 

getInstructions :: Program -> [(String, Int, Bool)]
getInstructions (Program _ _ instructions) = instructions

setAcc :: Int -> Program -> Program 
setAcc acc (Program _ index instructions) = Program acc index instructions

setIndex :: Int -> Program -> Program 
setIndex index (Program acc _ instructions) = Program acc index instructions

setInstructions :: [(String, Int, Bool)] -> Program -> Program 
setInstructions instructions (Program acc index _) = Program acc index instructions

getCurrentInstruction :: Program -> (String, Int, Bool)
getCurrentInstruction (Program _ index instructions) = instructions!!index

replaceInstruction :: Int -> (String, Int, Bool) -> Program -> Program
replaceInstruction 0 instr (Program acc i instrs) = Program acc i (instr: tail instrs) 
replaceInstruction n instr (Program acc i instrs) = Program acc i new_instructions
    where new_instructions = (take (n) instrs) ++ [instr] ++ (drop (n+1) instrs) 
    
flipInstruction :: Int -> Program -> Program 
flipInstruction n (Program acc i instrs) 
    | fst3 instr == "nop" = replaceInstruction n ("jmp", snd3 instr, trd3 instr) (Program acc i instrs) 
    | fst3 instr == "jmp" = replaceInstruction n ("nop", snd3 instr, trd3 instr) (Program acc i instrs)
    where instr = instrs!!n
