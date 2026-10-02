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
import crafttweaker.util.Math;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<minecraft:blaze_powder>).matcher(),
    BlockMatcher.BlockMatcher(<minecraft:end_bricks>).matcher(),
    function(world as IWorld, pos as IBlockPos, powder as IItemStack, player as IPlayer, hand as string)as bool{
        world.setBlockState(<blockstate:embers:block_caminite_brick>,pos);
        powder.mutable().shrink(1);
        return true;
    }
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<botania:blazeblock>).matcher(),
    function(world as IWorld, pos as IBlockPos, powder as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var posesToClear as IBlockPos[] = [pos,pos.add(0,1,0)];
        val stairs as string[int[]] = {[0,-2]:"south",[-2,0]:"east",[2,0]:"west",[0,2]:"north"};
        //layer -2
        for z in -2 to 3{
            for x in -2 to 3{
                for p, facing in stairs{
                    if(p[0] == x && p[1]==z){
                        posesToClear += pos.add(x,-2,z);
                        if(!BlockMatcher.BlockMatcher(<blockstate:embers:stairs_caminite_brick:shape=straight,half=bottom,facing=${facing}>).matcher()(world,pos.add(x,-2,z))){
                            Misc.missBlock(player,pos.add(x,-2,z),<embers:stairs_caminite_brick>.displayName+"(shape=straight,half=bottom,facing="+facing+")");
                            return false;
                        }
                    }
                }
                if(x*z==0 && Math.abs(x+z)<2){
                    posesToClear += pos.add(x,-2,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:embers:block_caminite_brick>).matcher()(world,pos.add(x,-2,z))){
                        Misc.missBlock(player,pos.add(x,-2,z),<embers:block_caminite_brick>.displayName);
                        return false;
                    }
                }
                if(Math.abs(x*z)==1){
                    posesToClear += pos.add(x,-2,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:embers:wall_caminite_brick>).matcher()(world,pos.add(x,-2,z))){
                        Misc.missBlock(player,pos.add(x,-2,z),<embers:wall_caminite_brick>.displayName);
                        return false;
                    }
                }
            }
        }
        //layer -1
        for z in -1 to 2{
            for x in -1 to 2{
                if(x*z==0 && Math.abs(x+z)==1){
                    posesToClear += pos.add(x,-1,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:contenttweaker:block_embercrystal>).matcher()(world,pos.add(x,-1,z))){
                        Misc.missBlock(player,pos.add(x,-1,z),<contenttweaker:block_embercrystal>.displayName);
                        return false;
                    }
                }
                if(x==0 && z==0){
                    posesToClear += pos.add(x,-1,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:embers:mech_core>).matcher()(world,pos.add(x,-1,z))){
                        Misc.missBlock(player,pos.add(x,-1,z),<embers:mech_core>.displayName);
                        return false;
                    }
                }
                if(Math.abs(x*z)==1){
                    posesToClear += pos.add(x,-1,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:embers:wall_caminite_brick>).matcher()(world,pos.add(x,-1,z))){
                        Misc.missBlock(player,pos.add(x,-1,z),<embers:wall_caminite_brick>.displayName);
                        return false;
                    }
                }
            }
        }
        if(!BlockMatcher.BlockMatcher(<botania:blazeblock>).matcher()(world,pos.add(0,1,0))){
            Misc.missBlock(player,pos.add(0,1,0),<botania:blazeblock>.displayName);
            return false;
        }
        for i in posesToClear{
            world.destroyBlock(i,false);
        }
        world.setBlockState(<blockstate:embers:beam_cannon:facing=up>,pos.add(0,-1,0));
        return true;
    }
);

