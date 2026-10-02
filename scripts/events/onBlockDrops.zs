#reloadable
#priority 10000
import crafttweaker.event.BlockHarvestDropsEvent;
import crafttweaker.item.IItemStack;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockState;
import crafttweaker.player.IPlayer;

zenClass BlockDrop{
    val block as function(IBlock)bool;
    val drops as function(WeightedItemStack[],IBlockState,IBlockPos,IPlayer,bool,int)WeightedItemStack[];

    zenConstructor(block as function(IBlock)bool,drops as function(WeightedItemStack[],IBlockState,IBlockPos,IPlayer,bool,int)WeightedItemStack[]){
        this.drops = drops;
        this.block = block;
    }
}

static BlockDrops as BlockDrop[] = [];

function onBlockDrops(block as function(IBlock)bool, drops as function(WeightedItemStack[],IBlockState,IBlockPos,IPlayer,bool,int)WeightedItemStack[])as void{
    BlockDrops += BlockDrop(block,drops);
}

events.onBlockHarvestDrops(function(event as BlockHarvestDropsEvent){
    if(event.world.remote)return;
    for i in BlockDrops{
        if(i.block(event.block)){
            event.drops = i.drops(event.drops, event.blockState, event.position, event.player, event.silkTouch, event.fortuneLevel);
            return;
        }
    }
});