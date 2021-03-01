{- Crypto currencies frequently use numbers with uncommonly high precision. Said precision defies our ability to use ordinary
   Ints or Floats for a variety of reasons.  Please see https://gist.github.com/bostontrader/37ad3aba39d77e6f8a4e8212c02b25aa for
   discussion of this.

So therefore this module implements a Decimal Floating Point (DFP) type.  A DFP is a type composed of two integers, a significand and an exponent. Using this format we can readily represent the _exact_ amounts that we find in financial transactions, with arbitrary precision, using a method similar to scientific notation, w/o rounding error. Please see https://en.wikipedia.org/wiki/Decimal_floating_point for more info.

Not only must we represent DFP but we must be able to perform a handful of useful operations on them such as adding, rounding, and string formatting.  This is a small subset of possible operations that can be imagined, but it's enough for this application.

We implement the DFP significand using a List of Int.  Each list entry represents one digit of the significand, and said
digits are arranged from the least significant to most significant digit order.  Some of the low-level functions have
a parameterized number base, but some of the higher-level functions are hardwired for base 10.

Given base 10, all of the digits should be restricted to being _only_ 0 - 9 inclusive.  Any function documentation that
accepts a List of Int should included these constraints by reference.

This module exposes several functions.  Functions that start with "dfp" are for actual use by the application.  There
are also a variety of "md" (multi-digit) functions that are also exposed.  These functions are used to implement the
"dfp" functions and are very narrowly designed to do just that.  They are not generally useful in their own right
but are exposed so that we may test them.

One nettlesome aspect of this software involves the anality level of doing this the "Elm" way.  For example,
a List of Int is not easily restricted to Ints of only 0 - 9.  So we might be tempted to make a List of Digit where
Digit is a Union Type of ZERO | ONE | ... | NINE.  Doing this causes other tedious woes elsewhere and it's easier
to just make sure we never use Ints other than 0 - 9.

Another issue in this department comes from parameter errors.  There are a variety of nonsensical parameters
that we might torment our functions with.  How shall we communicate does-not-compute back to the caller?
The Elm way is to use Maybes.  However, doing so introduces numerous tedious issues in dealing with Maybes.  Instead,
we use a variety of ad-hoc return values that "seem sensible" in the given circumstances.  All of our tests pass
and this problem is most prevalent in the "md" and other functions that are simply not intended for public use,
so this is an issue of minimal consequence.  Again, feel free to Maybeize this if you're feeling too unclean doing
it our way.

-}


module DecimalFP exposing (DFP, DFPFmt, Sign(..), md_add, md_compare, md_sub, dfp_add, dfp_abs, dfp_neg, dfp_norm, dnc, stripZ)


type Sign
    = Positive
    | Negative
    | Zero

type alias DFP =
    { amount : List Int
    , exp : Int
    , sign : Sign
    }

{- A string representing a DFP, with a decimal point, for UI purposes.  This is produced by dfp_fmt with some
specific decimal precision specified.  This may be rounded and the UI may want to know that there
exists a loss of precision due to rounding.
-}
type alias DFPFmt =
    { s : String
    , r : Bool -- True = loss of precision due to rounding.
    }


{- Given a DFP return its absolute value -}
dfp_abs : DFP -> DFP
dfp_abs n =

    if n.sign == Negative then
        DFP n.amount n.exp Positive
    else
        n


