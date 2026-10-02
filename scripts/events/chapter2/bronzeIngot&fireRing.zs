#reloadable
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.util.EnumHand;
import native.moze_intel.projecte.gameObjs.items.rings.Ignition;
import native.moze_intel.projecte.utils.WorldHelper;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<prodigytech:inferno_fuel>).matcher(),
    BlockMatcher.BlockMatcher(<blockstate:thermalfoundation:storage_alloy:type=lumium>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        world.setBlockState(<blockstate:minecraft:air>,pos);
        item.mutable().shrink(1);
        player.give(<thermalfoundation:material:163>*5);
        return true;
    }
);

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<projecte:item.pe_ignition>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking){
            WorldHelper.igniteNearby(player.world.native, player.native);
        }else{
            Ignition().shootProjectile(player.native,item as ItemStack,((hand=="MAIN_HAND")?EnumHand.MAIN_HAND:EnumHand.OFF_HAND));
        }
        return true;
    }
);
<projecte:item.pe_ignition>.addJEIDes("projecte.ignition");