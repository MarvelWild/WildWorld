# Profile.lua
profile.lua is a small, non-intrusive module for finding bottlenecks in your Lua code.
The profiler is used by making minimal changes to your existing code.
Basically, you require the profile.lua file and specify when to start or stop collecting data.
Once you are done profiling, a report is generated, describing:
- which functions were called most frequently
- how much time was spent executing each function

# Limitations
Calling functions is slower while profiling so make sure to disable it in production code.
Hooking C functions is not very useful but you don't really need to profile those anyways.
The profiler uses a lot of Lua memory so make sure your GC is not disabled.

# API
## profile.hook(func, label)
Collects data for a given function.
This is used if you want to profile only one specific function.

## profile.hookall(what)
Collects data for functions of a given type.
You can choose which functions should be profiled.
Most of the time, you will be profiling "Lua" or "hooked" functions.
Advanced users can profile "C" or "internal" functions too.

## profile.unhook(func)
Ignores data for a given function.

## profile.report(sort, rows)
Generates a report and returns it as a string.
"sort" determines how the report is sorted, allowed values include "time" or "call".
"rows" limits the number of rows in the report.

## profile.start()
Starts collecting data.

## profile.stop()
Stops collecting data.
For optimal accuracy, this function should be called from code that is NOT being profiled.

## profile.reset()
Resets all collected data.

## profile.setclock(func)
Defines a custom clock function that must return a number.

## profile.combine()
Combines closures to individual rows in the report.

# Examples
## Basic
~~~~
local profile = require("profile")
-- consider "Lua" functions only
profile.hookall("Lua")
profile.start()
-- execute code that will be profiled
profile.stop()
-- report for the top 10 functions, sorted by execution time
local r = profile.report('time', 10)
print(r)
~~~~

## Love2D
~~~~
-- setup
function love.load()
  love.profiler = require('profile') 
  love.profiler.hookall("Lua")
  love.profiler.start()
end

-- generates a report every 100 frames
love.frame = 0
function love.update(dt)
  love.frame = love.frame + 1
  if love.frame%100 == 0 then
    love.report = love.profiler.report('time', 20)
    love.profiler.reset()
  end
end

-- prints the report
function love.draw()
  love.graphics.print(love.report or "Please wait...")
end
~~~~

# Reports
The default report is in plain text:
~~~~
 +-----+----------------------------------+----------+--------------------------+----------------------------------+
 | #   | Function                         | Calls    | Time                     | Code                             |
 +-----+----------------------------------+----------+--------------------------+----------------------------------+
 | 1   | update                           | 1        | 9.0023296745494          | main.lua:23                      |
 | 2   | f                                | 1        | 9.0022503120126          | main.lua:12                      |
 | 3   | g                                | 8        | 8.0016986143455          | main.lua:5                       |
 | 4   | [string "boot.lua"]:185          | 3        | 2.4960798327811e-005     | [string "boot.lua"]:185          |
 | 5   | [string "boot.lua"]:134          | 2        | 1.7920567188412e-005     | [string "boot.lua"]:134          |
 | 6   | [string "boot.lua"]:188          | 1        | 1.6000514733605e-005     | [string "boot.lua"]:188          |
 | 7   | [string "boot.lua"]:182          | 1        | 1.2160395272076e-005     | [string "boot.lua"]:182          |
 | 8   | [string "boot.lua"]:131          | 1        | 1.0240328265354e-005     | [string "boot.lua"]:131          |
 | 9   | load                             | 0        | 0                        | main.lua:17                      |
 +-----+----------------------------------+----------+--------------------------+----------------------------------+
~~~~

It's easy to generate any type of report that you want, for example CSV:

~~~~
print('Position,Function name,Number of calls,Time,Average time per call,Source,')
local n = 1
for func, called, elapsed, source in profiler.query("time", 10) do
  local t = {n, func, called, elapsed, elapsed/called, source }
  print(table.concat(t, ",")..",")
  n = n + 1
end
profiler.reset()
~~~~

Credits
=======
0x25a0
grump
Roland Yonaba