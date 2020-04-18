-- todo: tutorial messges
-- todo: start menu
-- todo: image ref/author

local _=BaseEntity.new("splash",true)

local alpha=1

local bgs=
{
	"splash/mira_2020_04_1",
	"splash/mira_2020_04_2",
	"splash/mira_2020_04_3",
	"splash/mira_2020_04_4",
	{"3rd_party/d0b27479e2a7b136d0a49d2850757915","jpg"},
	{"3rd_party/863f8d2e110e53dc834a06724151c0d1","jpg"},
}

local random_bg_data=Pow.lume.randomchoice(bgs)
local ext="png"

local random_bg_name
if type(random_bg_data)=="table" then
	random_bg_name=random_bg_data[1]
	ext=random_bg_data[2]
else
	random_bg_name=random_bg_data
end



--random_bg_name="splash/mira_2020_04_3"

local random_bg=Img.get(random_bg_name,ext)

-- todo: refactor
local _x=0
local _y=0
local w,h=random_bg:getDimensions()

local extra_x=w-512
local extra_y=h-512

if extra_x>0 then
	_x=_x-_rnd(extra_x,extra_x)
end

if extra_y>0 then
	_y=_y-_rnd(extra_y,extra_y)
end


_.drawUnscaledUi=function()
	
	
--	local gw,gh=love.graphics.getDimensions()
--	local sx = gw / w
--	local sy = gh / h

----	love.graphics.draw(random_bg,0,0)
	
--	local max_s=math.max(sx,sy)
--	local min_s=math.min(sx,sy)
	
--	love.graphics.draw(random_bg, 0, 0, 0, min_s,min_s)
	love.graphics.setColor( 1, 1, 1, alpha )
	love.graphics.draw(random_bg, _x, _y, 0)
	love.graphics.setColor( 1, 1, 1, 1 )
end



local _frame_started=nil
_.update=function(dt,splash)
	local frame=_frm()
	
--	log("splash frame:"..frame)
	
	-- test with frame load: client doesn't load frame number
	if frame>60 then
		alpha=alpha-0.04
		if alpha<0 then
			-- wip destroy
			Entity.remove(splash)
		end
		
	end
	
end



return _