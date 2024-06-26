local baseUri = "https://raw.githubusercontent.com/Like475/GPod/main/"
local files = { "help", "play", "save", "startup", "setvolume" }

term.clear()

for _, file in pairs(files) do
	print("Downloading program '" .. file .. "'...")

	local fileInstance = fs.open(file .. ".lua", "w")
	local response = http.get(baseUri .. file .. ".lua")

	fileInstance.write(response.readAll())
	fileInstance.close()
end

local updateUri = "https://raw.githubusercontent.com/Like475/GPod/main/version.txt"

local updateResponse = http.get(updateUri)
local updateFile = fs.open("version.txt", "w")

updateFile.write(updateResponse.readAll())

print("Installation complete! Please restart your GPod.")
