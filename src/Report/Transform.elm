{- There are a handful of transformations required to convert the raw data returned from the server into data structures amenable for display by reports.  Because of the arcane and tedious nature of said transformations it's not feasible to give the relevant functions or type aliases sensible names.  We will therefore give them not-so-sensible names and rely upon this index for guidance instead.

   The party starts when the server gives us a List of DistributionReport in unknown order.

   Our general goal is to transform said List into a Dict String (List AccountSummary). The String key of this Dict is a currency symbol. An AccountSummary contains the account id and a single number that has meaning according to the type of report.  For "stock" type reports the number represents the balance for the account as of a given time.  For "flow" type reports the number represents the quantity of activity during a time period specified by two times.

   xform1 - The first obvious transformation is take the initial List of DistributionReport and filter out irrelevant distributions, based on their start and stop times of the report.

   xform2 - Given the output of xform1, build a Dict Int DFP.  The Int keys are account_ids and the DFP values are the sums of all distributions for the given account_id)

   xform2a - Given the output of xform2, and the omitZeros flag, filter out accounts with zero balances, if requested.

   xform3 - Given the output of xform2, build a Dict String (List AccountSummary).  The String keys are currency_symbols and the values are the AccountSummary(ies) of all accounts for the given curreny.

-}


module Report.Transform exposing (xform1, xform2, xform2a, xform3)

import Account.Model
import DecimalFP exposing (DFP, dfp_add, dfp_equal)
import Dict exposing (Dict)
import Distribution.Distribution exposing (DistributionReport)
import Report.Report exposing (AccountSummary)
import Util exposing (getCurrencySymbol)


xform1 : String -> String -> List DistributionReport -> List DistributionReport
xform1 start stop input =
    List.filter (\e -> start <= e.time && e.time <= stop) input


xform2 : List DistributionReport -> Dict Int DFP
xform2 input =
    List.foldl
        (\dr dict ->
            case Dict.get dr.account_id dict of
                Just x ->
                    -- add this distribution to an existing account
                    Dict.insert dr.account_id (dfp_add x (DFP dr.amount dr.amount_exp)) dict

                Nothing ->
                    -- add a new account with an initial balance
                    Dict.insert dr.account_id (DFP dr.amount dr.amount_exp) dict
        )
        Dict.empty
        input


xform2a : Bool -> Dict Int DFP -> Dict Int DFP
xform2a omitZeros input =
    Dict.filter (\_ v -> not omitZeros || not (dfp_equal v (DFP 0 0))) input


xform3 : Dict Int DFP -> Account.Model.Model -> Dict String (List AccountSummary)
xform3 input accounts_model =
    List.foldl
        (\dr dict ->
            let
                currency_symbol =
                    getCurrencySymbol accounts_model (Tuple.first dr)
            in
            case Dict.get currency_symbol dict of
                Just x ->
                    -- add this account to an existing currency
                    Dict.insert currency_symbol (x ++ [ AccountSummary (Tuple.first dr) (Tuple.second dr) ]) dict

                Nothing ->
                    -- add a new currency with this first account
                    Dict.insert currency_symbol [ AccountSummary (Tuple.first dr) (Tuple.second dr) ] dict
        )
        Dict.empty
        (Dict.toList input)
