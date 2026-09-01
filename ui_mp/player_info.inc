#ifndef PLAYER_INFO_INC
#define PLAYER_INFO_INC

#define PLAYERSTATS_WIDTH 		265

#ifdef PC
	#define PLAYERSTATS_X			((-(PLAYERSTATS_WIDTH - RIGHTITEM_OFFSET))-80)
	#define PLAYERSTATS_Y			103
	#define FRAME_BG_COLOR			0.1 0.1 0.1 0.3
#else
	#define PLAYERSTATS_X			(-(PLAYERSTATS_WIDTH - RIGHTITEM_OFFSET))
	#define PLAYERSTATS_Y			93
	#define FRAME_BG_COLOR			0.1 0.1 0.1 0.3
#endif	

// -----------------------------------------------------
// MOVE BOX TO CENTER OF RIGHT SIDE
// -----------------------------------------------------
// We'll override the typical offsets to put it in the center right.
// The default uses HORIZONTAL_ALIGN_SUBLEFT, but the rects use RIGHTITEM_ALIGN.
// We will change the rects to use HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER below.
#define ORIGIN_PLAYERSTATS 		-280 -190
	
#define LABEL_ITEM_SPACING		18
#define SUB_LABEL_INDENT		16
	
#define LABEL_START_X			12
#define LABEL_START_Y			LABEL_ITEM_SPACING
#define ORIGIN_LABEL			LABEL_START_X LABEL_START_Y

#define LABEL_TEXTCOLOR			0.8 0.8 0.85 0.8
#define LABEL_TITLECOLOR		0.8 0.8 0.85 0.8

#define ORIGIN_LABEL_ITEM( itemNumber ) \
		LABEL_START_X (LABEL_START_Y+(LABEL_ITEM_SPACING*(itemNumber-1))) 

#define ORIGIN_SUB_LABEL_ITEM( itemNumber ) \
		(LABEL_START_X+SUB_LABEL_INDENT) (LABEL_START_Y+(LABEL_ITEM_SPACING*(itemNumber-1))) 
		
#define ORIGIN_DIVIDER( itemNumber ) \
		0 (LABEL_START_Y+(LABEL_ITEM_SPACING/2)+(LABEL_ITEM_SPACING*(itemNumber-1))) 

#define PREPROC_LABEL( ptext, itemNumber ) \
itemDef { \
	text			ptext \
	rect			ORIGIN_LABEL_ITEM( itemNumber ) (PLAYERSTATS_WIDTH) LABEL_ITEM_SPACING HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER \
	origin			ORIGIN_PLAYERSTATS \
	textfont		UI_FONT_NORMAL \
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	textscale		TEXTSIZE_SMALL \
	textalign		ITEM_ALIGN_MIDDLE_LEFT \
	forecolor		LABEL_TITLECOLOR \
	visible			1 \
	decoration }
	
#define PREPROC_DIVIDER( itemNumber ) \
	PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_DIVIDER( itemNumber ) (PLAYERSTATS_WIDTH) 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER, ORIGIN_PLAYERSTATS, "white", 1 1 1 0.1, 0, 0, 0 0 0 0 )

#define PREPROC_SUB_LABEL( ptext, itemNumber ) \
	PREPROC_SUB_LABEL_VIS( ptext, itemNumber, 1 )
	
#define PREPROC_SUB_LABEL_VIS( ptext, itemNumber, visArg ) \
itemDef { \
	text			ptext \
	rect			ORIGIN_SUB_LABEL_ITEM( itemNumber ) (PLAYERSTATS_WIDTH) LABEL_ITEM_SPACING HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER \
	origin			ORIGIN_PLAYERSTATS \
	textfont		UI_FONT_NORMAL \
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	textscale		TEXTSIZE_SMALL \
	textalign		ITEM_ALIGN_MIDDLE_LEFT \
	forecolor		LABEL_TEXTCOLOR \
	visible			visArg \
	decoration }
	
#define PREPROC_VALUE_TEXT( ptext, itemNumber, px_offset, pcolor ) \
		PREPROC_VALUE_TEXT_VIS( ptext, itemNumber, px_offset, pcolor, 1, ITEM_ALIGN_MIDDLE_RIGHT )

#define PREPROC_VALUE_TEXT_LEFT_ALIGNED( ptext, itemNumber, px_offset, pcolor ) \
		PREPROC_VALUE_TEXT_VIS( ptext, itemNumber, px_offset, pcolor, 1, ITEM_ALIGN_MIDDLE_LEFT )
		
