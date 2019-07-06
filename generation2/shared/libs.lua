-- connect all the libs
Pow=require "shared.lib.powlov.pow"
Img=require "shared.res.img"
Flux=Pow.flux

Entity=Pow.entity
BaseEntity=Pow.baseEntity


Movable=require "shared.entity.movable"

-- shortcuts
log=Pow.debug.log
draw=love.graphics.draw

serialize=Pow.pack
deserialize=Pow.unpack
_ets=Entity.toString
