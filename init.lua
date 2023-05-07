local function autograph(player, sign_to)
    local name = player:get_player_name()
    local stack = player:get_wielded_item()
    local meta = stack:get_meta()
    if stack:get_name() == "" then
        minetest.chat_send_player(name, minetest.colorize("#FF0000", "Wielded item invalid."))
        return
    end
    if meta:get_int("signed?") == 1 then
        minetest.chat_send_player(name, minetest.colorize("#FF0000", "Item/Node has already been signed."))
        return
    end
    local description = stack:get_description()
    local new_description = description .. "\n\nSigned By: " .. name
    local autograph_log = string.format("%s signed an item/node.", name)
    if sign_to ~= nil then
        if not minetest.player_exists(sign_to) then
            minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player in param is not real."))
            return
        end
        if name == sign_to then
            minetest.chat_send_player(name, minetest.colorize("#FF0000", "You can not be the same signer and receiver!"))
            return
        end
        new_description = new_description .. "\nGiven to: " .. sign_to
        autograph_log = autograph_log .. " Signed to: " .. sign_to .. "."
    end
    meta:set_string("description", new_description)
    meta:set_int("signed?", 1)
    player:set_wielded_item(stack)
    minetest.log("ACTION", autograph_log)
end

minetest.register_chatcommand("sign_item", {
    params = "[<sign_to>]",
    description = "Sign your wielded item with your username.",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if param == "" or minetest.is_singleplayer() then
            autograph(player, nil)
        else
            autograph(player, param)
        end
    end
})