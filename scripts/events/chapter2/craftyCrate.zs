#reloadable
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onBlockPlace;
import scripts.events.onItemUse;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;

onBlockPlace.onBlockPlace(BlockMatcher.BlockMatcher(<botania:opencrate:1>).matcher(),
    function(world as IWorld, pos as IBlockPos, player as IPlayer)as bool{
        val block = world.getBlock(pos);
        if(!isNull(block.data)){
            world.catenation().then(function(w,c){
                if(world.random.nextBoolean()){
                    world.setBlockState(<blockstate:botania:opencrate:pattern=crafty_1_3,variant=crafty>,block.data.dataSet(4,"pattern"),pos);
                }else{
                    world.setBlockState(<blockstate:botania:opencrate:pattern=crafty_3_1,variant=crafty>,block.data.dataSet(5,"pattern"),pos);
                }
            }).start();
        }
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<botania:manaresource:11>).matcher(),BlockMatcher.BlockMatcher(<botania:opencrate:1>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        val block = world.getBlock(pos);
        if(!isNull(block.data)){
            world.setBlockState(<blockstate:botania:opencrate:pattern=crafty_3_1,variant=crafty>,block.data.dataSet(-1,"pattern"),pos);
        }
        return true;
    }
);