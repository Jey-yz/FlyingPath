#reloadable
import scripts.events.onItemUpdate;
import scripts.events.onItemUse;
import scripts.libs.ItemMatcher;
import scripts.libs.Misc;
import scripts.libs.Data;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.potions.IPotion;
import crafttweaker.potions.IPotionEffect;
import crafttweaker.entity.IEntity;
import crafttweaker.entity.IEntityArrow;
import crafttweaker.entity.IEntityLiving;
import crafttweaker.entity.IEntityLivingBase;
import crafttweaker.util.Math;
import crafttweaker.util.Position3f;
import crafttweaker.util.IAxisAlignedBB;
import crafttweaker.event.EntityLivingDamageEvent;
import native.vazkii.botania.common.entity.EntityFallingStar;
import native.vazkii.botania.common.entity.EntityMagicMissile;
import mods.zenutils.NetworkHandler;

function getEntityInDistance(world as IWorld, pos as Position3f, distance as double, ball as bool = false)as IEntity[]{
    val AABB = IAxisAlignedBB.create(-distance+pos.x,-distance+pos.y,-distance+pos.z,distance+pos.x,distance+pos.y,distance+pos.z);
    val cubeArea as IEntity[] = world.getEntitiesWithinAABB(AABB);
    if(!ball)return cubeArea;
    var ballArea as IEntity[] = [];
    for e in cubeArea{
        if(((-e.x+pos.x)*(-e.x+pos.x)+(-e.y+pos.y)*(-e.y+pos.y)+(-e.z+pos.z)*(-e.z+pos.z)) <= (distance*distance)){
            ballArea += e;
        }
    }
    return ballArea;
}

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:badge_surviving_hplock>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(!player.alive)return;
        if(player.health<7.0){
            player.health=7.0;
        }
    },false
);

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:badge_attacking_arrow>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(player.world.time%((player.getCooldown(item)>0)?16:8)==0){
            val entities = getEntityInDistance(player.world, player.position3f, 20, true);
            var entitiesLiving as IEntity[] = [];
            for e in entities{
                if((e instanceof IEntityLiving) && !(e instanceof IPlayer)){
                    entitiesLiving += e;
                }
            }
            if(entitiesLiving.length == 0)return;
            val entity = entitiesLiving[player.world.random.nextInt(entitiesLiving.length)];
            val arrow as IEntityArrow = <entity:minecraft:arrow>.createEntity(player.world);
            arrow.setPickupDisallowed();
            arrow.shooter = player;
            arrow.posX = entity.posX;
            arrow.posY = entity.posY+10.0;
            arrow.posZ = entity.posZ;
            arrow.motionY = -5.0;
            arrow.rotationPitch = -90.0;
            player.world.spawnEntity(arrow);
        }
    },true
);

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:badge_attacking_arrow>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        player.setCooldown(item,300);
        for i in 0 to 4{
            player.world.catenation().sleep(i*10+1).then(function(world,c){
                val entities = getEntityInDistance(player.world, player.position3f, 10, true);
                for e in entities{
                    if((e instanceof IEntityLiving) && !(e instanceof IPlayer)){
                        val arrow as IEntityArrow = <entity:minecraft:arrow>.createEntity(player.world);
                        arrow.setPickupDisallowed();
                        arrow.shooter = player;
                        arrow.posX = e.posX;
                        arrow.posY = e.posY+10.0;
                        arrow.posZ = e.posZ;
                        arrow.motionY = -3.5;
                        arrow.rotationPitch = -90.0;
                        player.world.spawnEntity(arrow);
                    }
                }
            }).start();
        }
        return true;
    }
);

static buffs as [int][string] = {
    "minecraft:resistance":[2,200,1],
    "minecraft:absorption":[10,300,2],
    "minecraft:regeneration":[2,200,1],
    "minecraft:strength":[3,300],
    "minecraft:speed":[4,300,2],
    "botania:soulcross":[1,400]
};

