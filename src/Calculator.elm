module Calculator exposing (..)

import Browser
import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias Button =
    { val : String, cls : String, action : Msg }


type alias Model =
    { title : String
    , firstOperand : Float
    , secondOperand : Float
    , operator : String
    , display : String
    , keyboard : List Button
    , currentOperand : CurrentOperand
    , result : Float
    }


type CurrentOperand
    = First
    | Second


type Msg
    = InputNumber Float
    | Operator OpType
    | Equal
    | ClearAll


type OpType
    = Plus
    | Minus
    | Times
    | Divide
    | ClearLast
    | Comma
    | ChangeSign


update : Msg -> Model -> Model
update msg model =
    case msg of
        InputNumber num ->
            { model
                | display =
                    if model.display == "0" || List.member model.display [ "AC", "MC", "+/-", "x", "-", "+", "/" ] then
                        "" ++ String.fromFloat num

                    else
                        model.display ++ String.fromFloat num
                , firstOperand =
                    case model.currentOperand of
                        First ->
                            Maybe.withDefault 0 (String.toFloat (String.fromFloat model.firstOperand ++ String.fromFloat num))

                        -- refactor using map2
                        Second ->
                            model.firstOperand
                , secondOperand =
                    case model.currentOperand of
                        Second ->
                            Maybe.withDefault 0 (String.toFloat (String.fromFloat model.secondOperand ++ String.fromFloat num))

                        -- refactor using map2
                        First ->
                            model.secondOperand
            }

        Operator type_ ->
            { model
                | display = handleDisplayOperator type_
                , operator = handleDisplayOperator type_
                , currentOperand =
                    case model.currentOperand of
                        First ->
                            Second

                        Second ->
                            First
            }

        Equal ->
            let
                result =
                    evaluate model.operator model.firstOperand model.secondOperand
            in
            { model
                | display = String.fromFloat result
                , currentOperand = First
                , operator = ""
                , firstOperand = result
                , secondOperand = 0
                , result = result
            }

        ClearAll ->
            initialModel


evaluate op =
    case op of
        "+" ->
            (+)

        "-" ->
            (-)

        "." ->
            (-)

        "=" ->
            (+)

        "/" ->
            (/)

        "x" ->
            (*)

        "AC" ->
            (+)

        "MC" ->
            (+)

        "+/-" ->
            (+)

        _ ->
            (+)


handleDisplayOperator : OpType -> String
handleDisplayOperator op =
    case op of
        Plus ->
            "+"

        Minus ->
            "-"

        Divide ->
            "/"

        Times ->
            "x"

        ClearLast ->
            "MC"

        ChangeSign ->
            "+/-"

        Comma ->
            "."


keys : List Button
keys =
    [ { val = "AC", cls = "button action-button", action = ClearAll }
    , { val = "MC", cls = "button action-button", action = Operator ClearLast }
    , { val = "+/-", cls = "button action-button", action = Operator ChangeSign }
    , { val = "x", cls = "button calc-action-button", action = Operator Times }
    , { val = "7", cls = "button num-button", action = InputNumber 7 }
    , { val = "8", cls = "button num-button", action = InputNumber 8 }
    , { val = "9", cls = "button num-button", action = InputNumber 9 }
    , { val = "+", cls = "button calc-action-button", action = Operator Plus }
    , { val = "4", cls = "button num-button", action = InputNumber 4 }
    , { val = "5", cls = "button num-button", action = InputNumber 5 }
    , { val = "6", cls = "button num-button", action = InputNumber 6 }
    , { val = "-", cls = "button calc-action-button", action = Operator Minus }
    , { val = "1", cls = "button num-button", action = InputNumber 1 }
    , { val = "2", cls = "button num-button", action = InputNumber 2 }
    , { val = "3", cls = "button num-button", action = InputNumber 3 }
    , { val = "/", cls = "button calc-action-button", action = Operator Divide }
    , { val = "0", cls = "button num-button zero", action = InputNumber 0 }
    , { val = ".", cls = "button num-button", action = Operator Comma }
    , { val = "=", cls = "button calc-action-button", action = Equal }
    ]


renderKeyboardItem : Button -> Html Msg
renderKeyboardItem key =
    div [ class key.cls, onClick key.action ] [ text key.val ]


renderKeyboard : List Button -> List (Html Msg)
renderKeyboard data =
    List.map renderKeyboardItem data


initialModel : Model
initialModel =
    { title = "Elm Calculator"
    , keyboard = keys
    , firstOperand = 0
    , secondOperand = 0
    , operator = ""
    , display = "0"
    , currentOperand = First
    , result = 0
    }


view : Model -> Html Msg
view model =
    div [class "body"]
        [ Html.node "link"
            [ Html.Attributes.rel "stylesheet"
            , Html.Attributes.href "../styles.css"
            ]
            []
        , div []
            [ h1
                []
                [ text model.title ]
            , div
                [ class "container" ]
                [ div [ class "result" ] [ p [] [ text model.display ] ]
                , div [ class "keyboard" ] (renderKeyboard model.keyboard)
                ]
            ]
        ]


main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }
