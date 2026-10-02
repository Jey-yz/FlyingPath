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
    "   ; 1 ;   ",
    "   ; 1 ;   ",
    "   ; 1 ;   "
];
static map as string[string] = {
    "1":"rustichromia:block_steel","2":"contenttweaker:blitzblock"
};

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<contenttweaker:blitzblock>).matcher(),
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
        for p in poses{
            world.destroyBlock(p,false);
        }
        world.setBlockState(<blockstate:lightningcraft:air_terminal:variant=steel>,pos.add(-1,0,0));
        world.setBlockState(<blockstate:lightningcraft:air_terminal:variant=steel>,pos.add(1,0,0));
        world.setBlockState(<blockstate:lightningcraft:air_terminal:variant=steel>,pos.add(0,0,-1));
        world.setBlockState(<blockstate:lightningcraft:air_terminal:variant=steel>,pos.add(0,0,1));
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
    [<lightningcraft:air_terminal:1>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(1,0,0).asString()]),
     <lightningcraft:air_terminal:1>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(-1,0,0).asString()]),
     <lightningcraft:air_terminal:1>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,1).asString()]),
     <lightningcraft:air_terminal:1>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,-1).asString()])]
);