#reloadable
import scripts.libs.Misc;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.util.Math;
import native.net.minecraft.item.ItemStack;

static templateCore as string[] = [
    "     ; 121 ; 212 ; 121 ;     ",
    " 121 ;13331;23432;13331; 121 ",
    " 212 ;23432;14541;23432; 212 ",
    " 121 ;13331;23432;13331; 121 ",
    "     ; 121 ; 212 ; 121 ;     "
];
static mapCore as string[string] = {
    "1":"projecte:matter_block:tier=dark_matter","2":"projecte:matter_block:tier=red_matter","3":"embers:ember_pipe",
    "4":"botania:manabomb","5":"thermalfoundation:storage_alloy:type=signalum"
};

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<projecte:matter_block>).matcher(),
    function(world as IWorld, pos as IBlockPos, hammer as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var poses as IBlockPos[] = [];
        for y in 0 to 5{
            for z in 0 to 5{
                for x in 0 to 5{
                    val pos0 = pos.add(-2+x,-4+y,-2+z);
                    val temp = templateCore[y].split(";")[z][x];
                    if(temp==" ")continue;
                    if(!BlockMatcher.BlockMatcher(<blockstate:${mapCore[temp]}>).matcher()(world,pos0)){
                        Misc.missBlock(player, pos0, ItemStack(<blockstate:${mapCore[temp]}>.getBlock().native,1,<blockstate:${mapCore[temp]}>.getBlock().meta).wrapper.displayName);
                        return false;
                    }
                    poses += pos0;
                }
            }
        }
        for p in poses{
            world.destroyBlock(p,false);
        }
        world.setBlockState(<blockstate:draconicevolution:reactor_core>,pos.add(0,-2,0));
        return true;
    }
);

var newMapCore as IIngredient[string] = {" ":<contenttweaker:gunmu>};
for a,b in mapCore{
    newMapCore[a] = ItemStack(<blockstate:${b}>.getBlock().native,1,<blockstate:${b}>.getBlock().meta).wrapper;
}

var layersCore as IIngredient[][][] = [];
for i in 0 to 5{
    layersCore += multiBlockJEI.addPosTips(multiBlockJEI.resize(Craft.map(templateCore[i],newMapCore)),3,-4+i,3);
}

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        layersCore)
    ,
    [<draconicevolution:reactor_core>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-3,0).asString()])]
);

static templateInjector as string[] = [
    "1111111;1122211;1223221;1233321;1223221;1122211;1111111",
    "       ;   4   ;  454  ; 45654 ;  454  ;   4   ;       ",
    "       ;   4   ;   5   ; 45 54 ;   5   ;   4   ;       ",
    "       ;   4   ;   8   ; 48 84 ;   8   ;   4   ;       ",
    "       ;       ;   8   ;  8 8  ;   8   ;       ;       ",
    "       ;       ;   9   ;  9 9  ;   9   ;       ;       "
];
static mapInjector as string[string] = {
    "1":"botania:biomestoneb2slab:dummy=singleton,half=bottom","2":"botania:biomestoneb:variant=mountain","3":"minecraft:stained_glass:color=light_blue",
    "4":"prodigytech:ash_bricks","5":"projecte:matter_block:tier=red_matter","6":"embers:ember_injector:facing=up",
    "8":"minecraft:redstone_block","9":"minecraft:unlit_redstone_torch:facing=up"
};

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<blockstate:embers:ember_injector:facing=up>).matcher(),
    function(world as IWorld, pos as IBlockPos, hammer as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var poses as IBlockPos[] = [pos.add(-1,4,0),pos.add(1,4,0),pos.add(0,4,1),pos.add(0,4,-1)];
        for y in 0 to 6{
            for z in 0 to 7{
                for x in 0 to 7{
                    val pos0 = pos.add(-3+x,-1+y,-3+z);
                    val temp = templateInjector[y].split(";")[z][x];
                    if(temp==" ")continue;
                    if(!BlockMatcher.BlockMatcher(<blockstate:${mapInjector[temp]}>).matcher()(world,pos0)){
                        if(temp=="9")Misc.missBlock(player, pos0, <minecraft:redstone_torch>.displayName~"(facing=up,id=minecraft:unlit_redstone_torch)");
                        else if(temp=="1")Misc.missBlock(player, pos0, <botania:biomestoneb2slab>.displayName~"(dummy=singleton,half=bottom)");
                        else{Misc.missBlock(player, pos0, ItemStack(<blockstate:${mapInjector[temp]}>.getBlock().native,1,<blockstate:${mapInjector[temp]}>.getBlock().meta).wrapper.displayName);}
                        return false;
                    }
                    poses += pos0;
                }
            }
        }
        for p in poses{
            world.destroyBlock(p,false);
        }
        world.setBlockState(<blockstate:draconicevolution:reactor_component:type=injector>,{BCManagedData:{facing:1}},pos.add(0,0,0));
        return true;
    }
);

var newMapInjector as IIngredient[string] = {" ":<contenttweaker:gunmu>};
for a,b in mapInjector{
    if(a!="9")newMapInjector[a] = ItemStack(<blockstate:${b}>.getBlock().native,1,<blockstate:${b}>.getBlock().meta).wrapper;
}
newMapInjector["1"] = Craft.addLore(<botania:biomestoneb2slab>,"dummy=singleton,half=bottom");
newMapInjector["6"] = Craft.addLore(<embers:ember_injector>,"facing=up");
newMapInjector["9"] = Craft.addLore(<minecraft:redstone_torch>,"facing=up,id=minecraft:unlit_redstone_torch");

var layersInjector as IIngredient[][][] = [];
for i in 0 to 6{
    layersInjector += multiBlockJEI.addPosTips(multiBlockJEI.resize(Craft.map(templateInjector[i],newMapInjector)),3,-1+i,3);
}

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        layersInjector)
    ,
    [<draconicevolution:reactor_component:1>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString()])]
);