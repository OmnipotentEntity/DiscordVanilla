SMODS.Atlas {
  key = "Stickers",
  path = "Stickers.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
  key = "Chips",
  path = "Chips.png",
	px = 29,
	py = 29
}

local base_dir = "Stakes/"

local file_list = {
  "silver.lua"
}

for _, file in ipairs(file_list) do
    assert(SMODS.load_file(base_dir .. file))()
end