function rollEffect(player as IPlayer, multiplier as int = 1)as string{
    var try = 0;
    while (try<30){
        try += 1;
        val potion = buffs.keys[player.world.random.nextInt(buffs.keys.length)];
        val buffLimit = buffs[potion];
        if(player.isPotionActive(<potion:${potion}>)&&(try>8)){
            val duration = player.getActivePotionEffect(<potion:${potion}>).duration;
            val amplifier = player.getActivePotionEffect(<potion:${potion}>).amplifier;
            if(duration<(buffLimit[1]*multiplier*3/4)){
                return potion;
            }
            if(amplifier<buffLimit[0]){
                if(amplifier<(buffLimit[0]/2) && try>15)return potion;
            }
        }else{
            return potion;
        }
    }
    return buffs.keys[player.world.random.nextInt(buffs.keys.length)];
}

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:badge_surviving_dedebuff>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(player.world.time%3==2){
            for potionActive in player.activePotionEffects{
                if(potionActive.potion.badEffect){
                    player.removePotionEffect(potionActive.potion);
                    val buff as string = rollEffect(player);
                    if(player.isPotionActive(<potion:${buff}>)){
                        val amplifier = player.getActivePotionEffect(<potion:${buff}>).amplifier;
                        player.addPotionEffect(<potion:${buff}>.makePotionEffect(buffs[buff][1],min(((buffs[buff].length==3)?buffs[buff][2]:1)+amplifier, buffs[buff][0])));
                    }else{
                        player.addPotionEffect(<potion:${buff}>.makePotionEffect(buffs[buff][1],(buffs[buff].length==3)?(-1+buffs[buff][2]):0));
                    }
                }
            }
        }
    },true
);
onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:badge_buff_buffs>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        player.setCooldown(item,600);
        for i in 0 to 8{
            val buff as string = rollEffect(player,3);
            if(player.isPotionActive(<potion:${buff}>)){
                val amplifier = player.getActivePotionEffect(<potion:${buff}>).amplifier;
                player.addPotionEffect(<potion:${buff}>.makePotionEffect(buffs[buff][1]*3,min(((buffs[buff].length==3)?buffs[buff][2]:1)+amplifier, buffs[buff][0])));
            }else{
                player.addPotionEffect(<potion:${buff}>.makePotionEffect(buffs[buff][1]*3,(buffs[buff].length==3)?(-1+buffs[buff][2]):0));
            }
        }
        return true;
    }
);

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:badge_buff_strength>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(player.world.time%10==7){
            val entities = getEntityInDistance(player.world, player.position3f, 6, false);
            player.addPotionEffect(<potion:minecraft:strength>.makePotionEffect(200,min(8,entities.length/4)));
        }
    },true
);
onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:badge_buff_strength>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(!onItemUpdate.isHolding(player, ItemMatcher.ItemMatcher(<contenttweaker:badge_buff_strength>).matcher())){
            player.removePotionEffect(<potion:minecraft:strength>);
        }
    },false,false
);

