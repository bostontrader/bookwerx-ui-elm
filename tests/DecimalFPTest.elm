module DecimalFPTest exposing (..)

import DecimalFP exposing (DFP, DFPFmt, Sign(..), dfp_abs, dfp_add, dfp_equal, dfp_fmt, dfp_fromString, dfp_fromStringExp, dfp_neg, dfp_norm, dfp_norm_exp, dfp_round, dnc, insertDp, md_add, md_compare, md_fromString, md_sub, stripZ)

import Expect exposing (Expectation)
import Test exposing (..)


dncTest : Test
dncTest =
    describe "positive digits 'n' carries, base 10"
        [ test "0 + 0" (\_ -> Expect.equal (dnc 0 0 0 10) (0,0))
        , test "0 + 1" (\_ -> Expect.equal (dnc 0 1 0 10) (1,0))
        , test "5 + 6" (\_ -> Expect.equal (dnc 5 6 0 10) (1,1))
        , test "99 + 99" (\_ -> Expect.equal (dnc 99 99 0 10) (8, 19))
        ]


dfp_absTest : Test
dfp_absTest =
    describe "dfp_abs"
        [ test "Positive" (\_ -> Expect.equal (dfp_abs (DFP [1] 0 Positive)) (DFP  [1]  0 Positive))
        , test "Negative" (\_ -> Expect.equal (dfp_abs (DFP [1] 0 Negative)) (DFP  [1]  0 Positive))
        , test "Zero" (\_ -> Expect.equal (dfp_abs (DFP [1] 0 Zero)) (DFP  [1]  0 Zero))
        ]


