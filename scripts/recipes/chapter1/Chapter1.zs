#reloadable
import scripts.libs.Craft;
import scripts.events.crafting.beaconConversion as BeaconConversion;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.data.IData;
import mods.embers.DawnstoneAnvil;
import mods.embers.Alchemy;
import mods.collision.Collider;
import mods.botania.ManaInfusion;

//start game
recipes.addShaped(<contenttweaker:dice_pickaxe>,Craft.map("12;31",{"1":<contenttweaker:badge_basic>,"2":<botania:dice>,"3":<contenttweaker:gaia_ingot>}));
recipes.addShapeless(<embers:tinker_hammer>,[<contenttweaker:badge_attacking>,<contenttweaker:badge_buff>,<contenttweaker:badge_surviving>,<botania:manaresource:5>]);
Craft.compress(<embers:dawnstone_anvil>,<botania:pylon:2>,4);
DawnstoneAnvil.add([<botanicadds:gaia_shard>*4],<botania:manaresource:5>,null);
DawnstoneAnvil.add([<collision:nucleus:2>*5],<botania:quartztypeelf>,<botanicadds:gaia_shard>);
DawnstoneAnvil.add([<embers:glimmer_shard>],<minecraft:beacon>,<botania:quartztypeblaze>);
Craft.compressAndDecompress(<minecraft:beacon>,<thermalexpansion:device:10>,4);
Craft.compress(<botania:manaresource:5>,<botanicadds:gaia_shard>,8);

recipes.addShapedMirrored(<betterbuilderswands:wandunbreakable:12>,[[<botania:manaresource:5>,<minecraft:beacon>],[<embers:tinker_hammer>.Reuse(),<botania:manaresource:5>]]);

//Collider && glowstone
val quartzTypes as string[] = ["dark","mana","blaze","lavender","red","elf","sunny"];
for i in 0 to quartzTypes.length{
    val quartzBlock = itemUtils.getItem("botania:quartztype"+quartzTypes[i]);
    val quartz = <botania:quartz>.definition.makeStack(i);
    recipes.remove(quartzBlock.definition.makeStack(2));
    recipes.addShaped(quartzBlock.definition.makeStack(2)*3,[[quartzBlock],[quartzBlock],[quartzBlock]]);
    mods.thermalexpansion.Factorizer.addRecipeSplit(quartzBlock,quartz*4);
    mods.thermalexpansion.Factorizer.addRecipeCombine(quartz.withAmount(4),quartzBlock);
    // recipes.addShaped(itemUtils.getItem("botania:quartzslab"+quartzTypes[i]+"half"),[[quartz,quartz]]);
    DawnstoneAnvil.add([itemUtils.getItem("botania:quartzslab"+quartzTypes[i]+"half")],quartz,quartz);
}

Craft.compressAndDecompress(<botania:quartztypedark>,<projecte:matter_block>,64);
Collider.addCustomRecipe(1,<contenttweaker:sandwich_ingot>,Craft.ColliderBlocks([
    [<botania:quartztypedark:1>,<botania:quartztypemana:1>,<botania:quartztypeblaze:1>],
    [<botania:quartztypelavender:1>,null,<botania:quartztypered:1>],
    [<botania:quartztypeelf:1>,<projecte:matter_block>,<botania:quartztypesunny:1>],
]));
<contenttweaker:sandwich_ingot>.addTooltips(["sandwich_ingot.beacon","sandwich_ingot.eaten"]);
Collider.addCustomRecipe(1,<thermalfoundation:material:167>*3,Craft.ColliderBlocks([
    [<ore:endstone>,<ore:oreEnderium>,<ore:endstone>],
    [<ore:oreEnderium>,null,<ore:oreEnderium>],
    [<ore:endstone>,<ore:oreEnderium>,<ore:endstone>]
]),100,75);
Collider.addCustomRecipe(1,<contenttweaker:block_pulse>*3,Craft.ColliderBlocks([
    [<minecraft:end_bricks>,<contenttweaker:ore_enderium>,<minecraft:end_bricks>],
    [<botania:quartztypered:1>,null,<botania:quartztypered:1>],
    [<minecraft:end_bricks>,<contenttweaker:ore_enderium>,<minecraft:end_bricks>]   
]));

