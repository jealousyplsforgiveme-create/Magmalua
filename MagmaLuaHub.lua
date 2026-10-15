-- Magma MM2 loader
local UI_URL = "https://pastebin.com/raw/nr9sFkPX"
local LOGIC_URL = "https://pastebin.com/raw/rfPCRixZ"

local function fetch(url)
	local ok, body = pcall(function()
		return game:HttpGet(url)
	end)
	assert(ok and type(body) == "string" and #body > 0, "could not download " .. url)
	return body
end

xpcall(function()
	local Magma = assert(loadstring(fetch(UI_URL)))()
	getgenv().Magma = Magma
	assert(loadstring(fetch(LOGIC_URL)))()
end, function(err)
	warn("[Magma] failed to start: " .. tostring(err))
	warn(debug.traceback())
end)