dfp_addTest : Test
dfp_addTest =
    describe "dfp_add"
        [ test "Zero + Zero]" (\_ -> Expect.equal (dfp_add (DFP [] 0 Zero) (DFP [] 0 Zero)) (DFP [] 0 Zero))
        , test "Zero + Something]" (\_ -> Expect.equal (dfp_add (DFP [] 0 Zero) (DFP [1] 0 Positive)) (DFP [1] 0 Positive))
        , test "Something + Zero]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Positive) (DFP [] 0 Zero)) (DFP [1] 0 Positive))

        -- Positive + Positive
        , test "[1] + [2]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Positive) (DFP [2] 0 Positive)) (DFP [3] 0 Positive))
        , test "[1] + [1, 2]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Positive) (DFP [1,2] 0 Positive)) (DFP [2,2] 0 Positive))
        , test "1.2 + 3" (\_ -> Expect.equal (dfp_add (DFP [2, 1] -1 Positive) (DFP [3] 0 Positive)) (DFP [2, 4] -1 Positive))
        , test "4.9 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] -1 Positive) (DFP [1] 0 Positive)) (DFP [9, 5] -1 Positive))
        , test "49 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 0 Positive) (DFP [1] 0 Positive)) (DFP [5] 1 Positive))
        , test "490 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Positive) (DFP [1] 0 Positive)) (DFP [1,9,4] 0 Positive))
        , test "490 + 0.1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Positive) (DFP [1] -1 Positive)) (DFP [1,0,9,4] -1 Positive))

        -- Positive + Negative
        , test "[1] + -[1]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Positive) (DFP [1] 0 Negative)) (DFP [] 0 Zero))
        , test "[1] + -[3]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Positive) (DFP [3] 0 Negative)) (DFP [2] 0 Negative))
        , test "[3] + -[2]" (\_ -> Expect.equal (dfp_add (DFP [3] 0 Positive) (DFP [2] 0 Negative)) (DFP [1] 0 Positive))
        , test "[1] + -[1, 2]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Positive) (DFP [1,2] 0 Negative)) (DFP [2] 1 Negative))
        , test "[1,2] + -[1]" (\_ -> Expect.equal (dfp_add (DFP [1,2] 0 Positive) (DFP [1] 0 Negative)) (DFP [2] 1 Positive))
        , test "1.2 + -3" (\_ -> Expect.equal (dfp_add (DFP [2, 1] -1 Positive) (DFP [3] 0 Negative)) (DFP [8, 1] -1 Negative))
        , test "4.9 + -1" (\_ -> Expect.equal (dfp_add (DFP [9,4] -1 Positive) (DFP [1] 0 Negative)) (DFP [9, 3] -1 Positive))
        , test "49 + -1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 0 Positive) (DFP [1] 0 Negative)) (DFP [8, 4] 0 Positive))
        , test "490 + -1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Positive) (DFP [1] 0 Negative)) (DFP [9, 8, 4] 0 Positive))
        , test "490 + -0.1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Positive) (DFP [1] -1 Negative)) (DFP [9, 9, 8, 4] -1 Positive))

        -- Negative + Positive
        , test "-[1] + [1]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Negative) (DFP [1] 0 Positive)) (DFP [] 0 Zero))
        , test "-[1] + [3]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Negative) (DFP [3] 0 Positive)) (DFP [2] 0 Positive))
        , test "-[3] + [2]" (\_ -> Expect.equal (dfp_add (DFP [3] 0 Negative) (DFP [2] 0 Positive)) (DFP [1] 0 Negative))
        , test "-[1] + [1, 2]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Negative) (DFP [1,2] 0 Positive)) (DFP [2] 1 Positive))
        , test "-[1,2] + [1]" (\_ -> Expect.equal (dfp_add (DFP [1,2] 0 Negative) (DFP [1] 0 Positive)) (DFP [2] 1 Negative))
        , test "-1.2 + 3" (\_ -> Expect.equal (dfp_add (DFP [2, 1] -1 Negative) (DFP [3] 0 Positive)) (DFP [8, 1] -1 Positive))
        , test "-4.9 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] -1 Negative) (DFP [1] 0 Positive)) (DFP [9, 3] -1 Negative))
        , test "-49 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 0 Negative) (DFP [1] 0 Positive)) (DFP [8,4] 0 Negative))
        , test "-490 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Negative) (DFP [1] 0 Positive)) (DFP [9,8,4] 0 Negative))
        , test "-490 + 0.1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Positive) (DFP [1] -1 Positive)) (DFP [1,0,9,4] -1 Positive))

        -- Negative + Negative
        , test "-[1] + -[1]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Negative) (DFP [1] 0 Negative)) (DFP [2] 0 Negative))
        , test "-[1] + -[3]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Negative) (DFP [3] 0 Negative)) (DFP [4] 0 Negative))
        , test "-[3] + -[2]" (\_ -> Expect.equal (dfp_add (DFP [3] 0 Negative) (DFP [2] 0 Negative)) (DFP [5] 0 Negative))
        , test "-[1] + -[1, 2]" (\_ -> Expect.equal (dfp_add (DFP [1] 0 Negative) (DFP [1,2] 0 Negative)) (DFP [2,2] 0 Negative))
        , test "-[1,2] + -[1]" (\_ -> Expect.equal (dfp_add (DFP [1,2] 0 Negative) (DFP [1] 0 Negative)) (DFP [2,2] 0 Negative))
        , test "-1.2 + -3" (\_ -> Expect.equal (dfp_add (DFP [2, 1] -1 Negative) (DFP [3] 0 Negative)) (DFP [2, 4] -1 Negative))
        , test "-4.9 + -1" (\_ -> Expect.equal (dfp_add (DFP [9,4] -1 Negative) (DFP [1] 0 Negative)) (DFP [9, 5] -1 Negative))
        , test "-49 + -1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 0 Negative) (DFP [1] 0 Negative)) (DFP [5] 1 Negative))
        , test "-490 + -1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Negative) (DFP [1] 0 Negative)) (DFP [1, 9, 4] 0 Negative))
        , test "-490 + -0.1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Negative) (DFP [1] -1 Negative)) (DFP [1,0,9,4] -1 Negative))

        -- other
        , test "big + small" (\_ -> Expect.equal (dfp_add (DFP
            [9, 0, 0, 0, 0 ,0, 0, 8, 4, 1, 2] -8 Positive) (DFP [1] -8 Positive)) (DFP [1, 0, 0, 0 ,0, 0, 8, 4, 1, 2] -7 Positive))
        ]


