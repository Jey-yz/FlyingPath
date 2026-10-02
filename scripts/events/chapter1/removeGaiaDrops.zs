#reloadable
import crafttweaker.event.EntityLivingDeathDropsEvent;
import crafttweaker.event.EntityJoinWorldEvent;
import crafttweaker.entity.IEntityItem;
import crafttweaker.item.IItemStack;
import native.net.minecraft.entity.passive.EntityChicken;

events.onEntityLivingDeathDrops(function(event as EntityLivingDeathDropsEvent){
    val entity = event.entityLivingBase;
    if(entity.world.remote)return;
    if(!isNull(entity.tags)&&((entity.tags has "gaiaSpawned") || (entity.tags has "chickenJockey"))){
        event.drops = [] as IEntityItem[];
    }else if(!isNull(entity.definition)&&entity.definition.id=="botania:doppleganger"){
        var newDrops as IEntityItem[] = [];
        for i in event.drops{
            val item = i.item;
            if(isNull(item)||isNull(item.definition))continue;
            if(item.definition.id=="botania:ancientwill"||item.definition.id=="botania:dice")newDrops+=i;
            if(item.definition.id=="botania:manaresource"&&item.metadata==5)newDrops+=i;
        }
        event.drops = newDrops;
    }
});

events.onEntityJoinWorld(function(event as EntityJoinWorldEvent){
    if(event.world.remote)return;
    if(event.entity.native instanceof EntityChicken){
        val chicken as EntityChicken = event.entity.native as EntityChicken;
        if(chicken.chickenJockey){
            event.entity.addTag("chickenJockey");
        }
    }
});