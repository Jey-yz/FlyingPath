#reloadable
import scripts.events.onBlockUpdate;
import scripts.libs.BlockMatcher;
import scripts.libs.Misc;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;

onBlockUpdate.onBlockUpdate(BlockMatcher.BlockMatcher(<contenttweaker:block_pulse>).matcher(),
function(world as IWorld, pos as IBlockPos)as void{
    if(world.time%5==2)return;
    var count = 0;
    for i in Misc.IFacings{
        if(BlockMatcher.BlockMatcher(<thermalfoundation:storage_alloy:7>).matcher()(world,pos.getOffset(i,1))){
            count += 1;
        }
    }
    if(count<3 && world.random.nextInt(100)<(-count+3))world.destroyBlock(pos,true);
},false,"pulseBlock");

<contenttweaker:block_pulse>.addTooltips(["block_pulse.beaconbase","block_pulse.drop"]);