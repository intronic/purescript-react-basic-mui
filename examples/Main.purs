module Examples.Main where

import Prelude

import Data.Array (singleton) as Array
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import MUI.Core (jss)
import MUI.Core.AppBar (appBar)
import MUI.Core.AppBar (position) as AppBar
import MUI.Core.Badge (badgeWithStyles)
import MUI.Core.Badge (color) as Badge
import MUI.Core.Button (button, color) as Button
import MUI.Core.Button (buttonWithStyles)
import MUI.Core.ButtonGroup (buttonGroupWithStyles, color, variant) as ButtonGroup
import MUI.Core.Container (container)
import MUI.Core.CssBaseline (cssBaseline)
import MUI.Core.Divider (dividerWithStyles)
import MUI.Core.Divider (variant) as Dividier
import MUI.Core.FormControl (formControlWithStyles)
import MUI.Core.FormHelperText (formHelperText)
import MUI.Core.Grid (grid)
import MUI.Core.Grid (gridSize) as Grid
import MUI.Core.Hidden (hidden)
import MUI.Core.Hidden (implementation, only) as Hidden
import MUI.Core.Input (input)
import MUI.Core.InputLabel (inputLabel)
import MUI.Core.Link (color, variant) as Link
import MUI.Core.Link (link)
import MUI.Core.TextField (filledWithStyles, outlinedWithStyles, standardWithStyles) as TextField
import MUI.Core.Toolbar (toolbar)
import MUI.Core.Typography (typography)
import MUI.Core.Typography (variant) as Typography
import MUI.Icons.Menu (menu)
import MUI.Icons.Types (iconWithStyles)
import React.Basic (Component, JSX, createComponent, make)
import React.Basic.DOM (a, css, div, form, span, text) as DOM
import React.Basic.DOM (render)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

type Props = {}

component :: Component Props
component = createComponent "Counter"

gridItem :: JSX -> JSX
gridItem child = grid { item: true, children: [ child ], xs: Grid.gridSize.six }

app :: JSX
app = make component { initialState: {}, render } {}
  where
    textInputStyle theme = { root: jss { width: "80%", margin: theme.spacing 2.0 }}
    render self = DOM.div $ { children: _ }
      [ cssBaseline
      , appBar $ { children: _, position: AppBar.position.static } <<< Array.singleton $
          toolbar $ { children: _ }
            [ iconWithStyles menu (\theme → { root: jss { marginRight: theme.spacing 2.0 }}) {}
            , typography $ { children: _, variant: Typography.variant.h6 } <<< Array.singleton $
               link { children: [ DOM.text "LINK" ], href: "#TEST", color: Link.color.inherit }
            , buttonWithStyles
                (\theme → { root: jss { marginRight: theme.spacing 2.0 }})
                { children: [ DOM.text "Login" ]
                , color: Button.color.inherit
                }
            , hidden
              { implementation: Hidden.implementation.css
              , children: [ DOM.text "Hidden on xs or lg" ]
              , only: Hidden.only.only [ Hidden.only.xs, Hidden.only.lg ]
              }
            ]
      , container $ { fixed: true, children: _ }
          [ DOM.form $ { children: _ } $
            [ grid $ { container: true, children: _ }
              [ gridItem $
                  formControlWithStyles textInputStyle $ { children: _ }
                    [ inputLabel
                      { htmlFor: "m-input"
                      , children: [ DOM.text "Email address" ]
                      }
                    , input { placeholder: "your email address" }
                    , formHelperText { id: "my-helper-text", children: [ DOM.text "We'll never share your email" ]}
                    ]
              , gridItem $
                  TextField.outlinedWithStyles
                    textInputStyle
                    { error: true
                    , helperText: DOM.span $ { children: _ }
                      [ DOM.text "A link inside a helper text: "
                      , DOM.a { href: "https://example.com", children: [ DOM.text "example.com" ]}
                      ]
                      -- { dangerouslySetInnerHTML: { __html : "<a href=\"https://google.com\">UNSAFE</a>" }}
                    , label: inputLabel { children: [ DOM.text "Label" ]}
                    , placeholder: "test"
                    }
              , gridItem $
                  TextField.standardWithStyles
                    textInputStyle
                    { error: false
                    , label: inputLabel { children: [ DOM.text "Label" ]}
                    , placeholder: "test"
                    }
              , gridItem $
                  TextField.filledWithStyles
                    textInputStyle
                    { error: true
                    , label: inputLabel { children: [ DOM.text "Label" ]}
                    , placeholder: "test"
                    }
              ]
          ]
          , dividerWithStyles
              (\theme → { root: jss { marginTop: theme.spacing 4.0, marginBottom: theme.spacing 4.0 }})
              { variant: Dividier.variant.middle }
          , grid $ { container: true, children: _ }
            [ gridItem $
                ButtonGroup.buttonGroupWithStyles (\theme → { root: jss { margin: theme.spacing 2.0 }}) $
                  { variant: ButtonGroup.variant.text, color: ButtonGroup.color.primary, children: _ }
                  [ Button.button { children: [ DOM.text "One" ]}
                  , Button.button { children: [ DOM.text "Two" ]}
                  , Button.button { children: [ DOM.text "Three" ]}
                  ]
            , gridItem $ badgeWithStyles
                (\theme → { root: jss { margin: theme.spacing 2.0 }})
                { badgeContent: DOM.text "4"
                , children: [ DOM.text "Badge experiment" ]
                , color: Badge.color.secondary
                }
            ]
          ]
      ]


main :: Effect Unit
main = do
  container <- getElementById "container" =<< (map toNonElementParentNode $ document =<< window)
  case container of
    Nothing -> throw "Container element not found."
    Just c  -> render app c

