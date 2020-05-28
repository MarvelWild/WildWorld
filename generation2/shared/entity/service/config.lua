-- shared config
-- global Config

local _={}

_.port=4242

-- client uses to connect
-- _.serverHost='ww.o7.by'
-- localhost only
_.serverHost='127.0.0.1'



_.serverFps=60



-- to debug tree
_.fast_grow=true



_.serverListen='127.0.0.1'

-- listens on ipv6 only. 
-- todo: listen all by default (ask community)
-- _.serverListen='*'




-- personal config


-- lan forwarded to internet
-- _.serverListen='192.168.1.195'

-- wifi -//-
--_.serverListen='192.168.1.168'

return _