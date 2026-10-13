-- Magma MM2 loader: pulls the UI library and the logic from your two pastes at runtime.
local UI_URL = "https://pastebin.com/raw/811JMCy1"
local LOGIC_URL = "https://pastebin.com/raw/AzmRKfEZ"

if _G.MagmaMM2Cleanup then
	pcall(_G.MagmaMM2Cleanup)
	task.wait(0.5)
end

-- Shut down the old F$VL (WindUI) script if it is still running or in autoexec, so only Magma is on screen.
pcall(function()
	if _G.FVLV2Cleanup then
		_G.__FVLReloading = true
		pcall(_G.FVLV2Cleanup)
		_G.__FVLReloading = nil
	end

	if _G.FVLV2 and _G.FVLV2.Destroy then
		pcall(function()
			_G.FVLV2:Destroy()
		end)
	end

	_G.FVLV2, _G.FVLV2Cleanup = nil, nil

	for _, container in ipairs({ (type(gethui) == "function" and gethui()) or false, game:GetService("CoreGui") }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child.Name == "WindUI" or child.Name:match("^WindUI/") or child.Name == "FVLESP" or child.Name == "FVLCard" then
					child:Destroy()
				end
			end
		end
	end
end)

local function fetch(url)
	local ok, body = pcall(function()
		return game:HttpGet(url)
	end)

	assert(ok and type(body) == "string" and #body > 0, "could not download " .. url)
	return body
end

local function magmaMain()
	local Magma = assert(loadstring(fetch(UI_URL)))()
	getgenv().Magma = Magma -- the logic paste refers to a bare `Magma` global
	assert(loadstring(fetch(LOGIC_URL)))()
end

xpcall(magmaMain, function(err)
	warn("[Magma] failed to start: " .. tostring(err))
	warn(debug.traceback())
end)
