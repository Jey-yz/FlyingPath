#reloadable
import scripts.libs.Craft;
import scripts.events.crafting.beaconConversion as BeaconConversion;
import scripts.events.crafting.inFireCraft as InFire;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.data.IData;
import mods.embers.Alchemy;
import mods.embers.DawnstoneAnvil;
import mods.botania.ManaInfusion;
import mods.botania.ElvenTrade;
import mods.botania.Apothecary;
import mods.collision.Collider;
import mods.prodigytech.explosionfurnace.recipes as ExplosionFurnace;
import mods.rustichromia.Assembler;
import mods.incorporeal.Skytouching;
import native.vazkii.botania.api.BotaniaAPI;

//Get start
ElvenTrade.addRecipe([<contenttweaker:message_tablet>.withTag({translanted:"chat.alf_message_0"})],[<contenttweaker:alf_portal_key>]);
ElvenTrade.addRecipe([<contenttweaker:message_tablet>.withTag({translanted:"chat.alf_message_1"})],[<minecraft:written_book>]);
ManaInfusion.addInfusion(<minecraft:writable_book>,<contenttweaker:message_tablet>,100);
ManaInfusion.addInfusion(<contenttweaker:message_tablet>,<minecraft:written_book>,100);
ElvenTrade.addRecipe([<contenttweaker:dice_pickaxe>],[<contenttweaker:dice_pickaxe>]);//just in case
Skytouching.addRecipe(<botania:lexicon>.withTag({"knowledge.minecraft": 1 as byte, "knowledge.alfheim": 1 as byte, "knowledge.relic": 1 as byte, "knowledge.incorporeal.skytouch": 1 as byte}),<botania:lexicon>.withTag({"knowledge.minecraft": 1 as byte, "knowledge.alfheim": 1 as byte, "knowledge.relic": 1 as byte}));

//Some useful recipes that unlocked after the portal
ElvenTrade.addRecipe([<draconicevolution:entity_detector>],[<botania:endereyeblock>,<minecraft:comparator>,<minecraft:comparator>,<minecraft:comparator>]);
ElvenTrade.addRecipe([<embers:mech_core>],[<embers:copper_cell>,<contenttweaker:gaia_essence>]);
Collider.addCustomRecipe(2,<botania:opencrate>,Craft.ColliderBlocks(Craft.map("111;1 1;1 1",{"1":<botania:livingwood:1>})));
ElvenTrade.addRecipe([<contenttweaker:elf_powder>],[<projecte:item.pe_covalence_dust>,<contenttweaker:life_essence>]);
recipes.addShapeless(<minecraft:dispenser>,[<embers:mech_core>,<botania:opencrate>,<contenttweaker:elf_powder>]);
DawnstoneAnvil.add([<botania:pylon:2>],<botania:pylon:1>,<contenttweaker:elf_powder>);
ElvenTrade.addRecipe([<embers:ember_gauge>,<minecraft:comparator>],[<embers:ember_pipe>,<minecraft:comparator>]);
// Collider.addCustomRecipe(2,<botania:opencrate:1>,Craft.ColliderBlocks(Craft.map("111;1 1;121",{"1":<botania:dreamwood:1>,"2":<minecraft:dispenser>})));
ElvenTrade.addRecipe([<botania:opencrate:1>],[<minecraft:dispenser>,<botania:dreamwood>,<botania:dreamwood>]);
recipes.addShaped(<projecte:item.pe_rm_sword>,[[<projecte:matter_block:1>],[<projecte:matter_block:1>],[<projecte:matter_block>]]);

