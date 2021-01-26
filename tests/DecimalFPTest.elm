module DecimalFPTest exposing (..)

import DecimalFP exposing (DFP, DFPFmt)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


dfp_absTests : Test
dfp_absTests =
    describe "dfp_abs"
        [ test "-1 0" (\_ -> Expect.equal (DecimalFP.dfp_abs (DFP -1 0)) (DFP 1 0))
        , test "1 0" (\_ -> Expect.equal (DecimalFP.dfp_abs (DFP 1 0)) (DFP 1 0))
        ]


dfp_addTests : Test
dfp_addTests =
    describe "dpf_add"
        [ test "1 + -1" (\_ -> Expect.equal (DecimalFP.dfp_add (DFP 1 0) (DFP -1 0)) (DFP 0 0))
        , test "0.009 + 0.001" (\_ -> Expect.equal (DecimalFP.dfp_add (DFP 9 -3) (DFP 1 -3)) (DFP 10 -3))
        , test "big + small" (\_ -> Expect.equal (DecimalFP.dfp_add (DFP 21480000009 -8) (DFP 1 -8)) (DFP 21480000010 -8))
        ]



dfp_fmtTests : Test
dfp_fmtTests =
    describe "dfp_fmt"
        [ test "-5 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_fmt -5 (DFP 555 -4)) (DFPFmt "0.05550" False))
        , test "-4 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_fmt -4 (DFP 555 -4)) (DFPFmt "0.0555" False))
        , test "-3 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_fmt -3 (DFP 555 -4)) (DFPFmt "0.056" True))
        , test "-2 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_fmt -2 (DFP 555 -4)) (DFPFmt "0.06" True))
        , test "-1 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_fmt -1 (DFP 555 -4)) (DFPFmt "0.1" True))
        , test "0 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_fmt 0 (DFP 555 -4)) (DFPFmt "0" True))
        , test "-5 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt -5 (DFP 555 -3)) (DFPFmt "0.55500" False))
        , test "-4 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt -4 (DFP 555 -3)) (DFPFmt "0.5550" False))
        , test "-3 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt -3 (DFP 555 -3)) (DFPFmt "0.555" False))
        , test "-2 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt -2 (DFP 555 -3)) (DFPFmt "0.56" True))
        , test "-1 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt -1 (DFP 555 -3)) (DFPFmt "0.6" True))
        , test "0 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt 0 (DFP 555 -3)) (DFPFmt "1" True))
        , test "1 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_fmt 1 (DFP 555 -3)) (DFPFmt "0" True))
        , test "-5 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt -5 (DFP 555 -2)) (DFPFmt "5.55000" False))
        , test "-4 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt -4 (DFP 555 -2)) (DFPFmt "5.5500" False))
        , test "-3 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt -3 (DFP 555 -2)) (DFPFmt "5.550" False))
        , test "-2 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt -2 (DFP 555 -2)) (DFPFmt "5.55" False))
        , test "-1 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt -1 (DFP 555 -2)) (DFPFmt "5.6" True))
        , test "0 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt 0 (DFP 555 -2)) (DFPFmt "6" True))
        , test "1 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt 1 (DFP 555 -2)) (DFPFmt "10" True))
        , test "2 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_fmt 2 (DFP 555 -2)) (DFPFmt "0" True))
        , test "-5 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -5 (DFP 555 -1)) (DFPFmt "55.50000" False))
        , test "-4 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -4 (DFP 555 -1)) (DFPFmt "55.5000" False))
        , test "-3 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -3 (DFP 555 -1)) (DFPFmt "55.500" False))
        , test "-2 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -2 (DFP 555 -1)) (DFPFmt "55.50" False))
        , test "-1 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -1 (DFP 555 -1)) (DFPFmt "55.5" False))
        , test "0 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 0 (DFP 555 -1)) (DFPFmt "56" True))
        , test "1 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 1 (DFP 555 -1)) (DFPFmt "60" True))
        , test "2 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 2 (DFP 555 -1)) (DFPFmt "100" True))
        , test "3 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 3 (DFP 555 -1)) (DFPFmt "0" True))
        , test "-5 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt -5 (DFP 555 0)) (DFPFmt "555.00000" False))
        , test "-4 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt -4 (DFP 555 0)) (DFPFmt "555.0000" False))
        , test "-3 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt -3 (DFP 555 0)) (DFPFmt "555.000" False))
        , test "-2 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt -2 (DFP 555 0)) (DFPFmt "555.00" False))
        , test "-1 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt -1 (DFP 555 0)) (DFPFmt "555.0" False))
        , test "0 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt 0 (DFP 555 0)) (DFPFmt "555" False))
        , test "1 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt 1 (DFP 555 0)) (DFPFmt "560" True))
        , test "2 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt 2 (DFP 555 0)) (DFPFmt "600" True))
        , test "3 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt 3 (DFP 555 0)) (DFPFmt "1000" True))
        , test "4 555 0" (\_ -> Expect.equal (DecimalFP.dfp_fmt 4 (DFP 555 0)) (DFPFmt "0" True))
        , test "-5 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -5 (DFP 555 1)) (DFPFmt "5550.00000" False))
        , test "-4 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -4 (DFP 555 1)) (DFPFmt "5550.0000" False))
        , test "-3 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -3 (DFP 555 1)) (DFPFmt "5550.000" False))
        , test "-2 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -2 (DFP 555 1)) (DFPFmt "5550.00" False))
        , test "-1 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt -1 (DFP 555 1)) (DFPFmt "5550.0" False))
        , test "0 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 0 (DFP 555 1)) (DFPFmt "5550" False))
        , test "1 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 1 (DFP 555 1)) (DFPFmt "5550" False))
        , test "2 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 2 (DFP 555 1)) (DFPFmt "5600" True))
        , test "3 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 3 (DFP 555 1)) (DFPFmt "6000" True))
        , test "4 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 4 (DFP 555 1)) (DFPFmt "10000" True))
        , test "5 555 1" (\_ -> Expect.equal (DecimalFP.dfp_fmt 5 (DFP 555 1)) (DFPFmt "0" True))

        , test "-8 214.80000009" (\_ -> Expect.equal (DecimalFP.dfp_fmt -8 (DFP 21480000009 -8)) (DFPFmt "214.80000009" False))
        , test "-7 214.80000009" (\_ -> Expect.equal (DecimalFP.dfp_fmt -7 (DFP 21480000009 -8)) (DFPFmt "214.8000001" True))
        , test "-8 9013.50573940" (\_ -> Expect.equal (DecimalFP.dfp_fmt -8 (DFP 901350573940 -8)) (DFPFmt "9013.50573940" False))

        ]


