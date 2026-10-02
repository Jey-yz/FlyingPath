#reloadable
import scripts.libs.Misc;
import scripts.libs.Data;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.text.ITextComponent;
import crafttweaker.player.IPlayer;

val pattern as IItemStack[string] = {
    "s":<botania:shimmerrock0slab>,"m":<botania:quartzslabmanahalf>,"r":<botania:quartzslabredhalf>,
    "M":<projecte:matter_block:1>,"c":<embers:block_caminite_brick>};
val template as string = "sssss;scrcs;smmms;smMms;sssss";

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<projecte:matter_block:1>).matcher(),
    function(world as IWorld, pos as IBlockPos, powder as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var posesToClear as IBlockPos[] = [pos.add(-1,1,-2),pos.add(1,1,-2)];
        for z in 0 to 5{
            for x in 0 to 5{
                if(template.split(";")[z][x]!="M"){
                    if(!BlockMatcher.BlockMatcher(pattern[template.split(";")[z][x]].definition.id,0).matcher()(world,pos.add(-2+x,0,-3+z))){
                        Misc.missBlock(player,pos.add(-2+x,0,-3+z),pattern[template.split(";")[z][x]].displayName+((template.split(";")[z][x]=="c")?"":("(dummy=singleton,half=bottom)")));
                        return false;
                    }
                }
                posesToClear += pos.add(-2+x,0,-3+z);
            }
        }
        if(!BlockMatcher.BlockMatcher(<projecte:matter_block:1>).matcher()(world,pos.add(-1,1,-2))){
            Misc.missBlock(player,pos.add(-1,1,-2),<projecte:matter_block:1>.displayName);
            return false;
        }
        if(!BlockMatcher.BlockMatcher(<projecte:matter_block:1>).matcher()(world,pos.add(1,1,-2))){
            Misc.missBlock(player,pos.add(1,1,-2),<projecte:matter_block:1>.displayName);
            return false;
        }
        for p in posesToClear{
            world.destroyBlock(p,false);
        }
        val output = (<minecraft:comparator>*16).createEntityItem(world,pos);
        world.spawnEntity(output);
        return true;
    }
);

val newPattern as IItemStack[string] = {" ":<contenttweaker:gunmu>};
for a,b in pattern{
    if(a=="M"||a=="c"){newPattern[a]=b;}
    else{newPattern[a]=b.withLore(["dummy=singleton,half=bottom"]);}
}

val layer0 as IIngredient[][] = Craft.map(template,newPattern);
val layer1 as IIngredient[][] = Craft.map("M M;   ;   ",newPattern);

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [
            multiBlockJEI.addPosTips(multiBlockJEI.resize(layer0),3,0,4),
            multiBlockJEI.addPosTips(multiBlockJEI.resize(layer1),3,1,4),
        ])
    ,
    [<minecraft:comparator>*16]
);