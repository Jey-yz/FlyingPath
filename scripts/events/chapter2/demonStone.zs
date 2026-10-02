#reloadable
import scripts.libs.Misc;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<draconicevolution:chaos_shard:3>).matcher(),
    BlockMatcher.BlockMatcher(<lightningcraft:stone_block:0>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return true;
        world.setBlockState(<blockstate:minecraft:bedrock>,pos);
        item.mutable().shrink(1);
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<lightningcraft:material:5>).matcher(),
    BlockMatcher.BlockMatcher(<minecraft:bedrock>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(item.amount>=2){
            world.setBlockState(<blockstate:lightningcraft:stone_block:variant=3>,pos);
            item.mutable().shrink(2);
        }
        return true;
    }
);