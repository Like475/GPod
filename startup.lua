term.clear()

settings.define("gpod.volume", {
	description = "The volume to play songs at.",
	default = 1.0,
	type = "number"
})

print("Welcome to the GPod!")

print("")

print("")

if peripheral.find("speaker") == nil then
	print("ERR - Speaker not found!")
else
	local speaker = peripheral.find("speaker")
	local instr = "bell"

	speaker.playNote(instr, 3, 4)
	sleep(0.3)
	speaker.playNote(instr, 3, 8)
	sleep(0.3)
	speaker.playNote(instr, 3, 15)
	sleep(0.3)
	speaker.playNote(instr, 3, 16)
	sleep(0.5)

	speaker.playNote(instr, 3, 4)
	sleep(0.01)
	speaker.playNote(instr, 3, 8)
	sleep(0.01)
	speaker.playNote(instr, 3, 15)
	sleep(0.01)
	speaker.playNote(instr, 3, 16)
	sleep(0.01)
end

print("")

print("To save songs, they need to be converted to the DFPWMA audio format and uploaded to a static hosting site. For more information on this, enter 'help saving'.")

if fs.exists("download.lua") then fs.delete("download.lua") end
if fs.exists("install.lua") then fs.delete("install.lua") end
if fs.exists("download") then fs.delete("download") end
if fs.exists("install") then fs.delete("install") end
