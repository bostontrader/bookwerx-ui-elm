module View exposing (view)

import Account.Views.AddEdit
import Account.Views.DistributionJoinedIndex
import Account.Views.List
import Acctcat.Views.AddEdit
import Acctcat.Views.List
import Apikey.View
import Browser
import Bserver.View
import Category.Views.AddEdit
import Category.Views.List
import Constants exposing (bwuiVersion)
import Currency.Views.AddEdit
import Currency.Views.List
import Distribution.Views.AddEdit
import Distribution.Views.List
import Html exposing (Html, a, div, h3, p, text)
import Html.Attributes exposing (class, href)
import HttpLog.View
import Lint.View
import Model
import Msg exposing (Msg)
import Report.View
import Route exposing (Route(..))
import Settings.View
import Template exposing (template)
import Transaction.Views.AddEdit
import Transaction.Views.List
import Translate exposing (..)
import Types exposing (AEMode(..))


view : Model.Model -> Browser.Document Msg
view model =
    case model.currentRoute of
        AccountDistributionIndex id ->
            { body = [ Account.Views.DistributionJoinedIndex.view model ]
            , title = "Bookwerx UI: Distributions for account #" ++ id
            }

        AccountsAdd ->
            { body = [ Account.Views.AddEdit.view model Add ]
            , title = "Bookwerx UI"
            }

        AccountsEdit id ->
            { body = [ Account.Views.AddEdit.view model Edit ]
            , title = "Bookwerx UI: Edit account #" ++ id
            }

        AccountsIndex ->
            { body = [ Account.Views.List.view model ]
            , title = "Bookwerx UI"
            }

        AcctcatsAdd ->
            { body = [ Acctcat.Views.AddEdit.view model Add ]
            , title = "Bookwerx UI"
            }

        ApikeysIndex ->
            { body = [ Apikey.View.view model ]
            , title = "Bookwerx UI"
            }

        BserversIndex ->
            { body =
                [ Bserver.View.view model ]
            , title = "Bookwerx UI"
            }

        CategoriesAccounts id ->
            { body =
                [ Acctcat.Views.List.view model ]

            -- this is correct!
            , title = "Bookwerx UI: Accounts tagged with category #" ++ String.fromInt id
            }

        CategoriesAdd ->
            { body =
                [ Category.Views.AddEdit.view model Add ]
            , title = "Bookwerx UI"
            }

        CategoriesEdit id ->
            { body =
                [ Category.Views.AddEdit.view model Edit ]
            , title = "Bookwerx UI: Edit category #" ++ id
            }

        CategoriesIndex ->
            { body =
                [ Category.Views.List.view model ]
            , title = "Bookwerx UI"
            }

        CurrenciesAdd ->
            { body =
                [ Currency.Views.AddEdit.view model Add ]
            , title = "Bookwerx UI"
            }

        CurrenciesEdit id ->
            { body =
                [ Currency.Views.AddEdit.view model Edit ]
            , title = "Bookwerx UI: Edit currency #" ++ id
            }

        CurrenciesIndex ->
            { body =
                [ Currency.Views.List.view model ]
            , title = "Bookwerx UI"
            }

        DistributionsAdd ->
            { body =
                [ Distribution.Views.AddEdit.view model Add ]
            , title = "Bookwerx UI"
            }

        DistributionsEdit id ->
            { body =
                [ Distribution.Views.AddEdit.view model Edit ]
            , title = "Bookwerx UI: Edit distribution #" ++ id
            }

        DistributionsIndex ->
            { body =
                [ Distribution.Views.List.view model ]
            , title = "Bookwerx UI"
            }

        Home ->
            { body =
                [ template model
                    (div [] [])
                    (div []
                        [ h3 [ class "title is-size-2" ] [ text (txWelcome model) ]
                        , p [ class "is-size-5" ] (txPurpose model)

                        --, p [ class "is-size-5" ] [ text (txFollowTutorial model) ]
                        ]
                    )
                ]
            , title = "Bookwerx UI"
            }

        HttpLog ->
            { body = [ HttpLog.View.view model ]
            , title = "Bookwerx UI"
            }

        Lint ->
            { body = [ Lint.View.view model ]
            , title = "Bookwerx UI"
            }

        NotFound ->
            { body =
                [ h3 [] [ text "Oops! The page you requested was not found!" ] ]
            , title = "Bookwerx UI"
            }

        ReportRoute ->
            { body = [ Report.View.view model ]
            , title = "Bookwerx UI"
            }

        Settings ->
            { body = [ Settings.View.view model ]
            , title = "Bookwerx UI"
            }

        TransactionsAdd ->
            { body = [ Transaction.Views.AddEdit.view model Add ]
            , title = "Bookwerx UI"
            }

        TransactionsEdit id ->
            { body = [ Transaction.Views.AddEdit.view model Edit ]
            , title = "Bookwerx UI: : Edit transaction #" ++ id
            }

        TransactionsIndex ->
            { body = [ Transaction.Views.List.view model ]
            , title = "Bookwerx UI"
            }



--        _ ->
--            { body =
--                [ h3 [] [ text "Oops! The page you requested was not found!" ] ]
--            , title = "Bookwerx UI"
--            }
--
--
--
----pageNotFound: Html Msg
----pageNotFound = div[][ text "Page not found" ]
----txFollowTutorial : Model.Model -> String
----txFollowTutorial model =
----case model.language of
----English ->
----"Please follow the tutorial to get started."
----Chinese ->
----"请按照教程开始。"
----Pinyin ->
----"Qǐng ànzhào jiàochéng kāishǐ."
--
--


txPurpose : Model.Model -> List (Html Msg)
txPurpose model =
    case model.language of
        English ->
            [ text "The purpose of bookwerx-ui is to provide everything you need to get started using the"
            , a [ href "https://github.com/bostontrader/bookwerx-core " ] [ text " bookwerx-core " ]
            , text " multiple-currency bookkeeping engine."
            ]

        Chinese ->
            [ text "bookwerx-ui的目的是提供开始使用所需的一切"
            , a [ href "https://github.com/bostontrader/bookwerx-core" ] [ text "bookwerx-core" ]
            , text "多币种簿记引擎。"
            ]

        Pinyin ->
            [ text "bookwerx-ui de mùdì shì tígōng kāishǐ shǐyòng suǒ xū de yīqiè"
            , a [ href "https://github.com/bostontrader/bookwerx-core" ] [ text "bookwerx-core" ]
            , text "duō bì zhǒng bùjì yǐnqíng。"
            ]


txWelcome : Model.Model -> String
txWelcome model =
    let
        v =
            "v " ++ bwuiVersion
    in
    case model.language of
        English ->
            "Welcome to bookwerx-ui " ++ v

        Chinese ->
            "欢迎来到 bookwerx-ui " ++ v

        Pinyin ->
            "huānyíng lái dào bookwerx-ui " ++ v