events.onEntityLivingDamage(function(event as EntityLivingDamageEvent){
    if(event.entityLivingBase.world.remote)return;
    if(!(event.entityLivingBase instanceof IPlayer))return;
    val player as IPlayer = event.entityLivingBase;
    if(onItemUpdate.isHolding(player,ItemMatcher.ItemMatcher(<contenttweaker:badge_surviving_invulnerable>).matcher())){
        for e in getEntityInDistance(player.world, player.position3f, 8, true){
            if(e.isBoss){
                player.setCooldown(<contenttweaker:badge_attacking_areathorn>,10);
                event.cancel();
                return;
            }
        }
    }
    if(onItemUpdate.isHolding(player,ItemMatcher.ItemMatcher(<contenttweaker:badge_surviving_magicthorn>).matcher())){
        if(event.damageSource.damageType == "mob"){
            if(player.health<=(player.maxHealth*0.75)){
                player.setCooldown(<contenttweaker:badge_attacking_areathorn>,10);
                event.cancel();
                player.health=min(player.maxHealth, event.amount+player.health);
            }
        }else{
            player.attackEntityFrom(event.damageSource,event.amount*0.5);
        }
    }
    if(onItemUpdate.isHolding(player,ItemMatcher.ItemMatcher(<contenttweaker:badge_attacking_areathorn>).matcher())){
        if(player.getCooldown(<contenttweaker:badge_attacking_areathorn>)==0){
            for e in getEntityInDistance(player.world, player.position3f, 30, true){
                if(e instanceof IEntityLiving){
                    e.attackEntityFrom(crafttweaker.damage.IDamageSource.createThornsDamage(player),event.amount*2.0);
                }
            }
        }
    }
    if(onItemUpdate.isCarrying(player,ItemMatcher.ItemMatcher(<contenttweaker:force_of_life>).matcher())){
        if(player.world.random.nextInt(4)==0){
            event.cancel();
        }else{
            if(player.health<=(player.maxHealth*0.8)){
                player.setCooldown(<contenttweaker:badge_attacking_areathorn>,10);
                player.health=min(player.maxHealth, 0.5*event.amount+player.health);
            }
        }
    }
    if(onItemUpdate.isCarrying(player,ItemMatcher.ItemMatcher(<contenttweaker:force_of_murder>).matcher())){
        for e in getEntityInDistance(player.world, player.position3f, 30, true){
            if(e instanceof IEntityLiving){
                e.attackEntityFrom(crafttweaker.damage.IDamageSource.createThornsDamage(player),event.amount*2.0);
            }
        }
    }
    if(onItemUpdate.isCarrying(player,ItemMatcher.ItemMatcher(<contenttweaker:soul_of_challenger>).matcher())){
        if(onItemUpdate.isCarrying(player,function(item as IItemStack)as bool{
            if(!ItemMatcher.ItemMatcher(<contenttweaker:soul_of_challenger>).check(item))return false;
            if(isNull(item.tag))return true;
            return (item.tag.dataGet("murderingMode")??true as IData).asBool();
        })){
            for e in getEntityInDistance(player.world, player.position3f, 30, true){
                if(e instanceof IEntityLiving){
                    e.attackEntityFrom(crafttweaker.damage.IDamageSource.createThornsDamage(player),event.amount*2.8);
                }
            }
        }
        if(event.damageSource.damageType=="fall"){event.cancel();return;}
        if(player.world.random.nextInt(3)==0){
            event.cancel();
        }else{
            if(player.health<=(player.maxHealth*0.8)){
                player.health=min(player.maxHealth, 0.5*event.amount+player.health);
            }
        }
    }
});

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:badge_attacking_areathorn>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        player.attackEntityFrom(crafttweaker.damage.IDamageSource.createThornsDamage(player),min(10.0,player.health*0.6));
        player.setCooldown(item,50);
        return true;
    }
);

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:badge_attacking_star>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        player.setCooldown(item,600);
        for i in 0 to 10{
            player.world.catenation().sleep(i*10+1).then(function(world,c){
                for j in 0 to 30{
                    val star = EntityFallingStar(world.native, player.native);
                    star.setPosition(player.x+(-12.0+world.random.nextDouble()*24),player.y+40.0,player.z+(-12.0+world.random.nextDouble()*24));
                    star.motionY=-5.0*(0.3+world.random.nextDouble());
                    world.native.spawnEntity(star);
                }
            }).start();
        }
        return true;
    }
);

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:badge_attacking_missile>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        player.setCooldown(item,120);
        val entities = getEntityInDistance(player.world, player.position3f, 10, true);
        var targets as IEntityLivingBase[] = [];
        for e in entities{
            if(e.isBoss && (e instanceof IEntityLivingBase)){
                val target as IEntityLivingBase = e;
                targets+=target;
            }
        }
        for j in 0 to 15{
            player.world.catenation().sleep(j*5+1).then(function(world,c){
                val missile = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile.setPosition(player.x+2.0*Math.sin(Misc.arc(j*24)),player.y,player.z+2.0*Math.cos(Misc.arc(j*24)));
                missile.motionY=1.0;
                world.native.spawnEntity(missile);
                val missile2 = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile2.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile2.setPosition(player.x+3.5*Math.sin(Misc.arc(j*24+6)),player.y,player.z+3.5*Math.cos(Misc.arc(j*24+6)));
                missile2.motionY=1.0;
                world.native.spawnEntity(missile2);
                val missile3 = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile3.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile3.setPosition(player.x+3.5*Math.sin(Misc.arc(-6+j*24)),player.y,player.z+3.5*Math.cos(Misc.arc(-6+j*24)));
                missile3.motionY=1.0;
                world.native.spawnEntity(missile3);
            }).start();
        }
        return true;
    }
);

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher(<contenttweaker:badge_buff_teleport>).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        var mob as IEntityLivingBase = null;
        var health as float = 0.0 as float;
        for i in getEntityInDistance(player.world, player.position3f, 30, true){
            if(!(i instanceof IEntityLivingBase) || (i instanceof IPlayer))continue;
            val living as IEntityLivingBase = i;
            if(living.health > health){
                health = living.health;
                mob = living;
            }
        }
        if(!isNull(mob)){
            player.posX = mob.x;
            player.posY = mob.y;
            player.posZ = mob.z;
            // player.teleport(mob.position3f);
            player.setCooldown(item,2);
        }
        return true;
    }
);
onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:badge_buff_teleport>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(player.world.time%5==0){
            val pos = player.position3f;
            val distance = 4.5;
            val AABB = IAxisAlignedBB.create(-distance+pos.x,-distance+pos.y,-distance+pos.z,distance+pos.x,distance+pos.y,distance+pos.z);
            val entities = player.world.getEntitiesWithinAABB(AABB);
            if(entities.length==0)return;
            val random = player.world.random;
            // for i in 0 to 3{
                // val e = entities[random.nextInt(entities.length)];
            for e in entities{
                if(e instanceof IPlayer || e.isBoss)continue;
                val vec = [-0.5+random.nextDouble(),-0.5+random.nextDouble(),-0.5+random.nextDouble()];
                val length = Math.sqrt(vec[0]*vec[0]+vec[1]*vec[1]+vec[2]*vec[2]);
                val length2 = 10.0;
                val vec2 = [vec[0]*length2/length,vec[1]*length2/length,vec[2]*length2/length];
                e.posX = vec2[0]+player.x;
                e.posY = vec2[1]+player.y;
                e.posZ = vec2[2]+player.z;
            }
        }
    },true
);

