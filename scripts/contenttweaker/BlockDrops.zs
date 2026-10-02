#reloadable
import scripts.libs.BlockMatcher;
import scripts.events.onBlockDrops;
import crafttweaker.item.IItemStack;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockState;
import crafttweaker.player.IPlayer;

onBlockDrops.onBlockDrops(BlockMatcher.BlockMatcher("contenttweaker:redstone_weed").blockMatcher(),
    function(drops as WeightedItemStack[], state as IBlockState,pos as IBlockPos, player as IPlayer, silk as bool, fortune as int)as WeightedItemStack[]{
        var out as WeightedItemStack[] = [];
        for i in drops{
            if(<minecraft:redstone>.matches(i.stack))out += i;
        }
        return out;
    }
);

onBlockDrops.onBlockDrops(BlockMatcher.BlockMatcher("contenttweaker:ritual_dust").blockMatcher(),
    function(drops as WeightedItemStack[], state as IBlockState,pos as IBlockPos, player as IPlayer, silk as bool, fortune as int)as WeightedItemStack[]{
        if(state.matches(<blockstate:contenttweaker:ritual_dust:advanced=true>)){
            return [<contenttweaker:ritual_dust:1>] as WeightedItemStack[];
        }
        return [<contenttweaker:ritual_dust:0>] as WeightedItemStack[];
    }
);
