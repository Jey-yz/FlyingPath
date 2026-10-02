#reloadable
import scripts.libs.Misc;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.text.ITextComponent;
import crafttweaker.player.IPlayer;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<projecte:dm_pedestal>).matcher(),
    function(world as IWorld, pos as IBlockPos, ingot as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        val quartz = world.getBlockState(pos.add(0,-1,0));
        if(!BlockMatcher.BlockMatcher(<blockstate:botania:quartztypeelf:variant=pillar_y>).blockStateMatcher()(quartz)){
            Misc.missBlock(player,pos.add(0,-1,0),<botania:quartztypeelf:2>.displayName~"(variant:pillar_y)");
            return false;

        }else if(!BlockMatcher.BlockMatcher(<contenttweaker:ore_lumium>).matcher()(world,pos.add(0,1,0))){
            Misc.missBlock(player,pos.add(0,1,0),<contenttweaker:ore_lumium>.displayName);
            return false;
        }else{
            world.setBlockState(<blockstate:minecraft:air>,pos);
            world.setBlockState(<blockstate:minecraft:air>,pos.add(0,1,0));
            world.setBlockState(<blockstate:botania:miniisland:color=black>,pos.add(0,-1,0));
        }
        return true;
    }
);

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize([[Craft.addLore(<botania:quartztypeelf:2>,"variant=pillar_y")]]),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize([[<projecte:dm_pedestal>]]),3,0,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize([[<contenttweaker:ore_lumium>]]),3,1,3)
        ])
    ,
    [<contenttweaker:gunmu>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString(),game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,1,0).asString()]),
     <botania:miniisland:15>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-1,0).asString()])
    ]
);