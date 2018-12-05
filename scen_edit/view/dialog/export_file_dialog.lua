SB.Include(Path.Join(SB_VIEW_DIALOG_DIR, "file_dialog.lua"))

ExportFileDialog = FileDialog:extends{}

function ExportFileDialog:init(dir, fileTypes)
    self:super("init", dir, "Export file", fileTypes)

    local minHeight, maxHeight = Spring.GetGroundExtremes()
    self:AddField(GroupField({
        ChoiceField({
            name = "heightmapExtremes",
            title = "Heightmap min/max",    
            items = {"Automatic", "Initial", "Manual"},
        }),
        NumericField({
            name = "minh",
            title = "minh",
            value = minHeight,
            width = 100,
        }),
        NumericField({
            name = "maxh",
            title = "maxh",
            value = maxHeight,
            width = 100,
        }),
    }))
    self:SetInvisibleFields("heightmapExtremes", "minh", "maxh")
end

-- FIXME: DRY
local EXPORT_MAP_TEXTURES = "Map textures"
function ExportFileDialog:OnFieldChange(name, value)
    if name == "fileType" then
        if value == EXPORT_MAP_TEXTURES then
            if self.fields.heightmapExtremes.value == "Manual" then
                self:SetInvisibleFields()
            else
                self:SetInvisibleFields("minh", "maxh")
            end
        else
            self:SetInvisibleFields("heightmapExtremes", "minh", "maxh")
        end
    elseif name == "heightmapExtremes" then
        if value == "Manual" then
            self:SetInvisibleFields()
        else
            self:SetInvisibleFields("minh", "maxh")
        end
    end
end

function ExportFileDialog:GetHeightmapExtremes()
    if self.fields.fileType.value ~= EXPORT_MAP_TEXTURES then
        return
    end

    if self.fields.heightmapExtremes.value == "Automatic" then
        return
    elseif self.fields.heightmapExtremes.value == "Initial" then
        local minHeight, maxHeight = Spring.GetGroundExtremes()
        return {minHeight, maxHeight}
    else
        return {self.fields.minh.value, self.fields.maxh.value}
    end
end

function ExportFileDialog:confirmDialog()
    local filePath = self:getSelectedFilePath()
    --TODO: create a dialog which prompts the user if they want to delete the existing file
    -- TODO: need to add/check extension first
--     if (VFS.FileExists(filePath)) then
--         os.remove(filePath)
--     end
    if self.confirmDialogCallback then
        return self.confirmDialogCallback(filePath,
                                          self.fields.fileType.value,
                                          self:GetHeightmapExtremes())
    end
end
