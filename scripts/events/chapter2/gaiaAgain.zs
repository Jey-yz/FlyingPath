#reloadable
import scripts.libs.ItemMatcher;
import crafttweaker.event.EntityLivingDamageEvent;
import crafttweaker.player.IPlayer;


events.onEntityLivingDamage(function(event as EntityLivingDamageEvent){
    val entity = event.entityLivingBase;
    val source = event.damageSource;
    if(source.trueSource instanceof IPlayer){
        val player as IPlayer = source.trueSource;
        val item = player.mainHandHeldItem;
        if(ItemMatcher.ItemMatcher("botania:enderdagger").matcher()(item)){
            if(!isNull(entity.definition)&&(entity.definition.id=="botania:doppleganger")){
                item.mutable().damageItem(5,player);
                val essence = <contenttweaker:gaia_essence>.createEntityItem(entity.world, entity.x as float, entity.y as float, entity.z as float);
                entity.world.spawnEntity(essence);
            }else if(!isNull(entity.definition)&&!(entity instanceof IPlayer)&&entity.world.random.nextInt(10)<6){
                item.mutable().damageItem(2,player);
                val essence = <contenttweaker:life_essence>.createEntityItem(entity.world, entity.x as float, entity.y as float, entity.z as float);
                entity.world.spawnEntity(essence);
            }
        }
        if(ItemMatcher.ItemMatcher(<draconicevolution:entity_detector>).matcher()(item)){
            if(!isNull(entity.definition)&&(entity.definition.id=="minecraft:wither_skeleton")){
                item.mutable().shrink(1);
                entity.setDead();
                player.give(<draconicevolution:entity_detector:1>);
            }
        }
    }
});