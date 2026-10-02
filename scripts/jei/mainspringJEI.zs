#loader mainspringjei
import scripts.libs.Craft;
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.util.Math;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import native.lumaceon.mods.clockworkphase.ClockworkPhase;
import native.lumaceon.mods.clockworkphase.api.MainspringMetal;
import native.net.minecraftforge.oredict.OreIngredient;

val msJEI=JEI.createJei("Mainspring",game.localize("jei.category.mainspring"));
msJEI.setModid("clockworkphase");
msJEI.setIcon(<clockworkphase:mainspring>);
msJEI.addRecipeCatalyst(<clockworkphase:mainspring>);
msJEI.addRecipeCatalyst(<clockworkphase:clockwork_assembly_table>);
msJEI.setBackground(IJeiUtils.createBackground(80,40));
msJEI.addSlot(IJeiUtils.createItemSlot("input",5,10,true,true));
msJEI.addSlot(IJeiUtils.createItemSlot("output",54,8,false,true));
msJEI.addElement(IJeiUtils.createArrowElement(27,12,0));
msJEI.register();

for n in 0 to ClockworkPhase.MAINSPRING_METAL_DICTIONARY.mainspringMetals.length{
    val metal = ClockworkPhase.MAINSPRING_METAL_DICTIONARY.mainspringMetals[n];
    val ore =  <ore:${metal.metalName}>;
    if(!ore.empty){
        val recipe = JEI.createJeiRecipe("Mainspring");
        recipe.addInput(ore);
        recipe.addOutput(<clockworkphase:mainspring>.withTag({max_tension: metal.metalValue, tension_energy: 0}));
        recipe.build();
    }
}
