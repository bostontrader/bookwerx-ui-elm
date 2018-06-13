module RoutingTest exposing (routingTests)

import Expect exposing (Expectation)
import Navigation exposing (Location)
import Test exposing (Test, describe, test)

import Routing exposing (extractRoute)
import Types exposing
    ( Route
        ( CurrenciesAdd
        , CurrenciesEdit
        , CurrenciesIndex
        , NotFound
        )
    )

routingTests : Test
routingTests =
    describe "Routing tests"
        [ test "CurrenciesAdd" <|
            \_ -> Expect.equal (extractRoute (Location "" "" "" "" "" "" "currencies/add" "" "" "" "")) CurrenciesAdd
        , test "CurrenciesEdit" <|
            \_ -> Expect.equal (extractRoute (Location "" "" "" "" "" "" "currencies/5" "" "" "" "")) (CurrenciesEdit 5)
        , test "CurrenciesIndex" <|
            \_ -> Expect.equal (extractRoute (Location "" "" "" "" "" "" "currencies" "" "" "" "")) CurrenciesIndex
        , test "NotFound" <|
            \_ -> Expect.equal (extractRoute (Location "" "" "" "" "" "" "catfood" "" "" "" "")) NotFound
        ]