-- Load directories

local dir_list = {
  "Jokers",
  "Consumables",
  "Challenges",
  "Misc",
  "Stakes"
}

local main_file = "main.lua"

for _, dir_name in ipairs(dir_list) do
    assert(SMODS.load_file(dir_name .. "/" .. main_file))()
end

SMODS.current_mod.reset_game_globals = function(run_start)
  -- For ninja, reset hand chips and mult after end of round scoring
  update_hand_text({}, {chips = 0, mult = 0})
  -- For You're It, reset the card chosen
  uvdm_reset_youre_it_card()
end
