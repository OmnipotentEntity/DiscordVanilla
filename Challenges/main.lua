-- The Challenges Loading file

local base_dir = "Challenges/"

local file_list = {
  "student_loan_debt.lua"
}

for _, file in ipairs(file_list) do
    assert(SMODS.load_file(base_dir .. file))()
end
