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
    "111;121;111",
    "131;343;131",
    "111;111;111",
    "   ; 5 ;   "
];
static map as string[string] = {
    "1":"prodigytech:ash_bricks","2":"foundry:componentblock:variant=casing_standard","3":"botania:biomestonea:variant=mountain_cobble",
    "4":"embers:ember_pipe","5":"minecraft:red_mushroom"
};

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<foundry:componentblock:0>).matcher(),
    function(world as IWorld, pos as IBlockPos, hammer as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var poses as IBlockPos[] = [];
        for y in 0 to 4{
            for z in 0 to 3{
                for x in 0 to 3{
                    val pos0 = pos.add(-1+x,y,-1+z);
                    val temp = template[y].split(";")[z][x];
                    if(temp==" ")continue;
                    if(!BlockMatcher.BlockMatcher(<blockstate:${map[temp]}>).matcher()(world,pos0)){
                        Misc.missBlock(player, pos0, ItemStack(<blockstate:${map[temp]}>.getBlock().native,1,<blockstate:${map[temp]}>.getBlock().meta).wrapper.displayName);
                        return false;
                    }
                    poses += pos0;
                }
            }
        }
        world.destroyBlock(pos.add(0,3,0),false);
        for p in poses{
            world.destroyBlock(p,false);
        }
        world.setBlockState(<blockstate:prodigytech:explosion_furnace>,pos.add(0,1,0));
        return true;
    }
);

var newMap as IIngredient[string] = {" ":<contenttweaker:gunmu>};
for a,b in map{
    newMap[a] = ItemStack(<blockstate:${b}>.getBlock().native,1,<blockstate:${b}>.getBlock().meta).wrapper;
}

var layers as IIngredient[][][] = [];
for i in 0 to 4{
    layers += multiBlockJEI.addPosTips(multiBlockJEI.resize(Craft.map(template[i],newMap)),3,i,3);
}

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        layers)
    ,
    [<prodigytech:explosion_furnace>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,1,0).asString()])]
);