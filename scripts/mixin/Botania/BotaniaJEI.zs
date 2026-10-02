#loader mixin
import native.net.minecraft.client.Minecraft;
import native.net.minecraft.init.Blocks;
import native.net.minecraft.item.ItemBlock;
import native.net.minecraft.item.ItemStack;
import native.net.minecraftforge.oredict.OreDictionary;
import native.vazkii.botania.api.BotaniaAPI;
import native.vazkii.botania.api.recipe.RecipeBrew;
import native.vazkii.botania.api.recipe.RecipePureDaisy;
import native.java.util.Map;
import native.java.util.Map.Entry;
import native.java.lang.Math;
import native.java.lang.Integer;
import mixin.CallbackInfo;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "vazkii.botania.client.integration.jei.manapool.ManaPoolRecipeWrapper"}
zenClass MixinManaPoolJEI{

    #mixin Inject{method: "drawInfo", at = {value: "RETURN"}}
    function addManaInfo(minecraft as Minecraft, width as int, height as int, mouseX as int, mouseY as int, ci as CallbackInfo)as void{
        minecraft.fontRenderer.drawString("mana:"~this0.mana, 20, 41, 0, false);
    }
}

#mixin Mixin
#{targets: "vazkii.botania.client.integration.jei.runicaltar.RunicAltarRecipeWrapper"}
zenClass MixinRunicAltarJEI{

    #mixin Inject{method: "drawInfo", at = {value: "RETURN"}}
    function addManaInfo(minecraft as Minecraft, width as int, height as int, mouseX as int, mouseY as int, ci as CallbackInfo)as void{
        minecraft.fontRenderer.drawString("mana:"~this0.manaUsage, 6, 89, 0, false);
    }
}

#mixin Mixin
#{targets: "vazkii.botania.client.integration.jei.puredaisy.PureDaisyRecipeWrapper"}
zenClass MixinPureDaisyJEI{

    var time as int;

    #mixin Inject{method: "<init>", at = {value: "RETURN"}}
    function getTime(recipe as RecipePureDaisy, ci as CallbackInfo)as void{
        this.time = recipe.getTime();
    }

    function drawInfo(minecraft as Minecraft, width as int, height as int, mouseX as int, mouseY as int)as void{
        minecraft.fontRenderer.drawString("ticks:"~time*8, 2, 37, 0, false);
    }
}

#mixin Mixin
#{targets: "vazkii.botania.client.integration.jei.brewery.BreweryRecipeWrapper"}
zenClass MixinBreweryJEI{

    var mana as int;

    #mixin Inject{method: "<init>", at = {value: "RETURN"}}
    function getMana(recipe as RecipeBrew, ci as CallbackInfo)as void{
        this.mana = recipe.getManaUsage();
    }

    function drawInfo(minecraft as Minecraft, width as int, height as int, mouseX as int, mouseY as int)as void{
        minecraft.fontRenderer.drawString("mana:"~mana, 78, 44, 0, false);
    }
}

#mixin Mixin
#{targets: "vazkii.botania.client.integration.jei.orechid.OrechidRecipeWrapper"}
zenClass MixinOrechidJEI{

    var isRare as bool;
    var stoneAmount as int;

    #mixin Inject{method: "<init>", at = {value: "RETURN"}}
    function checkWeight(entry as Map.Entry, ci as CallbackInfo)as void{
        val weight = entry.value as Integer;
        this.isRare = weight*64 < this0.getTotalOreWeight();
        this.stoneAmount = Math.round(this0.getTotalOreWeight()/weight);
    }

    #mixin Inject{method: "getInputStack", at = {value: "RETURN"}, cancellable:true}
    function modifyStoneAmount(cir as CallbackInfoReturnable)as void{
        if(isRare){
            cir.setReturnValue(ItemStack(Blocks.STONE, stoneAmount) as ItemStack);
        }
    }

}