//乱花渐欲迷人眼
val quartzMeta as int[][] = [[0,4,6],[4,3,6],[1,4,3],[2,5,1],[2,6,3],[1,0,3],[2,1,5],[6,2,5]];
val quartzs as IItemStack[] = [<botania:quartztypedark:1>,<botania:quartztypemana:1>,<botania:quartztypeblaze:1>,<botania:quartztypelavender:1>,<botania:quartztypered:1>,<botania:quartztypeelf:1>,<botania:quartztypesunny:1>];
for i in 0 to 8{
    recipes.remove(<ceramics:rainbow_clay>.definition.makeStack(i));
    recipes.addShaped(<ceramics:rainbow_clay>.definition.makeStack(i),[[quartzs[quartzMeta[i][0]],quartzs[quartzMeta[i][1]],quartzs[quartzMeta[i][2]]]]);
}
ElvenTrade.addRecipe([<botania:specialflower>.withTag({type: "marimorphosis"})],[<ceramics:rainbow_clay:1>,<ceramics:rainbow_clay:3>,<ceramics:rainbow_clay:5>,<ceramics:rainbow_clay:7>]);
ElvenTrade.addRecipe([<botania:specialflower>.withTag({type: "orechidIgnem"})],[<ceramics:rainbow_clay:0>,<ceramics:rainbow_clay:2>,<ceramics:rainbow_clay:4>,<ceramics:rainbow_clay:6>]);
DawnstoneAnvil.add([<collision:nucleus:3>*5],<ore:ingotEnderium>,<thermalfoundation:material:894>);
recipes.addShapeless(<botania:livingwood:5>,[<botania:livingwood>,<thermalfoundation:material:894>]);

Collider.addCustomRecipe(2,<botanicadds:dreamrock>*8,Craft.ColliderBlocks([
    [<botania:biomestonea>,<botania:biomestonea:1>,<botania:biomestonea:2>],
    [<botania:biomestonea:3>,null,<botania:biomestonea:4>],
    [<botania:biomestonea:5>,<botania:biomestonea:6>,<botania:biomestonea:7>]
]));
BeaconConversion.addRecipe(<botania:shimmerrock>,<botanicadds:dreamrock>,40);
Craft.compressAndDecompress(<projecte:matter_block:1>,<contenttweaker:redmatterarmourgem_deactived>,12);
<contenttweaker:redmatterarmourgem_deactived>.addTooltips(["redarmourgem"]);
<contenttweaker:redmatterarmourgem_actived>.addTooltips(["redarmourgem"]);
// ElvenTrade.addRecipe([<botania:specialflower>.withTag({type: "orechidIgnem"})],[<ceramics:rainbow_clay:0>,<ceramics:rainbow_clay:2>,<ceramics:rainbow_clay:4>,<ceramics:rainbow_clay:6>]);
Alchemy.add(<contenttweaker:badge_basic>*3,[<botanicadds:dreamrock>,<projecte:item.pe_rm_sword>,<projecte:item.pe_soul_stone>,<contenttweaker:redmatterarmourgem_deactived>,<ore:ancientWill>],{"lumium":32 to 32, "sandwich":96 to 96});
Alchemy.add(<ceramics:clay_hard:5>*8,[<contenttweaker:gaia_essence>,<botania:quartztypeblaze:1>,<botania:biomestoneb:5>,<contenttweaker:block_embercrystal>,<botania:blazeblock>],{"lumium":10 to 10});

