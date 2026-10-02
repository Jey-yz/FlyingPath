#reloadable
import scripts.libs.Misc;
import scripts.libs.Data;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import scripts.events.onItemUpdate;
import scripts.events.onBlockPlace;
import scripts.events.onBlockUpdate;
import crafttweaker.item.IItemStack;
import crafttweaker.data.IData;
import crafttweaker.entity.IEntityLivingBase;
import crafttweaker.entity.IEntityEquipmentSlot;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.util.Math;
import crafttweaker.util.Position3f;
import crafttweaker.text.ITextComponent;
import mods.zenutils.NetworkHandler;
import mods.randomtweaker.botania.IBotaniaFXHelper;
import native.net.minecraft.util.math.AxisAlignedBB;
import native.teamroots.embers.particle.ParticleUtil;

static dust_poses as [int[]] = [];
static pedestal_poses as [int[]] = [];
for z in -7 to 8{
    for x in -7 to 8{
        if((Math.abs(x)+Math.abs(z)==7 && (Math.abs(z)<=5 && Math.abs(x)<=5))||(Math.abs(x)+Math.abs(z)==10)){
            dust_poses += [x,z];
        }
        if((Math.abs(x)==5 && Math.abs(z)<=1)||Math.abs(z)==5 && Math.abs(x)<=1){
            dust_poses += [x,z];
        }
        if((Math.abs(x)==7 && Math.abs(z)<=2)||Math.abs(z)==7 && Math.abs(x)<=2){
            dust_poses += [x,z];
        }
        if((Math.abs(x)+Math.abs(z))<4 && (Math.abs(x)<=2&&Math.abs(z)<=2)){
            pedestal_poses += [x,z];
        }
    } 
}

static fuels as int[string] = {"thermalfoundation:storage_alloy:7":200,"botania:manaresource:14":300,"clockworkphase:ingot_temporal:0":500,
    "contenttweaker:gaia_essence:0":150,"lightningcraft:material:11":750,"draconicevolution:chaos_shard:3":1500,"embers:ancient_motive_core:0":450};
static dusts as function(IWorld,IBlockPos)bool = BlockMatcher.BlockMatcher("contenttweaker:ritual_dust").matcher();

