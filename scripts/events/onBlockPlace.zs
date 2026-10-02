#reloadable
#priority 10000
import crafttweaker.event.BlockPlaceEvent;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlock;
import crafttweaker.player.IPlayer;

zenClass BlockPlace{
    val block as function(IWorld, IBlockPos)bool;
    val action as function(IWorld, IBlockPos, IPlayer)bool;

    zenConstructor(block as function(IWorld, IBlockPos)bool,action as function(IWorld,IBlockPos,IPlayer)bool){
        this.action = action;
        this.block = block;
    }
}

static BlockPlaces as BlockPlace[] = [];

function onBlockPlace(block as function(IWorld, IBlockPos)bool, action as function(IWorld,IBlockPos,IPlayer)bool)as void{
    BlockPlaces += BlockPlace(block,action);
}

events.onBlockPlace(function(event as BlockPlaceEvent){
    if(event.world.remote)return;
    for i in BlockPlaces{
        if(i.block(event.world,event.position)){
            if(!i.action(event.world, event.position, event.player))event.cancel();
        }
    }
});