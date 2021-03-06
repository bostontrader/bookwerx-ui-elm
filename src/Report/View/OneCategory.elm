module Report.View.OneCategory exposing (viewOneCategory)

import DecimalFP exposing (DFP, Sign(..))
import Dict exposing (Dict)
import Html exposing (Html, div, h3, p, table, tbody, td, text, tfoot, th, thead, tr)
import Html.Attributes exposing (class, style)
import Msg exposing (Msg(..))
import RemoteData exposing (WebData)
import Report.Model
import Report.Report exposing (BalanceResultDecorated, SumsDecorated)
import Translate exposing (Language, tx)
import Types exposing (DRCRFormat(..))
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (dvColumnHeader, viewDFP)


viewOneCategory : Report.Model.Model -> WebData String -> SumsDecorated -> Maybe String -> Language -> Html Msg
viewOneCategory model webdata sumsDecorated title language =
    div [ class "oneCategory" ]
        (case webdata of
            RemoteData.Success _ ->
                if List.isEmpty sumsDecorated.sums then
                    --[ h3 []
                    --[ text
                    --(tx language
                    --{ e = "No data found for this report"
                    --, c = "找不到此报告的数据"
                    --, p = "Zhǎo bù dào cǐ bàogào de shùjù"
                    --}
                    --)
                    --]
                    --]
                    let
                        nodata =
                            [ p [ class "is-size-6", style "margin-bottom" "1em" ]
                                [ text
                                    (tx language
                                        { e = "No data found for this report"
                                        , c = "找不到此报告的数据"
                                        , p = "Zhǎo bù dào cǐ bàogào de shùjù"
                                        }
                                    )
                                ]
                            ]
                    in
                    case title of
                        Just t ->
                            p [ class "is-size-4" ] [ text t ] :: nodata

                        Nothing ->
                            nodata

                else
                    -- Take the JSON decoded response from the server, group all accounts with the same currency together using a Dict, and then viewCurrencySection for each different currency.  Append a title if given.
                    let
                        cs =
                            dictByCurrency sumsDecorated.sums
                                |> Dict.values
                                |> List.map (\lbrd -> viewCurrencySection lbrd model title language)
                    in
                    case title of
                        Just t ->
                            p [ class "is-size-4" ] [ text t ] :: cs

                        Nothing ->
                            cs

            _ ->
                [ h3 [] [ text (getRemoteDataStatusMessage webdata language) ] ]
        )



-- Take all BalanceResultDecorated found in SumsDecorated and split them into individual groups by currency.


dictByCurrency : List BalanceResultDecorated -> Dict String (List BalanceResultDecorated)
dictByCurrency input =
    List.foldl
        combiner
        Dict.empty
        input


combiner : BalanceResultDecorated -> Dict String (List BalanceResultDecorated) -> Dict String (List BalanceResultDecorated)
combiner brd dict =
    case Dict.get brd.account.currency.symbol dict of
        Just x ->
            -- x is a List BalanceResultDecorated
            -- Add this BalanceResult to an existing currency. Doing this replaces the existing value.
            Dict.insert brd.account.currency.symbol (brd :: x) dict

        Nothing ->
            -- add a new account with an initial balance
            Dict.insert brd.account.currency.symbol [ brd ] dict


viewAccount : BalanceResultDecorated -> Int -> Html Msg
viewAccount brd decimalPlaces =
    tr []
        ([ td [] [ text (String.fromInt brd.account.account_id) ]
         , td [] [ text brd.account.title ]
         ]
            --++ viewDFP brd.sum decimalPlaces DRCR
            ++ viewDFP (DFP [] 0 Zero) decimalPlaces DRCR
        )



--calcSum : List BalanceResultDecorated -> DFPx
--calcSum list =
--List.foldl
--(\a b -> dfp_addx a.sum b)
--(DFPx 0 0)
--list
-- Given a List BalanceResultDecorated containing the balances of accounts all of the same currency


viewCurrencySection : List BalanceResultDecorated -> Report.Model.Model -> Maybe String -> Language -> Html Msg
viewCurrencySection lbrd model _ language =
    let
        symbol =
            case lbrd of
                -- Because of how it was built, lbrd should always have at least one item so this case should never be invoked. But try tellin' that to Elm!
                [] ->
                    "???"

                [ x ] ->
                    x.account.currency.symbol

                x :: _ ->
                    x.account.currency.symbol
    in
    div [ class "currencySection", style "margin-top" "0.5em" ]
        (viewCurrencySectionB lbrd model symbol language)



-- Given a List BalanceResultDecorated containing the balances of accounts all of the same currency


viewCurrencySectionB : List BalanceResultDecorated -> Report.Model.Model -> String -> Language -> List (Html Msg)
viewCurrencySectionB lbrd model currencySymbol language =
    [ table [ class "table is-striped" ]
        [ thead []
            ([ th [] [ text (tx language { e = "Account ID", c = "账户号码", p = "zhànghù haoma" }) ]
             , th [] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
             ]
                ++ dvColumnHeader (tx language { e = "Amount", c = "量", p = "Liàng" }) DRCR
            )
        , tbody []
            --(List.map (\brd -> viewAccount brd model.decimalPlaces) lbrd)
            (lbrd
                |> List.filter (\_ -> True)
                |> List.map (\brd -> viewAccount brd model.decimalPlaces)
            )
        , tfoot []
            [ tr []
                ([ td [] []
                 , td [ class "has-text-right has-text-weight-bold" ] [ text (tx language { e = "Total", c = "总", p = "zǒng" } ++ " " ++ currencySymbol) ]
                 ]
                    --++ viewDFP (calcSum lbrd) model.decimalPlaces DRCR
                    ++ viewDFP (DFP [] 0 Zero) model.decimalPlaces DRCR
                )
            ]
        ]
    ]