//Ceramic machines && Dawnstone
mods.thermalexpansion.Factorizer.addRecipeCombine(<embers:brick_caminite>*4,<embers:block_caminite_brick>);
mods.thermalexpansion.Factorizer.addRecipeSplit(<embers:block_caminite_brick>,<embers:brick_caminite>*4);
DawnstoneAnvil.add([<ceramics:unfired_clay:5>],<embers:brick_caminite>,<minecraft:quartz>);
recipes.addShaped(<ceramics:faucet>,[[<ceramics:unfired_clay:5>,<ceramics:clay_slab>,<ceramics:unfired_clay:5>]]);
ElvenTrade.addRecipe([<contenttweaker:frame_elven>*3],[<embers:mech_core>,<embers:mech_core>,<embers:mech_core>,<botania:manaresource:14>,<ore:ancientWill>,<botania:dice>]);
ElvenTrade.addRecipe([<contenttweaker:frame_elven>*2,<contenttweaker:gaia_ingot>],[<embers:mech_core>,<embers:mech_core>,<botania:manaresource:14>,<ore:ancientWill>,<ore:ancientWill>]);
ElvenTrade.addRecipe([<contenttweaker:frame_elven>,<contenttweaker:gaia_ingot>],[<embers:mech_core>,<botania:manaresource:14>,<ore:ancientWill>]);
mods.thermalexpansion.Factorizer.removeRecipeCombine(<embers:nugget_dawnstone>);
recipes.remove(<embers:ingot_dawnstone>,<embers:nugget_dawnstone>);
recipes.addShaped(<embers:ember_injector>,[[<projecte:dm_pedestal>],[<embers:ember_activator>],[<projecte:collector_mk3>]]);
DawnstoneAnvil.add([<foundry:componentblock:2>],<foundry:machine>,<contenttweaker:frame_elven>);
recipes.addShapeless(<foundry:machine:3>,[<foundry:componentblock>,<embers:ember_injector>]);
recipes.addShaped(<foundry:machine:8>,[[<foundry:machine>,<foundry:componentblock>,<foundry:machine>]]);
recipes.addShapeless(<foundry:machine:5>,[<foundry:componentblock>,<embers:copper_cell>.withTag({emberCapacity: 24000.0, ember: 24000.0})]);
ManaInfusion.addInfusion(<foundry:machine:1>,<foundry:componentblock>,10000);

//Petal Apothecaries are available
for i in 0 to 8{
    recipes.addShaped(<botania:altar>.definition.makeStack(i+1),[[<botania:biomestoneb>.definition.makeStack(i+8)],[<botania:biomestonea0wall>.definition.makeStack(i)],[itemUtils.getItem("botania:biomestoneb"~i~"slab")]]);
    recipes.addShaped(<botania:biomestonea0wall>.definition.makeStack(i),[[<botania:biomestonea>.definition.makeStack(i+8)],[<botania:biomestonea>.definition.makeStack(i+8)]]);
}
Apothecary.addRecipe("marired",[<draconicevolution:entity_detector:1>,<botania:endereyeblock>,<embers:breaker>,<botania:quartztypered:1>,<projecte:matter_block:1>]);
Apothecary.addRecipe("hopperhock",[<projecte:item.pe_black_hole>,<minecraft:minecart>,<botania:manaresource:6>]);
//Temporary recipe for covalence dust, since we can't grind coals
ElvenTrade.addRecipe([<projecte:item.pe_covalence_dust:1>*3],[<ore:dustRedstone>,<ore:gunpowder>,<contenttweaker:elf_powder>]);
recipes.addShapeless(<botania:floatingspecialflower>.withTag({type: "marired"}),[<botania:specialflower>.withTag({type: "marired"}),<botania:miniisland:*>]);

