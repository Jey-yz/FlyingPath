#reloadable
import scripts.libs.Misc;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.jei.multiBlockJEI;
import scripts.events.onItemUse;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;

val template = ". . . .;       ;.      ;       ;. - . .;       ;. - - .";

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<botania:quartztypedark:1>).matcher(),
    function(world as IWorld, pos as IBlockPos, hammer as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var blocks as IBlockPos[] = [];
        for z in -6 to 1{
            for x in 0 to 7{
                if(template.split(";")[z+6][x]==" ")continue;
                if(template.split(";")[z+6][x]=="."){
                    if(BlockMatcher.BlockMatcher(<botania:quartztypedark:1>).matcher()(world,pos.add(x,0,z))){
                        blocks += pos.add(x,0,z);
                    }else{
                        Misc.missBlock(player, pos.add(x,0,z), <botania:quartztypedark:1>.displayName);
                        return false;
                    }
                }
                if(template.split(";")[z+6][x]=="-"){
                    for y in 0 to 3{
                        if(BlockMatcher.BlockMatcher(<botania:quartztypedark:1>).matcher()(world,pos.add(x,y,z))){
                            blocks += pos.add(x,y,z);
                        }else{
                            Misc.missBlock(player, pos.add(x,y,z), <botania:quartztypedark:1>.displayName);
                            return false;
                        }
                    }
                }
            }
        }
        for p in blocks{
            world.destroyBlock(p,false);
        }
        val output = (<contenttweaker:alf_portal_key>).createEntityItem(world,pos);
        world.spawnEntity(output);
        return true;
    }
);

val layer0 as IIngredient[][] = Craft.map(template,{".":<botania:quartztypedark:1>,"-":<botania:quartztypedark:1>," ":<contenttweaker:gunmu>});
val layer1 as IIngredient[][] = Craft.map(template,{".":<contenttweaker:gunmu>,"-":<botania:quartztypedark:1>," ":<contenttweaker:gunmu>});

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [
            multiBlockJEI.addPosTips(multiBlockJEI.resize(layer0),0,0,6),
            multiBlockJEI.addPosTips(multiBlockJEI.resize(layer1),0,1,6),
            multiBlockJEI.addPosTips(multiBlockJEI.resize(layer1),0,2,6),
        ])
    ,
    [<contenttweaker:alf_portal_key>]
);