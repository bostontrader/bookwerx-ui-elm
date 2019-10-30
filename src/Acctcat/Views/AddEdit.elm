module Acctcat.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Acctcat.Acctcat exposing (Acctcat)
import Acctcat.MsgB exposing (MsgB(..))
import Category.Model
import Html exposing (Html, a, button, div, h3, label, option, select, text)
import Html.Attributes exposing (class, href, selected, value)
import Html.Events exposing (onClick, onInput)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx_save)
import Types exposing (AEMode(..))
import Flash exposing (viewFlash)
import ViewHelpers exposing (viewHttpPanel)


addeditForm : Acctcat -> List (Html Msg) -> Html Msg
addeditForm editBuffer accountSelectOptions =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ] [ text "Account" ]
            , div [ class "control" ]
                [ div [ class "select" ]
                    [ select [ onInput (\newValue -> AcctcatMsgA (UpdateAccountID newValue)) ]
                        accountSelectOptions
                    ]
                ]
            ]
        ]


buildAccountSelect : Model.Model -> Int -> List (Html msg)
buildAccountSelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map
            (\a ->
                option [ value (String.fromInt a.id), selected (a.id == selected_id) ]
                    [ text (a.title ++ " " ++ a.currency.symbol) ]
            )
            (List.sortBy .title model.accounts.accounts)
        )


buildCategorySelect : Category.Model.Model -> Int -> List (Html msg)
buildCategorySelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map (\a -> option [ value (String.fromInt a.id), selected (a.id == selected_id) ] [ text a.title ]) (List.sortBy .title model.categories))


leftContent : String -> Language -> Html Msg
leftContent logMsg language =
    div []
        [ viewHttpPanel logMsg "" language ]


rightContent : { id : String, logMsg : String, onClick : Msg, title : String } -> Model.Model -> Html Msg
rightContent r model =
    div []
        [ h3 [ class "title is-3" ] [ text r.title ]
        , viewFlash model.flashMessages
        , a [href "/acctcats" ] [ text "Acctcats index" ]
        , addeditForm
            model.acctcats.editBuffer
            (buildAccountSelect model model.acctcats.editBuffer.account_id)

        , div []
            [ button
                [ class "button is-link"
                , onClick r.onClick
                ]
                [ model.language |> tx_save |> text ]
            ]
        ]


view : Model.Model -> AEMode -> Html Msg
view model aemode =
    let
        postParams =
            "apikey="
                ++ model.apikeys.apikey
                ++ "&account_id="
                ++ String.fromInt model.acctcats.editBuffer.account_id
                ++ "&category_id="
                ++ String.fromInt model.acctcats.category_id

        putParams =
            postParams
                ++ "&id="
                ++ String.fromInt model.acctcats.editBuffer.id

        r =
            --case aemode of
            --Add ->
            { id = "acctcats-add"
            , title = "Create New Acctcat"
            , onClick =
                AcctcatMsgA
                    (PostAcctcat
                        (model.bservers.baseURL ++ "/acctcats")
                        "application/x-www-form-urlencoded"
                        postParams
                    )
            , logMsg =
                "POST application/x-www-form-urlencoded "
                    ++ model.bservers.baseURL
                    ++ "/acctcats "
                    ++ postParams
            }

    in
        template model (leftContent r.logMsg model.language) (rightContent r model)