dfp_addTestx : Test
dfp_addTestx =
    describe "dfp_addx"
        [
        --, test "-4900 + 0.1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 2 Negative) (DFP [1] -1 Positive)) (DFP [9,9,9,8,4] -1 Positive))
         --test "-4.9 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] -1 Negative) (DFP [1] 0 Positive)) (DFP [9, 3] -1 Negative))
        --test "-49 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 0 Negative) (DFP [1] 0 Positive)) (DFP [8,4] 0 Negative))
         test "-490 + 1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Negative) (DFP [1] 0 Positive)) (DFP [9,8,4] 0 Negative))
        , test "-490 + 0.1" (\_ -> Expect.equal (dfp_add (DFP [9,4] 1 Positive) (DFP [1] -1 Positive)) (DFP [1,0,9,4] -1 Positive))
        ]


dfp_equalTest : Test
dfp_equalTest =
    describe "dfp_equal"
        [ test "True" (\_ -> Expect.equal (dfp_equal (DFP [1] 0 Positive) (DFP [1] 0 Positive) ) True)
        , test "False amt" (\_ -> Expect.equal (dfp_equal (DFP [1] 0 Positive) (DFP [2] 0 Positive) ) False)
        , test "False exp" (\_ -> Expect.equal (dfp_equal (DFP [1] 0 Positive) (DFP [1] 1 Positive) ) False)
        , test "False sign" (\_ -> Expect.equal (dfp_equal (DFP [1] 0 Positive) (DFP [1] 0 Negative) ) False)
        ]


