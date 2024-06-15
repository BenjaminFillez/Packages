--[[
  Module script permettent de stocker un message transformer html ou plutot message fait av
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

--[=[
	@Dummy
	
	Create a html string using rich text markup.
	
	@Examples:
	
	local MessageModule = require(somewhere.Message)
	
	local message = MessageModule.new(
		prefix = "This is" -- text before the colored part : @Optional
		message = "a message"  -- colored text 
		suffix = "with a suffix" -- text after the colored part : @Optional
		color = "rgb(255,0,0)"  -- color <[Don't use Color3.fromRGB()]/>
		style = "b" -- change the style of the colored message : @Optional
	)
	
	print(message:Get()) -- the message can be edited outside the module
	
	message:Clean() -- destroy the message
]=]

export type Message<T> = {
	Info : {}
}

local module = {}
module.__index = module


local function Combine(info)
	local message:Message<T> = {
		Info = info
	}
	return message
end


function module.new<T>(info : T) : Message<T>
	--[=[
		create a string with the given message
	]=]
	
	local self = setmetatable({},module)
	self._memory = Combine(info)
	
	if not info.style then
		if info.prefix and info.suffix then
			self.htmlMessage = `{info.prefix} <font color="{info.color}"> {info.message} </font> {info.suffix}`
		elseif info.prefix and not info.suffix then
			self.htmlMessage = `{info.prefix} <font color="{info.color}"> {info.message} </font>`
		elseif info.suffix and not info.prefix then
			self.htmlMessage = `<font color="{info.color}"> {info.message} </font> {info.suffix}`
		else
			self.htmlMessage = `<font color="{info.color}"> {info.message} </font>`
		end	
	else
		if info.prefix and info.suffix then
			self.htmlMessage = `<{info.style}>{info.prefix} <font color="{info.color}"> {info.message} </font> {info.suffix}</{info.style}>`
		elseif info.prefix and not info.suffix then
			self.htmlMessage = `<{info.style}>{info.prefix} <font color="{info.color}"> {info.message} </font></{info.style}>`
		elseif info.suffix and not info.prefix then
			self.htmlMessage = `<{info.style}><font color="{info.color}"> {info.message} </font> {info.suffix}</{info.style}>`
		else
			self.htmlMessage = `<{info.style}><font color="{info.color}"> {info.message} </font></{info.style}>`
		end		
	end
	
	self._memory.Info.result = self.htmlMessage
	
	return self		
end

function module:Get()
	-- get the created message
	if self.htmlMessage then
		return self.htmlMessage
	end
end

function module:Clean()
	-- clean self and the message
	
	if self.htmlMessage then
		self.htmlMessage = nil
		table.clear(self)
		self = nil
	end
end

return module
