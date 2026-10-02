#reloadable
#priority 10003
import scripts.libs.Data;
import scripts.libs.BlockMatcher;
import crafttweaker.player.IPlayer;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.block.IBlock;
import crafttweaker.data.IData;
import mods.zenutils.DataUpdateOperation.REMOVE;

static BlockUpdateID as int = 0;

zenClass BlockUpdate{
    val id as string;
    val block as function(IWorld,IBlockPos)bool;
    val tickStart as bool = false;
    val action as function(IWorld,IBlockPos)void;

    zenConstructor(id as string, block as function(IWorld,IBlockPos)bool, action as function(IWorld,IBlockPos)void, atStart as bool){
        this.id = id;
        this.block = block;
        this.action = action;
        this.tickStart = tickStart;
    }
}

static BlockUpdates as BlockUpdate[] = [];

function onBlockUpdate(block as function(IWorld,IBlockPos)bool, action as function(IWorld,IBlockPos)void, tickStart as bool = false, id as string = "")as void{
    if(id==""){
        BlockUpdates += BlockUpdate("TickBlock"~BlockUpdateID as string,block,action,tickStart);
        BlockUpdateID += 1;
    }else{
        BlockUpdates += BlockUpdate(id,block,action,tickStart);
    }
}

function getTickBlockByID(id as string)as BlockUpdate{
    for i in BlockUpdates{
        if(i.id==id)return i;
    }
    return null;
}

events.onBlockNeighborNotify(function(event as crafttweaker.event.BlockNeighborNotifyEvent){
    var world = event.world;
    var pos = event.position;
    if(isNull(world.getCustomWorldData())||isNull(world.getCustomWorldData().onTickBlocks)){
        world.setCustomWorldData(world.getCustomWorldData().dataSet({"onTickBlocks":{}} as IData,""));
    }
    for a in BlockUpdates{
        if(!a.block(world,pos))continue;
        if(isNull(world.getCustomWorldData().dataGet("onTickBlocks."~a.id))){
            world.setCustomWorldData(world.getCustomWorldData().dataSet([Data.fromBlockPos(pos)] as IData,"onTickBlocks."~a.id));
        }else{
            if(world.getCustomWorldData().dataGet("onTickBlocks."~a.id) has Data.fromBlockPos(pos))continue;
            world.setCustomWorldData(world.getCustomWorldData().dataSet((world.getCustomWorldData().dataGet("onTickBlocks."~a.id)+[Data.fromBlockPos(pos)]) as IData,"onTickBlocks."~a.id));
        }
    }
});

events.onWorldTick(function(event as crafttweaker.event.WorldTickEvent){
    var world = event.world;
    if(world.remote)return;
    if(event.side!="SERVER")return;
    var data as IData= world.getCustomWorldData();
    if(isNull(data))return;
    if(isNull(data.onTickBlocks))return;
    for i,j in world.getCustomWorldData().onTickBlocks.asMap(){
        val block as BlockUpdate = getTickBlockByID(i);
        if(isNull(block))continue;
        if(block.tickStart==true){if(event.phase!="START")continue;}
        if(block.tickStart==false){if(event.phase!="END")continue;}
        if(isNull(j))continue;
        if(j.length==0){continue;}
        for k in 0 to j.length{
            if(!world.native.isBlockLoaded(Data.toBlockPos(j[k]).native))continue;
            if(!block.block(world,Data.toBlockPos(j[k]))){
                world.setCustomWorldData(world.getCustomWorldData().dataSet(j.deepUpdate([j[k]], REMOVE),"onTickBlocks."~i));
            }else{
                block.action(world,Data.toBlockPos(j[k]));
            }
        }
    }
});