function generateRecipe(out as IItemStack, inp as IItemStack, slot as int)as void{
    val twoNull as IIngredient[] = [null,null];
    if(slot==0)recipes.addShaped(out,[[inp,null],twoNull]);
    if(slot==1)recipes.addShaped(out,[[null,inp],twoNull]);
    if(slot==2)recipes.addShaped(out,[twoNull,[inp,null]]);
    if(slot==3)recipes.addShaped(out,[twoNull,[null,inp]]);
    if(!(inp.matches(<contenttweaker:badge_basic>)))recipes.addShapeless(inp,[out]);
}

val basic = [<contenttweaker:badge_attacking>,<contenttweaker:badge_surviving>,<contenttweaker:badge_buff>] as IItemStack[];
val attacking = [<contenttweaker:badge_attacking_areathorn>,<contenttweaker:badge_attacking_arrow>,<contenttweaker:badge_attacking_missile>,<contenttweaker:badge_attacking_star>]as IItemStack[];
val surviving = [<contenttweaker:badge_surviving_dedebuff>,<contenttweaker:badge_surviving_hplock>,<contenttweaker:badge_surviving_invulnerable>,<contenttweaker:badge_surviving_magicthorn>];
val buff = [<contenttweaker:badge_buff_buffs>,<contenttweaker:badge_buff_strength>,<contenttweaker:badge_buff_teleport>]as IItemStack[];

for i in 0 to attacking.length{
    generateRecipe(attacking[i],<contenttweaker:badge_attacking>,i);
}
for i in 0 to surviving.length{
    generateRecipe(surviving[i],<contenttweaker:badge_surviving>,i);
}
for i in 0 to buff.length{
    generateRecipe(buff[i],<contenttweaker:badge_buff>,i);
}
for i in 0 to basic.length{
    generateRecipe(basic[i],<contenttweaker:badge_basic>,i);
    recipes.addShapeless(<contenttweaker:badge_basic>,[basic[i],basic[i].Reuse()]);
}

