#reloadable
#priority 2000
import mods.jei.JEI;
import mods.randomtweaker.jei.IJeiPanel;
import mods.randomtweaker.jei.IJeiUtils;
import mods.randomtweaker.jei.IJeiRecipe;
import crafttweaker.util.Math;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.text.ITextComponent;

val wiJEI=JEI.createJei("WorldInteraction",game.localize("jei.category.world_interaction"));
wiJEI.setModid("crafttweaker");
wiJEI.setIcon(<clickmachine:auto_clicker>);
wiJEI.addRecipeCatalyst(<clickmachine:auto_clicker>);
wiJEI.setBackground(IJeiUtils.createBackground(0,0,80,40,"contenttweaker:textures/gui/WorldInteraction_JEI.png"));
wiJEI.addSlot(IJeiUtils.createItemSlot("inputhand",23,3,true,true));
wiJEI.addSlot(IJeiUtils.createItemSlot("inputworld",3,21,true,true));
wiJEI.addSlot(IJeiUtils.createItemSlot("output",53,13,false,true));
wiJEI.register();

function createWorldInteractionRecipe(handinp as IIngredient, worldinp as IIngredient, out as IIngredient)as void{
    val recipe = JEI.createJeiRecipe("WorldInteraction");
    recipe.addInput(handinp);
    recipe.addInput(worldinp);
    recipe.addOutput(out);
    recipe.build();
}

static oneArg as string[] = ["chance","lumium.chance1","lumium.chance2","item.damage"];
function addToolTips(ins as IIngredient,tooltips as string[], args as string[] = [])as IIngredient{
    var out as IIngredient = null;
    var lores as string[] = [];
    var index= 0;
    for i in tooltips{
        if(oneArg has i){
            lores += ITextComponent.fromTranslation("jei.tooltip."~i, "§e"~(args[index] as string)~"§r").formattedText;
            index += 1;
        }else{
            lores += game.localize("jei.tooltip."~i);
        }
    }
    for i in ins.items{
        if(isNull(out))out = i.withLore(lores);
        else out = out.or(i.withLore(lores));
    }
    return out;
}

<embers:tinker_hammer>.addJEIDes("multi_block.active");
<embers:tinker_hammer>.addJEIDes("multi_block.inquiry");

createWorldInteractionRecipe(
    addToolTips(<collision:nucleus:2>,["rightclick","item.consume"]),
    addToolTips(<botania:quartztypesunny>,["block","block.consume"]),
    addToolTips(<contenttweaker:ore_enderium>,["block"]));
createWorldInteractionRecipe(
    addToolTips(<ore:nuggetEnderium>*4,["rightclick","item.consume"])*4,
    addToolTips(<botania:lens:17>,["block","block.consume"]),
    <ore:nuggetLumium>*4);
createWorldInteractionRecipe(
    addToolTips(<ore:nuggetEnderium>*2,["rightclick","item.consume","lumium.chance1","chance","else","chance"],[2,"50%","0%"])*2,
    addToolTips(<embers:glimmer_shard>.withTag({light: 800}),["block","block.consume"]),
    <ore:nuggetLumium>*2);
createWorldInteractionRecipe(
    addToolTips(<ore:nuggetEnderium>,["rightclick","item.consume","lumium.chance2","chance","else","chance"],[1,"100%","50%"]),
    addToolTips(<embers:glimmer_shard>.withTag({light: 800}),["block","block.consume"]),
    <ore:nuggetLumium>);
createWorldInteractionRecipe(
    addToolTips(<ore:nuggetLumium>,["shift","rightclick","item.consume"]),
    addToolTips(<minecraft:beacon>,["block","block.reuse"]),
    addToolTips(<minecraft:beacon>,["chance"],["25%"]));
createWorldInteractionRecipe(
    addToolTips(<embers:glimmer_shard>.withTag({light: 0}),["shift","rightclick"]),
    addToolTips(<botania:quartztypeblaze>,["block","block.consume"]),
    <embers:glimmer_shard>.withTag({light: 200}));
createWorldInteractionRecipe(
    addToolTips(<ore:ingotEnderium>,["shift","rightclick","item.consume"]),
    addToolTips(<minecraft:beacon>,["block","block.reuse"]),
    <botanicadds:gaia_shard>*8);