recipes.addShaped(<thermaldynamics:duct_0:4>*2,[[<ore:ingotEnderium>,<ore:dustRedstone>,<ore:ingotEnderium>]]);
recipes.addShapeless(<minecraft:chest>,[<storagedrawers:customdrawers:4>,<projecte:item.pe_covalence_dust:1>]);
recipes.addShapeless(<storagedrawers:customdrawers:2>,[<storagedrawers:customdrawers:4>,<storagedrawers:customdrawers:4>,<projecte:item.pe_covalence_dust:1>]);
DawnstoneAnvil.add([<thermalexpansion:cell>.withTag({Level: 4 as byte})],<ore:blockEnderium>,<ore:blockRedstone>);
ElvenTrade.addRecipe([<clickmachine:auto_clicker>],[<projectred-expansion:machine2:2>,<embers:breaker>,<ore:blockRedstone>,<incorporeal:natural_comparator>,<thermaldynamics:duct_0:4>]);
recipes.addShaped(<minecraft:redstone_torch>*8,[[<ore:blockRedstone>],[<ore:livingwoodTwig>]]);
recipes.addShapeless(<botania:manaresource:6>,[<minecraft:redstone_torch>,<projecte:item.pe_covalence_dust:1>,<ore:livingwood>]);
recipes.addShaped(<thermaldynamics:filter:4>,[[<ore:ingotEnderium>,<ore:nuggetDawnstone>,<ore:ingotEnderium>]]);
BeaconConversion.addRecipe(<minecraft:item_frame>,<thermaldynamics:filter:4>,200);
ElvenTrade.addRecipe([<minecraft:observer>*5],[<botania:endereyeblock>,<ore:blockRedstone>,<ore:blockQuartz>]);
ElvenTrade.addRecipe([<botania:craftpattern:4>,<minecraft:dispenser>],[<botania:opencrate:1>,<ore:dustRedstone>,<ore:dustRedstone>]);
ElvenTrade.addRecipe([<botania:craftpattern:5>,<minecraft:dispenser>],[<botania:opencrate:1>,<ore:dustRedstone>,<minecraft:redstone_torch>]);

recipes.addShaped(<botania:flighttiara>,[[<contenttweaker:gaia_essence>],[Craft.reuse(<botania:flugeleye>)],[<projecte:item.pe_covalence_dust:1>]]);
recipes.addShaped(<botania:manamirror>,[[<botania:pool:3>],[<ore:livingwoodTwig>],[<botania:endereyeblock>]]);
for i in 0 to 9{
    recipes.addShapeless("flighttiaraTimeFilling"~i,<botania:flighttiara>.definition.makeStack(i),[<botania:flighttiara>.definition.makeStack(i).marked("a"),Craft.reuse(<botania:flugeleye>),<ore:gaiaIngot>],function(out,ins,info){
        return <botania:flighttiara>.definition.makeStack(i).withTag((ins.a.tag??{}).dataSet(1200000,"timeLeft"));
    },null);
}

