#define TRAIL_TABLE "mp/trailTable.csv"

#define TRAIL(row, itemID, req_p, req_r) \
itemDef \
{ \
    rect                      -40 (70 + (19*row)) 300 18 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_SUBTOP \
    style                     WINDOW_STYLE_SHADER \
    borderSize                1 \
    foreColor                 0.445 0.457 0.527 0.4 \
    backColor                 0 0 0 0 \
    borderColor               0 0 0 0 \
    outlineColor              0 0 0 0 \
    background                "menu_button_backg" \
    textScale                 0.55 \
    visible                   1 \
    decoration                \
} \
itemDef \
{ \
    rect                      -40 (70 + (19*row)) 300 18 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_SUBTOP \
    style                     WINDOW_STYLE_SHADER \
    borderSize                1 \
    foreColor                 0.445 0.457 0.527 1 \
    backColor                 0 0 0 0 \
    borderColor               0 0 0 0 \
    outlineColor              0 0 0 0 \
    background                "menu_button_backg" \
    textScale                 0.55 \
    visible                   when ( localvarint( "ui_hover_trail" ) == itemID ) \
    decoration                \
} \
itemDef \
{ \
    rect                      -40 (70 + (19*row)) 300 18 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_SUBTOP \
    style                     WINDOW_STYLE_SHADER \
    borderSize                1 \
    foreColor                 0.2 0.8 0.2 1 \
    backColor                 0 0 0 0 \
    borderColor               0 0 0 0 \
    outlineColor              0 0 0 0 \
    background                "menu_button_backg" \
    textScale                 0.55 \
    visible                   when ( stat( 978 ) == itemID ) \
    decoration                \
} \
itemDef \
{ \
    rect                      -40 (70 + (19*row)) 300 18 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_SUBTOP \
    borderSize                1 \
    foreColor                 1 1 1 1 \
    backColor                 0 0 0 0 \
    borderColor               0 0 0 0 \
    outlineColor              0 0 0 0 \
    textFont                  UI_FONT_OBJECTIVE \
    textAlign                 ITEM_ALIGN_MIDDLE_RIGHT \
    textAlignX                -25 \
    textScale                 0.33 \
    textStyle                 ITEM_TEXTSTYLE_SHADOWED \
    exp                       text(tableLookup(TRAIL_TABLE, 0, itemID, 4)) \
    visible                   when ( itemID == 1 || (stat(2326) > req_p) || (stat(2326) == req_p && stat(252) >= req_r) ) \
    decoration                \
} \
itemDef \
{ \
    rect                      -40 (70 + (19*row)) 300 18 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_SUBTOP \
    borderSize                1 \
    foreColor                 0.5 0.5 0.5 1 \
    backColor                 0 0 0 0 \
    borderColor               0 0 0 0 \
    outlineColor              0 0 0 0 \
    textFont                  UI_FONT_OBJECTIVE \
    textAlign                 ITEM_ALIGN_MIDDLE_RIGHT \
    textAlignX                -25 \
    textScale                 0.33 \
    textStyle                 ITEM_TEXTSTYLE_SHADOWED \
    exp                       text(tableLookup(TRAIL_TABLE, 0, itemID, 4)) \
    visible                   when ( itemID != 1 && (stat(2326) < req_p || (stat(2326) == req_p && stat(252) < req_r)) ) \
    decoration                \
} \
itemDef \
{ \
    rect                      -40 (70 + (19*row)) 300 18 HORIZONTAL_ALIGN_SUBLEFT VERTICAL_ALIGN_SUBTOP \
    borderSize                1 \
    foreColor                 0 0 0 0 \
    backColor                 0 0 0 0 \
    borderColor               0 0 0 0 \
    outlineColor              0 0 0 0 \
    type                      ITEM_TYPE_BUTTON \
    textScale                 0.55 \
    action                    { play mouse_click; setLocalVarInt ui_highlight_trail itemID; scriptMenuResponse itemID; } \
    onFocus                   { play mouse_over; setLocalVarInt ui_hover_trail itemID; } \
    leaveFocus                { setLocalVarInt ui_hover_trail 0; } \
    visible                   1 \
}