val layer0 as IIngredient[][] = Craft.map("  N  ; wbw ;WbbbE; wbw ;  S  ",{
    "N":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=south"),
    "W":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=east"),
    "E":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=west"),
    "S":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=north"),
    "w":<embers:wall_caminite_brick>,"b":<embers:block_caminite_brick>," ":<contenttweaker:gunmu>
});
val layer1 as IIngredient[][] = Craft.map("wcw;cmc;wcw",{"w":<embers:wall_caminite_brick>,"c":<contenttweaker:block_embercrystal>,"m":<embers:mech_core>});
val layer2 as IIngredient[][] = [[<botania:blazeblock>]];
multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize(layer0),3,-2,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(layer1),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(layer2),3,0,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(layer2),3,1,3)
        ])
    ,
    [<embers:beam_cannon>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-1,0).asString()])]
);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<contenttweaker:block_embercrystal>).matcher(),
    function(world as IWorld, pos as IBlockPos, powder as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var posesToClear as IBlockPos[] = [pos,pos.add(0,2,0)];
        val stairs as string[int[]] = {[0,-1]:"south",[-1,0]:"east",[1,0]:"west",[0,1]:"north"};
        //layer -1
        for z in -1 to 2{
            for x in -1 to 2{
                for p, facing in stairs{
                    if(p[0] == x && p[1]==z){
                        posesToClear += pos.add(x,-1,z);
                        if(!BlockMatcher.BlockMatcher(<blockstate:embers:stairs_caminite_brick:shape=straight,half=bottom,facing=${facing}>).matcher()(world,pos.add(x,-1,z))){
                            Misc.missBlock(player,pos.add(x,-1,z),<embers:stairs_caminite_brick>.displayName+"(shape=straight,half=bottom,facing="+facing+")");
                            return false;
                        }
                    }
                }
                if(x==0 && z==0){
                    posesToClear += pos.add(x,-1,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:embers:block_caminite_brick>).matcher()(world,pos.add(x,-1,z))){
                        Misc.missBlock(player,pos.add(x,-1,z),<embers:block_caminite_brick>.displayName);
                        return false;
                    }
                }
            }
        }
        //layer 1
        for z in -1 to 2{
            for x in -1 to 2{
                for p, facing in stairs{
                    if(p[0] == x && p[1]==z){
                        posesToClear += pos.add(x,1,z);
                        if(!BlockMatcher.BlockMatcher(<blockstate:embers:stairs_caminite_brick:shape=straight,half=top,facing=${facing}>).matcher()(world,pos.add(x,1,z))){
                            Misc.missBlock(player,pos.add(x,1,z),<embers:stairs_caminite_brick>.displayName+"(shape=straight,half=bottom,facing="+facing+")");
                            return false;
                        }
                    }
                }
                if(x==0 && z==0){
                    posesToClear += pos.add(x,1,z);
                    if(!BlockMatcher.BlockMatcher(<blockstate:embers:block_caminite_brick>).matcher()(world,pos.add(x,1,z))){
                        Misc.missBlock(player,pos.add(x,1,z),<embers:block_caminite_brick>.displayName);
                        return false;
                    }
                }
            }
        }
        if(!BlockMatcher.BlockMatcher(<botania:blazeblock>).matcher()(world,pos.add(0,2,0))){
            Misc.missBlock(player,pos.add(0,2,0),<botania:blazeblock>.displayName);
            return false;
        }
        for i in posesToClear{
            world.destroyBlock(i,false);
        }

        world.setBlockState(<blockstate:embers:alchemy_pedestal:top=false>,pos.add(0,-1,0));
        return true;
    }
);

val Layer0 as IIngredient[][] = Craft.map(" N ;WbE; S ",{
    "N":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=south"),
    "W":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=east"),
    "E":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=west"),
    "S":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=bottom,facing=north"),
    "b":<embers:block_caminite_brick>," ":<contenttweaker:gunmu>
});
val Layer1 as IIngredient[][] = [[<contenttweaker:block_embercrystal>]];
val Layer2 as IIngredient[][] = Craft.map(" N ;WbE; S ",{
    "N":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=south"),
    "W":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=east"),
    "E":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=west"),
    "S":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=north"),
    "b":<embers:block_caminite_brick>," ":<contenttweaker:gunmu>
});
multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize(Layer0),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(Layer1),3,0,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(Layer2),3,1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(layer2),3,2,3)
        ])
    ,
    [<embers:alchemy_pedestal>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-1,0).asString()])]
);