dfp_fmtTest : Test
dfp_fmtTest =
    describe "dfp_fmt"
        [ test "[5,5,5] -4, p = -5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -4 Positive) -5) (DFPFmt "0.05550" False))
        , test "[5,5,5] -4, p = -4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -4 Positive) -4) (DFPFmt "0.0555" False))
        , test "[5,5,5] -4, p = -3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -4 Positive) -3) (DFPFmt "0.056" True))
        , test "[5,5,5] -4, p = -2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -4 Positive) -2) (DFPFmt "0.06" True))
        , test "[5,5,5] -4, p = -1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -4 Positive) -1) (DFPFmt "0.1" True))
        , test "[5,5,5] -4, p = 0" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -4 Positive) 0) (DFPFmt "0" True))

        , test "[5,5,5] -3, p = -5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) -5) (DFPFmt "0.55500" False))
        , test "[5,5,5] -3, p = -4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) -4) (DFPFmt "0.5550" False))
        , test "[5,5,5] -3, p = -3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) -3) (DFPFmt "0.555" False))
        , test "[5,5,5] -3, p = -2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) -2) (DFPFmt "0.56" True))
        , test "[5,5,5] -3, p = -1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) -1) (DFPFmt "0.6" True))
        , test "[5,5,5] -3, p = 0" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) 0) (DFPFmt "1" True))
        , test "[5,5,5] -3, p = 1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -3 Positive) 1) (DFPFmt "0" True))

        , test "[5,5,5] -2, p = -5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) -5) (DFPFmt "5.55000" False))
        , test "[5,5,5] -2, p = -4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) -4) (DFPFmt "5.5500" False))
        , test "[5,5,5] -2, p = -3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) -3) (DFPFmt "5.550" False))
        , test "[5,5,5] -2, p = -2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) -2) (DFPFmt "5.55" False))
        , test "[5,5,5] -2, p = -1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) -1) (DFPFmt "5.6" True))
        , test "[5,5,5] -2, p = 0" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) 0) (DFPFmt "6" True))
        , test "[5,5,5] -2, p = 1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) 1) (DFPFmt "10" True))
        , test "[5,5,5] -2, p = 2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -2 Positive) 2) (DFPFmt "0" True))

        , test "[5,5,5] -1, p = -5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) -5) (DFPFmt "55.50000" False))
        , test "[5,5,5] -1, p = -4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) -4) (DFPFmt "55.5000" False))
        , test "[5,5,5] -1, p = -3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) -3) (DFPFmt "55.500" False))
        , test "[5,5,5] -1, p = -2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) -2) (DFPFmt "55.50" False))
        , test "[5,5,5] -1, p = -1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) -1) (DFPFmt "55.5" False))
        , test "[5,5,5] -1, p = 0" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) 0) (DFPFmt "56" True))
        , test "[5,5,5] -1, p = 1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) 1) (DFPFmt "60" True))
        , test "[5,5,5] -1, p = 2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) 2) (DFPFmt "100" True))
        , test "[5,5,5] -1, p = 3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] -1 Positive) 3) (DFPFmt "0" True))

        , test "[5,5,5] 0, p = -5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) -5) (DFPFmt "555.00000" False))
        , test "[5,5,5] 0, p = -4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) -4) (DFPFmt "555.0000" False))
        , test "[5,5,5] 0, p = -3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) -3) (DFPFmt "555.000" False))
        , test "[5,5,5] 0, p = -2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) -2) (DFPFmt "555.00" False))
        , test "[5,5,5] 0, p = -1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) -1) (DFPFmt "555.0" False))
        , test "[5,5,5] 0, p = 0" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) 0) (DFPFmt "555" False))
        , test "[5,5,5] 0, p = 1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) 1) (DFPFmt "560" True))
        , test "[5,5,5] 0, p = 2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) 2) (DFPFmt "600" True))
        , test "[5,5,5] 0, p = 3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) 3) (DFPFmt "1000" True))
        , test "[5,5,5] 0, p = 4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 0 Positive) 4) (DFPFmt "0" True))

        , test "[5,5,5] 1, p = -5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) -5) (DFPFmt "5550.00000" False))
        , test "[5,5,5] 1, p = -4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) -4) (DFPFmt "5550.0000" False))
        , test "[5,5,5] 1, p = -3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) -3) (DFPFmt "5550.000" False))
        , test "[5,5,5] 1, p = -2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) -2) (DFPFmt "5550.00" False))
        , test "[5,5,5] 1, p = -1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) -1) (DFPFmt "5550.0" False))
        , test "[5,5,5] 1, p = 0" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) 0) (DFPFmt "5550" False))
        , test "[5,5,5] 1, p = 1" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) 1) (DFPFmt "5550" False))
        , test "[5,5,5] 1, p = 2" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) 2) (DFPFmt "5600" True))
        , test "[5,5,5] 1, p = 3" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) 3) (DFPFmt "6000" True))
        , test "[5,5,5] 1, p = 4" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) 4) (DFPFmt "10000" True))
        , test "[5,5,5] 1, p = 5" (\_ -> Expect.equal (dfp_fmt (DFP [5,5,5] 1 Positive) 5) (DFPFmt "0" True))

        , test "[0,9,1,5,0,9,9,2,4] -7, p = -6" (\_ -> Expect.equal (dfp_fmt (DFP [0,9,1,5,0,9,9,2,4] -7 Positive) -6) (DFPFmt "42.990519" False))
        , test "[0,9,1,5,0,9,9,2,4] -7, p = -7" (\_ -> Expect.equal (dfp_fmt (DFP [0,9,1,5,0,9,9,2,4] -7 Positive) -7) (DFPFmt "42.9905190" True))
        ]


dfp_fromStringTest : Test
dfp_fromStringTest =
    describe "dfp_fromString"
        [ test "empty string" (\_ -> Expect.equal (dfp_fromString "") (DFP  [] 0 Zero))
        , test "x" (\_ -> Expect.equal (dfp_fromString "x") (DFP [] 0 Zero))
        , test ".." (\_ -> Expect.equal (dfp_fromString "..") (DFP  [] 0 Zero))
        , test "1" (\_ -> Expect.equal (dfp_fromString "1") (DFP  [1] 0 Positive))
        , test "1x2" (\_ -> Expect.equal (dfp_fromString "1x2") (DFP  [2, 1] 0 Positive))
        , test "1.x2" (\_ -> Expect.equal (dfp_fromString "1.x2") (DFP  [2, 1] -1 Positive))
        , test "-1" (\_ -> Expect.equal (dfp_fromString "-1") (DFP  [1] 0 Negative))
        , test "50" (\_ -> Expect.equal (dfp_fromString "50") (DFP  [5] 1 Positive))
        , test "-50" (\_ -> Expect.equal (dfp_fromString "-50") (DFP  [5] 1 Negative))
        ]