{- Given two DFP, add them and return their sum. -}
dfp_add : DFP -> DFP -> DFP
dfp_add dfp1 dfp2 =

    let
        -- normalize to identical exponents
        (n1, n2) = dfp_norm dfp1 dfp2
    in

    -- there are 9 permutations of Positive, Negative, and Zero.  But this simplifies to:
    case (n1.sign, n2.sign) of
        -- +a + +b is easy, just add them via md_addition
        (Positive, Positive) ->
            DFP (md_add n1.amount n2.amount 0 10) n1.exp Positive -- both exponents are the same

        -- +a + -b = subtract abs(b) from a via md_subtraction
        (Positive, Negative) ->
            let
                cmp = md_compare n1.amount n2.amount
            in
            if cmp == -1 then -- abs(a) < abs(b)
                let
                    diff = md_sub n2.amount n1.amount
                in
                case diff of
                    Just d ->
                        DFP d n1.exp Negative -- both exponents are the same
                    Nothing ->
                        DFP [] 0 Zero
            else if cmp == 0 then
                DFP [] 0 Zero
            else -- abs(a) > abs(b)
                --just do the subtraction and return positive
                let
                    diff = md_sub n1.amount n2.amount
                in
                case diff of
                    Just d ->
                        DFP d n1.exp Positive -- both exponents are the same
                    Nothing ->
                        DFP [] 0 Zero

        -- -a + +b = subtract abs(a) from b via md_subtraction
        (Negative, Positive) ->
            let
                cmp = md_compare n1.amount n2.amount
            in
            if cmp == -1 then -- abs(a) < abs(b)
                let
                    diff = md_sub n2.amount n1.amount
                in
                case diff of
                    Just d ->
                        DFP d n1.exp Positive -- both exponents are the same
                    Nothing ->
                        DFP [] 0 Zero
            else if cmp == 0 then
                DFP [] 0 Zero
            else -- abs(a) > abs(b)
                --just do the subtraction and return positive
                let
                    diff = md_sub n1.amount n2.amount
                in
                case diff of
                    Just d ->
                        DFP d n1.exp Negative -- both exponents are the same
                    Nothing ->
                        DFP [] 0 Zero

        -- -a + -a is easy, neg(neg a + neg b)  example: -5 + -6 = -11
        (Negative, Negative) ->
            let
                sum = md_add n1.amount n2.amount 0 10
            in
            DFP sum n1.exp Negative -- both exponents are the same


        (Zero, _) ->
            n2

        (_, Zero) ->
            n1


{- Given a DFP reverse the sign. -}
dfp_neg : DFP -> DFP
dfp_neg n =

    if n.sign == Negative then
        DFP n.amount n.exp Positive
    else if n.sign == Positive then
        DFP n.amount n.exp Negative
    else
        n


{- Suppose you want to add 1 + 0.1.  As DFP they'd be represented as [1] 0 Positive and [1] -1 Positive.  In
order to perform the addition we'll first have to change [1] 0 to [0, 1] -1.  This is still the same number
but now the exponents of both DFP match and we can simply add the digits normally.

This function takes two DFP n1, and n2.  If the exponents are the same it merely
returns (n1, n2).  But if the exponents are different, it adjusts the amount and exponent of the DFP with the
higher exponent by successively appending a 0 as a LSD and decrementing the exponent until the exponent matches
the other DFP.  This function then returns (new n1, new n2).
-}
dfp_norm : DFP -> DFP -> (DFP, DFP)
dfp_norm n1 n2 =

    if n1.exp == n2.exp then
        (n1, n2)
    else if n1.exp > n2.exp then
        (DFP (0 :: n1.amount) (n1.exp - 1) n1.sign, n2)
    else -- n1.exp < n2.exp
        (n1, DFP (0 :: n2.amount) (n2.exp - 1) n2.sign)


