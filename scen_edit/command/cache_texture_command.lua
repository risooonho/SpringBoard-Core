CacheTextureCommand = AbstractCommand:extends{}
CacheTextureCommand.className = "CacheTextureCommand"

function CacheTextureCommand:init(texture)
    self.className = "CacheTextureCommand"
    self.texture = texture
end

function CacheTextureCommand:execute()
    local cmd = WidgetCacheTextureCommand(self.texture)
    SCEN_EDIT.commandManager:execute(cmd, true)
end

WidgetCacheTextureCommand = AbstractCommand:extends{}
WidgetCacheTextureCommand.className = "WidgetCacheTextureCommand"

function WidgetCacheTextureCommand:init(texture)
    self.className = "WidgetCacheTextureCommand"
    self.texture = texture
end

function WidgetCacheTextureCommand:execute()
	for _, tex in pairs(self.texture) do
		SCEN_EDIT.model.textureManager:CacheTexture(tex)
	end
end