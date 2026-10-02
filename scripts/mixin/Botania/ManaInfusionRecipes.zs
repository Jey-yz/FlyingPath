#loader mixin
import native.java.lang.Object;
import native.net.minecraft.init.Blocks;
import native.net.minecraft.item.ItemStack;
import native.vazkii.botania.api.BotaniaAPI;
import native.vazkii.botania.api.recipe.RecipeManaInfusion;

#mixin Mixin
#{targets: "vazkii.botania.common.crafting.ModManaInfusionRecipes"}
zenClass MixinManaInfusionRecipe{

    #mixin Static
    #mixin Redirect{method: "init", at: {value: "INVOKE", target:"vazkii/botania/api/BotaniaAPI.registerManaInfusionRecipe(Lnet/minecraft/item/ItemStack;Ljava/lang/Object;I)Lvazkii/botania/api/recipe/RecipeManaInfusion;", ordinal:12}}
    function modifyGrassSeeds(out as ItemStack,inp as Object, mana as int)as RecipeManaInfusion{
        val recipe = BotaniaAPI.registerManaInfusionRecipe(out,inp,mana);
        recipe.setCatalyst(Blocks.GRASS.getDefaultState());
        return recipe;
    }
    
    #mixin Static
    #mixin Redirect{method: "init", at: {value: "INVOKE", target:"vazkii/botania/api/BotaniaAPI.registerManaInfusionRecipe(Lnet/minecraft/item/ItemStack;Ljava/lang/Object;I)Lvazkii/botania/api/recipe/RecipeManaInfusion;", ordinal:13}}
    function modifyPodzolSeeds(out as ItemStack,inp as Object, mana as int)as RecipeManaInfusion{
        val recipe = BotaniaAPI.registerManaInfusionRecipe(out,inp,mana);
        recipe.setCatalyst(Blocks.DIRT.getStateFromMeta(2));
        return recipe;
    }

    #mixin Static
    #mixin Redirect{method: "init", at: {value: "INVOKE", target:"vazkii/botania/api/BotaniaAPI.registerManaInfusionRecipe(Lnet/minecraft/item/ItemStack;Ljava/lang/Object;I)Lvazkii/botania/api/recipe/RecipeManaInfusion;", ordinal:14}}
    function modifyMycelSeeds1(out as ItemStack,inp as Object, mana as int)as RecipeManaInfusion{
        val recipe = BotaniaAPI.registerManaInfusionRecipe(out,inp,mana);
        recipe.setCatalyst(Blocks.MYCELIUM.getDefaultState());
        return recipe;
    }

    #mixin Static
    #mixin Redirect{method: "init", at: {value: "INVOKE", target:"vazkii/botania/api/BotaniaAPI.registerManaInfusionRecipe(Lnet/minecraft/item/ItemStack;Ljava/lang/Object;I)Lvazkii/botania/api/recipe/RecipeManaInfusion;", ordinal:15}}
    function modifyMycelSeeds2(out as ItemStack,inp as Object, mana as int)as RecipeManaInfusion{
        val recipe = BotaniaAPI.registerManaInfusionRecipe(out,inp,mana);
        recipe.setCatalyst(Blocks.MYCELIUM.getDefaultState());
        return recipe;
    }
}