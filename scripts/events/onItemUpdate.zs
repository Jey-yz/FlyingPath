#reloadable
#priority 10002
import crafttweaker.event.PlayerTickEvent;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import crafttweaker.entity.IEntityEquipmentSlot;
import scripts.libs.ItemMatcher;

zenClass itemUpdate{
    val check as function(IItemStack)bool;
    val action as function(IItemStack,IPlayer,int)void;
    val atStart as bool;
    val holding as bool;

    zenConstructor(check as function(IItemStack)bool, action as function(IItemStack,IPlayer,int)void, start as bool, holding as bool){
        this.check = check;
        this.action = action;
        this.atStart = start;
        this.holding = holding;
    }
}

static itemUpdates as itemUpdate[] = [];

function onItemUpdate(check as function(IItemStack)bool, action as function(IItemStack,IPlayer,int)void, holding as bool = false, start as bool = true)as void{
    itemUpdates += itemUpdate(check, action, start, holding);
}

events.onPlayerTick(function(event as PlayerTickEvent){
    if(event.player.world.remote)return;
    var player = event.player;
    for i in 0 to player.inventorySize{
        for item in itemUpdates{
            if(item.holding&&(i!=40))continue;
            if(item.atStart&&event.phase=="START"){
                if(item.check(player.getInventoryStack(i))){
                    item.action(player.getInventoryStack(i),player,i);
                }
            }else if(!item.atStart&&event.phase=="END"){
                if(item.check(player.getInventoryStack(i))){
                    item.action(player.getInventoryStack(i),player,i);
                }
            }
        }
    }
    for item in itemUpdates{
        if((item.atStart&&event.phase=="START")||!item.atStart&&event.phase=="END"){
            if(item.holding&&item.check(player.currentItem))item.action(player.currentItem,player,-1);
        }
    }

    //Allow players to eat food to regenerate faster, but eating is not necessary.
    if(player.foodStats.foodLevel<18){
        player.foodStats.foodLevel=18;
    }
});

function isHolding(player as IPlayer, item as function(IItemStack)bool)as bool{
    if(item(player.getItemInSlot(IEntityEquipmentSlot.mainHand()))){
        return true;
    }
    if(item(player.getItemInSlot(IEntityEquipmentSlot.offhand()))){
        return true;
    }
    return false;
}

function isCarrying(player as IPlayer, item as function(IItemStack)bool)as bool{
    for i in 0 to player.inventorySize{
        if(item(player.getInventoryStack(i)))return true;
    }
    return false;
}