onBlockUpdate.onBlockUpdate(BlockMatcher.BlockMatcher(<contenttweaker:demon_core>).matcher(),
    function(world as IWorld, pos as IBlockPos)as void{
        val block = world.getBlock(pos);
        var data = block.data;
        if(isNull(data.CustomData)||data.CustomData.asMap().length<1){
            var poses as IData = []as IData;
            for i in dust_poses{
                poses += [Data.fromBlockPos(pos.add(i[0],0,i[1]))];
            }
            world.setBlockState(<blockstate:contenttweaker:demon_core>,{"CustomData":{
                "CoolDown":0,"Energy":0,"TemporalBlock":0,
                "Poses":poses
            }},pos);
            return;
        }
        if(data.CustomData.Energy.asInt()<100){
            if(data.CustomData.CoolDown>0){
                lightning(world,pos);
                world.setBlockState(<blockstate:minecraft:air>,pos);
                world.createExplosion(null,0.5+pos.x,0.5+pos.y,0.5+pos.z,2.0f,false,false);
                return;
            }
            val AABBLightning = AxisAlignedBB(-1.5+pos.x,-1.0+pos.y,-1.5+pos.z,2.5+pos.x,2.5+pos.y,2.5+pos.z);
            val lightnings = native.sblectric.lightningcraft.util.WeatherUtils.getLightningBoltsWithinAABB(world.native,AABBLightning);
            if(lightnings.length>0){
                for i in dust_poses{
                    if(!dusts(world,pos.add(i[0],0,i[1])))return;
                }
                val AABBSaber = AxisAlignedBB(pos.x,pos.y,pos.z,1.0+pos.x,1.0+pos.y,1.0+pos.z);
                val Items = world.native.getEntitiesWithinAABB(native.net.minecraft.entity.item.EntityItem.class,AABBSaber);
                for entity in Items{
                    val entityItem = entity as native.net.minecraft.entity.item.EntityItem;
                    val item = entityItem.getItem().wrapper;
                    if(!isNull(item)&&(item.definition.id=="clockworkphase:temporal_clockwork_saber")){
                        var temporalBlocks = 0;
                        var fuel as int[string] = {};
                        for i in pedestal_poses{
                            if(BlockMatcher.BlockMatcher(<clockworkphase:block_temporal>).matcher()(world,pos.add(i[0],-1,i[1]))){
                                temporalBlocks+=1;
                            }
                            if(BlockMatcher.BlockMatcher(<projecte:dm_pedestal>).matcher()(world,pos.add(i[0],0,i[1]))){
                                val pedestal = world.getItemHandler(pos.add(i[0],0,i[1]));
                                val item = pedestal.getStackInSlot(0);
                                if(!isNull(item)&&(fuels.keys has (item.definition.id~":"~item.damage))){
                                    pedestal.extractItem(0,1,false);
                                    world.native.notifyBlockUpdate(pos.add(i[0],0,i[1]), world.getBlockState(pos.add(i[0],0,i[1])), world.getBlockState(pos.add(i[0],0,i[1])), 3);
                                    NetworkHandler.sendToAllAround("DemonCoreItemParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,32,world.dimension,function(b){
                                        b.writeBlockPos(pos.add(i[0],0,i[1]));
                                        b.writeItemStack(item);
                                    });
                                    fuel[item.definition.id~":"~item.damage] = ((fuel[item.definition.id~":"~item.damage])??0)+1;
                                }
                            }
                        }
                        var energy = 0.0;
                        for i,j in fuel{
                            energy += (-pow(2.0,-j+1)+2)*fuels[i];
                        }
                        data = data.dataSet(temporalBlocks,"CustomData.TemporalBlock").dataSet(energy as int,"CustomData.Energy").dataSet(30000,"CustomData.CoolDown");
                        entityItem.setDead();
                        break;
                    }
                }
            }
        }else{
            if(data.dataGet("CustomData.Poses").asList().length==0){
                world.setBlockState(<blockstate:minecraft:air>,pos);
                lightning(world,pos);
                world.createExplosion(null,0.5+pos.x,0.5+pos.y,0.5+pos.z,2.0f,false,false);
                return;
            }
            if(world.time%world.random.nextInt(5,10)==2){
                if(world.random.nextInt(8)==1){lightning(world,pos,true);}
                else{
                    val pos0 = pedestal_poses[world.random.nextInt(pedestal_poses.length)];
                    lightning(world,pos.add(pos0[0],0,pos0[1]),true);
                }
            }
            if(world.time%2==0){
                NetworkHandler.sendToAllAround("DemonCorePointParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,32,world.dimension,function(b){
                    b.writeBlockPos(pos);
                    b.writeInt(data.CustomData.Energy.asInt()/100);
                });
            }
            if(data.CustomData.CoolDown.asInt()>0){
                data = data.dataSet(((-100.0)*(Math.log(1+data.CustomData.TemporalBlock)/Math.log(2)+1)+data.CustomData.CoolDown.asInt()) as int,"CustomData.CoolDown");
            }else{
                val pos0 = Data.toBlockPos(data.dataGet("CustomData.Poses").asList()[world.random.nextInt(data.dataGet("CustomData.Poses").asList().length)]);
                if(BlockMatcher.BlockMatcher(<blockstate:contenttweaker:ritual_dust:advanced=false>).matcher()(world,pos0)){
                    summonEntity(world,pos0,1);
                    data = data.dataSet(-100+data.CustomData.Energy.asInt(),"CustomData.Energy").dataSet(30000,"CustomData.CoolDown");
                }else if(BlockMatcher.BlockMatcher(<blockstate:contenttweaker:ritual_dust:advanced=true>).matcher()(world,pos0)){
                    var mode = world.random.nextInt(2,5);
                    if(BlockMatcher.BlockMatcher([<minecraft:beacon>,"collision:wither_altar"]).matcher()(world,pos0.add(0,-1,0))&&world.random.nextDouble()<0.9){mode=3;}
                    else if(BlockMatcher.BlockMatcher(["minecraft:packed_ice","minecraft:ice","minecraft:slime"]).matcher()(world,pos0.add(0,-1,0))&&world.random.nextDouble()<0.9){mode=2;}
                    else if(BlockMatcher.BlockMatcher(["minecraft:tnt",<lightningcraft:under_tnt:1>,<lightningcraft:light_block:0>]).matcher()(world,pos0.add(0,-1,0))&&world.random.nextDouble()<0.9){mode=5;}
                    else if(BlockMatcher.BlockMatcher([<lightningcraft:stone_block:6>,<lightningcraft:under_sand>,<lightningcraft:corrupt_stone>]).matcher()(world,pos0.add(0,-1,0))&&world.random.nextDouble()<0.9){mode=4;}
                    summonEntity(world,pos0,mode);
                    data = data.dataSet(-100+data.CustomData.Energy.asInt(),"CustomData.Energy").dataSet(30000,"CustomData.CoolDown");
                }
                data = data.dataSet(data.dataGet("CustomData.Poses").deepUpdate([Data.fromBlockPos(pos0)],mods.zenutils.DataUpdateOperation.REMOVE),"CustomData.Poses");
            }
        }
        world.setBlockState(<blockstate:contenttweaker:demon_core>,data,pos);
    },true,"DemonCore");