{- Given two integers of a given base, and a prior carry (or zero if none) calculate their sum modulo base and return (sum, carry)
-}
dnc : Int -> Int -> Int -> Int -> (Int, Int)
dnc i1 i2 carry base =
    let
        sm = i1 + i2 + carry
    in
        (modBy base sm, sm // base)


{- Given two lists of Int, a carry, and a number base, perform a multi-digit addition of them and return
the resulting sum.

The initial carry should be zero, but each subsequent digit may have a carry.
-}
md_add: List Int -> List Int -> Int -> Int -> List Int
md_add l1 l2 carry base =

    case (l1, l2) of
        ([], []) ->
            if carry == 0 then
                []
            else
                [carry]
        ([], [_]) ->
            if carry == 0 then
                l2
            else
                md_add [carry] l2 0 base


        ([], _::_) ->
            if carry == 0 then
                l2
            else
                md_add [carry] l2 0 base

        ([_], []) ->
            if carry == 0 then
                l1
            else
                md_add l1 [carry] 0 base

        ([x1], [x2]) -> -- add these
            let
                (d, c1) = dnc x1 x2 carry base
            in
                if c1 == 0 then
                    [d]
                else
                    [d, c1]

        ([x1], x2::xs2) -> -- add these
            let
                (d, c1) = dnc x1 x2 carry base
            in
                d :: md_add [] xs2 c1 base

        (_::_, []) ->
            if carry == 0 then
                l1

            else
                md_add [carry] l1 0 base

        (x1::xs1, [x2]) -> -- add these
            let
                (d, c1) = dnc x1 x2 carry base
            in
                d :: md_add xs1 [] c1 base

        (x1::xs1, x2::xs2) -> -- add these
            let
                (d, c1) = dnc x1 x2 carry base
            in
                d :: md_add xs1 xs2 c1 base


{- Give two List of Int, A and B, determine if A < B, A == B, or A > B.
Return -1, 0, or 1 to indicate.

This is the public entry point where obvious cases such as different list lengths are dealt with.
-}
md_compare : List Int -> List Int -> Int
md_compare listA listB =
    let
        lna = List.length listA
        lnb = List.length listB
    in
    if lna < lnb then
        -1
    else if lna > lnb then
        1
    else
        md_compare1 listA listB

{- Give two List of Int, A and B, determine if A < B, A == B, or A > B.
Return -1, 0, or 1 to indicate.

This is a private method that recursively deals with lists of the same length.
-}
md_compare1 : List Int -> List Int -> Int
md_compare1 listA listB =
    let
        listAr = List.reverse listA
        listBr = List.reverse listB
    in
    case (listAr, listBr) of
        ([],[]) ->
            0
        ([a],[b]) ->
            if a < b then
                -1
            else if a > b then
                1
            else
                0

        (a::at, b::bt) ->
            if a < b then
                -1
            else if a > b then
                1
            else
                md_compare (List.reverse at)  (List.reverse bt )

        (_, _) -> -- this should never happen
            666


{- Given two lists of Int, top and bottom,  perform a multi-digit subtraction of bottom from top and return
Maybe (the resulting value).  This is a Maybe because parameter errors are possible.

This is the public entry point where obvious cases are dealt with.

This function uses the "Three Digit Trick" (http://web.sonoma.edu/users/w/wilsonst/courses/math_300/groupwork/altsub/3d.html)
generalized for lists of digits of indefinite length.

The advantage of this method is that we don't have to deal with regrouping.  The disadvantage is that there are
many gyrations required to get this done.  Complicated to understand and probably not good for running time.

This function is a very special purpose thing that exists solely to support dfp_add.  dfp_add needs subtraction
in order to deal with negative DFP numbers.  As such, this function only cares about doing that.  It has the following
rather tedious constraints:

* top and bottom are both arrays of "small" positive integers from 0 to base-1 inclusive and have not been tested
with "large" or negative integers.

* the top and bottom arrays both represent positive numbers.  In the event of the necessity of subtraction of a negative
number, re-arrange the problem using negation such that this constraint can hold.

* top >= bottom

-}
md_sub: List Int -> List Int -> Maybe (List Int)
md_sub top bottom =
    let
        zzTop = stripZ top
        zzBot = stripZ bottom
    in
    case (zzTop, zzBot) of
        ([], []) ->
            Just []
        ([], [_]) ->
            Nothing
        ([], _::_) ->
            Nothing
        ([_], []) ->
            Just zzTop
        ([x], [y]) ->
            Just [ x - y ]
        ([_], _::_) ->
            Nothing
        (_::_, []) ->
            Just zzTop
        (_::_, [_]) ->
            Just (stripZ (md_sub1 top bottom))
        (_::_, _::_) ->
            Just (stripZ (md_sub1 top bottom))

{- Given two lists of Int, top and bottom,  perform a multi-digit subtraction of bottom from top and return
a List of Int containing the resulting value.

This is a private method that recursively performs the actual subtraction for md_sub which is
responsible for any error checking.
-}
md_sub1: List Int -> List Int -> List Int
md_sub1 top bottom =
    let
        n1 = List.map (\d -> 9 - d) bottom
        n2 = md_add top n1 0 10
        n3 = List.reverse n2
        n4 = case n3 of  -- subtract 1000
            [] ->
                []
            [x] ->
                [x - 1]
            x::xs ->
                [x - 1] ++ xs

        n5 = List.reverse n4
        n6 = case n5 of
            [] ->
                []
            _ ->
                md_add n5 [1] 0 10

    in
    n6


{- Given a List of Int, starting at the tail (the msb)
successively and recursively remove all zeros, if any, and return the resulting trimmed list.
-}
stripZ : List Int -> List Int
stripZ lsti =
    case List.reverse lsti of
        [] ->
            []
        [x] ->
            if x == 0 then
                []
            else
                [x]
        x::xs ->
            if x == 0 then
                stripZ (List.reverse xs)
            else
                lsti