<contenttweaker:badge_attacking_areathorn>.addShiftTooltips(["badge_attacking_areathorn.holding","badge_attacking_areathorn.click","badge_attacking_areathorn.cooldown"] as string[]);
<contenttweaker:badge_attacking_arrow>.addShiftTooltips(["badge_attacking_arrow.holding","badge_attacking_arrow.click","badge_attacking_arrow.cooldown"]as string[]);
<contenttweaker:badge_attacking_missile>.addTooltip(game.localize("item.description.badge_attacking_missile"));
<contenttweaker:badge_attacking_missile>.addShiftTooltips(["badge_attacking_missile.click"]as string[]);
<contenttweaker:badge_attacking_star>.addShiftTooltips(["badge_attacking_star.click","badge_attacking_star.ez"]as string[]);
<contenttweaker:badge_surviving_invulnerable>.addTooltip(game.localize("item.description.badge_surviving_invulnerable"));
<contenttweaker:badge_surviving_invulnerable>.addShiftTooltips(["item.shift_description.badge_surviving_invulnerable.holding"]as string[]);
<contenttweaker:badge_surviving_dedebuff>.addShiftTooltips(["item.shift_description.badge_surviving_dedebuff.holding"]as string[]);
<contenttweaker:badge_surviving_hplock>.addShiftTooltips(["item.shift_description.badge_surviving_hplock.carrying"]as string[]);
<contenttweaker:badge_surviving_magicthorn>.addTooltip(game.localize("item.description.badge_surviving_magicthorn"));
<contenttweaker:badge_surviving_magicthorn>.addShiftTooltips(["badge_surviving_magicthorn.regenerate","badge_surviving_magicthorn.areathron","badge_surviving_magicthorn.extradamage"]as string[]);
<contenttweaker:badge_buff_strength>.addShiftTooltips(["badge_buff_strength.holding","badge_buff_strength.carrying"]as string[]);
<contenttweaker:badge_buff_buffs>.addShiftTooltips(["badge_buff_buffs.click"]as string[]);
<contenttweaker:badge_buff_teleport>.addShiftTooltips(["badge_buff_teleport.holding","badge_buff_teleport.click"]as string[]);

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:force_of_life>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(!player.alive)return;
        if(player.health<0.4*player.maxHealth){
            player.health=0.4*player.maxHealth;
        }
        if(player.world.time%5==2){
            for potionActive in player.activePotionEffects{
                if(potionActive.potion.badEffect){
                    player.removePotionEffect(potionActive.potion);
                    var buff as string = buffs.keys[player.world.random.nextInt(buffs.length)];
                    var attempt as int = 0;
                    while attempt<10{
                        if(buff=="minecraft:strength"||player.isPotionActive(<potion:${buff}>)){
                            buff = buffs.keys[player.world.random.nextInt(buffs.length)];
                        }
                        attempt+=1;
                    }
                    player.addPotionEffect(<potion:${buff}>.makePotionEffect(2*buffs[buff][1],buffs[buff][0]));
                }
            }
        }
    },false
);

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:force_of_aid>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(player.world.time%100==0){
            for i in 0 to 3{
                val buff as string = rollEffect(player,1);
                if(player.isPotionActive(<potion:${buff}>)){
                    val amplifier = player.getActivePotionEffect(<potion:${buff}>).amplifier;
                    player.addPotionEffect(<potion:${buff}>.makePotionEffect(1.5*buffs[buff][1],min(((buffs[buff].length==3)?buffs[buff][2]:1)+amplifier, buffs[buff][0])));
                }else{
                    player.addPotionEffect(<potion:${buff}>.makePotionEffect(buffs[buff][1],(buffs[buff].length==3)?(-1+buffs[buff][2]):0));
                }
            }
        }
        if(player.world.time%10==7){
            player.foodStats.foodLevel=20;
            val entities = getEntityInDistance(player.world, player.position3f, 6, false);
            player.addPotionEffect(<potion:minecraft:strength>.makePotionEffect(200,entities.length/3));
            if(player.isInLava)player.addPotionEffect(<potion:minecraft:fire_resistance>.makePotionEffect(20,0));
            player.extinguish();
            if(player.air<0)player.addPotionEffect(<potion:minecraft:water_breathing>.makePotionEffect(20,0));
        }
        if(player.posY<-2){
            player.motionY=1.8;
            NetworkHandler.sendTo("PlayerForceOfAidLifting",player,function(b){
            });
        }
    },false
);
onItemUse.onItemRightClick(ItemMatcher.ItemMatcher([<contenttweaker:force_of_aid>,<contenttweaker:soul_of_challenger>]).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        val reachDistance = player.getAttribute("generic.reachDistance");
        if(isNull(reachDistance))return false;
        var pos = player.getRayTrace(((item.definition.id=="contenttweaker:force_of_aid")?1.5:2.5)*reachDistance.getAttributeValue(),1.0 as float).blockPos;
        player.position = pos;
        NetworkHandler.sendTo("IslandTeleport",player,function(b){
            b.writeData(Data.fromBlockPos(pos));
        });
        return true;
    }
);
NetworkHandler.registerServer2ClientMessage("PlayerForceOfAidLifting",function(player,b){
    player.motionY = 1.8;
});

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:force_of_murder>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(player.world.time%15==0){
            val world = player.world;
            val entities = getEntityInDistance(player.world, player.position3f, 20, true);
            var entitiesLiving as IEntity[] = [];
            var targets as IEntityLivingBase[] = [];
            for e in entities{
                if((e instanceof IEntityLiving) && !(e instanceof IPlayer)){
                    entitiesLiving += e;
                }
                if(e.isBoss && (e instanceof IEntityLivingBase)){
                    val target as IEntityLivingBase = e;
                    targets+=target;
                }
            }
            if(entitiesLiving.length == 0)return;
            for i in 0 to 3{
                val entity = entitiesLiving[player.world.random.nextInt(entitiesLiving.length)];
                val arrow as IEntityArrow = <entity:minecraft:arrow>.createEntity(player.world);
                arrow.setPickupDisallowed();
                arrow.shooter = player;
                arrow.posX = entity.posX;
                arrow.posY = entity.posY+10.0;
                arrow.posZ = entity.posZ;
                arrow.motionY = -5.0;
                arrow.rotationPitch = -90.0;
                player.world.spawnEntity(arrow);
                val missile = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile.setPosition(player.x,player.y+2.0,player.z);
                world.native.spawnEntity(missile);
                for j in 0 to 2{
                    val star = EntityFallingStar(world.native, player.native);
                    star.setPosition(player.x+(-12.0+world.random.nextDouble()*24),player.y+40.0,player.z+(-12.0+world.random.nextDouble()*24));
                    star.motionY=-5.0*(0.3+world.random.nextDouble());
                    world.native.spawnEntity(star);
                }
            }
        }
    },false
);

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher([<contenttweaker:force_of_murder>,<contenttweaker:soul_of_challenger>]).matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        if(player.isSneaking)return false;
        val world = player.world;
        val entities = getEntityInDistance(player.world, player.position3f, 15, true);
        for i in 0 to 2{
            player.world.catenation().sleep(i*25+1).then(function(world,c){
                for e in entities{
                    if((e instanceof IEntityLiving) && !(e instanceof IPlayer)){
                        val arrow as IEntityArrow = <entity:minecraft:arrow>.createEntity(player.world);
                        arrow.setPickupDisallowed();
                        arrow.shooter = player;
                        arrow.posX = e.posX;
                        arrow.posY = e.posY+10.0;
                        arrow.posZ = e.posZ;
                        arrow.motionY = ((item.definition.id=="contenttweaker:force_of_murder")?-4.5:-6.0);
                        arrow.rotationPitch = -90.0;
                        player.world.spawnEntity(arrow);
                    }
                }
            }).start();
        }
        var targets as IEntityLivingBase[] = [];
        for e in entities{
            if(e.isBoss && (e instanceof IEntityLivingBase)){
                val target as IEntityLivingBase = e;
                targets+=target;
            }
        }
        for j in 0 to 15{
            player.world.catenation().sleep(j*2+1).then(function(world,c){
                val missile = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile.setPosition(player.x+2.0*Math.sin(Misc.arc(j*24)),player.y,player.z+2.0*Math.cos(Misc.arc(j*24)));
                missile.motionY=1.0;
                world.native.spawnEntity(missile);
                val missile2 = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile2.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile2.setPosition(player.x+3.5*Math.sin(Misc.arc(j*24+6)),player.y,player.z+3.5*Math.cos(Misc.arc(j*24+6)));
                missile2.motionY=1.0;
                world.native.spawnEntity(missile2);
            }).start();
        }
        for j in 0 to ((item.definition.id=="contenttweaker:force_of_murder")?30:50){
            val star = EntityFallingStar(world.native, player.native);
            star.setPosition(player.x+(-12.0+world.random.nextDouble()*24),player.y+40.0,player.z+(-12.0+world.random.nextDouble()*24));
            star.motionY=-5.0*(0.3+world.random.nextDouble());
            world.native.spawnEntity(star);
        }
        player.setCooldown(item,((item.definition.id=="contenttweaker:force_of_murder")?180:75));
        return true;
    }
);

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:soul_of_challenger>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        if(!isNull(player.nbt.dataGet("abilities.flying"))&&player.nbt.dataGet("abilities.flying")==1){
            native.vazkii.botania.api.mana.ManaItemHandler.dispatchManaExact(item.native,player.native,1,true);
        }
        if(player.world.time%60==0){
            for i in 0 to 3{
                val buff as string = rollEffect(player,1);
                if(player.isPotionActive(<potion:${buff}>)){
                    val amplifier = player.getActivePotionEffect(<potion:${buff}>).amplifier;
                    player.addPotionEffect(<potion:${buff}>.makePotionEffect(2.5*buffs[buff][1],min(((buffs[buff].length==3)?buffs[buff][2]:1)+amplifier, buffs[buff][0])));
                }else{
                    player.addPotionEffect(<potion:${buff}>.makePotionEffect(1.5*buffs[buff][1],(buffs[buff].length==3)?(-1+buffs[buff][2]):0));
                }
            }
        }
        if(player.world.time%10==7){
            val entities = getEntityInDistance(player.world, player.position3f, 8, false);
            player.addPotionEffect(<potion:minecraft:strength>.makePotionEffect(200,entities.length/3));
            if(player.isInLava)player.addPotionEffect(<potion:minecraft:fire_resistance>.makePotionEffect(200,0));
            player.extinguish();
            player.air = 300;
        }
        if(player.posY<-2){
            player.motionY=1.8;
            NetworkHandler.sendTo("PlayerForceOfAidLifting",player,function(b){
            });
        }
        if(!player.alive)return;
        if(player.health<0.6*player.maxHealth){
            player.health=0.6*player.maxHealth;
        }
        if(player.world.time%5==2){
            player.foodStats.foodLevel=20;
            for potionActive in player.activePotionEffects{
                if(potionActive.potion.badEffect){
                    player.removePotionEffect(potionActive.potion);
                    var buff as string = buffs.keys[player.world.random.nextInt(buffs.length)];
                    for i in 0 to 2{
                        var attempt as int = 0;
                        while attempt<10{
                            if(player.isPotionActive(<potion:${buff}>)){
                                buff = buffs.keys[player.world.random.nextInt(buffs.length)];
                            }
                            attempt+=1;
                        }
                        player.addPotionEffect(<potion:${buff}>.makePotionEffect(2*buffs[buff][1],buffs[buff][0]));
                    }
                }
            }
        }
        if(player.world.time%10==0){
            if(!isNull(item.tag)&&!(item.tag.dataGet("murderingMode")??true as IData).asBool())return;
            val world = player.world;
            val entities = getEntityInDistance(player.world, player.position3f, 20, true);
            var entitiesLiving as IEntity[] = [];
            var targets as IEntityLivingBase[] = [];
            for e in entities{
                if((e instanceof IEntityLiving) && !(e instanceof IPlayer)){
                    entitiesLiving += e;
                }
                if(e.isBoss && (e instanceof IEntityLivingBase)){
                    val target as IEntityLivingBase = e;
                    targets+=target;
                }
            }
            if(entitiesLiving.length == 0)return;
            for i in 0 to 3{
                val entity = entitiesLiving[player.world.random.nextInt(entitiesLiving.length)];
                val arrow as IEntityArrow = <entity:minecraft:arrow>.createEntity(player.world);
                arrow.setPickupDisallowed();
                arrow.shooter = player;
                arrow.posX = entity.posX;
                arrow.posY = entity.posY+10.0;
                arrow.posZ = entity.posZ;
                arrow.motionY = ((item.definition.id=="contenttweaker:force_of_murder")?-4.5:-6.0);
                arrow.rotationPitch = -90.0;
                player.world.spawnEntity(arrow);
                val missile = EntityMagicMissile(player.native, false);
                if(targets.length>0 && world.random.nextBoolean()){
                    missile.setTarget(targets[world.random.nextInt(targets.length)].native);
                }
                missile.setPosition(player.x,player.y+2.0,player.z);
                world.native.spawnEntity(missile);
                for j in 0 to 2{
                    val star = EntityFallingStar(world.native, player.native);
                    star.setPosition(player.x+(-12.0+world.random.nextDouble()*24),player.y+40.0,player.z+(-12.0+world.random.nextDouble()*24));
                    star.motionY=-5.0*(0.3+world.random.nextDouble());
                    world.native.spawnEntity(star);
                }
            }
        }
    },false
);

