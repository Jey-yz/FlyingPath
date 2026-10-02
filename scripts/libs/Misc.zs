#reloadable
#priority 100000000
import scripts.libs.Data;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IFacing;
import crafttweaker.player.IPlayer;
import crafttweaker.text.ITextComponent;
import crafttweaker.entity.IEntityEquipmentSlot;
import mods.zenutils.NetworkHandler;
import mods.randomtweaker.botania.IBotaniaFXHelper;

function addShiftTooltips(item as IItemStack, tooltips as string[])as void{
    var tooltip = "";
    for i in tooltips{
        if(i.startsWith("item.shift_description.")){
            tooltip += game.localize(i);
            if(!(i==tooltips[-1+tooltips.length]))tooltip+="\u000A";
        }
        else{
            tooltip+=game.localize("item.shift_description."+i);
            if(!(i==tooltips[-1+tooltips.length]))tooltip+="\u000A";
        }
    }
    item.addShiftTooltip(tooltip,game.localize("item.description.shift"));
}
$ expand IItemStack $ addShiftTooltips(tooltips as string[])as void{
    return addShiftTooltips(this,tooltips);
}

function addTooltips(item as IItemStack, tooltips as string[])as void{
    for i in tooltips{
        if(i.startsWith("item.description.")){
            item.addTooltip(game.localize(i));
        }
        else{
            item.addTooltip(game.localize("item.description."+i));
        }
    }
}
$ expand IItemStack $ addTooltips(tooltips as string[])as void{
    return addTooltips(this,tooltips);
}

function addJEI(item as IItemStack, description as string)as void{
    if(description.startsWith("jei.description.")){
        mods.jei.JEI.addDescription(item,game.localize(description));
    }
    else{
        mods.jei.JEI.addDescription(item,game.localize("jei.description."+description));
    }
}
$ expand IItemStack $ addJEIDes(des as string)as void{
    return addJEI(this,des);
}

function addPos(pos as IBlockPos, dx as int, dy as int, dz as int)as IBlockPos{
    return IBlockPos.create(pos.x+dx,pos.y+dy,pos.z+dz);
}
$ expand IBlockPos $ add(x as int, y as int, z as int)as IBlockPos{
    return addPos(this,x,y,z);
}

function say(message as string)as void{
    server.commandManager.executeCommandSilent(server,"/say "~message);
}
// scripts.libs.Misc.say("Hello world");

$ expand string $ output()as void{
    print(this);
    return say(this);
}

$ expand string $ say()as void{
    return say(this);
}

function ItemToString(item as IItemStack)as string{
    if(isNull(item))return "null";
    return (item.definition.id~":"~item.metadata~" *"~item.amount);
}

$ expand IItemStack $ asString()as string{
    return ItemToString(this);
}

function ItemsToString(items as IItemStack[])as string{
    if(items.length==0)return "[]";
    var out = "[";
    for i in 0 to items.length{
        out+=(items[i].definition.id~":"~items[i].metadata~" *"~items[i].amount);
        if(i!=(-1+items.length))out+=", ";
    }
    out+="]";
    return out;
}

$ expand IItemStack[] $ asString()as string{
    return ItemsToString(this);
}

static IFacings as IFacing[] = [IFacing.up(),IFacing.down(),IFacing.north(),IFacing.east(),IFacing.south(),IFacing.west()];

function bracketPos(pos as IBlockPos)as string{
    return "("~pos.x~","~pos.y~","~pos.z~")";
}

$ expand IBlockPos $ asString()as string{
    return bracketPos(this);
}

function getHand(hand as string)as IEntityEquipmentSlot{
    if(hand.toUpperCase()=="MAIN_HAND")return IEntityEquipmentSlot.mainHand();
    if(hand.toUpperCase()=="OFF_HAND")return IEntityEquipmentSlot.offhand();
    return null;
}

function missBlock(player as IPlayer, pos as IBlockPos, name as string)as void{
    player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.miss_block_at", pos.asString(), name),false);
    NetworkHandler.sendTo("MissingBlockPosition",player,function(b){
        b.writeData(Data.fromBlockPos(pos));
    });
}

NetworkHandler.registerServer2ClientMessage("MissingBlockPosition",function(p,b){
    var pos = Data.toBlockPos(b.readData());
    IBotaniaFXHelper.wispFX(0.5+pos.x,0.5+pos.y,0.5+pos.z,1.0,0.2,0.2,0.5,0,0,0,1.0);
});

static pi as double = 3.141593;

function arc(degree as double)as double{
    return pi*degree/180;
}

