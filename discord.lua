-- Load jokers

assert(SMODS.load_file("Jokers/main.lua"))()
assert(SMODS.load_file("Consumables/main.lua"))()
assert(SMODS.load_file("Challenges/main.lua"))()

SMODS.current_mod.reset_game_globals = function(run_start)
  -- For ninja, reset hand chips and mult after end of round scoring
  update_hand_text({}, {chips = 0, mult = 0})
end