Collider.addCustomRecipe(1,<contenttweaker:ore_enderium>*10,Craft.ColliderBlocks([
    [<ore:endstone>,<ore:blockEnderium>,<ore:endstone>],
    [<ore:endstone>,null,<ore:endstone>],
    [<ore:endstone>,<ore:endstone>,<ore:endstone>]
]));
BeaconConversion.addRecipe(<contenttweaker:ore_lumium>,<ore:oreEnderium>,80);
BeaconConversion.addRecipe(<minecraft:end_stone>,<botania:quartztypesunny>,20);
Collider.addCustomRecipe(1,<projecte:collector_mk2>,Craft.ColliderBlocks([
    [<minecraft:glowstone>,<projecte:matter_block>,<minecraft:glowstone>],
    [<minecraft:glowstone>,null,<minecraft:glowstone>],
    [<minecraft:glowstone>,<thermalfoundation:storage_alloy:6>,<minecraft:glowstone>]
]));
recipes.remove(<botania:blazeblock>);
recipes.remove(<minecraft:blaze_rod>);
Craft.compressAndDecompress(<minecraft:blaze_powder>,<botania:blazeblock>,9);

//Basic Ember Automation
BeaconConversion.addRecipe(<contenttweaker:block_embercrystal>,<botania:quartztypeblaze>*24,60);
Craft.decompress(<botania:quartztypeblaze>,<contenttweaker:block_embercrystal>,24);
DawnstoneAnvil.add([<embers:ember_pipe>*5],<contenttweaker:block_embercrystal>,<botania:quartztypemana:1>);
Collider.addCustomRecipe(1,<embers:copper_cell>.withTag({emberCapacity: 24000.0, ember: 4800}),Craft.ColliderBlocks([
    [<minecraft:end_bricks>,<contenttweaker:block_embercrystal>,<minecraft:end_bricks>],
    [<contenttweaker:block_embercrystal>,null,<contenttweaker:block_embercrystal>],
    [<minecraft:end_bricks>,<contenttweaker:block_embercrystal>,<minecraft:end_bricks>]
]));
DawnstoneAnvil.add([<embers:mech_core>*2],<contenttweaker:block_embercrystal>,<botania:manaresource:14>);
recipes.addShapeless(<embers:breaker>,[<embers:mech_core>,<contenttweaker:dice_pickaxe>.Reuse()]);
recipes.addShapeless(<embers:auto_hammer>,[<embers:mech_core>,<embers:tinker_hammer>.Reuse()]);
recipes.addShapeless(<projectred-expansion:machine2:2>,[<embers:mech_core>,<minecraft:beacon>]);

//GaiaIngot
var quartzs as IIngredient = <botania:quartztypedark:1>*2;
for i in quartzTypes{
    if(i!="dark")quartzs = quartzs.or(itemUtils.getItem("botania:quartztype"+i).definition.makeStack(1)*2);
}
BeaconConversion.addRecipe(<storagedrawers:customtrim>,quartzs,20);
recipes.addShaped(<storagedrawers:framingtable>,[[<storagedrawers:customtrim>,<storagedrawers:customtrim>]]);
Collider.addCustomRecipe(1,<framedcompactdrawers:framed_compact_drawer>,Craft.ColliderBlocks([
    [<storagedrawers:customtrim>,<thermalexpansion:device:10>,<storagedrawers:customtrim>],
    [<storagedrawers:customtrim>,null,<storagedrawers:customtrim>],
    [<storagedrawers:customtrim>,<storagedrawers:customtrim>,<storagedrawers:customtrim>]
]));
recipes.addShapeless("fillGaiaIngot1",<contenttweaker:gaia_ingot>.withTag({process:4}),[<contenttweaker:gaia_ingot>,<botania:manaresource:5>.or(<botanicadds:gaia_shard>)],
    function(out,ins,info){
        var ingot as IItemStack = null;
        var process as int = 0;
        for i in info.inventory.itemArray{
            if(!isNull(i) && i.definition.id=="contenttweaker:gaia_ingot")ingot = i;
            else if(!isNull(i))process += (<botania:manaresource:5>.matches(i))?6:1;
        }
        if(isNull(ingot)){return null;}
        else if((isNull(ingot.tag)||isNull(ingot.tag.process))){return ingot.withTag({process:process})*1;}
        else{ return ingot.withTag(ingot.tag.dataSet(min(100,process+ingot.tag.dataGet("process").asInt()),"process"))*1;}
},null);
for i in 1 to 9{
    var ingredients as IIngredient[] = [<contenttweaker:gaia_ingot>];
    for j in 0 to i{
        ingredients += <botania:manaresource:5>.or(<botanicadds:gaia_shard>);
    }
    recipes.addHiddenShapeless("fillGaiaIngot"+(i+1),<contenttweaker:gaia_ingot>.withTag({process:4}),ingredients,
        function(out,ins,info){
            var ingot as IItemStack = null;
            var process as int = 0;
            for i in info.inventory.itemArray{
                if(!isNull(i) && i.definition.id=="contenttweaker:gaia_ingot")ingot = i;
                else if(!isNull(i))process += (<botania:manaresource:5>.matches(i))?6:1;
            }
            if(isNull(ingot)){return null;}
            else if((isNull(ingot.tag)||isNull(ingot.tag.process))){return ingot.withTag({process:process})*1;}
            else{ return ingot.withTag(ingot.tag.dataSet(min(100,process+ingot.tag.dataGet("process").asInt()),"process"))*1;}
    },null);
}
<contenttweaker:gaia_ingot>.withEmptyTag().addAdvancedTooltip(function(item) {
    if(isNull(item.tag)||isNull(item.tag.process))return "";
    return game.localize("item.description.gaia_ingot.process") ~"§b"~ item.tag.process ~"§r";
});

