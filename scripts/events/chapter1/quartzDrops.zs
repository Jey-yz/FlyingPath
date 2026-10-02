#reloadable
import scripts.libs.BlockMatcher;
import scripts.events.onBlockDrops;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlockState;
import crafttweaker.player.IPlayer;

val types as string[] = ["mana","blaze","lavender","red","elf","sunny","dark"];
for i in types{
    val quartz = itemUtils.getItem("botania:quartztype"+i);
    onBlockDrops.onBlockDrops(BlockMatcher.BlockMatcher(quartz).blockMatcher(),
        function(drops as WeightedItemStack[], state as IBlockState, pos as IBlockPos, player as IPlayer,silk as bool,fortune as int)as WeightedItemStack[]{
            return [quartz*2]as WeightedItemStack[];
        });
}