module DecimalFPTestx exposing (..)

import DecimalFPx exposing (DFPx, DFPFmtx)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


dfp_absTests : Test
dfp_absTests =
    describe "dfp_abs"
        [ test "-1 0" (\_ -> Expect.equal (DecimalFPx.dfp_absx (DFPx -1 0)) (DFPx 1 0))
        , test "1 0" (\_ -> Expect.equal (DecimalFPx.dfp_absx (DFPx 1 0)) (DFPx 1 0))
        ]


dfp_addTests : Test
dfp_addTests =
    describe "dpf_add"
        [ test "1 + -1" (\_ -> Expect.equal (DecimalFPx.dfp_addx (DFPx 1 0) (DFPx -1 0)) (DFPx 0 0))
        , test "0.009 + 0.001" (\_ -> Expect.equal (DecimalFPx.dfp_addx (DFPx 9 -3) (DFPx 1 -3)) (DFPx 10 -3))
        , test "big + small" (\_ -> Expect.equal (DecimalFPx.dfp_addx (DFPx 21480000009 -8) (DFPx 1 -8)) (DFPx 21480000010 -8))
        ]



dfp_fmtTests : Test
dfp_fmtTests =
    describe "dfp_fmtx"
        [ test "-5 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -5 (DFPx 555 -4)) (DFPFmtx "0.05550" False))
        , test "-4 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -4 (DFPx 555 -4)) (DFPFmtx "0.0555" False))
        , test "-3 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -3 (DFPx 555 -4)) (DFPFmtx "0.056" True))
        , test "-2 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -2 (DFPx 555 -4)) (DFPFmtx "0.06" True))
        , test "-1 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -1 (DFPx 555 -4)) (DFPFmtx "0.1" True))
        , test "0 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 0 (DFPx 555 -4)) (DFPFmtx "0" True))
        , test "-5 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -5 (DFPx 555 -3)) (DFPFmtx "0.55500" False))
        , test "-4 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -4 (DFPx 555 -3)) (DFPFmtx "0.5550" False))
        , test "-3 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -3 (DFPx 555 -3)) (DFPFmtx "0.555" False))
        , test "-2 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -2 (DFPx 555 -3)) (DFPFmtx "0.56" True))
        , test "-1 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -1 (DFPx 555 -3)) (DFPFmtx "0.6" True))
        , test "0 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 0 (DFPx 555 -3)) (DFPFmtx "1" True))
        , test "1 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 1 (DFPx 555 -3)) (DFPFmtx "0" True))
        , test "-5 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -5 (DFPx 555 -2)) (DFPFmtx "5.55000" False))
        , test "-4 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -4 (DFPx 555 -2)) (DFPFmtx "5.5500" False))
        , test "-3 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -3 (DFPx 555 -2)) (DFPFmtx "5.550" False))
        , test "-2 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -2 (DFPx 555 -2)) (DFPFmtx "5.55" False))
        , test "-1 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -1 (DFPx 555 -2)) (DFPFmtx "5.6" True))
        , test "0 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 0 (DFPx 555 -2)) (DFPFmtx "6" True))
        , test "1 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 1 (DFPx 555 -2)) (DFPFmtx "10" True))
        , test "2 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 2 (DFPx 555 -2)) (DFPFmtx "0" True))
        , test "-5 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -5 (DFPx 555 -1)) (DFPFmtx "55.50000" False))
        , test "-4 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -4 (DFPx 555 -1)) (DFPFmtx "55.5000" False))
        , test "-3 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -3 (DFPx 555 -1)) (DFPFmtx "55.500" False))
        , test "-2 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -2 (DFPx 555 -1)) (DFPFmtx "55.50" False))
        , test "-1 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -1 (DFPx 555 -1)) (DFPFmtx "55.5" False))
        , test "0 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 0 (DFPx 555 -1)) (DFPFmtx "56" True))
        , test "1 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 1 (DFPx 555 -1)) (DFPFmtx "60" True))
        , test "2 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 2 (DFPx 555 -1)) (DFPFmtx "100" True))
        , test "3 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 3 (DFPx 555 -1)) (DFPFmtx "0" True))
        , test "-5 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -5 (DFPx 555 0)) (DFPFmtx "555.00000" False))
        , test "-4 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -4 (DFPx 555 0)) (DFPFmtx "555.0000" False))
        , test "-3 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -3 (DFPx 555 0)) (DFPFmtx "555.000" False))
        , test "-2 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -2 (DFPx 555 0)) (DFPFmtx "555.00" False))
        , test "-1 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -1 (DFPx 555 0)) (DFPFmtx "555.0" False))
        , test "0 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 0 (DFPx 555 0)) (DFPFmtx "555" False))
        , test "1 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 1 (DFPx 555 0)) (DFPFmtx "560" True))
        , test "2 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 2 (DFPx 555 0)) (DFPFmtx "600" True))
        , test "3 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 3 (DFPx 555 0)) (DFPFmtx "1000" True))
        , test "4 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 4 (DFPx 555 0)) (DFPFmtx "0" True))
        , test "-5 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -5 (DFPx 555 1)) (DFPFmtx "5550.00000" False))
        , test "-4 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -4 (DFPx 555 1)) (DFPFmtx "5550.0000" False))
        , test "-3 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -3 (DFPx 555 1)) (DFPFmtx "5550.000" False))
        , test "-2 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -2 (DFPx 555 1)) (DFPFmtx "5550.00" False))
        , test "-1 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -1 (DFPx 555 1)) (DFPFmtx "5550.0" False))
        , test "0 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 0 (DFPx 555 1)) (DFPFmtx "5550" False))
        , test "1 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 1 (DFPx 555 1)) (DFPFmtx "5550" False))
        , test "2 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 2 (DFPx 555 1)) (DFPFmtx "5600" True))
        , test "3 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 3 (DFPx 555 1)) (DFPFmtx "6000" True))
        , test "4 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 4 (DFPx 555 1)) (DFPFmtx "10000" True))
        , test "5 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx 5 (DFPx 555 1)) (DFPFmtx "0" True))

        , test "-8 214.80000009" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -8 (DFPx 21480000009 -8)) (DFPFmtx "214.80000009" False))
        , test "-7 214.80000009" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -7 (DFPx 21480000009 -8)) (DFPFmtx "214.8000001" True))
        , test "-8 9013.50573940" (\_ -> Expect.equal (DecimalFPx.dfp_fmtx -8 (DFPx 901350573940 -8)) (DFPFmtx "9013.50573940" False))

        ]


