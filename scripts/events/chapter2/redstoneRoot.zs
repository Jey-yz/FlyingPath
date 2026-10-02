#reloadable
import scripts.libs.Misc;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<projecte:item.pe_covalence_dust:1>).matcher(),
    BlockMatcher.BlockMatcher("minecraft:redstone_torch").matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(BlockMatcher.BlockMatcher(<botania:livingwood>).matcher()(world,pos.add(0,-1,0))){
            world.setBlockState(<blockstate:minecraft:air>,pos);
            val age = world.random.nextInt(3);
            world.setBlockState(<blockstate:incorporeal:redstone_root_crop:age=${age}>,pos.add(0,-1,0));
            item.mutable().shrink(1);
        }
        return true;
    }
);
