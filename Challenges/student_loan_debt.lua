G.localization.misc.v_text.ch_c_student_loan_debt_win_cond={
  "Must finish {C:attention}Ante 8{} with {C:money}$0{} or more."
}

G.win_conds.student_loan_debt = function()
  return G.GAME.dollars >= 0
end

SMODS.Challenge {
  key = "student_loan_debt",
  loc_txt = {
    name = "Student Loan Debt",
  },

  rules = {
    custom = {
      {id = "go_deep_into_debt"},
      {id = "student_loan_debt_win_cond"},
      {
        id = "win_condition",
        value = "student_loan_debt",
      },
    },
    modifiers = {
      {
        id = "dollars",
        value = -200,
      },
    },
  },

  jokers = {
    {id = "j_scholar"},
    {id = "j_ramen"},
  },

  restrictions = {
    banned_cards = {
      {id = "c_wraith"}
    },

    banned_other = {
      {
        id = "bl_ox",
        type = "blind",
      },
    },
  },

  deck = {
    type = "Challenge Deck",
  },
}