//hot air era(mystical machanics)
recipes.addShapeless(<prodigytech:ash_bricks>,[<ceramics:clay_hard:5>,<botanicadds:dreamrock>,<ore:dustAsh>,<projecte:item.pe_covalence_dust:1>]);
Apothecary.addRecipe(<minecraft:red_mushroom>,[<contenttweaker:sandwich_ingot>,<botania:specialflower>.withTag({type: "orechidIgnem"}),<contenttweaker:gaia_essence>]);
ExplosionFurnace.removeAll();
ExplosionFurnace.addRecipe(<embers:dawnstone_anvil>,<collision:material>*24,576);
ExplosionFurnace.addRecipe(<ceramics:unfired_clay:5>*8,<prodigytech:ferramic_ingot>*8,720,<collision:material>,1);
mods.thermalexpansion.Factorizer.removeRecipeCombine(<prodigytech:ferramic_ingot>*9);
mods.thermalexpansion.Factorizer.removeRecipeCombine(<prodigytech:ferramic_nugget>*9);
mods.thermalexpansion.Factorizer.removeRecipeSplit(<prodigytech:ferramic_ingot>);
mods.thermalexpansion.Factorizer.removeRecipeSplit(<prodigytech:ferramic_block>);
ElvenTrade.addRecipe([<prodigytech:heat_capacitor_0:12000>],[<prodigytech:ferramic_ingot>,<prodigytech:ferramic_ingot>,<minecraft:chest>]);
InFire.addCustomRecipe(<prodigytech:heat_capacitor_0:0>,<prodigytech:heat_capacitor_0:*>,function(item as IItemStack)as IItemStack{
    val damage = item.metadata;
    val out = max(-800+damage,0);
    return <prodigytech:heat_capacitor_0>.definition.makeStack(out);
},15,game.localize("jei.tooltip.in_fire.heat_capacitor"));
DawnstoneAnvil.add([<prodigytech:capacitor_aeroheater>],<projecte:dm_furnace>,<prodigytech:ferramic_block>);
recipes.addShaped(<prodigymechanics:hot_air_engine>,[[<embers:ember_activator>],[<prodigytech:ferramic_block>],[<contenttweaker:frame_elven>]]);
ExplosionFurnace.addRecipe(<botania:opencrate:1>,<rustichromia:assembler2>,1440,<embers:mech_core>,1);
Assembler.add("gearbox_iron",2,[<embers:mech_core>,<collision:material>*4,<projecte:item.pe_covalence_dust:1>*2],[<mysticalmechanics:gearbox_frame>],5,2147483647,1000);
Assembler.add("quern",2,[<prodigytech:explosion_furnace>,<embers:tinker_hammer>],[<rustichromia:quern>],5,2147483647,1000);
DawnstoneAnvil.add([<foundry:small_clay>*3],<minecraft:gunpowder>,<ceramics:unfired_clay:5>);
ManaInfusion.addInfusion(<ceramics:clay_barrel_unfired:2>,<ceramics:clay_soft>,3000);
InFire.addRecipe(<ceramics:clay_barrel>,<ceramics:clay_barrel_unfired:2>,12);
Assembler.add("casting_table_block",2,[<ceramics:clay_barrel>,<ceramics:porcelain_barrel>],[<foundry:casting_table:3>],5,2147483647,2500);
recipes.addShaped(<rustichromia:axle_wood>*2,[[<rustichromia:plate_wood>,<rustichromia:plate_wood>,<rustichromia:plate_wood>]]);
Craft.grindSimple(<thermalfoundation:material:768>,<minecraft:coal>,4,[5,2147483647,1200]);
Craft.grindSimple(<thermalfoundation:material:800>,<minecraft:ladder>);
Craft.grindSimple(<contenttweaker:endstone_dust>,<minecraft:end_bricks>,15,[10000, 750, 5, 2147483647, 2500]);
Collider.addCustomRecipe(2,<botania:vial>*8,Craft.ColliderBlocks(Craft.map("   ;a a; a ",{"a":<botania:managlass>})));

//Clockwork
Assembler.add("dawnstone_gear",2,[<embers:plate_dawnstone>*2,<embers:nugget_dawnstone>*8],[<embers:gear_dawnstone>],5,2147483647,800);
BeaconConversion.addRecipe(<contenttweaker:gear_dawnstone>,<embers:gear_dawnstone>,400*20);
recipes.remove(<prodigytech:inferno_fuel>);
recipes.replaceAllOccurences(<minecraft:blaze_powder>,<botania:blazeblock>,<minecraft:magma_cream>);
recipes.addShapeless(<prodigytech:inferno_fuel>,[<minecraft:magma_cream>,<ore:gunpowder>,<ore:dustCoal>]);
BeaconConversion.addRecipe(<clockworkphase:framework>,<clockworkphase:brass_ingot>*3,100);
DawnstoneAnvil.add([<clockworkphase:winding_box>],<mysticalmechanics:mergebox_frame>,<clockworkphase:gear_steel>);
recipes.addShaped(<clockworkphase:clockwork_assembly_table>,[[<botania:opencrate:1>,<ore:gearWood>],[<ore:gearWood>,<ore:gearWood>]]);
recipes.addShapeless(<thermalexpansion:morb>,[<ore:ingotEnderium>,<ore:dustBlitz>,<projecte:item.pe_matter:1>]);
ElvenTrade.addRecipe([<clockworkphase:mainspring>],[<collision:booster>,<minecraft:slime>]);//Because it should be a spring spring
Assembler.add("clock_pickaxe",2,[<clockworkphase:framework>,<clockworkphase:brass_ingot>*3,<rustichromia:axle_wood>*2],[<clockworkphase:clockwork_pickaxe>.withTag({max_tension: 0, tension_energy: 0, internal_time_sand: 0})],15,2147483647,2000);
Assembler.add("clock_axe",2,[<clockworkphase:framework>,<clockworkphase:brass_ingot>*3,<rustichromia:axle_wood>*2],[<clockworkphase:clockwork_axe>.withTag({max_tension: 0, tension_energy: 0, internal_time_sand: 0})],15,2147483647,2000);
Assembler.add("clock_shovel",2,[<clockworkphase:framework>,<clockworkphase:brass_ingot>,<rustichromia:axle_wood>*2],[<clockworkphase:clockwork_shovel>.withTag({max_tension: 0, tension_energy: 0, internal_time_sand: 0})],15,2147483647,2000);
Assembler.add("clock_saber",2,[<clockworkphase:framework>*2,<ore:ingotTemporal>,<botania:enderdagger>],[<clockworkphase:clockwork_saber>.withTag({max_tension: 0, tension_energy: 0, internal_time_sand: 0})],15,2147483647,8000);
Alchemy.add(<contenttweaker:gear_lumium>,[<clockworkphase:gear_brass>,<collision:nucleus:3>,<contenttweaker:aspectus_lumium>,<collision:nucleus:3>,<collision:nucleus:3>],
    {"lumium":127 .. 127});