dfp_fromStringExpTest : Test
dfp_fromStringExpTest =
    describe "dfp_fromStringExp"
        [ test "empty string, 666" (\_ -> Expect.equal (dfp_fromStringExp "" 666) (DFP  [] 0 Zero))
        , test "x, 666" (\_ -> Expect.equal (dfp_fromStringExp "x" 666) (DFP [] 0 Zero))
        , test "-x, 666" (\_ -> Expect.equal (dfp_fromStringExp "-x" 666) (DFP [] 0 Zero))
        , test "1, 5" (\_ -> Expect.equal (dfp_fromStringExp "1" 5) (DFP  [1] 5 Positive))
        , test "1x2, -5" (\_ -> Expect.equal (dfp_fromStringExp "1x2" -5) (DFP  [2, 1] -5 Positive))
        , test "-1, 5" (\_ -> Expect.equal (dfp_fromStringExp "-1" 5) (DFP  [1] 5 Negative))
        , test "3141592653589792, 0" (\_ -> Expect.equal (dfp_fromStringExp "3141592653589792" 0) (DFP  [2,9,7,9,8,5,3,5,6,2,9,5,1,4,1,3] 0 Positive))
        , test "201808048762, -8" (\_ -> Expect.equal (dfp_fromStringExp "201808048762" -8) (DFP  [2,6,7,8,4,0,8,0,8,1,0,2] -8 Positive))
        , test "500, 0" (\_ -> Expect.equal (dfp_fromStringExp "500" 0) (DFP  [5] 2 Positive))
        , test "-500, 0" (\_ -> Expect.equal (dfp_fromStringExp "-500" 0) (DFP  [5] 2 Negative))
        ]

dfp_negTest : Test
dfp_negTest =
    describe "dfp_neg"
        [ test "Positive" (\_ -> Expect.equal (dfp_neg (DFP [1] 0 Positive)) (DFP  [1]  0 Negative))
        , test "Negative" (\_ -> Expect.equal (dfp_neg (DFP [1] 0 Negative)) (DFP  [1]  0 Positive))
        , test "Zero" (\_ -> Expect.equal (dfp_neg (DFP [1] 0 Zero)) (DFP  [1]  0 Zero))
        ]


dfp_normTest : Test
dfp_normTest =
    describe "dfp_norm"
        [ test "[]" (\_ -> Expect.equal (dfp_norm (DFP [] 0 Positive) ) (DFP [] 0 Zero))
        , test "[1]" (\_ -> Expect.equal (dfp_norm (DFP [1] 0 Positive) ) (DFP [1] 0 Positive))
        , test "[0,1] 0" (\_ -> Expect.equal (dfp_norm (DFP [0, 1] 0 Positive) ) (DFP [1] 1 Positive))
        ]


dfp_norm_expTest : Test
dfp_norm_expTest =
    describe "dfp_norm_exp"
        [ test "n1.exp == n2.exp" (\_ -> Expect.equal (dfp_norm_exp (DFP [1] 0 Negative) (DFP [1] 0 Negative)) ((DFP [1] 0 Negative), (DFP [1] 0 Negative)))
        , test "n1.exp > n2.exp" (\_ -> Expect.equal (dfp_norm_exp (DFP [1] 1 Positive) (DFP [1] 0 Negative)) ((DFP [0, 1] 0 Positive), (DFP [1] 0 Negative)))
        , test "n1.exp < n2.exp" (\_ -> Expect.equal (dfp_norm_exp (DFP [2] 0 Negative) (DFP [1] 1 Positive)) ((DFP [2] 0 Negative), (DFP [0, 1] 0 Positive)))
        , test "1.2, 3" (\_ -> Expect.equal (dfp_norm_exp (DFP [2, 1] -1 Positive) (DFP [3] 0 Positive)) ((DFP [2, 1] -1 Positive), (DFP [0, 3] -1 Positive)))
        ]


