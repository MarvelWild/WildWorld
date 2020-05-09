-- shared config
-- global Config

local _={}

_.port=4242

-- client uses to connect
_.serverHost='ww.o7.by'
-- localhost only
--_.serverListen='ww.o7.by'

--_.serverHost='127.0.0.1'
_.serverListen='127.0.0.1'

-- _.serverHost='109.207.194.113'
-- _.serverListen='109.207.194.113'
-- _.serverListen='192.168.1.195'


_.serverFps=60



-- to debug tree
_.fast_grow=true

-- listens on ipv6
-- _.serverListen='*'

-- todo: listen all by default
-- ask community
-- forwarded to internet
_.serverListen='192.168.1.195'

-- my wifi routed
_.serverListen='192.168.1.168'

return _