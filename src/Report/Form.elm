module Report.Form exposing (form)

import Category.Model
import Form exposing (Form)
import Msg exposing (Msg(..))
import Report.Model exposing (FValues, ManyCatTypes(..), ReportTypes(..))
import Report.Msg


form : Category.Model.Model -> Form FValues Msg
form category_model =
    let
        categories =
            List.map (\cat -> ( String.fromInt cat.id, cat.title )) (List.sortBy .symbol category_model.categories)

        reportTypeField =
            Form.radioField
                { parser =
                    \value ->
                        case value of
                            "stock" ->
                                Ok Stock

                            "flow" ->
                                Ok Flow

                            "bs" ->
                                Ok BS

                            "pnl" ->
                                Ok PNL

                            _ ->
                                Err "Invalid report type"
                , value = .reportType
                , update = \value values -> { values | reportType = value }
                , error = always Nothing
                , attributes =
                    { label = "I want..."
                    , options =
                        [ ( "stock", "... the balances of all accounts for a given category as of an instant in time." )
                        , ( "flow", "... the change in the balances of all accounts for a given category during a period of time." )
                        , ( "bs", "... a Balance Sheet." )
                        , ( "pnl", "... a Profit and Loss statement." )
                        ]
                    }
                }
    in
    reportTypeField
        |> Form.andThen
            (\reportType ->
                case reportType of
                    Stock ->
                        stockForm categories

                    Flow ->
                        flowForm categories

                    BS ->
                        bsForm categories

                    PNL ->
                        pnlForm categories
            )


stockForm : List ( String, String ) -> Form FValues Msg
stockForm categories =
    Form.succeed (\s1 s2 -> Report (Report.Msg.StockForm s1 s2))
        |> Form.append (categoryField categories)
        |> Form.append stopTimeField


flowForm : List ( String, String ) -> Form FValues Msg
flowForm categories =
    Form.succeed (\s1 s2 s3 -> Report (Report.Msg.FlowForm s1 s2 s3))
        |> Form.append (categoryField categories)
        |> Form.append startTimeField
        |> Form.append stopTimeField


bsForm : List ( String, String ) -> Form FValues Msg
bsForm categories =
    Form.succeed (\s1 s2 s3 s4 s5 s6 -> Report (Report.Msg.BSForm s1 s2 s3 s4 s5 s6))
        |> Form.append (categoryAssetsField categories)
        |> Form.append (categoryLiabilitiesField categories)
        |> Form.append (categoryEquityField categories)
        |> Form.append (categoryRevenueField categories)
        |> Form.append (categoryExpensesField categories)
        |> Form.append stopTimeField


pnlForm : List ( String, String ) -> Form FValues Msg
pnlForm categories =
    Form.succeed (\s1 s2 s3 s4 -> Report (Report.Msg.PNLForm s1 s2 s3 s4))
        |> Form.append (categoryRevenueField categories)
        |> Form.append (categoryExpensesField categories)
        |> Form.append startTimeField
        |> Form.append stopTimeField


categoryField : List ( String, String ) -> Form { a | category : String } String
categoryField categories =
    Form.selectField
        { parser = Ok
        , value = .category
        , update = \value values -> { values | category = value }
        , error = always Nothing
        , attributes =
            { label = "Category"
            , placeholder = "Choose a category"
            , options = categories
            }
        }


categoryAssetsField : List ( String, String ) -> Form { a | categoryAssets : String } String
categoryAssetsField categories =
    Form.selectField
        { parser = Ok
        , value = .categoryAssets
        , update = \value values -> { values | categoryAssets = value }
        , error = always Nothing
        , attributes =
            { label = "Assets Category"
            , placeholder = "Choose a category"
            , options = categories
            }
        }


categoryEquityField : List ( String, String ) -> Form { a | categoryEquity : String } String
categoryEquityField categories =
    Form.selectField
        { parser = Ok
        , value = .categoryEquity
        , update = \value values -> { values | categoryEquity = value }
        , error = always Nothing
        , attributes =
            { label = "Equity Category"
            , placeholder = "Choose a category"
            , options = categories
            }
        }


categoryExpensesField : List ( String, String ) -> Form { a | categoryExpenses : String } String
categoryExpensesField categories =
    Form.selectField
        { parser = Ok
        , value = .categoryExpenses
        , update = \value values -> { values | categoryExpenses = value }
        , error = always Nothing
        , attributes =
            { label = "Expenses Category"
            , placeholder = "Choose a category"
            , options = categories
            }
        }


categoryLiabilitiesField : List ( String, String ) -> Form { a | categoryLiabilities : String } String
categoryLiabilitiesField categories =
    Form.selectField
        { parser = Ok
        , value = .categoryLiabilities
        , update = \value values -> { values | categoryLiabilities = value }
        , error = always Nothing
        , attributes =
            { label = "Liabilities Category"
            , placeholder = "Choose a category"
            , options = categories
            }
        }


categoryRevenueField : List ( String, String ) -> Form { a | categoryRevenue : String } String
categoryRevenueField categories =
    Form.selectField
        { parser = Ok
        , value = .categoryRevenue
        , update = \value values -> { values | categoryRevenue = value }
        , error = always Nothing
        , attributes =
            { label = "Revenue Category"
            , placeholder = "Choose a category"
            , options = categories
            }
        }


startTimeField : Form { a | startTime : String } String
startTimeField =
    Form.textField
        { parser = Ok
        , value = .startTime
        , update = \value values -> { values | startTime = value }
        , error = always Nothing
        , attributes =
            { label = "Start time"
            , placeholder = "2020-01-31T08:30:00.000Z"
            }
        }


stopTimeField : Form { a | stopTime : String } String
stopTimeField =
    Form.textField
        { parser = Ok
        , value = .stopTime
        , update = \value values -> { values | stopTime = value }
        , error = always Nothing
        , attributes =
            { label = "Stop time"
            , placeholder = "2020-01-31T08:30:00.000Z"
            }
        }
