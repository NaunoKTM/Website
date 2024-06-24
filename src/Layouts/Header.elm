module Layouts.Header exposing (Model, Msg, Props, header, layout)

import Effect exposing (Effect)
import Element exposing (Element, alignTop, centerX, column, el, fill, height, link, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model
            , Effect.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view { toContentMsg, model, content } =
    { title = content.title
    , body =
        [ Element.layout [ centerX ] <| header
        ]
    }


header : Element contentMsg
header =
    column
        [ width fill ]
        [ Element.image
            [ width fill
            , height (px 100)
            , alignTop
            ]
            { src = "/public/logo.png"
            , description = "Logo"
            }
        , el
            [ Background.color (rgb255 30 30 30)
            , Border.color (rgb255 50 50 50)
            , width fill
            ]
            (row
                [ width fill
                , height (px 50)
                , spacing 20
                , padding 20
                , centerX
                ]
                -- (List.map2 navButton
                --     [ "Accueil"
                --     , "Nos Galleries"
                --     , "Actualités"
                --     , "Evenements"
                --     , "Contact"
                --     ]
                --     [ "/"
                --     , "/Nos Galleries"
                --     , "/Actualités"
                --     , "/Evenements"
                --     , "/Contact"
                --     ]
                -- )
                [ navButton "Accueil" "/"
                , navButton "Nos Galleries" "/galleries"
                , navButton "Actualités" "/news"
                , navButton "Evenements" "/events"
                , navButton "Contact" "/contact"
                ]
            )
        ]


navButton : String -> String -> Element contentMsg
navButton label urlString =
    link
        [ Font.color (rgb255 255 255 255)
        , Font.size 16
        ]
        { url = urlString, label = text label }
