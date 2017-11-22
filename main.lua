local reactor = peripheral.wrap("BigReactors-Reactor_1") --The reactor's number is shown when connecting to a network
local screen = peripheral.wrap("monitor_1") --Again the number is shown when connecting, if you're connecting by placing it directly to the computor you put the direction compared to the computer's screen
local capBank = peripheral.wrap("title_blockcapacitorbank_name_1") --Again this is shown when connecting
local capacitorNum = 27 --Number of capacitor bank blocks in your setup, this uses a 3x3x3
local screenX = 1 --Starting location of the cursor
local textSize = 1 --Change with the size of your display, made with a 2x4 monitor
local reactorFuelCapacity = 8000 --The capacity of your reactor in milibuckets
local ejecting = false --Tells when to display that waste is being ejected
local ticksps = 4 --Refresh speed in refreshes per second

--Function to print a line to the monitor
function println(text)
	screen.setTextScale(textSize)
	screenX = screenX + 1 --Move down the screen
	screen.write(text) --Prints to screen
	screen.setCursorPos(1, screenX) --Sets the typing location
end

--Loop to monitor
while true do
	screenX = 1 --Reset screen location
	screen.setCursorPos(1, 1)
	screen.clear() --Reset screen
	
	--Checks if the reactor is connected to the computor
	if reactor.getConnected() then
		println("Reactor online")
	else
		println("Reactor offline")
	end
	
	--Check if the reactor is running
	if reactor.getActive() then
		println("Reactor active")
	else
		println("Reactor inactive")
	end
	
	--If numbers aren't aligned I miscounted when transcribing and you should just adjust them
	--They should show up aligned in the editor
	--Show how much power is being produced in kRFs
	local kRTf = reactor.getEnergyProducedLastTick() / 1000
	--15 spaces so the number lines up
	println("kRF/t:               "..kRFt.." kRF/t")
	
	--Show how much power is stored
	local kRFs = (capBank.getEnergyStored() / 1000) * capacitorNum
	--10 spaces
	println("kRF Stored:          "..kRFs.." kRF")
	
	--Show how much fuel is being consumed
	local fut = reactor.getFuelConsumedLastTick()
	--7 spaces
	println("Fuel per tick:       "..fut.." mb")
	
	--Show how much fuel is in the reactor
	local fusi = reactor.getFuelAmount() / 1000
	--9 spaces
	println("Fuel Stored:         "..fusi.." ingots")
	
	--Show how much waste is in the reactor
	local was = reactor.getWasteAmount()
	--8 spaces
	println("Waste Stored:        "..was.." mb")
	
	--Show the percentage of depleted fuel is in the reactor
	local wap = (was / (reactorFuelCapacity - (fusi + was))) * 100
	--1 space
	println("Percentage Depleted: "..wap.."%")
	
	--Show the reactivity of the fuel
	local fpo = reactor.getFuelReactivity()
	--5 spaces
	println("Fuel Reactivity:     "..fpo.."%")
	
	--Check if waste can be dumped
	if was >= 1000 then
		--Tell to display that waste is being dumped
		ejecting = true
		reactor.doEjectWaste()
	elseif ejectCount < ticksps * 5 then --Shows for 5 seconds
		ejectCount = ejectCount + 1 --Increment counter
	else
		--Reset when the counter finishes
		ejectCount = 0
		ejecting = false
	end
	
	--Show ejecting message
	if ejecting then
		println("Ejecting Waste")
	end
	
	--Delay for the refresh rate
	os.sleep(1 / ticksps)
end