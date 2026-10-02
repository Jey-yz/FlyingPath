#reloadable
#priority -1
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.util.Math;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.text.ITextComponent;

val ardJEI=JEI.createJei("AdvancedRitualDust",game.localize("jei.category.advanced_ritual_dust"));
ardJEI.setModid("crafttweaker");
ardJEI.setIcon(<contenttweaker:demon_core>);
ardJEI.addRecipeCatalyst(<contenttweaker:demon_core>);
ardJEI.addRecipeCatalyst(<contenttweaker:ritual_dust:1>);
ardJEI.setBackground(IJeiUtils.createBackground(0,0,80,40,"contenttweaker:textures/gui/WorldInteraction_JEI.png"));
ardJEI.addSlot(IJeiUtils.createItemSlot("inputDust",23,3,true,true));
ardJEI.addSlot(IJeiUtils.createItemSlot("inputBlock",3,21,true,true));
ardJEI.addSlot(IJeiUtils.createItemSlot("output",53,13,false,true));
ardJEI.register();

function createAdvancedRitualDust(block as IIngredient, out as string)as void{
    val recipe = JEI.createJeiRecipe("AdvancedRitualDust");
    recipe.addInput(<contenttweaker:ritual_dust:1>);
    recipe.addInput(block);
    recipe.addOutput(<minecraft:spawn_egg>.withTag({EntityTag: {id: out}}));
    recipe.build();
}
createAdvancedRitualDust(<minecraft:beacon>,"lightningcraft:underworld_ghast");
createAdvancedRitualDust(<collision:wither_altar>,"lightningcraft:underworld_ghast");
createAdvancedRitualDust(<minecraft:packed_ice>,"lightningcraft:underworld_slime");
createAdvancedRitualDust(<minecraft:ice>,"lightningcraft:underworld_slime");
createAdvancedRitualDust(<minecraft:slime>,"lightningcraft:underworld_slime");
createAdvancedRitualDust(<minecraft:tnt>,"lightningcraft:underworld_creeper");
createAdvancedRitualDust(<lightningcraft:under_tnt:1>,"lightningcraft:underworld_creeper");
createAdvancedRitualDust(<lightningcraft:light_block:0>,"lightningcraft:underworld_creeper");
createAdvancedRitualDust(<lightningcraft:stone_block:6>,"lightningcraft:underworld_skeleton");
createAdvancedRitualDust(<lightningcraft:under_sand>,"lightningcraft:underworld_skeleton");
createAdvancedRitualDust(<lightningcraft:corrupt_stone>,"lightningcraft:underworld_skeleton");
val normal_dust_recipe = JEI.createJeiRecipe("AdvancedRitualDust");
normal_dust_recipe.addInput(<contenttweaker:ritual_dust>);
normal_dust_recipe.addOutput(<minecraft:spawn_egg>.withTag({EntityTag: {id: "lightningcraft:demon_soldier"}}));
normal_dust_recipe.build();

val drsJEI=JEI.createJei("DemonRitualSacrifice",game.localize("jei.category.demon_ritual_sacrifice"));
drsJEI.setModid("crafttweaker");
drsJEI.setIcon(<contenttweaker:demon_core>);
drsJEI.addRecipeCatalyst(<contenttweaker:demon_core>);
drsJEI.setBackground(IJeiUtils.createBackground(80,40));
drsJEI.addSlot(IJeiUtils.createItemSlot("input",32,5,true,true));
drsJEI.register();

for i,j in scripts.contenttweaker.DemonCore.fuels{
    val recipe = JEI.createJeiRecipe("DemonRitualSacrifice");
    val inp = i.split(":");
    recipe.addInput(itemUtils.getItem(inp[0]~":"~inp[1],((inp.length>2)?(inp[2]as int):0)));
    recipe.addElement(IJeiUtils.createFontInfoElement(ITextComponent.fromTranslation("jei.tooltip.demon_ritual_sacrifice.point", j).formattedText,0,28,0));
    recipe.build();
}