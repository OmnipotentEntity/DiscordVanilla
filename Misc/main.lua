-- The Joker Loading file

local base_dir = "Misc/"

local file_list = {
  "boss_tag_rework.lua",
}

for _, file in ipairs(file_list) do
    assert(SMODS.load_file(base_dir .. file))()
end
