-- shared


local _entity_name='PinService'
local _=BaseEntity.new(_entity_name, true)
-- local _={}


-- k=follow
-- v={lead,p1,p2}
local _pins={}


local new_pin=function(lead,lead_x,lead_y,follow_x,follow_y)
	local pin={}
	pin.lead=lead
	pin.lead_x=lead_x
	pin.lead_y=lead_y
	pin.follow_x=follow_x
	pin.follow_y=follow_y
	
	return pin
end


-- todo: call from event
-- happens locally.
_.pin=function(lead,follow,lead_x,lead_y,follow_x,follow_y)
	local existing=_pins[follow]
	if existing then
		log("pin update:".._str(pin))
		
		existing.lead=lead
		existing.lead_x=lead_x
		existing.lead_y=lead_y
		existing.follow_x=follow_x
		existing.follow_y=follow_y
	else
		local pin=new_pin(lead,lead_x,lead_y,follow_x,follow_y)
		table.insert(_pins,pin)
		log("pinned new:"..serialize(pin))
	end
end

-- wip should be called when entities finished moving
_.update=function()
	-- wip move pinned entities
	log("pins update")
end


_.unpin=function(follow)
	local existing=_pins[follow]
	if not existing then
		log("warn:unpin when no pin")
		return
	end
	
	_pins[follow]=nil
end



return _