dfp_roundTest : Test
dfp_roundTest =
    describe "dfp_round"
        [ test "[5,5,5] -4, p = -5" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -4 Positive) -5) (DFP [5,5,5] -4 Positive) )
        , test "[5,5,5] -4, p = -4" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -4 Positive) -4) (DFP [5,5,5] -4 Positive) )
        , test "[5,5,5] -4, p = -3" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -4 Positive) -3) (DFP [6, 5] -3 Positive) )
        , test "[5,5,5] -4, p = -2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -4 Positive) -2) (DFP [6] -2 Positive) )
        , test "[5,5,5] -4, p = -1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -4 Positive) -1) (DFP [1] -1 Positive) )
        , test "[5,5,5] -4, p = 0" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -4 Positive) 0) (DFP [] 0 Zero) )

        , test "[5,5,5] -3, p = -4" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -3 Positive) -4) (DFP [5,5,5] -3 Positive) )
        , test "[5,5,5] -3, p = -3" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -3 Positive) -3) (DFP [5,5,5] -3 Positive) )
        , test "[5,5,5] -3, p = -2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -3 Positive) -2) (DFP [6,5] -2 Positive) )
        , test "[5,5,5] -3, p = -1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -3 Positive) -1) (DFP [6] -1 Positive) )
        , test "[5,5,5] -3, p = 0" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -3 Positive) 0) (DFP [1] 0 Positive) )
        , test "[5,5,5] -3, p = 1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -3 Positive) 1) (DFP [] 0 Zero) )

        , test "[5,5,5] -2, p = -3" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -2 Positive) -3) (DFP [5,5,5] -2 Positive) )
        , test "[5,5,5] -2, p = -2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -2 Positive) -2) (DFP [5,5,5] -2 Positive) )
        , test "[5,5,5] -2, p = -1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -2 Positive) -1) (DFP [6,5] -1 Positive) )
        , test "[5,5,5] -2, p = 0" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -2 Positive) 0) (DFP [6] 0 Positive) )
        , test "[5,5,5] -2, p = 1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -2 Positive) 1) (DFP [1] 1 Positive) )
        , test "[5,5,5] -2, p = 2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -2 Positive) 2) (DFP [] 0 Zero) )

        , test "[5,5,5] -1, p = -2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -1 Positive) -2) (DFP [5,5,5] -1 Positive) )
        , test "[5,5,5] -1, p = -1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -1 Positive) -1) (DFP [5,5,5] -1 Positive) )
        , test "[5,5,5] -1, p = 0" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -1 Positive) 0) (DFP [6,5] 0 Positive) )
        , test "[5,5,5] -1, p = 1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -1 Positive) 1) (DFP [6] 1 Positive) )
        , test "[5,5,5] -1, p = 2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -1 Positive) 2) (DFP [1] 2 Positive) )
        , test "[5,5,5] -1, p = 3" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] -1 Positive) 3) (DFP [] 0 Zero) )

        , test "[5,5,5] 0, p = -1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 0 Positive) -1) (DFP [5,5,5] 0 Positive) )
        , test "[5,5,5] 0, p = 0" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 0 Positive) 0) (DFP [5,5,5] 0 Positive) )
        , test "[5,5,5] 0, p = 1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 0 Positive) 1) (DFP [6,5] 1 Positive) )
        , test "[5,5,5] 0, p = 2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 0 Positive) 2) (DFP [6] 2 Positive) )
        , test "[5,5,5] 0, p = 3" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 0 Positive) 3) (DFP [1] 3 Positive) )
        , test "[5,5,5] 0, p = 4" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 0 Positive) 4) (DFP [] 0 Zero) )

        , test "[5,5,5] 1, p = 0" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 1 Positive) 0) (DFP [5,5,5] 1 Positive) )
        , test "[5,5,5] 1, p = 1" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 1 Positive) 1) (DFP [5,5,5] 1 Positive) )
        , test "[5,5,5] 1, p = 2" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 1 Positive) 2) (DFP [6,5] 2 Positive) )
        , test "[5,5,5] 1, p = 3" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 1 Positive) 3) (DFP [6] 3 Positive) )
        , test "[5,5,5] 1, p = 4" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 1 Positive) 4) (DFP [1] 4 Positive) )
        , test "[5,5,5] 1, p = 5" (\_ -> Expect.equal (dfp_round (DFP [5,5,5] 1 Positive) 5) (DFP [] 0 Zero) )
        ]


