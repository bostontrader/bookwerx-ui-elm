module State exposing (init, update)

import RemoteData exposing (WebData)

import Types exposing (Currency, CurrencyId, Model, Msg(..), Route)
--import Rest exposing (createPostCommand, deletePostCommand, fetchPostsCommand)
import Rest exposing (createCurrencyCommand, deleteCurrencyCommand, fetchCurrenciesCommand)

import Navigation exposing (Location)
import Routing exposing (extractRoute)
--import Debug
import Misc exposing (findCurrencyById)
--import Rest exposing (updatePostCommand, updatePostRequest)

tempCurrencyId =
    "-1"

emptyCurrency : Currency
emptyCurrency =
    Currency tempCurrencyId "" ""

initialModel : Route -> Model
initialModel route =
    { currencies = RemoteData.Loading
    , currentRoute = route
    , newCurrency = emptyCurrency
    }

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.extractRoute (Debug.log "location" location)
    in
        ( initialModel currentRoute, fetchCurrenciesCommand )

-- How can I test this?
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        FetchCurrencies ->
            ( { model | currencies = RemoteData.Loading }, fetchCurrenciesCommand )

        CurrenciesReceived response ->
            ( { model | currencies = response }, Cmd.none )

        LocationChanged location ->
            ( { model
                | currentRoute = Routing.extractRoute location
              }
            , Cmd.none
            )

        {-UpdateTitle postId newTitle ->
            let
                updatedPosts =
                    updateTitle postId newTitle model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorName postId newName ->
            let
                updatedPosts =
                    updateAuthorName postId newName model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorUrl postId newUrl ->
            let
                updatedPosts =
                    updateAuthorUrl postId newUrl model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        SubmitUpdatedPost postId ->
            case findPostById postId model.posts of
                Just post ->
                    ( model, updatePostCommand post )

                Nothing ->
                    ( model, Cmd.none )

        PostUpdated _ ->
            ( model, Cmd.none ) -}

        DeleteCurrency currencyId ->
            case findCurrencyById currencyId model.currencies of
                Just currency ->
                    ( model, deleteCurrencyCommand currency )

                Nothing ->
                    ( model, Cmd.none )

        CurrencyDeleted _ ->
            ( model, fetchCurrenciesCommand )

        NewCurrencyTitle newTitle ->
            let
                updatedNewCurrency =
                    setTitle newTitle model.newCurrency
            in
                ( { model | newCurrency = updatedNewCurrency }, Cmd.none )

        NewCurrencySymbol newSymbol ->
            let
                updatedNewCurrency =
                    setSymbol newSymbol model.newCurrency
            in
                ( { model | newCurrency = updatedNewCurrency }, Cmd.none )

        CreateNewCurrency ->
            ( model, createCurrencyCommand model.newCurrency )

        CurrencyCreated (Ok currency) ->
            ( { model
                | currencies = addNewCurrency currency model.currencies
                , newCurrency = emptyCurrency
              }
            , Cmd.none
            )

        CurrencyCreated (Err _) ->
            ( model, Cmd.none )

addNewCurrency : Currency -> WebData (List Currency) -> WebData (List Currency)
addNewCurrency newCurrency currencies =
    let
        appendCurrency : List Currency -> List Currency
        appendCurrency listOfCurrencies =
            List.append listOfCurrencies [ newCurrency ]
    in
        RemoteData.map appendCurrency currencies

setSymbol : String -> Currency -> Currency
setSymbol newSymbol currency =
    { currency | symbol = newSymbol }

setTitle : String -> Currency -> Currency
setTitle newTitle currency =
    { currency | title = newTitle }

{-setAuthorName : String -> Post -> Post
setAuthorName newName post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | name = newName } }


setAuthorUrl : String -> Post -> Post
setAuthorUrl newUrl post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | url = newUrl } }

updateTitle : PostId -> String -> Model -> WebData (List Post)
updateTitle postId newTitle model =
    let
        updatePost post =
            if post.id == postId then
                { post | title =  Debug.log "newTitle: " newTitle }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts

map : (a -> b) -> RemoteData e a -> RemoteData e b
map f data =
    case data of
        Success value ->
            Success (f value)

        Loading ->
            Loading

        NotAsked ->
            NotAsked

        Failure error ->
            Failure error

type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


updateAuthorName : PostId -> String -> Model -> WebData (List Post)
updateAuthorName postId newName model =
    let
        updatePost post =
            if post.id == postId then
                let
                    oldAuthor =
                        post.author
                in
                    { post | author = { oldAuthor | name = newName } }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts


updateAuthorUrl : PostId -> String -> Model -> WebData (List Post)
updateAuthorUrl postId newUrl model =
    let
        updatePost post =
            if post.id == postId then
                let
                    oldAuthor =
                        post.author
                in
                    { post | author = { oldAuthor | url = newUrl } }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts

-}