-- The consumable loading file

SMODS.Atlas {
	key = "Consumables",
	path = "Consumables.png",
	px = 71,
	py = 95
}

local base_dir = "Consumables/"

local file_list = {"chimera.lua"}

for _, file in ipairs(file_list) do
    assert(SMODS.load_file(base_dir .. file))()
end
