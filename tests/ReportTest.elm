module ReportTest exposing (..)

import Account.Account exposing (Account, AccountJoined)
import Account.Model
import Currency.Currency exposing (CurrencyShort)
import DecimalFP exposing (DFP)
import Dict exposing (Dict)
import Distribution.Distribution exposing (DistributionReport)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import IntField exposing (IntField(..))
import RemoteData exposing (WebData)
import Report.Report exposing (AccountSummary)
import Report.Transform exposing (xform1, xform2, xform2a, xform3)
import Test exposing (..)


xform1Tests : Test
xform1Tests =
    let
        -- account_id, amount, amount_exp, date
        dr1 =
            DistributionReport 0 0 0 "2018"

        dr2 =
            DistributionReport 0 0 0 "2019"

        dr3 =
            DistributionReport 0 0 0 "2020"

        drs =
            [ dr1, dr2, dr3 ]
    in
    describe "xform1"
        [ test "a" (\_ -> Expect.equal (xform1 "" "" []) [])
        , test "b" (\_ -> Expect.equal (xform1 "" "2019" drs) [ dr1, dr2 ])
        , test "c" (\_ -> Expect.equal (xform1 "2019" "2019" drs) [ dr2 ])
        ]


xform2Tests : Test
xform2Tests =
    let
        -- account_id, amount, amount_exp, date
        dr1 =
            DistributionReport 1 10 0 "2019"

        dr2 =
            DistributionReport 2 20 0 "2019"

        dr3 =
            DistributionReport 2 30 -1 "2019"
    in
    describe "xform2"
        [ test "a" (\_ -> Expect.equal (xform2 []) Dict.empty)
        , test "b" (\_ -> Expect.equal (xform2 [ dr1 ]) (Dict.fromList [ ( 1, DFP 10 0 ) ]))
        , test "c"
            (\_ ->
                Expect.equal (xform2 [ dr1, dr2 ])
                    (Dict.fromList
                        [ ( 1, DFP 10 0 )
                        , ( 2, DFP 20 0 )
                        ]
                    )
            )
        , test "d"
            (\_ ->
                Expect.equal (xform2 [ dr1, dr2, dr3 ])
                    (Dict.fromList
                        [ ( 1, DFP 10 0 )
                        , ( 2, DFP 230 -1 )
                        ]
                    )
            )
        ]


xform2aTests : Test
xform2aTests =
    let
        testData =
            Dict.fromList
                [ ( 1, DFP 10 0 )
                , ( 2, DFP 0 0 )
                ]

        result =
            Dict.fromList
                [ ( 1, DFP 10 0 ) ]
    in
    describe "xform2a"
        [ test "a" (\_ -> Expect.equal (xform2a False testData) testData) -- Don't omit zeros
        , test "b" (\_ -> Expect.equal (xform2a True testData) result) -- Do omit zeros
        ]


xform3Tests : Test
xform3Tests =
    let
        -- account_id, apikey, categories, currency, rarity, title
        aj1 =
            AccountJoined 1 "" [] (CurrencyShort "CNY" "Chinese Yuan") (IntField (Just 0) "0") "Cash"

        aj2 =
            AccountJoined 2 "" [] (CurrencyShort "RUB" "Russian Ruble") (IntField (Just 0) "0") "Hookers 'n' blow"

        aj3 =
            AccountJoined 3 "" [] (CurrencyShort "RUB" "Russian Ruble") (IntField (Just 0) "0") "Hitman"

        aj4 =
            AccountJoined 4 "" [] (CurrencyShort "QLO" "Quatloo") (IntField (Just 0) "0") "Gambling"

        accounts_model =
            { accounts = [ aj1, aj2, aj3, aj4 ]
            , wdAccounts = RemoteData.NotAsked
            , wdAccount = RemoteData.NotAsked
            , editBuffer = Account -1 "" -1 (IntField (Just 0) "0") "" -- empty account
            , decimalPlaces = 2
            , rarityFilter = IntField (Just 10) "10"
            , distributionJoineds = []
            , wdDistributionJoineds = RemoteData.NotAsked
            }

        d1 =
            Dict.empty

        d2 =
            Dict.fromList [ ( 1, DFP 10 0 ) ]

        d3 =
            Dict.fromList
                [ ( 1, DFP 10 0 )
                , ( 2, DFP 20 0 )
                ]

        d4 =
            Dict.fromList
                [ ( 1, DFP 10 0 )
                , ( 2, DFP 20 0 )
                , ( 3, DFP 30 0 )
                ]
    in
    describe "xform3"
        [ test "a" (\_ -> Expect.equal (xform3 d1 accounts_model) Dict.empty)
        , test "b" (\_ -> Expect.equal (xform3 d2 accounts_model) (Dict.fromList [ ( "CNY", [ AccountSummary 1 (DFP 10 0) ] ) ]))
        , test "c"
            (\_ ->
                Expect.equal (xform3 d3 accounts_model)
                    (Dict.fromList
                        [ ( "CNY", [ AccountSummary 1 (DFP 10 0) ] )
                        , ( "RUB", [ AccountSummary 2 (DFP 20 0) ] )
                        ]
                    )
            )
        , test "d"
            (\_ ->
                Expect.equal (xform3 d4 accounts_model)
                    (Dict.fromList
                        [ ( "CNY", [ AccountSummary 1 (DFP 10 0) ] )
                        , ( "RUB"
                          , [ AccountSummary 2 (DFP 20 0)
                            , AccountSummary 3 (DFP 30 0)
                            ]
                          )
                        ]
                    )
            )
        ]