roundTests : Test
roundTests =
    describe "round"
        [ test "-5 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -5 (DFPx 555 -4)) (DFPx 555 -4))
        , test "-4 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -4 (DFPx 555 -4)) (DFPx 555 -4))
        , test "-3 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -3 (DFPx 555 -4)) (DFPx 56 -3))
        , test "-2 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -2 (DFPx 555 -4)) (DFPx 6 -2))
        , test "-1 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -1 (DFPx 555 -4)) (DFPx 1 -1))
        , test "0 555 -4" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 0 (DFPx 555 -4)) (DFPx 0 0))
        , test "-4 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -4 (DFPx 555 -3)) (DFPx 555 -3))
        , test "-3 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -3 (DFPx 555 -3)) (DFPx 555 -3))
        , test "-2 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -2 (DFPx 555 -3)) (DFPx 56 -2))
        , test "-1 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -1 (DFPx 555 -3)) (DFPx 6 -1))
        , test "0 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 0 (DFPx 555 -3)) (DFPx 1 0))
        , test "1 555 -3" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 1 (DFPx 555 -3)) (DFPx 0 1))
        , test "-3 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -3 (DFPx 555 -2)) (DFPx 555 -2))
        , test "-2 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -2 (DFPx 555 -2)) (DFPx 555 -2))
        , test "-1 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -1 (DFPx 555 -2)) (DFPx 56 -1))
        , test "0 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 0 (DFPx 555 -2)) (DFPx 6 0))
        , test "1 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 1 (DFPx 555 -2)) (DFPx 1 1))
        , test "2 555 -2" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 2 (DFPx 555 -2)) (DFPx 0 2))
        , test "-2 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -2 (DFPx 555 -1)) (DFPx 555 -1))
        , test "-1 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -1 (DFPx 555 -1)) (DFPx 555 -1))
        , test "0 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 0 (DFPx 555 -1)) (DFPx 56 0))
        , test "1 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 1 (DFPx 555 -1)) (DFPx 6 1))
        , test "2 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 2 (DFPx 555 -1)) (DFPx 1 2))
        , test "3 555 -1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 3 (DFPx 555 -1)) (DFPx 0 3))
        , test "-1 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_roundx -1 (DFPx 555 0)) (DFPx 555 0))
        , test "0 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 0 (DFPx 555 0)) (DFPx 555 0))
        , test "1 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 1 (DFPx 555 0)) (DFPx 56 1))
        , test "2 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 2 (DFPx 555 0)) (DFPx 6 2))
        , test "3 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 3 (DFPx 555 0)) (DFPx 1 3))
        , test "4 555 0" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 4 (DFPx 555 0)) (DFPx 0 4))
        , test "0 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 0 (DFPx 555 1)) (DFPx 555 1))
        , test "1 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 1 (DFPx 555 1)) (DFPx 555 1))
        , test "2 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 2 (DFPx 555 1)) (DFPx 56 2))
        , test "3 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 3 (DFPx 555 1)) (DFPx 6 3))
        , test "4 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 4 (DFPx 555 1)) (DFPx 1 4))
        , test "5 555 1" (\_ -> Expect.equal (DecimalFPx.dfp_roundx 5 (DFPx 555 1)) (DFPx 0 5))
        ]