createWorldInteractionRecipe(
    addToolTips(<contenttweaker:gaia_ingot>,["pylon","shift","rightclick","item.reuse"]),
    addToolTips(<minecraft:beacon>.or(<botania:pylon:2>),["block","block.reuse"]),
    addToolTips(<minecraft:spawn_egg>.withTag({EntityTag: {id: "botania:doppleganger"}}),["entity"]));
createWorldInteractionRecipe(
    addToolTips(<contenttweaker:gaia_ingot>,["shift","rightclick","item.reuse"]),
    addToolTips(<minecraft:beacon>,["block","block.reuse"]),
    addToolTips(<botanicadds:gaia_shard>,["chance"],["33%"]));
createWorldInteractionRecipe(
    addToolTips(<minecraft:blaze_powder>,["rightclick","item.consume"]),
    addToolTips(<minecraft:end_bricks>,["block","block.consume"]),
    addToolTips(<embers:block_caminite_brick>,["block"]));
createWorldInteractionRecipe(
    addToolTips(<contenttweaker:life_essence>,["rightclick","item.consume"]),
    addToolTips(<storagedrawers:customtrim>,["block","block.consume"]),
    addToolTips(<botania:livingwood>,["block"]));
createWorldInteractionRecipe(
    addToolTips(<botania:enderdagger>,["rightclick","enderdagger.hurt","enderdagger.cooldown","item.reuse"]),
    addToolTips(<botania:quartztypelavender:1>,["lavender.hold","lavender.consume","lavender.progress","lavender.fade"])*32,
    addToolTips(<contenttweaker:life_essence>,["item.give"])*16);
createWorldInteractionRecipe(
    addToolTips(<draconicevolution:entity_detector>,["leftclick","item.consume"]),
    addToolTips(<minecraft:spawn_egg>.withTag({EntityTag: {id: "minecraft:wither_skeleton"}}),["entity","entity.consume"]),
    addToolTips(<draconicevolution:entity_detector:1>,["item.give"]));
createWorldInteractionRecipe(
    addToolTips(<botania:enderdagger>,["item.mainhand","item.damage"],[5]),
    addToolTips(<minecraft:spawn_egg>.withTag({EntityTag: {id: "botania:doppleganger"}}),["entity","entity.hurt"]),
    addToolTips(<contenttweaker:gaia_essence>,["entity.drop"]));
createWorldInteractionRecipe(
    addToolTips(<botania:enderdagger>,["item.mainhand","item.damage"],[2]),
    addToolTips(<minecraft:spawn_egg>,["entity","notgaia","entity.hurt"]),
    addToolTips(<contenttweaker:life_essence>,["chance","entity.drop"],["60%"]));
createWorldInteractionRecipe(
    addToolTips(<ceramics:unfired_clay:5>,["rightclick","item.consume"])*4,
    addToolTips(<projecte:dm_furnace>,["block","block.consume"]),
    addToolTips(<foundry:machine>,["block"]));
createWorldInteractionRecipe(
    addToolTips(<projecte:item.pe_covalence_dust:1>,["rightclick","redstoneroot.torch","item.consume"]),
    addToolTips(<botania:livingwood>.or(<minecraft:redstone_torch>),["block","block.consume","redstoneroot.place"]),
    addToolTips(<botania:manaresource:6>,["redstoneroot.pos","block"]));
createWorldInteractionRecipe(
    addToolTips(<prodigytech:inferno_fuel>,["rightclick","item.consume"]),
    addToolTips(<thermalfoundation:storage_alloy:6>,["block","block.consume"]),
    <thermalfoundation:material:163>*5);
createWorldInteractionRecipe(
    addToolTips(<draconicevolution:chaos_shard:3>,["shift","rightclick","item.consume"]),
    addToolTips(<lightningcraft:stone_block>,["block","block.consume"]),
    addToolTips(<minecraft:bedrock>,["block"]));
createWorldInteractionRecipe(
    addToolTips(<lightningcraft:material:5>,["rightclick","item.consume"])*2,
    addToolTips(<minecraft:bedrock>,["block","block.consume"]),
    addToolTips(<lightningcraft:stone_block:3>,["block"]));