BotaniaAPI.registerManaInfusionRecipe(<contenttweaker:gear_enderium>.native,<thermalfoundation:storage_alloy:7>.native,8000).setCatalyst(<clockworkphase:brass_block>.asBlock().native.getDefaultState());
BotaniaAPI.registerManaInfusionRecipe(<clockworkphase:gear_steel>.native,<contenttweaker:gear_dawnstone>.native,8000).setCatalyst(<rustichromia:block_steel>.asBlock().native.getDefaultState());

//Easy reactor
Assembler.add("draconic_ingot",2,[<contenttweaker:sandwich_ingot>*56,<projecte:fuel_block:2>*25,<thermalfoundation:storage_alloy:5>*12,<botania:manaresource:15>*48],[<draconicevolution:draconic_ingot>*2],20,2147483647,20000);
ElvenTrade.addRecipe([<embers:aspectus_dawnstone>],[<contenttweaker:aspectus_enderium>,<ore:plateDawnstone>,<ore:plateDawnstone>]);
Alchemy.add(<draconicevolution:reactor_component>,[<mysticalmechanics:gearbox_frame>,<botania:dice>,<ore:blockSignalum>,<contenttweaker:gaia_essence>,<contenttweaker:badge_surviving_hplock>],
    {"dawnstone":45 .. 45,"enderium":38 .. 38,"sandwich":77 .. 77});
DawnstoneAnvil.add([<trashcans:energy_trash_can>],<storagedrawers:upgrade_void>,<botania:manaresource:6>);
ElvenTrade.addRecipe([<draconicevolution:flow_gate>],[<thermaldynamics:duct_0:4>,<embers:item_transfer>,<minecraft:hopper>]);

//lightning
DawnstoneAnvil.add([<projecte:item.pe_swrg>],<projecte:item.pe_ring_iron_band>,<contenttweaker:blitzblock>);
Skytouching.addRecipe(<thermalfoundation:material:2051>,<contenttweaker:endstone_dust>);
Craft.addLightningTransform(<thermalfoundation:material:164>*5,[<thermalfoundation:storage_alloy:7>,<contenttweaker:netherrack_dust>]);
val metal_blocks as IItemStack[string]={"1":<embers:block_dawnstone>,"2":<thermalfoundation:storage_alloy:4>,"3":<prodigytech:ferramic_block>,"4":<thermalfoundation:storage_alloy:5>};
Collider.addCustomRecipe(2,<collision:booster>*4,Craft.map(" 1 ;2 3; 4 ",metal_blocks));
val wrong_order as string[] = [" 1 ;   ;   ","   ;2  ;   ","   ;  3;   ","   ;   ; 4 ",
    " 1 ;2  ;   "," 1 ;  3;   "," 1 ;   ; 4 ","   ;2 3;   ","   ;2  ; 4 ","   ;  3; 4 ",
    " 1 ;2 3;   "," 1 ;2  ; 4 "," 1 ;  3; 4 ","   ;2 3; 4 "];
