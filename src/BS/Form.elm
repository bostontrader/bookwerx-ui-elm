module BS.Form exposing (form)

import BS.Model exposing (FValues)
import BS.MsgB exposing (MsgB(..))
import Category.Model
import Form exposing (Form)
import Msg exposing (Msg(..))

form : Category.Model.Model -> Form FValues Msg
form category_model =
    let

        categories =
            List.map (\cat -> (String.fromInt cat.id, cat.title) ) (List.sortBy .symbol category_model.categories)

        asofTime =
             Form.textField
                 { parser = Ok
                 , value = .asofTime
                 , update = \value values -> { values | asofTime = value }
                 , error = always Nothing
                 , attributes =
                     { label = "As of time"
                     , placeholder = "2020-01-31T08:30:00.000Z"
                     }
                 }

        assetsCategorySelect =
            Form.selectField
                { parser = Ok
                , value = .assetsCategory
                , update = \value values -> { values | assetsCategory = value }
                , error = always Nothing
                , attributes =
                    { label = "Assets Category"
                    , placeholder = "Choose a category"
                    , options = categories
                    }
                }

        equityCategorySelect =
            Form.selectField
                { parser = Ok
                , value = .equityCategory
                , update = \value values -> { values | equityCategory = value }
                , error = always Nothing
                , attributes =
                    { label = "Equity Category"
                    , placeholder = "Choose a category"
                    , options = categories
                    }
                }

        expensesCategorySelect =
            Form.selectField
                { parser = Ok
                , value = .expensesCategory
                , update = \value values -> { values | expensesCategory = value }
                , error = always Nothing
                , attributes =
                    { label = "Expenses Category"
                    , placeholder = "Choose a category"
                    , options = categories
                    }
                }

        liabilitiesCategorySelect =
            Form.selectField
                { parser = Ok
                , value = .liabilitiesCategory
                , update = \value values -> { values | liabilitiesCategory = value }
                , error = always Nothing
                , attributes =
                    { label = "Liabilities Category"
                    , placeholder = "Choose a category"
                    , options = categories
                    }
                }

        revenueCategorySelect =
            Form.selectField
                { parser = Ok
                , value = .revenueCategory
                , update = \value values -> { values | revenueCategory = value }
                , error = always Nothing
                , attributes =
                    { label = "Revenue Category"
                    , placeholder = "Choose a category"
                    , options = categories
                    }
                }

    in

        Form.succeed (\s1 s2 s3 s4 s5 s6 -> BSMsgA (BS.MsgB.GetDistributions s1 s2 s3 s4 s5 s6))
            |> Form.append assetsCategorySelect
            |> Form.append liabilitiesCategorySelect
            |> Form.append equityCategorySelect
            |> Form.append revenueCategorySelect
            |> Form.append expensesCategorySelect
            |> Form.append asofTime