events.onEntityJoinWorld(function(event as crafttweaker.event.EntityJoinWorldEvent){
    if(event.world.remote)return;
    if(!(event.entity instanceof crafttweaker.entity.IEntityItem))return;
    val itemEntity as crafttweaker.entity.IEntityItem = event.entity;
    if(!ItemMatcher.ItemMatcher(["contenttweaker:force_of_murder","contenttweaker:force_of_aid","contenttweaker:force_of_life","contenttweaker:soul_of_challenger"]).check(itemEntity.item))return;
    itemEntity.native.setPickupDelay(5);
    itemEntity.native.lifespan = 2147483647;
    event.world.catenation()
        .sleepUntil(function(w, ctx) {
            if (!itemEntity.native.addedToWorld || !itemEntity.alive) {
                ctx.catenation.stop();
            }
            if (itemEntity.posY<0) {
                return true;
            } else {
                return false;
            }
    }).then(function(w,c){
        if(itemEntity.native.addedToWorld || itemEntity.alive){
            itemEntity.hasNoGravity = true;
            itemEntity.motionY = 0.2;
            itemEntity.world.catenation().sleepUntil(function(w,c){
                if (!itemEntity.native.addedToWorld || !itemEntity.alive) {
                    c.catenation.stop();
                }
                if (itemEntity.posY>5) {
                    return true;
                } else {
                    return false;
                }
            }).then(function(w,c){
                if(itemEntity.native.addedToWorld || itemEntity.alive){
                    itemEntity.motionY = 0.0;
                }
            }).start();
        }
    }).start();
});

