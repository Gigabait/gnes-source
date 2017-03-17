AddCSLuaFile()

function SpawnGNES(ply, ent)
	print("Spawned GNES")
	ent:SetNWEntity("creator", ply)
end

hook.Add("PlayerSpawnedSENT", "spawnGNES", SpawnGNES)