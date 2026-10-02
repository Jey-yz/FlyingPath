#reloadable
#priority 10000005
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;

var ltJEI = JEI.createJei("LightningTransform",game.localize("jei.category.lightning_transform"));
ltJEI.setModid("lightningcraft");
ltJEI.setIcon(<projecte:item.pe_wind_projectile>);
ltJEI.addRecipeCatalyst(<lightningcraft:golf_club>);
ltJEI.addRecipeCatalyst(<lightningcraft:golf_club_gold>);
ltJEI.addRecipeCatalyst(<projecte:item.pe_swrg>);
ltJEI.setBackground(IJeiUtils.createBackground(135, 80));
ltJEI.addSlot(IJeiUtils.createItemSlot(13, 13, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(32, 13, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(51, 13, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(13, 32, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(32, 32, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(51, 32, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(13, 51, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(32, 51, true));
ltJEI.addSlot(IJeiUtils.createItemSlot(51, 51, true));
ltJEI.addElement(IJeiUtils.createArrowElement(72,33,0));
ltJEI.addSlot(IJeiUtils.createItemSlot(100, 30, false));
ltJEI.register();

function createLightningTransformingRecipe(out as IItemStack, ins as IIngredient[])as void{
    val recipe = JEI.createJeiRecipe("LightningTransform");
    for i in ins{
        recipe.addInput(i);
    }
    recipe.addOutput(out);
    recipe.build();
}

createLightningTransformingRecipe(<lightningcraft:ingot>,[<ore:ingotIron>,<ore:ingotGold>,<ore:gemDiamond>]);
createLightningTransformingRecipe(<lightningcraft:material:11>,[<ore:ingotSkyfather>,<lightningcraft:material:5>,<ore:gemEmerald>]);