onItemUse.onItemRightClickBlock(ItemMatcher.allItems,BlockMatcher.BlockMatcher(<contenttweaker:demon_core>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return true;
        var flag = 1;
        var missing_blocks as IBlockPos[] = [];
        for i in dust_poses{
            if(!dusts(world,pos.add(i[0],0,i[1]))){
                missing_blocks += pos.add(i[0],0,i[1]);
                flag = 0;
            }
        }
        val AABBSaber = AxisAlignedBB(pos.x,pos.y,pos.z,1.0+pos.x,1.0+pos.y,1.0+pos.z);
        val Items = world.native.getEntitiesWithinAABB(native.net.minecraft.entity.item.EntityItem.class,AABBSaber);
        var temporalBlocks = 0;
        for entity in Items{
            val entityItem = entity as native.net.minecraft.entity.item.EntityItem;
            val item = entityItem.getItem().wrapper;
            if(!isNull(item)&&(item.definition.id=="clockworkphase:temporal_clockwork_saber")){
                flag = flag|2;
                break;
            }
        }
        var fuel as int[string] = {};
        var energy = 0.0;
        for i in pedestal_poses{
            if(BlockMatcher.BlockMatcher(<clockworkphase:block_temporal>).matcher()(world,pos.add(i[0],-1,i[1]))){
                temporalBlocks+=1;
            }
            if(BlockMatcher.BlockMatcher(<projecte:dm_pedestal>).matcher()(world,pos.add(i[0],0,i[1]))){
                val pedestal = world.getItemHandler(pos.add(i[0],0,i[1]));
                val item = pedestal.getStackInSlot(0);
                if(!isNull(item)&&(fuels.keys has (item.definition.id~":"~item.damage))){
                    fuel[item.definition.id~":"~item.damage] = ((fuel[item.definition.id~":"~item.damage])??0)+1;
                    flag = flag|4;
                }

            }
        }
        for i,j in fuel{
            energy += (-pow(2.0,-j+1)+2)*fuels[i];
        }
        if(flag==7){
            player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.demon_core.complete", temporalBlocks, (Math.round(100.0*(Math.log(1+temporalBlocks)/Math.log(2)+1)))~"%",energy as int),false);
            return true;
        }else if((flag&1) != 1){
            var poses as string = "";
            for i in  missing_blocks{
                poses += i.asString()~" ";
                NetworkHandler.sendTo("MissingBlockPosition",player,function(b){
                    b.writeData(Data.fromBlockPos(i));
                });
            }
            player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.demon_core.missdust", poses),false);
        }else if((flag&2) != 2){
            player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.demon_core.misssaber"),false);
        }else if((flag&4) != 4){
            player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.demon_core.missenergy"),false);
        }
        return true;
    },"MAIN_HAND");
onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher([<clockworkphase:temporal_clockwork_saber>,<contenttweaker:ritual_dust:*>] as IItemStack[]).matcher(),BlockMatcher.BlockMatcher(<contenttweaker:demon_core>).matcher(),
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        if(world.remote)return false;
        if(item.definition.id=="clockworkphase:temporal_clockwork_saber"){
            val saber = item.mutable().copy().createEntityItem(world, 0.5f+pos.x,0.5f+pos.y,0.5f+pos.z);
            saber.motionX=0;
            saber.motionY=0;
            saber.motionZ=0;
            item.mutable().shrink(1);
            world.spawnEntity(saber);
        }else if(item.definition.id=="contenttweaker:ritual_dust"){
            for i in dust_poses{
                if(world.getBlockState(pos.add(i[0],0,i[1])).isReplaceable(world,pos.add(i[0],0,i[1]))){
                    world.native.setBlockState(pos.add(i[0],0,i[1]).native,item.asBlock().native.getStateFromMeta(item.metadata),11);
                    item.mutable().shrink(1);
                    return false;
                }
            }
        }
        return true;
    },"ALL",false);

function summonEntity(world as IWorld, pos as IBlockPos, mode as int = 1)as void{
    val delay as int = 25;
    val color as IData[int] = {1:{"r":0.85,"g":0.2,"b":0.08},2:{"r":0.0,"g":0.0,"b":0.8},3:{"r":0.1,"g":0.1,"b":0.1},
        4:{"r":0.2,"g":0.2,"b":0.7},5:{"r":0.1,"g":0.1,"b":0.9}};
    val entities as string[int] = {1:"lightningcraft:demon_soldier",2:"lightningcraft:underworld_slime",3:"lightningcraft:underworld_ghast",
        4:"lightningcraft:underworld_skeleton",5:"lightningcraft:underworld_creeper"};
    if(isNull(color[mode])||isNull(entities[mode]))return;
    NetworkHandler.sendToAllAround("DemonSummonParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,32,world.dimension,function(b){
        b.writeBlockPos(pos);
        b.writeInt(delay);
        b.writeData(color[mode]);
    });
    world.catenation().sleep(delay).run(function(w,c){
        if(dusts(world,pos)){
            lightning(world,pos);
            val entity as IEntityLivingBase = <entity:${entities[mode]}>.createEntity(world);
            entity.position3f = Position3f.create(0.5f+pos.x,1.5f+pos.y,0.5f+pos.z);
            if(mode==1){
                entity.addPotionEffect(<potion:minecraft:resistance>.makePotionEffect(2147483647,2));
                entity.addPotionEffect(<potion:minecraft:strength>.makePotionEffect(2147483647,4));
                entity.addPotionEffect(<potion:minecraft:regeneration>.makePotionEffect(2147483647,1));            
            }
            world.spawnEntity(entity);
            world.setBlockState(<blockstate:minecraft:air>,pos);
        }

    }).start();
}

function lightning(world as IWorld, pos as IBlockPos, deco as bool = true)as void{
    val lightning = world.createLightningBolt(pos.x,pos.y,pos.z,deco);
    world.spawnEntity(lightning);
    world.addWeatherEffect(lightning);
}

events.onEntityLivingHurt(function(event as crafttweaker.event.EntityLivingHurtEvent){
    val entity = event.entity;
    if(isNull(entity.definition))return;
    if(entity.definition.id!="lightningcraft:demon_soldier")return;
    if(event.damageSource.damageType!="player")return;
    val source = event.damageSource.trueSource;
    if(!(source instanceof IPlayer))return;
    val player as IPlayer = source;
    val blacklist = ItemMatcher.ItemMatcher([<projecte:item.pe_rm_sword>,<projecte:item.pe_dm_sword>,<projecte:item.pe_rm_katar>] as string[]).matcher();
    if(blacklist(player.mainHandHeldItem)&&!isNull(player.mainHandHeldItem.tag.dataGet("Charge"))&&player.mainHandHeldItem.tag.Charge.asInt()>0){
        player.setItemToSlot(IEntityEquipmentSlot.mainHand(),player.mainHandHeldItem.withTag(player.mainHandHeldItem.tag.dataSet(-1+player.mainHandHeldItem.tag.Charge,"Charge")));
        player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.invalid_pe_weapons"),false);
        event.cancel();
        return;
    }
    if(blacklist(player.offHandHeldItem)&&!isNull(player.offHandHeldItem.tag.dataGet("Charge"))&&player.offHandHeldItem.tag.Charge.asInt()>0){
        player.setItemToSlot(IEntityEquipmentSlot.offhand(),player.offHandHeldItem.withTag(player.offHandHeldItem.tag.dataSet(-1+player.offHandHeldItem.tag.Charge,"Charge")));
        player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.invalid_pe_weapons"),false);
        event.cancel();
        return;
    }
});

