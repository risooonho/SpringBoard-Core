LoadCommandWidget = AbstractCommand:extends{}
LoadCommandWidget.className = "LoadCommandWidget"

function LoadCommandWidget:init(path, isZip)
    self.className = "LoadCommandWidget"
    self.path = path
    self.isZip = isZip
end

function LoadCommandWidget:execute()
    local path = self.path
    local isZip = self.isZip
    local modelData, heightMapdata = nil, nil

    if isZip then
        Spring.Echo("Loading archive: " .. path .. " ...")

        if not VFS.FileExists(path, VFS.RAW) then
            Spring.Echo("Archive doesn't exist: " .. path)
            return
        end

        if VFS.UnmapArchive and SCEN_EDIT.loadedArchive ~= nil then
            VFS.UnmapArchive(SCEN_EDIT.loadedArchive)
        end

        VFS.MapArchive(path)
        SCEN_EDIT.loadedArchive = path
        modelData = VFS.LoadFile("model.lua", VFS.ZIP)
        heightmapData = VFS.LoadFile("heightmap.data", VFS.ZIP)
    else
        Spring.Echo("Loading project: " .. path .. " ...")

        if not SCEN_EDIT.DirExists(path, VFS.RAW) then
            Spring.Echo("Project doesn't exist: " .. path)
            return
        end

        modelData = VFS.LoadFile(path .. "/" .. "model.lua", VFS.RAW)
        heightmapData = VFS.LoadFile(path .. "/" .. "heightmap.data", VFS.RAW)

    end

    local loadModelCmd = LoadCommand(modelData)
    local loadMapCmd = LoadMap(heightmapData)

    SCEN_EDIT.commandManager:execute(loadModelCmd)
    SCEN_EDIT.commandManager:execute(loadMapCmd)

    Spring.Echo("Loaded archive.")
end