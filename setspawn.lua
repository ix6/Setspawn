-- setspawn script
-- lets players set their own spawn point with !sp or !setspawn in chat
-- doesnt save to file so it resets when server restarts, thats fine for now

if SERVER then

	-- store everyones spawn here, gets cleared on restart
	local spawns = {}

	hook.Add("PlayerSay", "setspawn_chat", function(ply, msg)

		local m = string.lower(string.Trim(msg))

		if m == "!sp" or m == "!setspawn" then

			local pos = ply:GetPos()
			local ang = ply:EyeAngles()

			-- dont want roll messing things up so just zero it
			local a = Angle(ang.p, ang.y, 0)

			spawns[ply:SteamID()] = {pos = pos, ang = a}

			ply:ChatPrint("Setspawn set.")

			return ""  -- hides the message from chat
		end

	end)

	hook.Add("PlayerSpawn", "setspawn_apply", function(ply)

		local data = spawns[ply:SteamID()]
		if not data then return end

		-- small delay otherwise the game overrides the position
		timer.Simple(0, function()
			if IsValid(ply) then
				ply:SetPos(data.pos)
				ply:SetEyeAngles(data.ang)
			end
		end)

	end)

	-- cleanup when they leave so the table doesnt grow forever
	hook.Add("PlayerDisconnected", "setspawn_cleanup", function(ply)
		spawns[ply:SteamID()] = nil
	end)

end