#reloadable
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.events.onBlockDrops;
import crafttweaker.item.IItemStack;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlockState;
import crafttweaker.player.IPlayer;
import crafttweaker.entity.IEntityEquipmentSlot;
import native.vazkii.botania.common.core.handler.ModSounds;
import native.net.minecraft.util.SoundCategory;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<ore:nuggetEnderium>).matcher(),
    BlockMatcher.BlockMatcher("botania:manaflame").matcher(),
    function(world as IWorld, pos as IBlockPos, enderium as IItemStack, player as IPlayer, hand as string)as bool{
        if(enderium.amount<4)return false;
        world.setBlockState(<blockstate:minecraft:air>,pos);
        enderium.mutable().shrink(4);
        player.give(<thermalfoundation:material:230>*4);
        return true;
    }
);
onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<ore:nuggetEnderium>).matcher(),
    BlockMatcher.BlockMatcher("embers:glow").matcher(),
    function(world as IWorld, pos as IBlockPos, enderium as IItemStack, player as IPlayer, hand as string)as bool{
        if(enderium.amount>1){
            val random = world.random.nextInt(1,2);
            world.setBlockState(<blockstate:minecraft:air>,pos);
            enderium.mutable().shrink(random);
            player.give(<thermalfoundation:material:230>*random);
            return true;
        }else if(enderium.amount>0){
            world.setBlockState(<blockstate:minecraft:air>,pos);
            enderium.mutable().shrink(1);
            player.give(<thermalfoundation:material:230>*1);
            return true;
        }
        return false;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<ore:nuggetLumium>).matcher(),
    BlockMatcher.BlockMatcher("minecraft:beacon").matcher(),
    function(world as IWorld, pos as IBlockPos, lumium as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        lumium.mutable().shrink(1);
        if(world.random.nextDouble()<0.25)player.give(<minecraft:beacon>*1);
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:glimmer_shard>).matcher(),
    BlockMatcher.BlockMatcher(<botania:quartztypeblaze>).matcher(),
    function(world as IWorld, pos as IBlockPos, shard as IItemStack, player as IPlayer, hand as string)as bool{
        // if(!player.isSneaking)return false;
        val light = shard.tag.dataGet("light");
        if(light<=600&&player.isSneaking){
            player.setItemToSlot((hand=="MAIN_HAND")?IEntityEquipmentSlot.mainHand():IEntityEquipmentSlot.offhand(),shard.withTag(shard.tag.dataSet(light+200,"light")));
            world.setBlockState(<blockstate:minecraft:air>,pos);
            world.native.playSound(null, pos.native, ModSounds.endoflame, SoundCategory.BLOCKS, 0.2 as float, 1 as float);
        }
        return true;
    }
);

onBlockDrops.onBlockDrops(BlockMatcher.BlockMatcher(<contenttweaker:ore_lumium>).blockMatcher(),
    function(drops as WeightedItemStack[], state as IBlockState, pos as IBlockPos, player as IPlayer,silk as bool,fortune as int)as WeightedItemStack[]{
        if(silk){
            return [<contenttweaker:ore_lumium>]as WeightedItemStack[];
        }
        return [<minecraft:glowstone_dust>*((fortune>=3)?4:player.world.random.nextInt(2,4)),<thermalfoundation:material:230>*(2+player.world.random.nextInt(1+fortune))]as WeightedItemStack[];
    }
);