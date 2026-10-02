#reloadable
import scripts.events.onItemUse;
import scripts.events.onBlockDrops;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IFacing;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlockState;
import mods.zenutils.NetworkHandler;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.block.Block;

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:blitzblock>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        val reachDistance = player.getAttribute("generic.reachDistance");
        if(isNull(reachDistance))return false;
        if(!player.getRayTrace(reachDistance.getAttributeValue(),1.0 as float).isMiss)return false;
        var pos = player.getRayTrace(reachDistance.getAttributeValue(),1.0 as float).blockPos;
        if(pos.y>=player.world.provider.getHeight()){pos = IBlockPos.create(pos.x,-1+player.world.provider.getHeight(),pos.z);}
        else if(pos.y<=0){pos = IBlockPos.create(pos.x,1,pos.z);}
        if(<blockstate:minecraft:air>.isReplaceable(player.world,pos)&&<contenttweaker:blitzblock>.asBlock().definition.canPlaceBlockAt(player.world,pos)){
            player.world.setBlockState(<blockstate:contenttweaker:blitzblock>,pos);
            NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                b.writeString(hand);
            });
            if(!player.creative)item.mutable().shrink(1);
        }
        return true;
    }
);
NetworkHandler.registerServer2ClientMessage("PlayerSwingHand",function(player,b){
    val hand = b.readString();
    player.native.swingArm(((hand=="OFF_HAND")?EnumHand.OFF_HAND:EnumHand.MAIN_HAND));
});

<contenttweaker:blitzblock>.addTooltips(["blitzblock"]);
<contenttweaker:blizzblock>.addTooltips(["blizzblock"]);

Craft.compressAndDecompress(<thermalfoundation:material:2049>,<contenttweaker:blizzblock>,9);
Craft.compressAndDecompress(<thermalfoundation:material:2051>,<contenttweaker:blitzblock>,9);
Craft.compressAndDecompress(<thermalfoundation:material:2053>,<contenttweaker:basalzblock>,9);

onBlockDrops.onBlockDrops(BlockMatcher.BlockMatcher(<minecraft:packed_ice>).blockMatcher(),
    function(drops as WeightedItemStack[], state as IBlockState, pos as IBlockPos, player as IPlayer,silk as bool,fortune as int)as WeightedItemStack[]{
        if(silk){
            return [<minecraft:packed_ice>]as WeightedItemStack[];
        }
        return [<thermalfoundation:material:2049>*(2+player.world.random.nextInt(4))]as WeightedItemStack[];
    }
);

val coldBlocks as int[string] = {
    "minecraft:snow":3, "minecraft:ice":5, "minecraft:packed_ice":10, 
    "contenttweaker:blizzblock":15, "thermalfoundation:fluid_cryotheum":30
};
val coldLevel as int[string] = {
    "minecraft:water":0, "minecraft:flowing_water":0,
    "minecraft:ice":1, "minecraft:packed_ice":2, 
    "contenttweaker:blizzblock":3, "thermalfoundation:fluid_cryotheum":4
};

<cotBlock:blizzblock>.onRandomTick = function(world as IWorld, pos, state){
    var coldness = 15;
    val allDirections as IFacing[] = [up,down,north,south,east,west];
    for i in allDirections{
        if(BlockMatcher.BlockMatcher(coldBlocks.keys).check(world,pos.getOffset(i,1))){
            val block = world.getBlock(pos.getOffset(i,1));
            if(block.meta==0)coldness += coldBlocks[block.definition.id];
        }
    }
    for i in allDirections{
        if(BlockMatcher.BlockMatcher(["minecraft:water","minecraft:flowing_water","minecraft:ice"]).check(world,pos.getOffset(i,1))){
            if(coldness<=world.random.nextInt(100))continue;
            val Block1 = world.getBlock(pos.getOffset(i,1));
            val Block2 = world.getBlock(pos.getOffset(i.opposite(),1));
            if(!isNull(Block2) && !isNull(Block2.definition) && !isNull(coldLevel[Block2.definition.id]) && coldLevel[Block2.definition.id]-coldLevel[Block1.definition.id]>=2){
                for block,level in coldLevel{
                    if(level+1 == coldLevel[Block2.definition.id]){
                        world.setBlockState(Block.getBlockFromName(block).wrapper.definition.defaultState,pos.getOffset(i.opposite(),1));
                        break;
                    }
                }
            }
            if(coldLevel[Block1.definition.id]==0){
                world.setBlockState(<blockstate:minecraft:ice>,pos.getOffset(i,1));
            }else if(coldLevel[Block1.definition.id]==1){
                world.setBlockState(<blockstate:minecraft:packed_ice>,pos.getOffset(i,1));
            }
        }
    }
    return;
};