insertDpTest : Test
insertDpTest =
    describe "insertDp"
        [ test "empty string, 0" (\_ -> Expect.equal (insertDp 0 "" ) ".")
        , test "1, 0" (\_ -> Expect.equal (insertDp 0 "1" ) ".1")
        , test "1, 1" (\_ -> Expect.equal (insertDp 1 "1" ) "1.")
        , test "10, 0" (\_ -> Expect.equal (insertDp 0 "10" ) ".10")
        , test "10, 1" (\_ -> Expect.equal (insertDp 1 "10" ) "1.0")
        , test "10, 2" (\_ -> Expect.equal (insertDp 2 "10" ) "10.")
        ]


md_addTest : Test
md_addTest =
    describe "positive multi-digit addition, base 10"
        [ test "[] + []" (\_ -> Expect.equal (md_add [] [] 0 10 ) ([]))
        , test "[] + [] + carry 1" (\_ -> Expect.equal (md_add [] [] 1 10 ) ([1]))

        , test "[] + [1]" (\_ -> Expect.equal (md_add [] [1] 0 10 ) ([1]))
        , test "[] + [1] + carry 2" (\_ -> Expect.equal (md_add [] [1] 2 10 ) ([3]))
        , test "[] + [1] + carry 9" (\_ -> Expect.equal (md_add [] [1] 9 10 ) ([0,1]))

        , test "[] + [1, 2, 3]" (\_ -> Expect.equal (md_add [] [1, 2, 3] 0 10 ) ([1,2,3]))
        , test "[] + [1, 2, 3] + carry 2" (\_ -> Expect.equal (md_add [] [1, 2, 3] 2 10 ) ([3,2,3]))
        , test "[] + [1, 2, 3] + carry 9" (\_ -> Expect.equal (md_add [] [1, 2, 3] 9 10 ) ([0,3,3]))
        , test "[] + [9, 9, 9] + carry 1" (\_ -> Expect.equal (md_add [] [9, 9, 9] 1 10 ) ([0,0,0,1]))

        , test "[1] + []" (\_ -> Expect.equal (md_add [1] [] 0 10 ) ([1]))
        , test "[1] + [] + carry 2" (\_ -> Expect.equal (md_add [1] [] 2 10 ) ([3]))
        , test "[1] + [] + carry 9" (\_ -> Expect.equal (md_add [1] [] 9 10 ) ([0,1]))

        , test "[1, 2, 3] + []" (\_ -> Expect.equal (md_add [1, 2, 3] [] 0 10 ) ([1,2,3]))
        , test "[1, 2, 3] + [] + carry 2" (\_ -> Expect.equal (md_add [1, 2, 3] [] 2 10 ) ([3,2,3]))
        , test "[1, 2, 3] + [] + carry 9" (\_ -> Expect.equal (md_add [1, 2, 3] [] 9 10 ) ([0,3,3]))
        , test "[9, 9, 9] + [] + carry 1" (\_ -> Expect.equal (md_add [9, 9, 9] [] 1 10 ) ([0,0,0,1]))

        , test "[1] + [1]" (\_ -> Expect.equal (md_add [1] [1] 0 10 ) ([2]))
        , test "[1] + [1] + carry 8" (\_ -> Expect.equal (md_add [1] [1] 8 10 ) ([0, 1]))
        , test "[5] + [6]" (\_ -> Expect.equal (md_add [5] [6] 0 10 ) ([1,1]))
        , test "[5, 5] + [9]" (\_ -> Expect.equal (md_add [5, 5] [9] 0 10 ) ([4, 6]))

        , test "[5, 5] + [6,6]" (\_ -> Expect.equal (md_add [5, 5] [6, 6] 0 10 ) ([1, 2, 1]))
        , test "[6, 1, 5] + [1, 6, 7]" (\_ -> Expect.equal (md_add [6, 1, 5] [1, 6, 7] 0 10 ) ([7, 7, 2, 1]))
        ]


