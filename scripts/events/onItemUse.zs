#reloadable
#priority 10001
import crafttweaker.event.PlayerRightClickItemEvent;
import crafttweaker.event.PlayerInteractBlockEvent;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import scripts.libs.ItemMatcher;

zenClass itemUsedOnBlock{
    val checkItem as function(IItemStack)bool;
    val checkBlock as function(IWorld,IBlockPos)bool;
    val action as function(IWorld,IBlockPos,IItemStack,IPlayer,string)bool;
    val hand as string;
    val noClient as bool;

    zenConstructor(checkItem as function(IItemStack)bool, checkBlock as function(IWorld,IBlockPos)bool, action as function(IWorld,IBlockPos,IItemStack,IPlayer,string)bool, hand as string, noClient as bool){
        this.checkItem = checkItem;
        this.checkBlock = checkBlock;
        this.action = action;
        this.hand = hand;
        this.noClient = noClient;
    }
}

static itemRightClickBlocks as itemUsedOnBlock[] = [];

function onItemRightClickBlock(item as function(IItemStack)bool, block as function(IWorld,IBlockPos)bool, action as function(IWorld,IBlockPos,IItemStack,IPlayer,string)bool, hand as string = "ALL", noClient as bool = true)as void{
    itemRightClickBlocks += itemUsedOnBlock(item, block, action, hand, noClient);
}

zenClass itemRightClick{
    val check as function(IItemStack)bool;
    val action as function(IItemStack,IPlayer,string)bool;
    val hand as string;

    zenConstructor(check as function(IItemStack)bool, action as function(IItemStack,IPlayer,string)bool, hand as string){
        this.check = check;
        this.action = action;
        this.hand = hand;
    }
}

static itemRightClicks as itemRightClick[] = [];

function onItemRightClick(check as function(IItemStack)bool, action as function(IItemStack,IPlayer,string)bool, hand as string = "ALL")as void{
    itemRightClicks += itemRightClick(check, action, hand);
}

events.onPlayerRightClickItem(function(event as PlayerRightClickItemEvent){
    if(event.world.remote)return;
    for i in itemRightClicks{
        if(i.hand.toUpperCase()=="ALL"||i.hand.toUpperCase()==event.hand.toUpperCase()){
            if(i.check(event.item)){
                if(!i.action(event.item, event.player, event.hand.toUpperCase()))event.cancel();
            }
        }
    }
});

events.onPlayerRightClickBlock(function(event as PlayerInteractBlockEvent){
    for i in itemRightClickBlocks{
        if(i.noClient && event.world.remote)continue;
        if(i.hand.toUpperCase()=="ALL"||i.hand.toUpperCase()==event.hand.toUpperCase()){
            if(i.checkItem(event.item) && i.checkBlock(event.world,event.position)){
                if(!i.action(event.world, event.position, event.item, event.player, event.hand.toUpperCase()))event.cancel();
            }
        }
    }
});