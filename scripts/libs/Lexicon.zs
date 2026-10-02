#reloadable
import scripts.libs.Misc;
import crafttweaker.item.IItemStack;
import mods.botania.Lexicon;

Lexicon.addTextPage("botania.page.orechidIgnem2","botania.entry.orechidIgnem",2);
Lexicon.addTextPage("botania.page.marimorphosis4","botania.entry.marimorphosis",4);
Lexicon.addTextPage("botania.page.flightTiara7","botania.entry.flightTiara",7);
Lexicon.addTextPage("botania.page.poolCart5","botania.entry.poolCart",5);
Lexicon.addTextPage("botania.page.gaiaRitual5","botania.entry.gaiaRitual",5);
Lexicon.addTextPage("botania.page.relicInfo2","botania.entry.relicInfo",2);
Lexicon.addTextPage("botania.page.incorporeal.naturalDevices3","botania.entry.incorporeal.naturalDevices",3);
Lexicon.addTextPage("botania.page.craftCrate10","botania.entry.craftCrate",10);
Lexicon.addTextPage("botania.page.manaBomb2","botania.entry.manaBomb",2);


val items as IItemStack[] = [<botania:specialflower>.withTag({type: "orechidIgnem"}),<botania:specialflower>.withTag({type: "marimorphosis"}),
    <botania:flighttiara>,<botania:poolminecart>,<botania:dice>,<incorporeal:natural_repeater>,
    <incorporeal:natural_comparator>,<botania:opencrate:1>,<botania:manabomb>];
for item in items{
    item.addTooltips(["lexicon"]);
}
<botania:lexicon>.addTooltips(["lexicon.get"]);


Lexicon.addEntry("botania.entry.marired","botania.category.functionalFlowers",<botania:specialflower>.withTag({type: "marired"}));
Lexicon.addTextPage("botania.page.marired0","botania.entry.marired",0);
Lexicon.addTextPage("botania.page.marired1","botania.entry.marired",1);
Lexicon.addPetalPage("botania.page.marired2", "botania.entry.marired", 2, [<botania:specialflower>.withTag({type: "marired"})], [[<draconicevolution:entity_detector:1>,<botania:endereyeblock>,<embers:breaker>,<botania:quartztypered:1>,<projecte:matter_block:1>]]);
Lexicon.addRecipeMapping(<botania:specialflower>.withTag({type: "marired"}),"botania.entry.marired",0);
// Lexicon.addRecipeMapping(<botania:floatingspecialflower>.withTag({type: "marired"}),"botania.entry.marired",0);
