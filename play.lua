local args = { ... }

local dfpwm = require("cc.audio.dfpwm")
local speakers = { peripheral.find("speaker") }
local decoder = dfpwm.make_decoder()
local uri = nil
local volume = settings.get("gpod.volume")
local selectedSong = nil
if args[1] == nil then
	print("Invalid syntax!")
	error("Correct syntax: play <song name>")
else
	selectedSong = args[1]
end
local savedSongs = fs.list("songs/")

if #savedSongs == 0 then
	error("ERR - You don't have any songs")
else
	local fp = "songs/" .. selectedSong
	if fs.exists(fp) then
		local file = fs.open(fp, "r")
		uri = file.readAll()
		file.close()
	else
		print("Song was not found on device!")
		return
	end
end

if uri == nil or not uri:find("^https") then
	print("ERR - Invalid URI!")
	return
end

function playChunk(chunk)
	local returnValue = nil
	local callbacks = {}

	for i, speaker in pairs(speakers) do
		if i > 1 then
			table.insert(callbacks, function()
				speaker.playAudio(chunk, volume or 1.0)
			end)
		else
			table.insert(callbacks, function()
				returnValue = speaker.playAudio(chunk, volume or 1.0)
			end)
		end
	end

	parallel.waitForAll(table.unpack(callbacks))
	return returnValue
end

print("Playing '" .. selectedSong .. "' at volume " .. (volume / 3 * 100) .. "%")

local quit = false

function play()
	while true do
		local response = http.get(uri, nil, true)

		local chunkSize = 4 * 1024
		local chunk = response.read(chunkSize)
		while chunk ~= nil do
			local buffer = decoder(chunk)

			while not playChunk(buffer) do
				os.pullEvent("speaker_audio_empty")
			end

			chunk = response.read(chunkSize)
		end
	end
end

function readUserInput()
	local commands = {
		["stop"] = function()
			quit = true
		end
	}

	while true do
		local input = string.lower(read())
		local commandName = ""
		local cmdargs = {}

		local i = 1
		for word in input:gmatch("%w+") do
			if i > 1 then
				table.insert(cmdargs, word)
			else
				commandName = word
			end
		end

		local command = commands[commandName]
		if command ~= nil then
			command(table.unpack(cmdargs))
		else print('"' .. cmdargs[1] .. '" is not a valid command!') end
	end
end

function waitForQuit()
	while not quit do
		sleep(0.1)
	end
end

parallel.waitForAny(play, readUserInput, waitForQuit)