md_compareTest : Test
md_compareTest =
    describe "multi digit compare"
        [ test "[] []" (\_ -> Expect.equal (md_compare [] []) 0 )
        , test "[1] []" (\_ -> Expect.equal (md_compare [1] []) 1 )
        , test "[] [1]" (\_ -> Expect.equal (md_compare [] [1]) -1 )
        , test "[1] [1]" (\_ -> Expect.equal (md_compare [1] [1]) 0 )
        , test "[1] [2]" (\_ -> Expect.equal (md_compare [1] [2]) -1 )
        , test "[2] [1]" (\_ -> Expect.equal (md_compare [2] [1]) 1 )
        , test "[1, 2] [1, 3]" (\_ -> Expect.equal (md_compare [1, 2] [1, 3]) -1 )
        , test "[1, 2] [1, 2]" (\_ -> Expect.equal (md_compare [1, 2] [1, 2])  0)
        , test "[1, 2] [1, 1]" (\_ -> Expect.equal (md_compare [1, 2] [1, 1]) 1 )
        ]


md_fromStringTest : Test
md_fromStringTest =
    describe "md_fromString"
        [ test "empty string" (\_ -> Expect.equal (md_fromString "") ([], Zero))
        , test "x" (\_ -> Expect.equal (md_fromString "x") ([], Zero))
        , test "1" (\_ -> Expect.equal (md_fromString "1") ([1], Positive))
        , test "1x2" (\_ -> Expect.equal (md_fromString "1x2") ([2, 1], Positive))
        , test "-1" (\_ -> Expect.equal (md_fromString "-1") ([1], Negative))
        ]


md_subTest : Test
md_subTest =
    describe "positive multi-digit subtraction, base 10"
        [ test "[] - []" (\_ -> Expect.equal (md_sub [] [] ) (Just []))
        , test "[0] - [0]" (\_ -> Expect.equal (md_sub [0] [0] ) (Just []))

        -- should never happen because top >= bottom
        --, test "[] + [1]" (\_ -> Expect.equal (md_sub [] [1] 0 10 ) ([1]))
        --, test "[] + [1, 2, 3]" (\_ -> Expect.equal (md_sub [] [1, 2, 3] 0 10 ) ([1,2,3]))

        , test "[1] - []" (\_ -> Expect.equal (md_sub [1] [] ) (Just [1]))
        , test "[1, 0] - [0]" (\_ -> Expect.equal (md_sub [1, 0] [0] ) (Just [1]))
        , test "[1, 2, 3] - []" (\_ -> Expect.equal (md_sub [1, 2, 3] [] ) (Just [1,2,3]))
        , test "[6, 1, 5] - [8, 3, 2]" (\_ -> Expect.equal (md_sub [6, 1, 5] [8, 3, 2] ) (Just [8, 7, 2]))
        , test "[3] - [1]" (\_ -> Expect.equal (md_sub [3] [1]  ) (Just [2]))
        , test "[3] - [1, 0]" (\_ -> Expect.equal (md_sub [3] [1, 0]  ) (Just [2]))
        , test "[5, 5] - [9]" (\_ -> Expect.equal (md_sub [5, 5] [9]  ) (Just [6, 4]))
        , test "[5, 5] - [6,4]" (\_ -> Expect.equal (md_sub [5, 5] [6,4]  ) (Just [9]))
        , test "[0, 9, 4] - [1]" (\_ -> Expect.equal (md_sub [0, 9, 4] [1] ) (Just [9,8,4]))
        ]


stripZTest : Test
stripZTest =
    describe "strip extraneous msb zero digits, if any"
        [ test "[]" (\_ -> Expect.equal (stripZ []) ([]))
        , test "[0]" (\_ -> Expect.equal (stripZ [0]) ([]))
        , test "[1]" (\_ -> Expect.equal (stripZ [1]) ([1]))
        , test "[1, 0]" (\_ -> Expect.equal (stripZ [1, 0]) ([1]))
        , test "[0, 1, 0, 0]" (\_ -> Expect.equal (stripZ [0, 1, 0, 0]) ([0, 1]))
        , test "[0, 1]" (\_ -> Expect.equal (stripZ [0, 1]) ([0, 1]))
        ]
