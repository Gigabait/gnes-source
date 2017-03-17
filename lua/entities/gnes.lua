AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "GNES"
ENT.Author = "TotallyOriginal"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category = "TotallyOriginal"

canRun = false
gameRunning = false

if (CLIENT) then
	ENT.Mat = nil
	ENT.Panel = nil
	
	if(!file.Exists("gnes", "DATA")) then
		file.CreateDir("gnes")
	end
end

function ENT:Initialize()
	if(SERVER) then
		self:SetModel("models/props_phx/rt_screen.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetNWEntity("creator", self:GetCreator())
	end
	
	timer.Create("cc", 0.1, 0, function()
		if CLIENT then
			if(self:GetNWEntity("creator") == LocalPlayer() and canRun == false) then
				canRun = true
				self.Mat = nil
				self.Panel = nil
				htmlframe = nil
				self:OpenPage()
				self:ExpandMenu()
			end
		end
	end)
end

function ENT:OpenPage()
	if (CLIENT && canRun) then
		if(htmlframe) then
			htmlframe:Remove()
			htmlframe = nil
		end
		
		dframe = vgui.Create("DFrame")
		dframe:SetSize(600, 400)
		dframe:MakePopup()
		dframe:SetTitle("GNES")
		dframe:ShowCloseButton(false)
		dframe:SetDeleteOnClose(true)
		dframe:SetPos(100, 100)
		
		local closebutton = vgui.Create("DButton", dframe)
		closebutton:SetSize(150, 25)
		closebutton:SetPos(225, 350)
		closebutton:SetText("Minimize windows")
		closebutton.DoClick = function()
			Minimize()
		end
		
		webframe = vgui.Create("DFrame")
		webframe:SetSize(400, 400)
		webframe:MakePopup()
		webframe:SetTitle("Controls")
		webframe:SetDeleteOnClose(false)
		webframe:ShowCloseButton(false)
		webframe:SetPos(100, 550)
		webframe:SetMouseInputEnabled(true)
		webframe:SetKeyboardInputEnabled(true)
		
		local helpframe = vgui.Create("DFrame")
		helpframe:SetSize(500, 500)
		helpframe:MakePopup()
		helpframe:SetTitle("Help page")
		helpframe:SetDeleteOnClose(false)
		helpframe:Center()
		helpframe:Hide()
		
		local howlabel = vgui.Create("DLabel", helpframe)
		howlabel:SetPos(230, -200)
		howlabel:SetSize(500, 500)
		howlabel:SetBright(1)
		howlabel:SetText([[How to use:]])
		
		local helplabel = vgui.Create("DLabel", helpframe)
		helplabel:SetPos(20, -100)
		helplabel:SetSize(500, 500)
		helplabel:SetText([[1. You must own a legal copy of what ever game you download, I do not condone piracy. 
		2. Download an NES game to play (there are many websites to get .nes ROMS, I 
		recommend emuparadise.me). 
		3. Upload your .nes file to Dropbox, you can create a free acount if you haven't already. 
		4. Once your file is done uploading, click on the "Share" button next to it. 
		5. A window will pop up, click "Copy Link". 
		6. Go back into Gmod and paste that link in the "Enter ROM URL" box in GNES
		and name your game.
		7. Replace "www.dropbox.com" with "dl.dropboxusercontent.com" 
		8. Now select the game you saved from the My Games dropdown and have fun! ]])
		
		local knownlabel = vgui.Create("DLabel", helpframe)
		knownlabel:SetPos(220, 0)
		knownlabel:SetSize(500, 500)
		knownlabel:SetBright(1)
		knownlabel:SetText([[Known problems:]])
		
		local bugslabel = vgui.Create("DLabel", helpframe)
		bugslabel:SetPos(20, 50)
		bugslabel:SetSize(500, 500)
		bugslabel:SetText([[-Audio may be off-sync for some people (a problem with JSNES)
		-Some games can't play on the emulator
		-Upon spawning a GNES, pixelated scrollbars show up instead of the game
		-Spawning a GNES in a multiplayer game creates windows for all players]])
		
		local soundww = vgui.Create("DLabel", helpframe)
		soundww:SetPos(205, 100)
		soundww:SetSize(500, 500)
		soundww:SetBright(1)
		soundww:SetText([[The sound isn't working!]])
		
		local soundtxt = vgui.Create("DLabel", helpframe)
		soundtxt:SetPos(20, 150)
		soundtxt:SetSize(500, 500)
		soundtxt:SetText([[If you click Toggle Sound and nothing happens, it is because the sound
		system is Flash-based. To be able to hear in-game sounds, click the link below and copy the
		URL to install Flash NPAPI Plugin in an EXTERNAL BROWSER. Installing in the Steam overlay
		will not work.]])
		
		local flashlink = vgui.Create("DLabelURL", helpframe)
		flashlink:SetPos(20, 430)
		flashlink:SetSize(500, 20)
		flashlink:SetText("Click here to install the Flash NPAPI Plugin.")
		flashlink:SetURL("https://get.adobe.com/flashplayer/otherversions/")
		
		local url = "https://totallyoriginal.github.io/gnes/"
		htmlframe = vgui.Create("DHTML", webframe)
		htmlframe:Dock(FILL)
		htmlframe:OpenURL(url)
		htmlframe:SetAlpha(0)
		htmlframe:SetSize(100, 100)
		htmlframe:SetMouseInputEnabled(true)
		htmlframe:SetKeyboardInputEnabled(true)
		htmlframe:Call([[fitScreen(]] .. (ScrW() / (ScrW() / 1280) * 16) / 80 .. [[,]] .. (ScrW() / (ScrW() / 1280) * 15) / 80 .. [[);]])
		
		local label1 = vgui.Create("DLabel", dframe)
		label1:SetPos(100, 50)
		label1:SetSize(200, 20)
		label1:SetText("Add new game:")
		
		local label2 = vgui.Create("DLabel", dframe)
		label2:SetPos(350, 50)
		label2:SetText("My games:")
		
		local controls = vgui.Create("DLabel", dframe)
		controls:SetPos(100, 20)
		controls:SetSize(500, 500)
		controls:SetText([[Controls:
		
		Left - Left Arrow
		Right - Right Arrow
		Up - Up Arrow
		Down - Down Arrow
		A - X
		B - Z
		Start - Enter
		Select - Ctrl]])
		
		local coninfo = vgui.Create("DLabel", webframe)
		coninfo:SetPos(100, -35)
		coninfo:SetSize(500, 500)
		coninfo:SetText([[Click in this window to recognize key controls.]])
		
		local info = vgui.Create("DLabel", dframe)
		info:SetPos(300, 20)
		info:SetSize(500, 500)
		info:SetText([[To exit the game, simply close this window
		and undo the screen.]])
		
		local gamenamebox = vgui.Create("DTextEntry", dframe)
		local gamename
		gamenamebox:SetText("Enter name...")
		gamenamebox:SetPos(100, 75)
		gamenamebox:SetSize(150, 25)
		gamenamebox.OnChange = function(self)
			gamename = self:GetValue()
		end
		
		local urlbox = vgui.Create("DTextEntry", dframe)
		local url2
		urlbox:SetText("Enter ROM URL...")
		urlbox:SetPos(100, 110)
		urlbox:SetSize(150, 25)
		urlbox.OnChange = function(self)
			url2 = self:GetValue()
		end
		
		local soundbutton = vgui.Create("DButton", dframe)
		soundbutton:SetSize(150, 25)
		soundbutton:SetPos(350, 110)
		soundbutton:SetText("Toggle sound")
		soundbutton.DoClick = function()
			htmlframe:Call([[toggleSound();]])
		end
		
		local infobutton = vgui.Create("DButton", dframe)
		infobutton:SetSize(50, 25)
		infobutton:SetPos(525, 350)
		infobutton:SetText("Help")
		infobutton.DoClick = function()
			helpframe:Show()
			helpframe:FocusNext()
		end
		
		files, directories = file.Find("gnes/*.txt", "DATA")
		
		local gameslist = vgui.Create("DComboBox", dframe)
		gameslist:SetPos(350, 75)
		gameslist:SetSize(150, 25)
		gameslist:SetValue("Load game...")
		gameslist:Clear()
		for i = 1,#files do
			gameslist:AddChoice(files[i])
		end
		function gameslist:OnSelect (index, value, data)
			gameFile = file.Read("gnes/" .. value, "DATA")
			htmlframe:Call([[pleaseLoad(']] .. gameFile .. [[');]])
			gameRunning = true
			print("Successfully loaded file: " .. gameFile)
		end
		
		local savebutton = vgui.Create("DButton", dframe)
		savebutton:SetSize(150, 25)
		savebutton:SetPos(100, 145)
		savebutton:SetText("Save")
		savebutton.DoClick = function()
			tmpgamename = "";
			for i = 1, string.len(gamename) do
				if(gamename:sub(i,i) != ".") then
					tmpgamename = tmpgamename .. gamename:sub(i,i)
				end
			end
			gamename = tmpgamename
			print(tmpgamename)
			gameslist:Clear()
			if(gamename != "" && gamename != "Enter name...") then
				file.Write("gnes/" .. gamename .. ".txt", url2)
				files, directories = file.Find("gnes/*.txt", "DATA")
				for i = 1,#files do
					gameslist:AddChoice(files[i])
				end
				print("Successfully wrote file: " .. gamename .. ".txt")
			end
		end
		
		function htmlframe:ConsoleMessage(msg) end
	end
end

function ENT:ExpandMenu()
	if canRun then
		expandMenu = vgui.Create("DFrame")
		expandMenu:SetPos(ScrW() - 300, ScrH() - 150)
		expandMenu:SetTitle("")
		expandMenu:SetSize(200, 50)
		expandMenu:ShowCloseButton(false)
		expandMenu:MakePopup()
		expandMenu:SetDeleteOnClose(true)
		expandMenu:Hide()
		
		local expandButton = vgui.Create("DButton", expandMenu)
		expandButton:SetSize(150, 25)
		expandButton:SetPos(25, 13)
		expandButton:SetText("Maximize GNES")
		expandButton.DoClick = function()
			Maximize()
		end
	end
end

function ENT:Draw()
	if CLIENT && canRun then
		if(self.Mat) then
			if(render.MaterialOverrideByIndex) then
				render.MaterialOverrideByIndex(1, self.Mat)
			else
				render.MaterialOverrideByIndex(self.Mat)
			end
		elseif (htmlframe && htmlframe:GetHTMLMaterial()) then
			local html_mat = htmlframe:GetHTMLMaterial()
			local scale_x, scale_y = ScrW() / (ScrW() / 1024) / 1500, ScrW() / (ScrW() / 1024) / 2325
			local matdata = {
				["$basetexture"]=html_mat:GetName(),
				["$basetexturetransform"]="center 0.07 0.01 scale"..scale_x.." "..scale_y.." rotate 0 translate -0.1 0.025",
				["$model"]=1
			}
			local uid = string.Replace(html_mat:GetName(),"__vgui_texture_", "")
			self.Mat = CreateMaterial("WebMaterial_"..uid, "UnlitGeneric", matdata)
		end
		/*if (gameRunning == true) then
			local matdata = {
				["$basetexture"]="gm_construct/grass1",
				["$model"]=1
			}
			print("HELO")
			self.Mat = CreateMaterial("GNESIdle", "UnlitGeneric", matdata)
		end*/
		self:DrawModel()
		render.ModelMaterialOverride(nil)
	end
end

function ENT:OnRemove()
	self:SetNWEntity("creator", null)
	canRun = false
	if CLIENT then
		if(htmlframe and webframe and expandMenu) then
		htmlframe:Remove()
		webframe:Remove()
		expandMenu:Remove()
		expandMenu = nil
		end
	end
end

function Maximize()
	webframe:SetKeyboardInputEnabled(true)
	webframe:SetMouseInputEnabled(true)
	webframe:SetPos(100, 550)
	dframe:SetKeyboardInputEnabled(true)
	dframe:SetMouseInputEnabled(true)
	dframe:SetPos(100, 100)
end

function Minimize()
	webframe:SetKeyboardInputEnabled(false)
	webframe:SetMouseInputEnabled(false)
	webframe:SetPos(ScrW(), ScrH())
	dframe:SetKeyboardInputEnabled(false)
	dframe:SetMouseInputEnabled(false)
	dframe:SetPos(ScrW(), ScrH())
end

hook.Add("OnContextMenuOpen", "cmOpen", function()
	if(expandMenu) then
		expandMenu:Show()
	end
end)

hook.Add("OnContextMenuClose", "cmClose", function()
	if(expandMenu) then
		expandMenu:Hide()
	end
end)