<contenttweaker:force_of_murder>.addTooltip(game.localize("item.description.force_of_murder"));
<contenttweaker:force_of_murder>.addShiftTooltips(["force_of_murder.carrying","force_of_murder.click"]as string[]);
<contenttweaker:force_of_aid>.addTooltip(game.localize("item.description.force_of_aid"));
<contenttweaker:force_of_aid>.addShiftTooltips(["force_of_aid.carrying","force_of_aid.click"]as string[]);
<contenttweaker:force_of_life>.addTooltip(game.localize("item.description.force_of_life"));
<contenttweaker:force_of_life>.addShiftTooltips(["force_of_life.carrying"]as string[]);
<contenttweaker:soul_of_challenger>.addShiftTooltips(["soul_of_challenger","soul_of_challenger.not_so_true"]as string[]);
<contenttweaker:soul_of_challenger>.addAdvancedTooltip(function(item){
    val formats = "46ea23b915d";
    val text = game.localize("item.description.soul_of_challenger");
    var out = "";
    val time = native.vazkii.botania.common.Botania.proxy.getWorldElapsedTicks();
    for i in 0 to text.length{
        out+="§"~formats[(i+time)%formats.length]~text[i];
    }
    out+="§r";
    return out;
});
<contenttweaker:soul_of_challenger>.addShiftTooltip(function(item){
    val data = item.tag;
    if(isNull(data)||isNull(data.murderingMode))return game.localize("item.shift_description.soul_of_challenger.murder_on");
    return game.localize("item.shift_description.soul_of_challenger.murder_"~(data.murderingMode.asBool()?"on":"off"));
});

recipes.addHiddenShapeless("soul_of_the_aesir",<contenttweaker:soul_of_challenger>,[<contenttweaker:force_of_murder>,<contenttweaker:force_of_aid>,<contenttweaker:force_of_life>]);
recipes.addHiddenShapeless("soul_of_the_aesir_murdering",<contenttweaker:soul_of_challenger>,[<contenttweaker:soul_of_challenger>.marked("soul")],function(out,ins,info){
    val data = ins.soul.tag;
    if(isNull(data))return <contenttweaker:soul_of_challenger>.withTag({murderingMode:false});
    if(isNull(data.murderingMode))return <contenttweaker:soul_of_challenger>.withTag(data.dataSet(false,"murderingMode"));
    return <contenttweaker:soul_of_challenger>.withTag(data.dataSet(!data.murderingMode.asBool(),"murderingMode"));
},null);
mods.jei.JEI.hide(<contenttweaker:force_of_murder>);
mods.jei.JEI.hide(<contenttweaker:force_of_aid>);
mods.jei.JEI.hide(<contenttweaker:force_of_life>);
mods.jei.JEI.hide(<contenttweaker:soul_of_challenger>);