NetworkHandler.registerServer2ClientMessage("DemonCorePointParticle",function(player,b){
    val pos = b.readBlockPos();
    val energy= b.readInt();
    val world = player.world;
    val radius = 2.5;
    for i in 0 to energy{
        val end = [0.5+2.5*Math.sin(Misc.arc(360.0/energy*i))+pos.x,0.8+pos.y,0.5+2.5*Math.cos(Misc.arc(360.0/energy*i))+pos.z];
        IBotaniaFXHelper.wispFX(end[0],end[1]+0.5*Math.sin(Misc.arc(3.0*(360.0/energy*i+world.time%360))),end[2],0.8,0.25,0.05,0.2,0,0,0,1.0);
    }
});

NetworkHandler.registerServer2ClientMessage("DemonCoreItemParticle",function(player,b){
    val pos = b.readBlockPos();
    val item= b.readItemStack();
    val world = player.world.native;
    for i in 0 to 8{
        world.spawnParticle(native.net.minecraft.util.EnumParticleTypes.ITEM_CRACK, 0.5+pos.x, 0.5+pos.y, 0.5+pos.z, ((world.rand.nextFloat()as double) - 0.5D) * 0.08D, ((world.rand.nextFloat()as double)) * 0.08D, ((world.rand.nextFloat()as double) - 0.5D) * 0.08D, native.net.minecraft.item.Item.getIdFromItem(item.native.getItem()));
    }
});