for i in  wrong_order{
    Collider.addCustomRecipe(2,<collision:material>,Craft.map(i,metal_blocks));
}
InFire.addRecipe(<rustichromia:molten_steel>,<collision:booster>,16);
<projecte:item.pe_swrg>.addJEIDes("lightningtrans");

for i in 22 to 29{
    recipes.removeByRecipeName("lightningcraft:recipe"~i);
}

//Underworld
DawnstoneAnvil.add([<embers:archaic_bricks>],<prodigytech:ash_bricks>,<ore:nuggetTemporal>);
ElvenTrade.addRecipe([<embers:archaic_light>],[<embers:archaic_bricks>,<embers:archaic_bricks>,<embers:archaic_bricks>,<contenttweaker:block_embercrystal>,<prodigytech:inferno_fuel>]);
Craft.addLightningTransform(<contenttweaker:demon_core>,[<lightningcraft:air_terminal:1>,<embers:ancient_motive_core>,<botania:specialflower>.withTag({type: "orechidIgnem"}),<botania:pylon:2>]);
Craft.addLightningTransform(<lightningcraft:stone_block>,[<embers:archaic_bricks>,<minecraft:quartz>,<minecraft:stained_glass:15>]);
Craft.addLightningTransform(<lightningcraft:material:6>,[<minecraft:fire_charge>,<projecte:item.pe_swrg>,<contenttweaker:badge_buff_teleport>,<lightningcraft:material:5>]);
moretweaker.lightningcraft.LightningTransforming.add(<lightningcraft:material:6>,[<minecraft:fire_charge>,<projecte:item.pe_swrg>.withTag({}),<contenttweaker:badge_buff_teleport>,<lightningcraft:material:5>]);
Craft.grindSimple(<contenttweaker:netherrack_dust>,<minecraft:netherrack>);
BeaconConversion.addRecipe(<contenttweaker:ritual_dust>,<contenttweaker:netherrack_dust>,200);
<lightningcraft:under_sand>.asBlock().definition.setHarvestLevel("shovel",0);

//idk, but they're useful
Assembler.add("craftpattern2x2",2,[<botania:opencrate:1>,<ore:blockRedstone>],[<botania:craftpattern:1>],5,2147483647,2000);
ElvenTrade.addRecipe([<thermalfoundation:upgrade:35>],[<ore:blockEnderium>,<ore:gearDawnstone>,<storagedrawers:upgrade_template>,<botania:manaresource:15>]);
recipes.addShapeless(<thermalexpansion:augment:512>,[<ore:ingotTemporal>,<projecte:item.pe_covalence_dust:1>,<storagedrawers:upgrade_redstone>]);
recipes.addShapeless(<thermalexpansion:augment:515>,[<ore:nuggetTemporal>,<trashcans:energy_trash_can>]);
ElvenTrade.addRecipe([<minecraft:repeater>],[<incorporeal:natural_repeater>,<projectred-core:resource_item>,<ore:gemQuartz>]);
ExplosionFurnace.addRecipe(<contenttweaker:ore_signalum>,<minecraft:netherrack>*8,288);
ExplosionFurnace.addRecipe(<projecte:item.pe_black_hole>,<projecte:item.pe_ring_iron_band>,990);
InFire.addRecipe(<projecte:item.pe_ignition>,<projecte:item.pe_ring_iron_band>,64);
recipes.addShaped(<embers:caminite_lever>,[[<minecraft:redstone_torch>],[<embers:brick_caminite>]]);

