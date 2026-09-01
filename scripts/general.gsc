init()
{
	scripts\_eventmanager::init();
	[[level.on]]("connected", ::onPlayerConnected);
	
	level thread scripts\utility\common::load();
	level thread scripts\player_stats::main();
	level thread scripts\cmd::main();
	level thread scripts\_missions::init();
	level thread scripts\splash::init();
	
	thread duffman\onlymode::init();
	thread duffman\kdratio::init();
	thread duffman\killcard::init();
	thread duffman\engine_fixes::init();
	
	thread duffman\_antiafk::init();
	thread duffman\_walls::main();
	
	//level thread scripts\info::init();
}

onPlayerConnected()
{
	self endon("disconnect");
	if(isDefined(self.pers["welcomed"]))
		return;
	
	self thread scripts\menus\customization_load::loadCustomizations();

	self.pers["welcomed"] = true;
	wait 3.0;
	self playLocalSound("welcome");
}