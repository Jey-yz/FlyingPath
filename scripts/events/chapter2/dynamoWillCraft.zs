#reloadable
import scripts.libs.Misc;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.util.Math;
import native.net.minecraft.item.ItemStack;

static template as string[] = [
    "01110;20002;20302;20002;01110",
    "45554;56665;56765;56665;45554",
    "01110;28982;29A92;28982;01110",
    "     ; BCB ; CAC ; BCB ;     ",
    "     ; BCB ; CAC ; BCB ;     ",
    "     ; BDB ; EAE ; BDB ;     ",
];
static map as string[string] = {
    "0":"botania:biomestoneb:variant=chiseled_taiga","1":"botania:quartztypemana:variant=pillar_x","2":"botania:quartztypemana:variant=pillar_z",
    "3":"projecte:matter_block:tier=dark_matter","4":"botania:quartztypemana:variant=pillar_y","5":"botanicadds:dreamrock","6":"ceramics:clay_hard:type=lava_bricks",
    "7":"contenttweaker:frame_elven","8":"botania:quartztypered:variant=chiseled","9":"botania:biomestoneb:variant=mesa","A":"botania:quartztypered:variant=pillar_y",
    "B":"botania:quartztypedark:variant=pillar_y","C":"projecte:matter_block:tier=red_matter","D":"botania:quartztypedark:variant=pillar_x","E":"botania:quartztypedark:variant=pillar_z"
};

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<botania:quartztypered:2>).matcher(),
    function(world as IWorld, pos as IBlockPos, hammer as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var poses as IBlockPos[] = [];
        for y in 0 to 6{
            for z in 0 to 5{
                for x in 0 to 5{
                    val pos0 = pos.add(-2+x,-5+y,-2+z);
                    val temp = template[y].split(";")[z][x];
                    if(temp==" ")continue;
                    if(!BlockMatcher.BlockMatcher(<blockstate:${map[temp]}>).matcher()(world,pos0)){
                        if(map[temp].split(":").length==3 && map[temp].split(":")[2].startsWith("variant=pillar_")){
                            Misc.missBlock(player, pos0, ItemStack(<blockstate:${map[temp]}>.getBlock().native,1,2).wrapper.displayName~"("~map[temp].split(":")[2]~")");
                        }else{
                            Misc.missBlock(player, pos0, ItemStack(<blockstate:${map[temp]}>.getBlock().native,1,<blockstate:${map[temp]}>.getBlock().meta).wrapper.displayName);
                        }
                        return false;
                    }
                    poses += pos0;
                }
            }
        }
        for p in poses{
            world.destroyBlock(p,false);
        }
        world.setBlockState(<blockstate:thermalexpansion:dynamo:type=will>,pos.add(0,-4,0));
        return true;
    }
);

var newMap as IIngredient[string] = {" ":<contenttweaker:gunmu>};
for a,b in map{
    if(b.split(":").length==3 && b.split(":")[2].startsWith("variant=pillar_")){
        newMap[a] = Craft.addLore(ItemStack(<blockstate:${b}>.getBlock().native,1,2).wrapper,b.split(":")[2]);
    }else{
        newMap[a] = ItemStack(<blockstate:${b}>.getBlock().native,1,<blockstate:${b}>.getBlock().meta).wrapper;
    }
}

var layers as IIngredient[][][] = [];
for i in 0 to 6{
    layers += multiBlockJEI.addPosTips(multiBlockJEI.resize(Craft.map(template[i],newMap)),3,-5+i,3);
}

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        layers)
    ,
    [<thermalexpansion:dynamo:6>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-4,0).asString()])]
);