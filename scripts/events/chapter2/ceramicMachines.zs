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

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<ceramics:unfired_clay:5>).matcher(),
    BlockMatcher.BlockMatcher("projecte:dm_furnace").matcher(),
    function(world as IWorld, pos as IBlockPos, ingot as IItemStack, player as IPlayer, hand as string)as bool{
        if(ingot.amount>=4){
            world.setBlockState(<blockstate:foundry:machine:machine=crucible_basic>,pos);
            ingot.mutable().shrink(4);
        }
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<foundry:componentblock:2>).matcher(),
    function(world as IWorld, pos as IBlockPos, ingot as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        if(BlockMatcher.BlockMatcher("minecraft:fire").matcher()(world,pos.add(0,-1,0))){
            world.setBlockState(<blockstate:foundry:componentblock:variant=casing_standard>,pos);
            world.setBlockState(<blockstate:minecraft:air>,pos.add(0,-1,0));
        }
        return true;
    }
);

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize([[<minecraft:fire_charge>]]),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize([[<foundry:componentblock:2>]]),3,0,3)
        ])
    ,
    [<contenttweaker:gunmu>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-1,0).asString()]),
     <foundry:componentblock:0>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString()])
    ]
);