NetworkHandler.registerServer2ClientMessage("DemonSummonParticle",function(player,b){
    val world = player.world;
    val pos = b.readBlockPos();
    val delay = b.readInt();
    val size = 0.08;
    val v = 0.05;
    val pos0 as double[] = [0.5+pos.x,0.05+pos.y,0.5+pos.z];
    val color = b.readData();
    client.catenation().repeat(delay,function(builder){
        builder.run(function(w,c){
            var time = (!c.hasData())?0:c.data.time.asInt();
            if(time>(-5+delay))time=-5+delay;
            val radius = 0.5*time as double/(-5+delay);
            val density = 30;
            for i in 0 to 3{
                for j in 0 to density{
                    val end1 as double[] = [Math.sin(Misc.arc(120.0*(i+1)+360.0*time/delay))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(120.0*(i+1)+360.0*time/delay))*radius+0.5+pos.z];
                    val start1 as double[] = [Math.sin(Misc.arc(120.0*i+360.0*time/delay))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(120.0*i+360.0*time/delay))*radius+0.5+pos.z];
                    val vect1 as double[] = [start1[0]+(end1[0]-start1[0])*j/density,start1[1],start1[2]+(end1[2]-start1[2])*j/density];
                    ParticleUtil.spawnParticleGlow(world,vect1[0],vect1[1],vect1[2],0,0,0,color.r,color.g,color.b,0.3,1);
                    val end2 as double[] = [Math.sin(Misc.arc(60.0+120*(i+1)+360.0*time/delay))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(60.0+120*(i+1)+360.0*time/delay))*radius+0.5+pos.z];
                    val start2 as double[] = [Math.sin(Misc.arc(60.0+120*i+360.0*time/delay))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(60.0+120*i+360.0*time/delay))*radius+0.5+pos.z];
                    val vect2 as double[] = [start2[0]+(end2[0]-start2[0])*j/density,start2[1],start2[2]+(end2[2]-start2[2])*j/density];
                    ParticleUtil.spawnParticleGlow(world,vect2[0],vect2[1],vect2[2],0,0,0,color.r,color.g,color.b,0.3,1);
                }
            }
            for i in 0 to density*4{
                val end as double[] = [Math.sin(Misc.arc((90.0/density)*i+360.0*time/delay))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc((90.0/density)*i+360.0*time/delay))*radius+0.5+pos.z];
                ParticleUtil.spawnParticleGlow(world,end[0],end[1],end[2],0,0,0,color.r,color.g,color.b,0.3,2);
            }
            for i in 0 to (world.random.nextInt(3)+1){
                ParticleUtil.spawnParticleStar(world,-0.4+0.8*world.random.nextDouble()+pos0[0],pos0[1],-0.4+0.8*world.random.nextDouble()+pos0[2],0,world.random.nextDouble()*0.2,0,0.85,0.2,0.08,0.3,5+world.random.nextInt(11));
            }
            c.data = (c.hasData())?({"time":c.data.dataGet("time")+1} as IData):({"time":0} as IData);
        });
    }).start();
    // for i in 0 to 3{
    //     for j in 0 to 20{
            // val end1 as double[] = [Math.sin(Misc.arc(120*(i+1)))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(120*(i+1)))*radius+0.5+pos.z];
            // val start1 as double[] = [Math.sin(Misc.arc(120*i))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(120*i))*radius+0.5+pos.z];
            // val vect1 as double[] = [start1[0]+(end1[0]-start1[0])*j/20,start1[1],start1[2]+(end1[2]-start1[2])*j/20];
            // // IBotaniaFXHelper.wispFX(pos0[0],pos0[1],pos0[2],1.0,0,0,size,v*(vect1[0]-pos0[0]),0,v*(vect1[2]-pos0[2]),1.0);
            // val end2 as double[] = [Math.sin(Misc.arc(60+120*(i+1)))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(60+120*(i+1)))*radius+0.5+pos.z];
            // val start2 as double[] = [Math.sin(Misc.arc(60+120*i))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(60+120*i))*radius+0.5+pos.z];
            // val vect2 as double[] = [start2[0]+(end2[0]-start2[0])*j/20,start2[1],start2[2]+(end2[2]-start2[2])*j/20];
            // // IBotaniaFXHelper.wispFX(pos0[0],pos0[1],pos0[2],1.0,0,0,size,v*(vect2[0]-pos0[0]),0,v*(vect2[2]-pos0[2]),1.0);
            // IBotaniaFXHelper.wispFX(vect1[0],vect1[1],vect1[2],1.0,0,0,size,v*(vect2[0]-vect1[0]),0,v*(vect2[2]-vect1[2]),1.0);
            // val end3 as double[] = [Math.sin(Misc.arc(120+120*(i+1)))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(120+120*(i+1)))*radius+0.5+pos.z];
            // val start3 as double[] = [Math.sin(Misc.arc(120+120*i))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(120+120*i))*radius+0.5+pos.z];
            // val vect3 as double[] = [start3[0]+(end3[0]-start3[0])*j/20,start3[1],start3[2]+(end3[2]-start3[2])*j/20];
            // IBotaniaFXHelper.wispFX(vect2[0],vect2[1],vect2[2],1.0,0,0,size,v*(vect3[0]-vect2[0]),0,v*(vect3[2]-vect2[2]),1.0);
    //     }
    // }
    // for i in 0 to 90{
        // val end as double[] = [Math.sin(Misc.arc(4*i))*radius+0.5+pos.x,pos0[1],Math.cos(Misc.arc(4*i))*radius+0.5+pos.z];
        // IBotaniaFXHelper.wispFX(pos0[0],pos0[1],pos0[2],1.0,0,0,size,v*(end[0]-pos0[0]),0,v*(end[2]-pos0[2]),1.0);
        // IBotaniaFXHelper.wispFX(end[0],end[1],end[2],1.0,0,0,size,0,0,0,1.0);
        // ParticleUtil.spawnParticleGlow(world,end[0],end[1],end[2],0,0,0,1.0,0,0,0.3,2);
    // }
});
for i in 0 to 5{
    <contenttweaker:demon_core>.addJEIDes("demon_core_"~i);
}