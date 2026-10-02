#reloadable
#priority 2000
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.util.Math;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;

val bcJEI=JEI.createJei("BeaconConversion",game.localize("jei.category.beacon_conversion"));
bcJEI.setModid("crafttweaker");
bcJEI.setIcon(<minecraft:beacon>);
bcJEI.addRecipeCatalyst(<minecraft:beacon>);
bcJEI.setBackground(IJeiUtils.createBackground(80,70));
bcJEI.addSlot(IJeiUtils.createItemSlot("beacon",29,35,true,false));
bcJEI.addSlot(IJeiUtils.createItemSlot("input",5,15,true,true));
bcJEI.addSlot(IJeiUtils.createItemSlot("output",54,13,false,true));
bcJEI.addElement(IJeiUtils.createArrowElement(27,17,0));
bcJEI.register();

function createBeaconConversionRecipe(inp as IIngredient, out as IItemStack, time as int,chance as double = 0)as void{
    val recipe = JEI.createJeiRecipe("BeaconConversion");
    recipe.addInput(<minecraft:beacon>);
    recipe.addInput(inp);
    recipe.addOutput(out);
    recipe.addElement(IJeiUtils.createFontInfoElement(game.localize("jei.tooltip.beacon_conversion.time")~time~" ticks",10,1,0));
    if(chance!=0){
        recipe.addElement(IJeiUtils.createFontInfoElement(game.localize("jei.tooltip.beacon_conversion.consume")~Math.round(chance*100)~"%",10,55,0));
    }
    recipe.build();
}

<minecraft:beacon>.addJEIDes("beacon_conversion");