//pipes & corporea
Assembler.add("hopper",2,[<botania:specialflower>.withTag({type: "hopperhock"}),<minecraft:chest>],[<minecraft:hopper>*3],5,2147483647,2000);
Assembler.add("dropper",2,[<minecraft:dispenser>,<minecraft:hopper>],[<minecraft:dropper>*2],5,2147483647,2000);
Assembler.add("itempipe",2,[<minecraft:dropper>,<embers:ember_pipe>*8,<minecraft:slime_ball>,<thermalfoundation:material:768>*5],[<embers:item_pipe>*8],5,2147483647,2000);
recipes.addShaped(<embers:item_pump>,[[<embers:item_pipe>,<minecraft:hopper>,<embers:item_pipe>]]);
recipes.addShapeless(<embers:item_dropper>,[<embers:item_pipe>,<botania:opencrate>]);
Assembler.add("item_request",2,[<embers:item_pipe>*2,<botania:corporeaindex>,<lightningcraft:material:11>,<contenttweaker:gaia_essence>*2],[<embers:item_request>],10,2147483647,6000);
recipes.addShapeless(<embers:item_transfer>,[<embers:item_pipe>,<thermaldynamics:filter:4>,<projecte:item.pe_covalence_dust:1>]);

recipes.addShaped(<ceramics:clay_barrel_unfired:3>,[[<ceramics:unfired_clay:4>],[<ceramics:unfired_clay:4>],[<ceramics:unfired_clay:4>]]);
recipes.addShaped(<ceramics:unfired_clay:7>*3,[[<ceramics:unfired_clay:5>,<ceramics:unfired_clay:4>,<ceramics:unfired_clay:5>]]);
recipes.remove(<ceramics:unfired_clay:4>*5);

ElvenTrade.addRecipe([<botania:enderhand>],[<botania:endereyeblock>,<projecte:item.pe_covalence_dust:1>,<storagedrawers:upgrade_template>,<botania:manaresource:15>]);
ElvenTrade.addRecipe([<botania:spark>*2],[<ore:dustSulfur>,<botania:pump>,<embers:archaic_brick>,<prodigytech:inferno_fuel>]);
recipes.addShapeless(<botania:corporeaspark>,[<botania:spark>,<contenttweaker:elf_powder>,<botania:manaresource:15>]);
BeaconConversion.addRecipe(<botania:corporeaspark:1>,<botania:corporeaspark>,4000,true,1.0);
ElvenTrade.addRecipe([<botania:corporeaindex>],[<botania:corporeaspark:1>,<botanicadds:dreamrock>,<embers:item_pump>]);
recipes.remove(<botania:corporeacrystalcube>);
recipes.remove(<botania:corporearetainer>);
recipes.remove(<botania:corporeafunnel>);
recipes.remove(<botania:corporeainterceptor>);
recipes.addShaped(<botania:corporeacrystalcube>,[[<incorporeal:corporea_deco>],[<botania:elfglass>],[<botania:dreamwood>]]);
DawnstoneAnvil.add([<incorporeal:ender_soul_core>],<botania:corporeaindex>,<botania:enderhand>);

//Temporarily. Will be changed them in the next version.
recipes.removeShapeless(<thermalfoundation:material:1024>);
recipes.removeShapeless(<thermalfoundation:material:1025>);
recipes.removeShapeless(<thermalfoundation:material:1026>);
recipes.removeShapeless(<thermalfoundation:material:1027>);
for i in <ore:plankWood>.items{
    if(!(i.definition.id has "prodigytech:particle_board"))recipes.removeShapeless(i);
    if(i.definition.id=="creepingnether:charwood_planks")recipes.removeShaped(i);
}
recipes.removeShaped(<minecraft:crafting_table>);
mods.rustichromia.Quern.remove("rustichromia:cobblestone_to_gravel");