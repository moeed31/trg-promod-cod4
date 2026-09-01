#define CHARACTER(row, column, itemID) \
itemDef \
{ \
	rect			42 238 44 34 BUTTON_ALIGN \
	origin			(48*row) (42*column) \
	style			WINDOW_STYLE_SHADER \
	exp				material(tableLookup(CHAR_TABLE,0,(itemID-40),3)) \
	visible			1 \
	border			1 \
	bordercolor		0 0 0 1 \
	decoration \
} \
itemDef \
{ \
	rect			42 238 44 34 BUTTON_ALIGN \
	origin			(48*row) (42*column) \
	style			WINDOW_STYLE_SHADER \
	background		"black" \
	forecolor		0 0 0 0.8 \
	visible			when(plevel < tableLookup(CHAR_TABLE, 0, (itemID-40), 2)) \
	decoration \
} \
itemDef \
{ \
	visible		when(plevel < tableLookup(CHAR_TABLE, 0 , (itemID-40), 2)) \
	rect		42 238 0 0 BUTTON_ALIGN \
	origin		(48*row) (42*column) \
	textalignx	22 \
	textaligny	22 \
	forecolor	1 1 1 0.8 \
	exp			text("^1P:" + (tableLookup(CHAR_TABLE, 0, (itemID-40), 2) - 1)) \
	textfont	UI_FONT_NORMAL \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.18 \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		42 238 44 34 BUTTON_ALIGN \
	origin		(48*row) (42*column) \
	forecolor	1 1 1 0.8 \
	type		ITEM_TYPE_BUTTON \
	exp			text(" ") \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.32 \
	textalignx	70 \
	textaligny	22 \
	visible		1 /*unlocked*/ \
	mouseEnter \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		scriptMenuResponse itemID; \
	} \
}
