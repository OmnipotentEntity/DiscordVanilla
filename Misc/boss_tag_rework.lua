function uvdm_get_boss_reroll_button()
  local label = {
    localize('b_reroll_boss'),
    {
      ref_table = G.GAME,
      ref_value = 'boss_reroll_button_text',
    }
  }

  uvdm_update_boss_reroll_text()

  if G.GAME.used_vouchers["v_retcon"]
      or G.GAME.used_vouchers["v_directors_cut"]
      or uvdm_get_first_boss_tag() then
    return UIBox_button({
      label = label,
      button = "reroll_boss",
      func = 'reroll_boss_button',
      id = 'boss_reroll_ui'
    })
  end
end

function uvdm_update_boss_reroll_text()
  if G.GAME.used_vouchers["v_retcon"]
      or G.GAME.used_vouchers["v_directors_cut"] then
    G.GAME.boss_reroll_button_text = localize('$')..'10'
  end

  if uvdm_get_first_boss_tag() then
    G.GAME.boss_reroll_button_text = "One Boss Tag"
  end
end

function uvdm_get_first_boss_tag()
  for _,v in ipairs(G.GAME.tags) do
    if v.name == 'Boss Tag' then
      return v
    end
  end
end