#define PREPROC_VALUE_TEXT_VIS( ptext, itemNumber, px_offset, pcolor, visArg, alignment ) \
itemDef { \
	exp				text( ptext ); \
	type			ITEM_TYPE_TEXT \
	rect			ORIGIN_LABEL_ITEM( itemNumber ) (PLAYERSTATS_WIDTH) LABEL_ITEM_SPACING HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER \
	textstyle 		ITEM_TEXTSTYLE_SHADOWED \
	origin			ORIGIN_PLAYERSTATS \
	textfont		UI_FONT_NORMAL \
	textalignx		px_offset \
	textscale		TEXTSIZE_SMALL \
	forecolor		pcolor \
	textalign		alignment \
	visible			visArg \
	decoration }
	
#define PREPROC_RANK_ICON( itemNumber, pshader, y_offset ) \
		PREPROC_RANK_ICON_VIS( itemNumber, pshader, y_offset, 1 )

#define PREPROC_RANK_ICON_VIS( itemNumber, pshader, y_offset, visArg ) \
	PREPROC_SHADER_DRAW_ALIGNED_VIS( (LABEL_START_X+PLAYERSTATS_WIDTH-80) (LABEL_START_Y+y_offset+(LABEL_ITEM_SPACING*(itemNumber-1))) 22 22 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER, ORIGIN_PLAYERSTATS, pshader, 1 1 1 1, 0, 0, 0 0 0 0, visArg )
	
	// UI art
	PREPROC_SHADER_DRAW_ALIGNED( -3 10 (PLAYERSTATS_WIDTH+10) 377 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER, ORIGIN_PLAYERSTATS, "white", 0 0 0 0.5, 0, 0, 0 0 0 0.5 )

#ifdef PC
	#define FRAME_HEIGHT	412
#else
	#define FRAME_HEIGHT	412
#endif

	// =====================================
	// TRG RANK (ls_rank)
	// =====================================
	PREPROC_LABEL( "Rank", 1 )				
	PREPROC_VALUE_TEXT_LEFT_ALIGNED( dvarString("ui_ls_rank_name"), 2, SUB_LABEL_INDENT, LABEL_TITLECOLOR )
	PREPROC_RANK_ICON( 1, dvarString("ui_ls_rank_icon"), -4 )
	
	PREPROC_SUB_LABEL( "RR Required", 3 )
	PREPROC_VALUE_TEXT_VIS( dvarString("ui_ls_rr") + " / " + dvarString("ui_ls_rr_next"), 3, -86, LABEL_TEXTCOLOR, 1, ITEM_ALIGN_MIDDLE_RIGHT )
	
	// Progress Bar BG
	PREPROC_SHADER_DRAW_ALIGNED_VIS( (LABEL_START_X+PLAYERSTATS_WIDTH-80) (LABEL_START_Y+(LABEL_ITEM_SPACING*2)+7) 60 4 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER, ORIGIN_PLAYERSTATS, "white", 0.1 0.1 0.1 0.35, 1, 1, 1 1 1 0.2, 1 )
	// Progress Bar Fill
	itemDef {
		style			WINDOW_STYLE_SHADER
		exp				material( "gradient_fadein" );
		rect			(LABEL_START_X+PLAYERSTATS_WIDTH-80) (LABEL_START_Y+(LABEL_ITEM_SPACING*2)+7) 60 4 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER
		exp				rect W( 60 * ( ( dvarInt("ui_ls_rr") - dvarInt("ui_ls_rr_prev") ) / ( dvarInt("ui_ls_rr_next") - dvarInt("ui_ls_rr_prev") ) ) );
		origin			ORIGIN_PLAYERSTATS
		forecolor		0.95 0.72 0.21 0.8
		visible			1
		decoration
	}
	
	PREPROC_DIVIDER( 4 )
	// Line separator between lists
	

