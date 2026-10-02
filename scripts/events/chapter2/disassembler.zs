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

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<clockworkphase:gear_brass>).matcher(),
    BlockMatcher.BlockMatcher(<projecte:matter_block>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        val poses as int[][] = [[-1,-1],[0,-1],[-1,0],[1,0],[-1,1],[0,1]];
        for i in poses{
            if(!BlockMatcher.BlockMatcher(<botania:opencrate:1>).matcher()(world,pos.add(i[0],0,i[1]))){
                Misc.missBlock(player, pos.add(i[0],0,i[1]), <botania:opencrate:1>.displayName);
                return false;
            }
        }
        for i in poses{
            world.destroyBlock(pos.add(i[0],0,i[1]),false);
        }
        item.mutable().shrink(1);
        world.setBlockState(<blockstate:clockworkphase:disassembler>,pos);
        return true;
    }
);

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize([
            [<botania:opencrate:1>,<botania:opencrate:1>,<contenttweaker:gunmu>],
            [<botania:opencrate:1>,<projecte:matter_block>,<botania:opencrate:1>],
            [<botania:opencrate:1>,<botania:opencrate:1>,<contenttweaker:gunmu>]
        ]),3,0,3)]),
    [<clockworkphase:disassembler>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString()])],
    scripts.libs.Craft.consume(<clockworkphase:gear_brass>)
);