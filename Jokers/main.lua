-- The Joker Loading file

SMODS.Atlas {
	key = "Jokers",
	path = "Jokers.png",
	px = 71,
	py = 95
}

local base_dir = "Jokers/"

local file_list = {
  "ninja.lua",
  "template.lua",
  "filibuster.lua",
  -- "chagney.lua",
  "census.lua",
  "hivemind.lua",
  "rollingstone.lua",
  "three_peas_in_a_pod.lua",
  "ascension.lua"
}

for _, file in ipairs(file_list) do
    assert(SMODS.load_file(base_dir .. file))()
end
