module Views.Accounts.Edit exposing (view)

import Html exposing (Html, a, div, h3, text)
import Html.Attributes exposing (class, href, type_, value)
--import Html.Events exposing (onClick, onInput)
--import Types exposing (Account, Msg(..))
import Types exposing (Account, Model, Msg)
import RemoteData

view : Model -> Html Msg
view model =
    div []
        -- [ a [ href "/accounts" ] [ text "Back" ]
        --[ h3 [] [ text "Edit Account" ]
        --, editForm account
        [ viewAccountOrError model
        ]


viewAccountOrError : Model -> Html Msg
viewAccountOrError model =
    case model.account of
        RemoteData.NotAsked ->
            -- text ""
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success accounts ->
            --viewAccounts accounts
            --h3 [ id "accounts-index"] [ text "List accounts..." ]
            h3 [] [ text "Account found..." ]


        RemoteData.Failure httpError ->
            -- viewError (createErrorMessage httpError)
            h3 [] [ text "Account error..." ]

editForm : Account -> Html Msg
editForm account =
    div[][]
--    Html.form []
--        [ div []
--            [ text "Title"
--            , br [] []
--            , input
--                [ type_ "text"
--                , value account.title
--                , onInput (UpdateTitle account.id)
--                ]
--                []
--            ]
--        , br [] []
--        , div []
--            [ text "Author Name"
--            , br [] []
--            , input
--                [ type_ "text"
--                , value account.author.name
--                , onInput (UpdateAuthorName account.id)
--                ]
--                []
--            ]
--        , br [] []
--        , div []
--            [ text "Author URL"
--            , br [] []
--            , input
--                [ type_ "text"
--                , value account.author.url
--                , onInput (UpdateAuthorUrl account.id)
--                ]
--                []
--            ]
--        , br [] []
--        , div []
--            [ button [ onClick (SubmitUpdatedAccount account.id) ]
--                [ text "Submit" ]
--            ]
--        ]