#endif

	// =====================================
	// COD4 LEVEL
	// =====================================
	PREPROC_LABEL( "Level", 5 )				
	PREPROC_VALUE_TEXT_LEFT_ALIGNED( "@"+tablelookup("mp/ranktable.csv",0,stat(252),5), 6, SUB_LABEL_INDENT, LABEL_TITLECOLOR )
	PREPROC_VALUE_TEXT( locString( "@MPUI_LEVEL_N", int(tablelookup("mp/ranktable.csv",0,stat(252),14)) ), 5, -24, LABEL_TITLECOLOR )
	PREPROC_RANK_ICON( 5, tablelookup( "mp/rankIconTable.csv", 0, stat(252), stat(2326)+1 ), -4 )
	
	PREPROC_SUB_LABEL( "@MPUI_XP_PRE", 7 )
	PREPROC_VALUE_TEXT( stat( 2301 ), 7, -24, LABEL_TEXTCOLOR )
	
	PREPROC_DIVIDER( 8 )

	PREPROC_LABEL( "Next Level", 9 )
	/* rank name */
	PREPROC_VALUE_TEXT_VIS( "@"+tablelookup("mp/ranktable.csv",0,stat(252)+1,5), 10, SUB_LABEL_INDENT, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT==0 ), ITEM_ALIGN_MIDDLE_LEFT )
	PREPROC_VALUE_TEXT_VIS( "@MPUI_PRESTIGE", 10, SUB_LABEL_INDENT, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT ), ITEM_ALIGN_MIDDLE_LEFT )
	PREPROC_VALUE_TEXT_VIS( "@MPUI_NONE", 10, SUB_LABEL_INDENT, LABEL_TITLECOLOR, when( CAN_RANK_UP==0 ), ITEM_ALIGN_MIDDLE_LEFT )
	
	/* display level */
	PREPROC_VALUE_TEXT_VIS( locString( "@MPUI_LEVEL_N", int(tablelookup("mp/ranktable.csv",0,stat(252)+1,14)) ), 9, -24, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT==0 ), ITEM_ALIGN_MIDDLE_RIGHT )
	PREPROC_VALUE_TEXT_VIS( locString( "@MPUI_LEVEL_N", 1 ), 9, -24, LABEL_TITLECOLOR, when( CAN_RANK_UP && PRESTIGE_NEXT ), ITEM_ALIGN_MIDDLE_RIGHT )
	
	/* next rank icon */
	PREPROC_RANK_ICON_VIS( 9, tablelookup( "mp/rankIconTable.csv", 0, stat(252)+1, stat(2326)+1 ), -4, when( CAN_RANK_UP && PRESTIGE_NEXT==0 ) )
	PREPROC_RANK_ICON_VIS( 9, tablelookup( "mp/rankIconTable.csv", 0, 0, stat(2326)+2 ), -4, when( CAN_RANK_UP && PRESTIGE_NEXT ) )

	PREPROC_SUB_LABEL_VIS( "@MPUI_XP_REQUIRED_PRE", 11, when( CAN_RANK_UP ) )
	/* standard xp */
	PREPROC_VALUE_TEXT_VIS( int(tableLookup( "mp/rankTable.csv", 0, stat(252), 7) - stat( 2301 )), 11, -86, LABEL_TEXTCOLOR, when( CAN_RANK_UP ), ITEM_ALIGN_MIDDLE_RIGHT )

	PREPROC_SHADER_DRAW_ALIGNED_VIS( (LABEL_START_X+PLAYERSTATS_WIDTH-80) (LABEL_START_Y+(LABEL_ITEM_SPACING*10)+7) 60 4 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER, ORIGIN_PLAYERSTATS, "white", 0.1 0.1 0.1 0.35, 1, 1, 1 1 1 0.2, when( CAN_RANK_UP ) )
	itemDef {
		style			WINDOW_STYLE_SHADER
		exp				material( "gradient_fadein" );
		rect			(LABEL_START_X+PLAYERSTATS_WIDTH-80) (LABEL_START_Y+(LABEL_ITEM_SPACING*10)+7) 60 4 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_CENTER
		exp				rect W( 60 * ( (stat(2301) - int(tableLookup("mp/rankTable.csv",0,stat(252),2))) / int(tableLookup("mp/rankTable.csv",0,stat(252),3)) ) );
		origin			ORIGIN_PLAYERSTATS
		forecolor		1 0.8 0.4 0.8
		visible			when( CAN_RANK_UP )
		decoration
	}
	
	PREPROC_DIVIDER( 12 )	
	PREPROC_LABEL( "@MPUI_SCORE_PRE", 13)	
	PREPROC_VALUE_TEXT( stat(2302), 13, -24, LABEL_TITLECOLOR )	
	
	PREPROC_DIVIDER( 14 )	
	
	PREPROC_LABEL( "Prestige Level", 15)	
	PREPROC_VALUE_TEXT( stat(2326), 15, -24, LABEL_TITLECOLOR )	
	
	PREPROC_DIVIDER( 16 )
	
	PREPROC_LABEL( "@MPUI_KILLS_PRE", 17)
	PREPROC_VALUE_TEXT( stat(2303), 17, -24, LABEL_TITLECOLOR )
	
	PREPROC_LABEL( "@MPUI_DEATHS_PRE", 18)
	PREPROC_VALUE_TEXT( stat(2305), 18, -24, LABEL_TITLECOLOR )
	
	PREPROC_DIVIDER( 19 )	
	PREPROC_LABEL( "@MPUI_TIME_PLAYED_PRE", 20 )	
	PREPROC_VALUE_TEXT( secondsAsTime( stat( 2311 ) + stat( 2312 ) + stat( 2313 ) ), 20, -24, LABEL_TITLECOLOR )
