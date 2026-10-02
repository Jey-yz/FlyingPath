#reloadable
#priority 2000
import scripts.libs.Craft;
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.util.Math;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.text.ITextComponent;

val ifJEI=JEI.createJei("InFire",game.localize("jei.category.in_fire"));
ifJEI.setModid("crafttweaker");
ifJEI.setIcon(<minecraft:fire_charge>);
ifJEI.addRecipeCatalyst(<minecraft:fire_charge>);
ifJEI.addRecipeCatalyst(<minecraft:flint_and_steel>);
ifJEI.setBackground(IJeiUtils.createBackground(80,55));
ifJEI.addSlot(IJeiUtils.createItemSlot("fire",29,35,true,false));
ifJEI.addSlot(IJeiUtils.createItemSlot("input",5,15,true,true));
ifJEI.addSlot(IJeiUtils.createItemSlot("output",54,13,false,true));
ifJEI.addElement(IJeiUtils.createArrowElement(27,17,0));
ifJEI.register();

function createInFireRecipe(inp as IIngredient, out as IItemStack, time as int, tip as string = null)as void{
    val recipe = JEI.createJeiRecipe("InFire");
    recipe.addInput(<minecraft:flint_and_steel>.or(<minecraft:fire_charge>));
    recipe.addInput(inp);
    recipe.addOutput(isNull(tip)?(out):Craft.addLore(out,tip).items[0]);
    recipe.addElement(IJeiUtils.createFontInfoElement(ITextComponent.fromTranslation("jei.tooltip.in_fire.time", time).formattedText,5,1,0));
    recipe.build();
}

<minecraft:flint_and_steel>.addJEIDes("in_fire");
<minecraft:flint_and_steel>.addJEIDes("in_fire.warning");
<minecraft:fire_charge>.addJEIDes("in_fire");
<minecraft:fire_charge>.addJEIDes("in_fire.warning");