#reloadable
#priority 50000000
import mods.embers.Alchemy;

//OreDict
<ore:oreEnderium>.add(<contenttweaker:ore_enderium>);
<ore:oreLumium>.add(<contenttweaker:ore_lumium>);
<ore:oreSignalum>.add(<contenttweaker:ore_signalum>);
<ore:oreHallowium>.add(<contenttweaker:ore_hallowium>);

<ore:ingotHallowium>.add(<contenttweaker:hallowium_ingot>);
for i in 0 to 6{
    <ore:ancientWill>.add(<botania:ancientwill>.definition.makeStack(i));
}

<ore:gearEnderium>.add(<contenttweaker:gear_enderium>);
<ore:gearLumium>.add(<contenttweaker:gear_lumium>);
<ore:gearDawnstone>.add(<contenttweaker:gear_dawnstone>);

<ore:toolClockwork>.add(<clockworkphase:clockwork_pickaxe>);//just for advencement
<ore:toolClockwork>.add(<clockworkphase:clockwork_axe>);
<ore:toolClockwork>.add(<clockworkphase:clockwork_shovel>);

//Alchemy Aspect
mods.embers.Alchemy.addAspect("sandwich", <contenttweaker:sandwich_ingot>);
mods.embers.Alchemy.addAspect("lumium", <contenttweaker:aspectus_lumium>);
mods.embers.Alchemy.addAspect("enderium", <contenttweaker:aspectus_enderium>);

//ModifyBlocks
<botania:manabomb>.asBlock().definition.resistance = 2.0;

