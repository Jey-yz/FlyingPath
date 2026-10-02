#reloadable
import crafttweaker.oredict.IOreDictEntry;
import mods.botania.OrechidIgnem;
mods.botania.OrechidIgnem.removeOre("oreQuartz");

static count as int = 500;

//The freq is how many this ore will occour in 500 ores converted on averange.
//The rest in the 500 ores will be filled with quartz.
function addOreIgnem(ore as IOreDictEntry, freq as int)as void{
    OrechidIgnem.addOre(ore, freq);
    count -= freq;
}

addOreIgnem(<ore:oreSignalum>,160);
addOreIgnem(<ore:oreLumium>,100);
addOreIgnem(<ore:oreClathrateGlowstone>,40);

if(count>0){
    OrechidIgnem.addOre("oreQuartz", count);
}