DawnstoneAnvil.add([<botania:manaresource:14>],<contenttweaker:gaia_ingot>.withTag({process:100}),null);

//Alchemy
recipes.remove(<embers:stairs_caminite_brick>);
recipes.addShapedMirrored(<embers:stairs_caminite_brick>*4,[[<embers:block_caminite_brick>,null],[<embers:block_caminite_brick>,<embers:block_caminite_brick>]]);
recipes.addShaped(<embers:wall_caminite_brick>*2,[[<embers:block_caminite_brick>],[<embers:block_caminite_brick>]]);
DawnstoneAnvil.add([<embers:alchemy_tablet>],<projecte:fuel_block>,<embers:alchemy_pedestal>);
BeaconConversion.addRecipe(<embers:dust_ash>,<projecte:item.pe_matter>,120);
Alchemy.add(<embers:ashen_amulet>,
[<projecte:matter_block>,<botania:quartztypeblaze:1>,<botania:manaresource:14>,<contenttweaker:block_embercrystal>,<embers:glimmer_shard>.withTag({light:800})],
{"sandwich":3 to 3});
Alchemy.add(<contenttweaker:aspectus_enderium>*2,
[<ore:blockEnderium>,<ore:oreEnderium>,<ore:nuggetEnderium>,<ore:ingotEnderium>,<collision:nucleus:2>],
{"sandwich":15 to 15});
Alchemy.add(<contenttweaker:aspectus_lumium>,
[<ore:blockLumium>,<ore:oreLumium>,<contenttweaker:aspectus_enderium>,<botania:quartztypesunny:1>,<ore:glowstone>],
{"sandwich":8 to 8, "enderium":8 to 8});
Alchemy.add(<botania:shimmerrock>*5,
[<botania:quartztypemana:1>,<botania:quartztypered:1>,<botania:quartztypeelf:1>,<botania:quartztypesunny:1>,<botania:quartztypelavender:1>],
{"enderium":5 to 5, "lumium":5 to 5});
mods.thermalexpansion.Factorizer.addRecipeSplit(<botania:shimmerrock>,<botania:shimmerrock0slab>*2);

//When you have Collider_level2
Collider.addCustomRecipe(1,<projecte:item.pe_black_hole>,Craft.ColliderBlocks(Craft.map("qmq;q q;qqq",{"q":<botania:quartztypemana:1>,"m":<projecte:matter_block>})));
Collider.addCustomRecipe(2,<projecte:dm_pedestal>,Craft.ColliderBlocks(Craft.map("sds;s s;ddd",{"d":<projecte:matter_block>,"s":<botania:shimmerrock>})));
Collider.addCustomRecipe(2,<projecte:dm_furnace>,Craft.ColliderBlocks(Craft.map("ddd;d d;ddd",{"d":<projecte:matter_block>})));
furnace.addRecipe(<projecte:item.pe_matter:1>,<projecte:item.pe_matter>);
recipes.addShaped(<projecte:collector_mk3>,[[<projecte:matter_block:1>],[<projecte:collector_mk2>]]);
for i in quartzTypes{
    val quartzBlock = itemUtils.getItem("botania:quartztype"+i);
    Collider.addCustomRecipe(2,quartzBlock*8,Craft.ColliderBlocks(Craft.map("qqq;q q;qqq",{"q":quartzBlock})),8);
}
Alchemy.add(<embers:ember_activator>,
[<embers:mech_core>,<embers:ember_pipe>,<embers:copper_cell>,<embers:glimmer_shard>.withTag({light:800}),<projecte:dm_furnace>],
{"lumium":18 to 18});
mods.embers.EmberGeneration.addEmberFuel(<contenttweaker:block_embercrystal>, 6000);
<contenttweaker:block_embercrystal>.addJEIDes("block_embercrystal.fuel");

