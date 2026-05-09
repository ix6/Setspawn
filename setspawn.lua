if SERVER then

	-- store everyones spawn here, gets cleared on restart
	local spawns = {}

	hook.Add("PlayerSay", "setspawn_chat", function(ply, msg)

		local m = string.lower(string.Trim(msg))

		if m == "!sp" or m == "!setspawn" then

			local pos = ply:GetPos()
			local ang = ply:EyeAngles()

			local a = Angle(ang.p, ang.y, 0)

			spawns[ply:SteamID()] = {pos = pos, ang = a}

			ply:ChatPrint("Setspawn set.")

			return "" 
		end

	end)

	hook.Add("PlayerSpawn", "setspawn_apply", function(ply)

		local data = spawns[ply:SteamID()]
		if not data then return end

		-- small delay 
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
