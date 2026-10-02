#reloadable
import scripts.events.onItemUse;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import native.net.minecraft.util.EnumHand;
import native.vazkii.botania.common.item.material.ItemManaResource;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<contenttweaker:gaia_ingot>).matcher(),
    BlockMatcher.BlockMatcher(<minecraft:beacon>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        val poses as int[][] = [[4,4,1],[4,-4,1],[-4,4,1],[-4,-4,1]];
        var pylons = 0;
        val beaconCheck = BlockMatcher.BlockMatcher(<botania:pylon:2>).matcher();
        for i in poses{
            if(beaconCheck(world,IBlockPos.create(pos.x+i[0],pos.y+i[2],pos.z+i[1]))){
                pylons+=1;
            }
        }
        if(pylons==4){
            if(hand=="MAIN_HAND"){
                player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(),<botania:manaresource:14>);
                ItemManaResource().onItemUse(player.native,world.native,pos.native,EnumHand.MAIN_HAND,crafttweaker.world.IFacing.up().native,0.5f,0.5f,0.5f);
                player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(),item);
            }else{
                player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.offhand(),<botania:manaresource:14>);
                ItemManaResource().onItemUse(player.native,world.native,pos.native,EnumHand.OFF_HAND,crafttweaker.world.IFacing.up().native,0.5f,0.5f,0.5f);
                player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.offhand(),item); 
            }
        }else{
            if(world.random.nextInt(3)==1){
                player.give(<botanicadds:gaia_shard>);
            }
        }
        return true;
    }
);