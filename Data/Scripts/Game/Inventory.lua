inventory = {
    stone=32, dirt=0, clay=0, quarry=1
}

function Behavior:Update()
    local stone = CS.FindGameObject("Stone"):GetComponent("ModelRenderer")
    local stoneText = CS.FindGameObject("StoneCount"):GetComponent("TextRenderer")
    local dirt = CS.FindGameObject("Dirt"):GetComponent("ModelRenderer")
    local dirtText = CS.FindGameObject("DirtCount"):GetComponent("TextRenderer")
    local clay = CS.FindGameObject("Clay"):GetComponent("ModelRenderer")
    local clayText = CS.FindGameObject("ClayCount"):GetComponent("TextRenderer")
    local quarry = CS.FindGameObject("Quarry"):GetComponent("ModelRenderer")
    local quarryText = CS.FindGameObject("QuarryCount"):GetComponent("TextRenderer")
        
    if inventory.dirt > 0 then
        dirt:SetOpacity("1")
        dirtText:SetText(inventory.dirt)
    else
        dirt:SetOpacity("0")
    end
    
    if inventory.stone > 0 then
        stone:SetOpacity("1")
        stoneText:SetText(inventory.stone)
    else
        stone:SetOpacity("0")
    end
    
    if inventory.clay > 0 then
        clay:SetOpacity("1")
        clayText:SetText(inventory.clay)
    else
        clay:SetOpacity("0")
    end
    
    --if inventory.quarry > 0 then
        quarry:SetOpacity("1")
        quarryText:SetText(inventory.quarry)
    --[[else
        quarry:SetOpacity("0")
    end]]
end
