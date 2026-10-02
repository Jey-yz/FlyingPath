mods.foundry.AlloyingCrucible.clear();
mods.foundry.AlloyMixer.clear();

mods.foundry.Melting.addRecipe(<liquid:glass>*1000,<ore:blockQuartz>,1000);
mods.foundry.Melting.addRecipe(<liquid:glass>*1000,<lightningcraft:under_sand>,1550);
mods.foundry.Infuser.addRecipe(<liquid:glass_orange>*250, <liquid:glass>*250, <botania:quartztypeblaze:1>, 4000);
mods.foundry.Infuser.addRecipe(<liquid:glass_yellow>*250, <liquid:glass>*250, <botania:quartztypesunny:1>, 4000);
mods.foundry.Infuser.addRecipe(<liquid:glass_light_blue>*250, <liquid:glass>*250, <botania:quartztypemana:1>, 4000);
mods.foundry.Infuser.addRecipe(<liquid:glass_magenta>*250, <liquid:glass>*250, <botania:quartztypelavender:1>, 4000);
mods.foundry.Infuser.addRecipe(<liquid:glass_black>*250, <liquid:glass>*250, <botania:quartztypedark:1>, 4000);
mods.foundry.Infuser.addRecipe(<liquid:glass_red>*250, <liquid:glass>*250, <botania:quartztypered:1>, 4000);
mods.foundry.Infuser.addRecipe(<liquid:glass_lime>*250, <liquid:glass>*250, <botania:quartztypeelf:1>, 4000);

mods.foundry.Melting.removeRecipe(<contenttweaker:ore_signalum>);
mods.foundry.Melting.addRecipe(<liquid:signalum>*72,<ore:oreSignalum>,1200);
mods.foundry.AlloyingCrucible.addRecipe(<liquid:dawnstone>*288, <liquid:glass_orange>*1000, <liquid:signalum>*288);
mods.foundry.Casting.addRecipe(<embers:seed_dawnstone>, <liquid:dawnstone>*1152, <embers:dawnstone_anvil>, null, 200, true);
mods.foundry.Casting.addRecipe(<embers:seed_dawnstone>, <liquid:dawnstone>*576, <collision:material>, null, 200, true);
mods.foundry.Melting.addRecipe(<liquid:dawnstone>*16,<ore:nuggetDawnstone>,950);
mods.foundry.CastingTable.addBlockRecipe(<embers:block_dawnstone>, <liquid:dawnstone>*1296);
mods.foundry.AlloyingCrucible.addRecipe(<liquid:brass>*144, <liquid:glass_yellow>*250, <liquid:bronze>*144);
mods.foundry.CastingTable.removeBlockRecipe(<liquid:brass>*1296);
mods.foundry.Casting.addRecipe(<mysticalmechanics:mergebox_frame>, <liquid:brass>*576, <mysticalmechanics:gearbox_frame>, null, 200, true);
mods.foundry.Casting.addRecipe(<clockworkphase:gear_brass>, <liquid:brass>*576, <contenttweaker:gear_dawnstone>, null, 200, true);

mods.foundry.Casting.addRecipe(<thermalexpansion:morb>.withTag({Generic: 1 as byte, id: "minecraft:slime"}), <liquid:glass_lime>*500, <thermalexpansion:morb>, null, 200, true);

//Just because I said so in advencements.
mods.foundry.Melting.addRecipe(<liquid:dawnstone>*1296,<embers:dawnstone_anvil>,2500);
mods.foundry.Melting.addRecipe(<liquid:enderium>*1296,<botania:endereyeblock>,3800);

mods.foundry.Melting.removeRecipe(<minecraft:magma>);
mods.foundry.Melting.removeRecipe(<clockworkphase:gear_steel>);