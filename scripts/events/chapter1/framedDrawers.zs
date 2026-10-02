#reloadable
import scripts.events.onBlockPlace;
import scripts.events.onItemUse;
import scripts.libs.BlockMatcher;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.item.IItemStack;
import crafttweaker.player.IPlayer;

val framedDrawers as string[] = ["framedcompactdrawers:framed_compact_drawer","framedcompactdrawers:framed_drawer_controller","framedcompactdrawers:framed_slave",
    "storagedrawers:customdrawers","storagedrawers:customtrim"];

// onBlockPlace.onBlockPlace(function(world as IWorld, pos as IBlockPos)as bool{
//     val block = world.getBlock(pos);
//     if(isNull(block)||isNull(block.definition))return false;
//     if(!(framedDrawers has block.definition.id))return false;
//     return true;
// },function(world as IWorld, pos as IBlockPos, player as IPlayer)as bool{
//     val block = world.getBlock(pos);
//     val data = block.data;
//     var flag = 0;
//     if(isNull(data)){
//         player.sendChat(game.localize("chat.unfilled_framed_drawer"));
//         return false;
//     }
//     if(isNull(data.MatT))flag+=1;
//     if(isNull(data.MatS))flag+=1;
//     if(isNull(data.MatF))flag+=1;
//     if(flag>1){
//         player.sendChat(game.localize("chat.unfilled_framed_drawer"));
//         return false;
//     }
//     return true;
// });

onItemUse.onItemRightClickBlock(function(block as IItemStack)as bool{
    if(isNull(block)||isNull(block.definition))return false;
    if(!(framedDrawers has block.definition.id))return false;
    return true;
},BlockMatcher.allBlocks,
function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
    val data = item.tag;
    var flag = 0;
    if(isNull(data)){
        if(world.remote)player.sendChat(game.localize("chat.unfilled_framed_drawer"));
        return false;
    }
    if(isNull(data.MatT))flag+=1;
    if(isNull(data.MatS))flag+=1;
    if(isNull(data.MatF))flag+=1;
    if(flag>1){
        if(world.remote)player.sendChat(game.localize("chat.unfilled_framed_drawer"));
        return false;
    }
    return true;
},"all",false);