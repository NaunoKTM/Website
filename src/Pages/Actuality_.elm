module Pages.Actuality_ exposing (..)

import Browser.Navigation as Navigation
import Effect exposing (Effect, sendCmd)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events exposing (onMouseEnter)
import Element.Font as Font
import Http
import Json.Decode exposing (Decoder, field, list, map3, nullable, string)
import Page exposing (Page)
import Pages.Home_ exposing (subscriptions, view)
import Route exposing (Route)
import Shared exposing (Model)
import Task
import View exposing (View)


type alias Model =
    { articles : List Article
    , error : Maybe String
    }


type alias Article =
    { title : String
    , description : String
    , url : String
    }


page : Shared.Model -> Route { actuality : String } -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Effect Msg )
init _ =
    ( { articles = [], error = Nothing }, fetchNews )


type Msg
    = NewsFetched (Result Http.Error (List Article))
    | LinkClicked String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NewsFetched (Ok articles) ->
            ( { model | articles = articles, error = Nothing }, Effect.none )

        NewsFetched (Err error) ->
            let
                errorMessage =
                    case error of
                        Http.BadUrl url ->
                            "Bad URL: " ++ url

                        Http.Timeout ->
                            "Request timed out"

                        Http.NetworkError ->
                            "Network error"

                        Http.BadStatus status ->
                            "Bad status: " ++ String.fromInt status

                        Http.BadBody bodyError ->
                            "Bad body: " ++ bodyError
            in
            ( { model | error = Just errorMessage }, Effect.none )

        LinkClicked url ->
            ( model
            , sendCmd (Navigation.load url)
            )


fetchNews : Effect Msg
fetchNews =
    let
        url =
            "https://newsapi.org/v2/top-headlines?q=art&apiKey=195d412376fb4fd4bce31e150f0fb127"

        articleDecoder : Decoder Article
        articleDecoder =
            map3
                (\title description _ ->
                    Article title (Maybe.withDefault "No description available" description) url
                )
                (field "title" string)
                (field "description" (nullable string))
                (field "url" string)

        decoder : Decoder (List Article)
        decoder =
            field "articles" (list articleDecoder)
    in
    sendCmd
        (Http.get { url = url, expect = Http.expectJson NewsFetched decoder })


view : Model -> View Msg
view model =
    { title = "Home"
    , body =
        [ layout [ centerX ] <|
            newsPage model
        ]
    }



-- newsPage : Model -> Element Msg
-- newsPage model =
--     { title = "Art News"
--     , body =
--         column []
--             (List.newsPage : Model -> Element Msg


newsPage : Model -> Element Msg
newsPage model =
    column []
        [ text "Art News"
        , column [] (List.map viewArticle model.articles ++ [ maybeError model.error ])
        ]


viewArticle : { a | title : String, description : String, url : String } -> Element Msg
viewArticle article =
    column [ Border.width 2, Border.color (rgb 0 0 0), Border.solid, Border.rounded 5, spacing 5, padding 10 ]
        [ el [ Font.bold, Font.size 20, Events.onClick (LinkClicked article.url), Background.color (rgb 0 0 0.1) ]
            (text article.title)
        , text article.description
        ]



-- viewArticle : { a | title : String, description : String, url : String } -> Element msg
-- viewArticle article =
--     el [ Font.bold, Font.size 20, Border.color (rgb 0 0 0), Border.width 2 ]
--         (column []
--             [ el [] (text article.title)
--             , el [] (text article.description)
--             , el [] (link [] { label = text "Read more", url = article.url })
--             -- , el [] (link article.url (text "Read more"))
--             ]
--         )


maybeError : Maybe String -> Element msg
maybeError error =
    case error of
        Just msg ->
            el [] (text msg)

        Nothing ->
            el [] (text "")


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