roundTests : Test
roundTests =
    describe "round"
        [ test "-5 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_round -5 (DFP 555 -4)) (DFP 555 -4))
        , test "-4 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_round -4 (DFP 555 -4)) (DFP 555 -4))
        , test "-3 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_round -3 (DFP 555 -4)) (DFP 56 -3))
        , test "-2 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_round -2 (DFP 555 -4)) (DFP 6 -2))
        , test "-1 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_round -1 (DFP 555 -4)) (DFP 1 -1))
        , test "0 555 -4" (\_ -> Expect.equal (DecimalFP.dfp_round 0 (DFP 555 -4)) (DFP 0 0))
        , test "-4 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_round -4 (DFP 555 -3)) (DFP 555 -3))
        , test "-3 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_round -3 (DFP 555 -3)) (DFP 555 -3))
        , test "-2 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_round -2 (DFP 555 -3)) (DFP 56 -2))
        , test "-1 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_round -1 (DFP 555 -3)) (DFP 6 -1))
        , test "0 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_round 0 (DFP 555 -3)) (DFP 1 0))
        , test "1 555 -3" (\_ -> Expect.equal (DecimalFP.dfp_round 1 (DFP 555 -3)) (DFP 0 1))
        , test "-3 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_round -3 (DFP 555 -2)) (DFP 555 -2))
        , test "-2 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_round -2 (DFP 555 -2)) (DFP 555 -2))
        , test "-1 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_round -1 (DFP 555 -2)) (DFP 56 -1))
        , test "0 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_round 0 (DFP 555 -2)) (DFP 6 0))
        , test "1 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_round 1 (DFP 555 -2)) (DFP 1 1))
        , test "2 555 -2" (\_ -> Expect.equal (DecimalFP.dfp_round 2 (DFP 555 -2)) (DFP 0 2))
        , test "-2 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_round -2 (DFP 555 -1)) (DFP 555 -1))
        , test "-1 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_round -1 (DFP 555 -1)) (DFP 555 -1))
        , test "0 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_round 0 (DFP 555 -1)) (DFP 56 0))
        , test "1 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_round 1 (DFP 555 -1)) (DFP 6 1))
        , test "2 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_round 2 (DFP 555 -1)) (DFP 1 2))
        , test "3 555 -1" (\_ -> Expect.equal (DecimalFP.dfp_round 3 (DFP 555 -1)) (DFP 0 3))
        , test "-1 555 0" (\_ -> Expect.equal (DecimalFP.dfp_round -1 (DFP 555 0)) (DFP 555 0))
        , test "0 555 0" (\_ -> Expect.equal (DecimalFP.dfp_round 0 (DFP 555 0)) (DFP 555 0))
        , test "1 555 0" (\_ -> Expect.equal (DecimalFP.dfp_round 1 (DFP 555 0)) (DFP 56 1))
        , test "2 555 0" (\_ -> Expect.equal (DecimalFP.dfp_round 2 (DFP 555 0)) (DFP 6 2))
        , test "3 555 0" (\_ -> Expect.equal (DecimalFP.dfp_round 3 (DFP 555 0)) (DFP 1 3))
        , test "4 555 0" (\_ -> Expect.equal (DecimalFP.dfp_round 4 (DFP 555 0)) (DFP 0 4))
        , test "0 555 1" (\_ -> Expect.equal (DecimalFP.dfp_round 0 (DFP 555 1)) (DFP 555 1))
        , test "1 555 1" (\_ -> Expect.equal (DecimalFP.dfp_round 1 (DFP 555 1)) (DFP 555 1))
        , test "2 555 1" (\_ -> Expect.equal (DecimalFP.dfp_round 2 (DFP 555 1)) (DFP 56 2))
        , test "3 555 1" (\_ -> Expect.equal (DecimalFP.dfp_round 3 (DFP 555 1)) (DFP 6 3))
        , test "4 555 1" (\_ -> Expect.equal (DecimalFP.dfp_round 4 (DFP 555 1)) (DFP 1 4))
        , test "5 555 1" (\_ -> Expect.equal (DecimalFP.dfp_round 5 (DFP 555 1)) (DFP 0 5))
        ]
