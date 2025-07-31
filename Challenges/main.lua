-- The Challenges Loading file

-- Set up the table to hold the win condition functions
-- (We do this to avoid storing the functions directly in G.GAME.modifications,
-- which causes a crash when saving games)
G.win_conds = {}

local base_dir = "Challenges/"

local file_list = {
  "student_loan_debt.lua",
  "reconstruction.lua"
}

for _, file in ipairs(file_list) do
    assert(SMODS.load_file(base_dir .. file))()
end
