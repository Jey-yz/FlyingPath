#reloadable
import scripts.libs.Misc;
import scripts.libs.Data;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onBlockDrops;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlockState;
import crafttweaker.text.ITextComponent;
import crafttweaker.player.IPlayer;
import mods.zenutils.NetworkHandler;

onBlockDrops.onBlockDrops(BlockMatcher.BlockMatcher(<contenttweaker:ore_enderium>).blockMatcher(),
    function(drops as WeightedItemStack[], state as IBlockState, pos as IBlockPos, player as IPlayer,silk as bool,fortune as int)as WeightedItemStack[]{
        if(silk){
            return [<contenttweaker:ore_enderium>]as WeightedItemStack[];
        }
        return [<minecraft:end_stone>,<thermalfoundation:material:231>*(2+player.world.random.nextInt(1+fortune))]as WeightedItemStack[];
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<collision:nucleus:2>).matcher(),
    BlockMatcher.BlockMatcher("botania:quartztypesunny",0).matcher(),
    function(world as IWorld, pos as IBlockPos, nucleus as IItemStack, player as IPlayer, hand as string)as bool{
        world.setBlockState(<blockstate:contenttweaker:ore_enderium>,pos);
        nucleus.mutable().shrink(1);
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<ore:ingotEnderium>).matcher(),
    BlockMatcher.BlockMatcher("minecraft:beacon",0).matcher(),
    function(world as IWorld, pos as IBlockPos, ingot as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        player.give(<botanicadds:gaia_shard>*8);
        ingot.mutable().shrink(1);
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<thermalfoundation:storage_alloy:7>).matcher(),
    function(world as IWorld, pos as IBlockPos, ingot as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        val quartz = world.getBlock(pos.x,-1+pos.y,pos.z);
        if(BlockMatcher.BlockMatcher("botania:quartztypered",0).blockMatcher()(quartz)){
            world.setBlockState(<blockstate:minecraft:air>,pos);
            world.setBlockState(<blockstate:botania:endereyeblock>,IBlockPos.create(pos.x,-1+pos.y,pos.z));
        }else{
            // NetworkHandler.sendToAllAround("MissingBlockPosition",pos.x,pos.y,pos.z,20,world.getDimension(),function(b){
            //     b.writeData(Data.fromBlockPos(pos.add(0,-1,0)));
            // });
            // player.sendChat(ITextComponent.fromTranslation("chat.miss_block_at", (pos.x) as string~" "~(-1+pos.y)~" "~(pos.z) as string, <botania:quartztypered>.displayName).unformattedText);
            Misc.missBlock(player,pos.add(0,-1,0),<botania:quartztypered>.displayName);
            return false;
        }
        return true;
    }
);

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize([[<botania:quartztypered>]]),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize([[<thermalfoundation:storage_alloy:7>]]),3,0,3)
        ])
    ,
    [<contenttweaker:gunmu>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString()]),
     <botania:endereyeblock>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-1,0).asString()])
    ]
);