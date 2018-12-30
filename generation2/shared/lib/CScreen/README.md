# CScreen
A simple way to make resolution-independent Love2D games, by CodeNMore. This allows your game to be resized to any resolution by the user and still keep the aspect ratio and look pretty!

This version (1.3) has been tested (and works!) with LOVE 0.10.1

## Basic Usage
CScreen is very simple to use, and can be implemented in nearly any type of game. Simply place the *cscreen.lua* OR *cscreen.min.lua* file into your game directory, and follow the example below:
```lua
local CScreen = require "cscreen"

function love.load()
	CScreen.init(800, 600, true)
end

function love.draw(dt)
	CScreen.apply()
	-- Draw all of your objects here!
	CScreen.cease()
end

function love.resize(width, height)
	CScreen.update(width, height)
end
```

## Basic Documentation
<table>
	<tr>
		<th>Function</th>
		<th>Parameters</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>init(tw, th, center)</td>
		<td>
			<b>tw</b> (800) the target screen width<br>
			<b>th</b> (600) the target screen height<br>
			<b>center</b> (true) whether or not to letterbox
		</td>
		<td>
			Use <em>tw</em> and <em>th</em> to set the target width and height of the game screen. This defaults to 800 and 600, or a 4:3 screen ratio. Set <em>center</em> to true to center, or letterbox, the game screen (generally this should be true). Usually this is called in <em>love.load()</em>.
		</td>
	</tr>
	<tr>
		<td>update(w, h)</td>
		<td>
			<b>w</b> (int) the new screen width<br>
			<b>h</b> (int) the new screen height
		</td>
		<td>
			This allows CScreen to continue to properly resize the graphics. Usually this is called in <em>love.resize(w, h)</em> passing along the new screen width and height to the update function.
		</td>
	</tr>
	<tr>
		<td>apply()</td>
		<td>
			none
		</td>
		<td>
			Will apply any calculations to properly draw the screen. Usually this is called at the beginning of <em>love.draw(dt)</em>. This function utilizes <em>love.graphics.translate(..)</em> for centering and <em>love.graphics.scale(..)</em> for fitting.
		</td>
	</tr>
	<tr>
		<td>cease()</td>
		<td>
			none
		</td>
		<td>
			Actually draws the letterbox borders using <em>love.graphics.rectangle(..)</em> using the set color (see <em>setColor()</em>), then restores the previously set color. <b>**This is called at the end of <em>love.draw(dt)</em>, as drawing after this line will result in an incorrect ratio!</b>
		</td>
	</tr>
	<tr>
		<td>setColor(r, g, b, a)</td>
		<td>
			<b>r</b> (0) red<br>
			<b>g</b> (0) green<br>
			<b>b</b> (0) blue<br>
			<b>a</b> (255) alpha
		</td>
		<td>
			Sets the color to use for the screen letterbox borders (default is black).
		</td>
	</tr>
</table>