#define alevel (stat(3252))
#define dlevel (stat(3253))
#define SPRAY_TABLE "mp/sprayTable.csv"
#define CHAR_TABLE "mp/characterTable.csv"

#ifndef DR_BUTTON_ALIGN
#define DR_BUTTON_ALIGN HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
#endif

// Donation rank sprays
#define DR_SPRAY( row, column, itemID ) \
itemDef \
{ \
	rect			25 70 48 38 DR_BUTTON_ALIGN \
	origin			(83*row) (45*column) \
	style			WINDOW_STYLE_SHADER \
	exp				material( tableLookup(SPRAY_TABLE, 0, (itemID+30), 3) ) \
	visible			1 \
	border			1 \
	bordercolor		0 0 0 1 \
	decoration \
} \
itemDef \
{ \
	rect			25 70 48 38 DR_BUTTON_ALIGN \
	origin			(83*row) (45*column) \
	style			WINDOW_STYLE_SHADER \
	background		"black" \
	forecolor		0 0 0 0.8 \
	visible			when( dlevel < tableLookup(SPRAY_TABLE, 0, itemID, 5) ) \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		25 70 48 38 DR_BUTTON_ALIGN \
	origin		(83*row) (45*column) \
	forecolor	1 1 1 0.8 \
	type		ITEM_TYPE_BUTTON \
	exp			text( " " ) \
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

// Donation rank skins
#define DR_CHARACTER( row, column, itemID ) \
itemDef \
{ \
	rect			80 205 48 38 DR_BUTTON_ALIGN \
	origin			(83*row) (45*column) \
	style			WINDOW_STYLE_SHADER \
	exp				material( tableLookup(CHAR_TABLE,0,(itemID+11),3) ) \
	visible			1 \
	border			1 \
	bordercolor		0 0 0 1 \
	decoration \
} \
itemDef \
{ \
	rect			80 205 48 38 DR_BUTTON_ALIGN \
	origin			(83*row) (45*column) \
	style			WINDOW_STYLE_SHADER \
	background		"black" \
	forecolor		0 0 0 0.8 \
	visible			when( dlevel < tableLookup(CHAR_TABLE, 0, itemID, 5) ) \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		80 205 48 38 DR_BUTTON_ALIGN \
	origin		(83*row) (45*column) \
	forecolor	1 1 1 0.8 \
	type		ITEM_TYPE_BUTTON \
	exp			text( "  " ) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.2 \
	textalignx	0 \
	textaligny	45 \
	visible     1 \
	mouseEnter \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		scriptMenuResponse itemID; \
	} \
} 

// Award tier sprays
#define RW_SPRAY( row, column, itemID ) \
itemDef \
{ \
	rect			45 85 48 38 DR_BUTTON_ALIGN \
	origin			(50*row) 0 \
	style			WINDOW_STYLE_SHADER \
	exp				material( tableLookup(SPRAY_TABLE, 0,(itemID+30), 3) ) \
	visible			1 \
	border			1 \
	bordercolor		0 0 0 1 \
	decoration \
} \
itemDef \
{ \
	rect			45 85 48 38 DR_BUTTON_ALIGN \
	origin			(50*row) 0 \
	style			WINDOW_STYLE_SHADER \
	background		"black" \
	forecolor		0 0 0 0.8 \
	visible			when( dlevel < 3 || alevel < tableLookup(SPRAY_TABLE, 0,itemID, 5) ) \
	decoration \
} \
itemDef \
{ \
	visible		when( dlevel < 3 || alevel < tableLookup(SPRAY_TABLE, 0,(itemID), 5) ) \
	rect		45 125 0 0 DR_BUTTON_ALIGN \
	origin		(50*row) 0 \
	textalignx	24 \
	textaligny	8 \
	forecolor	1 1 1 0.8 \
	exp			text( "Reward Tier:" + (tableLookup(SPRAY_TABLE, 0,itemID, 5) )) \
	textfont	UI_FONT_NORMAL \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.18 \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		45 85 48 38 DR_BUTTON_ALIGN \
	origin		(50*row) 0 \
	forecolor	1 1 1 0.8 \
	type		ITEM_TYPE_BUTTON \
	exp			text( " " ) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	textalign	ITEM_ALIGN_LEFT \
	textscale	0.32 \
	textalignx	70 \
	textaligny	22 \
	visible		when( dlevel >= 3 ) \
	mouseEnter \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		scriptMenuResponse itemID; \
	} \
} 

// Award tier skins
#define RW_CHARACTER( row, column, itemID ) \
itemDef \
{ \
	rect			45 142 48 38 DR_BUTTON_ALIGN \
	origin			(50*row) 0 \
	style			WINDOW_STYLE_SHADER \
	exp				material( tableLookup(CHAR_TABLE,0,(itemID+11), 3) ) \
	visible			1 \
	border			1 \
	bordercolor		0 0 0 1 \
	decoration \
} \
itemDef \
{ \
	rect			45 142 48 38 DR_BUTTON_ALIGN \
	origin			(50*row) 0 \
	style			WINDOW_STYLE_SHADER \
	background		"black" \
	forecolor		0 0 0 0.8 \
	visible			when( dlevel < 3 || alevel < tableLookup(CHAR_TABLE, 0, itemID, 5) ) \
	decoration \
} \
itemDef \
{ \
	visible		when( dlevel < 3 || alevel < tableLookup(CHAR_TABLE, 0 , itemID, 5) ) \
	rect		45 182 0 0 DR_BUTTON_ALIGN \
	origin		(50*row) 0 \
	textalignx	24 \
	textaligny	8 \
	forecolor	1 1 1 0.8 \
	exp			text( "Reward Tier:" + (tableLookup(CHAR_TABLE, 0, itemID, 5) )) \
	textfont	UI_FONT_NORMAL \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.18 \
	decoration \
} \
itemDef \
{ \
	style		WINDOW_STYLE_FILLED \
	rect		45 142 48 38 DR_BUTTON_ALIGN \
	origin		(50*row) 0 \
	forecolor	1 1 1 0.8 \
	type		ITEM_TYPE_BUTTON \
	exp			text( "  " ) \
	textfont	UI_FONT_NORMAL \
	textstyle	ITEM_TEXTSTYLE_SHADOWED \
	textalign	ITEM_ALIGN_CENTER \
	textscale	0.2 \
	textalignx	0 \
	textaligny	45 \
	visible     when( dlevel >= 3 ) \
	mouseEnter \
	{ \
		play "mouse_over"; \
	} \
	action \
	{ \
		scriptMenuResponse itemID; \
	} \
} 