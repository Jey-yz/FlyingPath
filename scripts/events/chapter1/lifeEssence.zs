#reloadable
import scripts.events.onItemUse;
import scripts.events.onBlockPlace;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.libs.Data;
import scripts.libs.Misc;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import crafttweaker.damage.IDamageSource;
import crafttweaker.event.PlayerTickEvent;
import crafttweaker.util.Math;
import mods.zenutils.NetworkHandler;
import mods.zenutils.Catenation;
import mods.randomtweaker.botania.IBotaniaFXHelper;

static TimeLifeEssenceCanHold as int = 80;

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher("botania:enderdagger").matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        if(player.getCooldown(<botania:enderdagger>)>0)return false;
        if(hand=="MAIN_HAND"){
            if(!ItemMatcher.ItemMatcher("botania:quartztypelavender",1).matcher()(player.offHandHeldItem)){
                return false;
            }
            player.offHandHeldItem.mutable().shrink(1);
        }else if(hand=="OFF_HAND"){
            if(!ItemMatcher.ItemMatcher("botania:quartztypelavender",1).matcher()(player.mainHandHeldItem)){
                return false;
            }
            player.mainHandHeldItem.mutable().shrink(1);
        }
        player.attackEntityFrom(IDamageSource.MAGIC(),1.0);
        player.setCooldown(<botania:enderdagger>,10);
        player.update(player.nbt.dataGet("ForgeData").dataSet(1+(player.nbt.dataGet("ForgeData.LifeEssenceProgress")??(0 as IData)).asInt(),"LifeEssenceProgress"));
        player.update(player.nbt.dataGet("ForgeData").dataSet(TimeLifeEssenceCanHold,"LifeEssenceTime"));
        if((player.nbt.dataGet("ForgeData.LifeEssenceProgress")??(0 as IData)).asInt()>=32){
            player.update(player.nbt.dataGet("ForgeData").dataSet(0,"LifeEssenceProgress")); 
            player.give(<contenttweaker:life_essence>*16);
        }
        return true;
    }
);
onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher("botania:quartztypelavender",1).matcher(),BlockMatcher.allBlocks,
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(hand=="MAIN_HAND"){
            if(ItemMatcher.ItemMatcher("botania:enderdagger").matcher()(player.offHandHeldItem)){
                return false;
            }
        }else if(hand=="OFF_HAND"){
            if(ItemMatcher.ItemMatcher("botania:enderdagger").matcher()(player.mainHandHeldItem)){
                return false;
            }
        }
        return true;
    },"all",false
);

events.onPlayerTick(function(event as PlayerTickEvent){
    if(event.player.world.remote)return;
    var player = event.player;
    if(event.phase=="END")return;
    if(isNull(player.nbt.dataGet("ForgeData.LifeEssenceProgress"))||isNull(player.nbt.dataGet("ForgeData.LifeEssenceTime")))return;
    val time = player.nbt.dataGet("ForgeData.LifeEssenceTime").asInt();
    val progress = player.nbt.dataGet("ForgeData.LifeEssenceProgress").asInt();
    if(progress>0 && time>0){
        if(time==1){
            player.update(player.nbt.dataGet("ForgeData").dataSet(-1+progress,"LifeEssenceProgress")); 
            player.update(player.nbt.dataGet("ForgeData").dataSet(TimeLifeEssenceCanHold,"LifeEssenceTime"));
        }else{
            player.update(player.nbt.dataGet("ForgeData").dataSet(-1+time,"LifeEssenceTime")); 
        }
    }
    val pos = player.position3f;
    player.world.catenation().then(function(world,c){
        if(Math.abs(player.posX-pos.x)<0.1 && Math.abs(player.posY-pos.y)<0.1 && Math.abs(player.posZ-pos.z)<0.1 && progress>0){
            NetworkHandler.sendTo("PlayerLifeEssenceParticle",player,function(b){
                b.writeInt(player.nbt.dataGet("ForgeData.LifeEssenceProgress").asInt());
                b.writeData(Data.fromPos3f(player.position3f,"pos")+{Time:time});
            });
        }
    }).start();
});

NetworkHandler.registerServer2ClientMessage("PlayerLifeEssenceParticle",function(p,b){
    val num = b.readInt();
    val data = b.readData();
    val pos = Data.toPos3f(data,"pos");
    val time = data.Time.asInt();
    for i in 0 to num{
        IBotaniaFXHelper.wispFX(1.3*Math.sin(Misc.arc(360.0/32*i))+pos.x,0.2+pos.y,1.3*Math.cos(Misc.arc(360.0/32*i))+pos.z,0.1,0.1,0.1,0.2*((i==-1+num)?(0.8*time/TimeLifeEssenceCanHold+0.2):1),0,0,0,1.0);
    }
});

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<contenttweaker:life_essence>).matcher(),BlockMatcher.BlockMatcher(<storagedrawers:customtrim>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        item.mutable().shrink(1);
        world.setBlockState(<blockstate:botania:livingwood>,pos);
        return true;
    }
);