//Elf Portal
Alchemy.add(<projecte:item.pe_soul_stone>,
[<contenttweaker:sandwich_ingot>,<projecte:matter_block:1>,<botania:manaresource:5>,<ore:glowstone>,<botania:quartztypemana:1>],
{"sandwich":24 to 24, "lumium":24 to 24});
BeaconConversion.addRecipe(<botania:enderdagger>,<projecte:item.pe_soul_stone>,1200);
ManaInfusion.addInfusion(<botania:pump>,<embers:ember_pipe>,1000);
mods.thermalexpansion.Factorizer.addRecipeCombine(<botania:manaresource:3>*7,<minecraft:ladder>*48);
Collider.addCustomRecipe(2,<botania:pool:3>,Craft.ColliderBlocks(Craft.map("   ;s s;sss",{"s":<botania:shimmerrock0slab>})));
BeaconConversion.addRecipe(<minecraft:rail>,<minecraft:ladder>,10);
BeaconConversion.addRecipe(<minecraft:minecart>,<botania:pool:3>,600);
DawnstoneAnvil.add([<botania:poolminecart>],<minecraft:minecart>,<botania:pool:3>);
Alchemy.add(<botania:manabomb>,
[<botania:manaresource:14>,<botania:livingwood:5>,<botania:livingwood:5>,<botania:livingwood:5>,<botania:livingwood:5>],
{"sandwich":32 to 32, "enderium": 48 to 48, "lumium":48 to 48});
Collider.addCustomRecipe(2,<botania:pylon:1>,Craft.ColliderBlocks(Craft.map("ele;e e;ele",{"e":<botania:quartztypeelf>,"l":<botania:livingwood:5>})));
Alchemy.add(<botania:alfheimportal>,[<embers:mech_core>,<botania:manabomb>,<ore:blockEnderium>,<botania:shimmerrock>,<botania:livingwood:5>],
{"enderium":96 to 96});
recipes.remove(<botania:livingwood:5>);
recipes.addShapeless(<botania:livingwood:5>,[<ore:livingwood>,<ore:glowstone>,<embers:glimmer_shard>.withTag({light: 800}),<botania:quartztypeelf:1>]);

val quartzToColor as IData[IIngredient] = {<botania:quartztypedark:1>:15,<botania:quartztypemana:1>:3,<botania:quartztypeblaze:1>:1,<botania:quartztypelavender:1>:2,<botania:quartztypered:1>:14,<botania:quartztypeelf:1>:5,<botania:quartztypesunny:1>:4};
for a,b in quartzToColor{
    for c,d in quartzToColor{
        recipes.addShaped(<botania:twigwand>.withTag({color1: b, color2: d, boundTileZ: 0, boundTileX: 0, boundTileY: -1}),[[a,<botania:manaresource:3>],[<botania:manaresource:3>,c]]);
    }
}
recipes.addShapeless(<thermalfoundation:wrench>,[<botania:twigwand>,<embers:tinker_hammer>.Reuse()]);
BeaconConversion.addRecipe(<botania:twigwand>.withTag({color1: 11, color2: 8}),<thermalfoundation:wrench>);

Alchemy.add(<projecte:item.pe_covalence_dust>*4,[null,<ore:dustGlowstone>,<ore:dustBlaze>,<ore:dustAsh>,<ore:powderMana>],{'enderium':1 to 1});
recipes.addShapeless(<storagedrawers:upgrade_template>,[<storagedrawers:customtrim>,<projecte:item.pe_covalence_dust>]);
recipes.addShapeless(<storagedrawers:upgrade_redstone>,[<storagedrawers:upgrade_template>,<minecraft:comparator>]);
recipes.addShapeless(<storagedrawers:upgrade_void>,[<storagedrawers:upgrade_template>,<projecte:item.pe_black_hole>]);
recipes.addShapeless(<storagedrawers:customdrawers:3>,[<storagedrawers:customtrim>,<storagedrawers:customtrim>,<projecte:item.pe_covalence_dust>]);
recipes.addShapeless(<storagedrawers:customdrawers:4>,[<storagedrawers:customdrawers:3>,<storagedrawers:customdrawers:3>,<projecte:item.pe_covalence_dust>]);
