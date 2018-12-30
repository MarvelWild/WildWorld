local _=
{
	frame=0,
	windowHeight=512,
	windowWidth=512,
	scale=Config.scale,
	uiScale=Config.scale,
	isClient=false,
	login="defaultLogin",
	selectedEntity=nil,
	hasErrors=false,
	hasWarnings=false,
	
	-- ожидался бинд на всех интерфейсах, но поднимается только на Ipv6
	-- поэтому решено пока что просто через командную строку это передавать из хамачи, и дальше не морочиться
	serverBindAddress="*",
	port="8421",
}

return _