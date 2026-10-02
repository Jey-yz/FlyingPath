#reloadable
import scripts.events.onBlockUpdate;
import scripts.libs.BlockMatcher;
import crafttweaker.data.IData;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.util.IAxisAlignedBB;
import crafttweaker.entity.IEntityItem;

//I'm sure it will be used later
onBlockUpdate.onBlockUpdate(BlockMatcher.BlockMatcher(<projecte:dm_pedestal>).matcher(),
    function(world as IWorld, pos as IBlockPos)as void{
    },
false, "DarkPedestal");