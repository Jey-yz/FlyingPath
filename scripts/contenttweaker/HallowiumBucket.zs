#reloadable
import scripts.libs.Misc;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUse;
import crafttweaker.world.IWorld;
import crafttweaker.world.IFacing;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IVector3d;
import crafttweaker.player.IPlayer;
import crafttweaker.data.IData;
import crafttweaker.item.IItemStack;
import crafttweaker.text.ITextComponent;
import native.net.minecraft.init.SoundEvents;
import native.net.minecraft.block.material.Material;
import native.net.minecraft.util.SoundCategory;
import native.net.minecraft.util.SoundEvent;
import native.net.minecraftforge.event.entity.player.PlayerInteractEvent.LeftClickEmpty;
import mods.zenutils.StringList;
import mods.zenutils.NetworkHandler;

onItemUse.onItemRightClick(ItemMatcher.ItemMatcher("contenttweaker:hallowium_bucket").matcher(),
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        val world = player.world;
        if(isNull(player.getAttribute("generic.reachDistance")))return false;
        val vec1 = IVector3d.create(player.posX,player.posY+player.eyeHeight,player.posZ);
        val vec2 = player.lookingDirection;
        val reachDistance = player.getAttribute("generic.reachDistance").getAttributeValue();
        val mode = getMode(item);
        if(mode==1||mode==2){
            val result = player.getRayTrace(reachDistance,1.0);
            if(result.isMiss)return false;
            val pos = result.blockPos;
            val sound as SoundEvent = (mode==2)?SoundEvents.ITEM_BUCKET_EMPTY_LAVA:SoundEvents.ITEM_BUCKET_EMPTY;
            if(!player.isSneaking){
                if(!isNull(world.getLiquidHandler(pos,result.sideHit))){
                    val handler = world.getLiquidHandler(pos,result.sideHit);
                    var attempt as int = 0;
                    var success as int = 0;
                    var succeeded as bool = false;
                    while attempt<100{
                        attempt+=1;
                        if(mode==2&&success>=getLava(item)/1000)break;
                        val liquid = (mode==1)?<liquid:water>*1000:<liquid:lava>*1000;
                        if(handler.fill(liquid,false)==1000){
                            success+=1;
                            succeeded = true;
                            handler.fill(liquid,true);
                            if(!isMulti(item))break;
                        }
                    }
                    if(mode==2)player.setItemToSlot(Misc.getHand(hand),drainLava(item,success));
                    if(succeeded)world.native.playSound(null, pos.native, (mode==2)?SoundEvents.ITEM_BUCKET_EMPTY_LAVA:SoundEvents.ITEM_BUCKET_EMPTY, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
                else if(BlockMatcher.BlockMatcher("botania:altar").check(world,pos)){
                    var data = world.getBlock(pos).data;
                    var isEmpty = true;
                    if(isNull(data)){isEmpty=true;}
                    else if(!isNull(data.hasLava)&&data.hasLava.asBool()&&isEmpty){isEmpty=false;}
                    else if(!isNull(data.hasWater)&&data.hasWater.asBool()&&isEmpty){isEmpty=false;}
                    if(isEmpty){
                        data = data.dataSet(1 as byte,"has"~((mode==1)?"Water":"Lava"));
                        if(mode==2)player.setItemToSlot(Misc.getHand(hand),drainLava(item));
                        world.setBlockState(world.getBlockState(pos),data,pos);
                        world.native.notifyBlockUpdate(pos.native, world.getBlockState(pos).native, world.getBlockState(pos).native, 3);
                        world.native.playSound(null, pos.native, sound, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    }
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
                else if(BlockMatcher.BlockMatcher(["minecraft:cauldron","foundry:bronze_cauldron"]).check(world,pos)){
                    if(mode==1){
                        val state = world.getBlockState(pos);
                        val level = state.getPropertyValue("level");
                        if(level!="3"){
                            world.setBlockState(state.withProperty("level",3),pos);
                            world.native.playSound(null, pos.native, sound, SoundCategory.BLOCKS, 1.0f, 1.0f);
                        }
                    }
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }
            val pos1 = result.blockPos.getOffset(result.sideHit,1);
            val state = mode==1?<blockstate:minecraft:flowing_water:level=0>:<blockstate:minecraft:flowing_lava:level=0>;
            if(world.getBlockState(pos).isReplaceable(world,pos)||(!world.getBlockState(pos).native.getMaterial().isSolid())){
                if(!isNull(world.getBlock(pos).fluid))world.destroyBlock(pos, true);
                if(mode==2){
                    player.setItemToSlot(Misc.getHand(hand),drainLava(item));
                }else if(mode==1&&world.provider.waterVaporize){
                    world.native.playSound(null, pos.native, SoundEvents.BLOCK_FIRE_EXTINGUISH, SoundCategory.BLOCKS, 0.5f, 2.6f);
                    return true;
                }
                world.setBlockState(state,pos);
                NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                    b.writeString(hand);
                });
                world.native.playSound(null, pos.native, sound, SoundCategory.BLOCKS, 1.0f, 1.0f);
                return true;
            }else if(world.getBlockState(pos1).isReplaceable(world,pos1)||(!world.getBlockState(pos1).native.getMaterial().isSolid())){
                if(!canHold(world,pos1))world.destroyBlock(pos1, true);
                if(mode==2){
                    player.setItemToSlot(Misc.getHand(hand),drainLava(item));
                }else if(mode==1&&world.provider.waterVaporize){
                    world.native.playSound(null, pos.native, SoundEvents.BLOCK_FIRE_EXTINGUISH, SoundCategory.BLOCKS, 0.5f, 2.6f);
                    return true;
                }
                world.setBlockState(state,pos1);
                NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                    b.writeString(hand);
                });
                world.native.playSound(null, pos.native, sound, SoundCategory.BLOCKS, 1.0f, 1.0f);
                return true;
            }
        }
        if(mode==0){
            var result = world.native.rayTraceBlocks(vec1.native,vec1.add(vec2.scale(reachDistance)).native,false,false,true);
            var pos = result.blockPos.wrapper;
            val face = result.sideHit.wrapper;
            if(!player.isSneaking){
                if(!isNull(world.getLiquidHandler(pos,face))){
                    val handler = world.getLiquidHandler(pos,face);
                    var attempt as int = 0;
                    var success as int = 0;
                    var succeeded as bool = false;
                    while attempt<100{
                        attempt+=1;
                        if(!isNull(handler.drain(<liquid:lava>*1000,false))&&handler.drain(<liquid:lava>*1000,false).amount==1000){
                            success+=1;
                            succeeded = true;
                            handler.drain(<liquid:lava>*1000,true);
                            if(!isMulti(item))break;
                        }
                        if(!isNull(handler.drain(<liquid:water>*1000,false))&&handler.drain(<liquid:water>*1000,false).amount==1000){
                            handler.drain(<liquid:water>*1000,true);
                            succeeded = true;
                            if(!isMulti(item))break;
                        }
                    }
                    player.setItemToSlot(Misc.getHand(hand),fillLava(item,success));
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    if(success>0){
                        world.native.playSound(null, pos.native, SoundEvents.ITEM_BUCKET_FILL_LAVA, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    }else if(succeeded){
                        world.native.playSound(null, pos.native, SoundEvents.ITEM_BUCKET_FILL, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    }
                    return true;
                }
                else if(BlockMatcher.BlockMatcher("botania:altar").check(world,pos)){
                    var data = world.getBlock(pos).data;
                    var liquid = " ";
                    if(isNull(data)){liquid=" ";}
                    else if(!isNull(data.hasLava)&&data.hasLava.asBool()){liquid="Lava";}
                    else if(!isNull(data.hasWater)&&data.hasWater.asBool()){liquid="Water";}
                    if(liquid!=" "){
                        data = data.dataSet(0 as byte,"has"~liquid);
                        if(liquid=="Lava")player.setItemToSlot(Misc.getHand(hand),fillLava(item));
                        world.setBlockState(world.getBlockState(pos),data,pos);
                        world.native.notifyBlockUpdate(pos.native, world.getBlockState(pos).native, world.getBlockState(pos).native, 3);
                        world.native.playSound(null, pos.native, (liquid=="Lava")?SoundEvents.ITEM_BUCKET_FILL_LAVA:SoundEvents.ITEM_BUCKET_FILL, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    }
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
                else if(BlockMatcher.BlockMatcher(["minecraft:cauldron","foundry:bronze_cauldron"]).check(world,pos)){
                    val state = world.getBlockState(pos);
                    val level = state.getPropertyValue("level");
                    if(level!="0"){
                        world.setBlockState(state.withProperty("level",0),pos);
                        world.native.playSound(null, pos.native, SoundEvents.ITEM_BUCKET_FILL, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    }
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }
            var distance = 0.0;
            while (distance<reachDistance){
                distance += 0.2;
                val vec3 = vec1.add(vec2.scale(distance));
                val result = world.native.rayTraceBlocks(vec1.native,vec3.native,true,false,true);
                if(!isNull(result)&&canHold(world,result.blockPos.wrapper))break;
            }
            result = world.native.rayTraceBlocks(vec1.native,vec1.add(vec2.scale(distance)).native,false,false,true);
            pos = result.blockPos.wrapper;
            if(canHold(world,pos)){
                val directions as IFacing[] = [up,down,north,south,east,west];
                val lavas as string[] = ["minecraft:lava","minecraft:flowing_lava"];
                if(lavas has world.getBlock(pos).definition.id){
                    var lavaPoses as IBlockPos[] = [pos];
                    var findSource as int = 0;
                    if(world.getBlockState(pos).getPropertyValue("level")==0)findSource+=1;
                    var count = 0;
                    var newPoses1 as IBlockPos[] = [pos];
                    while count<60{
                        count+=1;
                        if(lavaPoses.length>500)break;
                        var newPoses2 as IBlockPos[] = [];
                        for p in newPoses1{
                            for d in directions{
                                val np = p.getOffset(d,1);
                                val state = world.getBlockState(np);
                                if(isNull(state.block)||isNull(state.block.definition))continue;
                                if(lavas has state.block.definition.id){
                                    if(!(lavaPoses has np)){
                                        if(state.getPropertyValue("level")==0){
                                            if(!isMulti(item)&&findSource>=1)continue;
                                            findSource+=1;
                                        }
                                        lavaPoses += np;
                                        newPoses2 += np;
                                    }
                                }
                            }
                        }
                        if(newPoses2.length==0)break;
                        newPoses1 = newPoses2;
                    }
                    player.setItemToSlot(Misc.getHand(hand),fillLava(item,findSource));
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    world.native.playSound(null, pos.native, SoundEvents.ITEM_BUCKET_FILL_LAVA, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    for p in lavaPoses{
                        world.setBlockState(<blockstate:minecraft:air>,p);
                    }
                    return true;
                }
                val waters as string[] = ["minecraft:water","minecraft:flowing_water"];
                if(waters has world.getBlock(pos).definition.id){
                    var waterPoses as IBlockPos[] = [pos];
                    var findSource as bool = world.getBlockState(pos).getPropertyValue("level")==0;
                    var count = 0;
                    var newPoses1 as IBlockPos[] = [pos];
                    while count<60{
                        count+=1;
                        if(waterPoses.length>500)break;
                        var newPoses2 as IBlockPos[] = [];
                        for p in waterPoses{
                            for d in directions{
                                val np = p.getOffset(d,1);
                                val state = world.getBlockState(np);
                                if(isNull(state.block)||isNull(state.block.definition))continue;
                                if(waters has state.block.definition.id){
                                    if(!(waterPoses has np)){
                                        if(state.getPropertyValue("level")==0){
                                            if(!isMulti(item)&&findSource)continue;
                                            findSource = true;
                                        }
                                        waterPoses += np;
                                        newPoses2 += np;
                                    }
                                }
                            }
                        }
                        if(newPoses2.length==0)break;
                        newPoses1 = newPoses2;
                    }
                    world.native.playSound(null, pos.native, SoundEvents.ITEM_BUCKET_FILL, SoundCategory.BLOCKS, 1.0f, 1.0f);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    for p in waterPoses{
                        world.setBlockState(<blockstate:minecraft:air>,p);
                    }
                    return true;
                }
            }
            return false;
        }
        return false;
    },"all");

events.register(function(event as LeftClickEmpty){
    val player = event.entityPlayer.wrapper;
    val item = player.mainHandHeldItem;
    if(ItemMatcher.ItemMatcher("contenttweaker:hallowium_bucket").check(item)){
        NetworkHandler.sendToServer("HallowiumBucketShiftMode",function(b){
            b.writeItemStack(item);
        });
    }
});

NetworkHandler.registerClient2ServerMessage("HallowiumBucketShiftMode",function(s,b,p){
    val bucket = b.readItemStack();
    if(!p.isSneaking)p.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(),shiftMode(bucket));
    if(p.isSneaking)p.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(),shiftMulti(bucket));
});

function canHold(world as IWorld, pos as IBlockPos)as bool{
    val material as Material = world.getBlockState(pos).native.getMaterial();
    if(isNull(material))return false;
    return material == Material.WATER || material == Material.LAVA;
}

function hasLava(item as IItemStack)as bool{
    if(isNull(item.tag)||isNull(item.tag.lava))return false;
    if(item.tag.lava.asInt()<=0)return false;
    return true;
}

function getLava(item as IItemStack)as int{
    if(isNull(item.tag)||isNull(item.tag.lava))return 0;
    return item.tag.lava.asInt();
}

function fillLava(item as IItemStack,amount as int = 1)as IItemStack{
    if(isNull(item.tag)||isNull(item.tag.lava))return item.withTag({"lava":(1000*amount<0)?2147483000:1000*amount});
    return item.withTag(item.tag.dataSet(((1000*amount+item.tag.dataGet("lava").asInt())<0)?2147483000:1000*amount+item.tag.dataGet("lava").asInt(),"lava"));
}

function drainLava(item as IItemStack,amount as int = 1)as IItemStack{
    if(isNull(item.tag)||isNull(item.tag.lava))return item.withTag({"lava":0});
    var result = item.withTag(item.tag.dataSet(-1000*amount+item.tag.dataGet("lava").asInt(),"lava"));
    if(result.tag.dataGet("lava").asInt()<1000)result = shiftMode(result,0);
    return result;
}

function getMode(item as IItemStack)as int{
    val modes as int[string] = {"none":0,"water":1,"lava":2};
    if(isNull(item.tag)||isNull(item.tag.mode)||!(modes.keys has item.tag.mode.asString()))return 0;
    return modes[item.tag.mode.asString()] as int;
}

function isMulti(item as IItemStack)as bool{
    if(isNull(item.tag)||isNull(item.tag.multiple))return true;
    return item.tag.multiple.asBool();
}

function shiftMulti(item as IItemStack)as IItemStack{
    if(isNull(item.tag))return item.withTag({"multiple":false});
    if(isNull(item.tag.multiple))return item.withTag(item.tag.dataSet(false,"multiple"));
    return item.withTag(item.tag.dataSet(!(item.tag.multiple.asBool()),"multiple"));
}

function shiftMode(item as IItemStack, mode as int = -1)as IItemStack{
    val modes as string[int] = {0:"none",1:"water",2:"lava"};
    var switchTo as string = "none";
    if(mode!=-1){
        switchTo = modes[mode%3];
        if(isNull(item.tag))return item.withTag({"mode":switchTo});
    }else{
        val modeNow = getMode(item);
        if(!hasLava(item)&&modeNow==1){switchTo = "none";}
        else{switchTo = modes[(modeNow+1)%3];}
    }
    return item.withTag(item.tag.dataSet(switchTo,"mode"));
}

// <contenttweaker:hallowium_bucket>.addAdvancedTooltip(function(item){
//     val modes as string[int] = {0:"none",1:"water",2:"lava"};
//     val mode = getMode(item);
//     var out = "";
//     out += ITextComponent.fromTranslation("item.description.hallowium_bucket.multiplemode",ITextComponent.fromTranslation("item.description.hallowium_bucket."~(isMulti(item)?"yes":"no")).formattedText).formattedText~"\n";
//     out += ITextComponent.fromTranslation("item.description.hallowium_bucket.liquidmode",ITextComponent.fromTranslation("item.description.hallowium_bucket."~modes[getMode(item)]).formattedText).formattedText;
//     if(mode!=0){
//         val amount = (mode==1)?"§b∞§r":"§6"~getLava(item)~"mB§r";
//         out += "\n"~ITextComponent.fromTranslation("item.description.hallowium_bucket.amount",amount).formattedText;
//     }
//     return out;
// });

<contenttweaker:hallowium_bucket:*>.addAdvancedTooltip(function(item){
    return ITextComponent.fromTranslation("item.description.hallowium_bucket.multiplemode",ITextComponent.fromTranslation("item.description.hallowium_bucket."~(isMulti(item)?"yes":"no")).formattedText).formattedText;
});
<contenttweaker:hallowium_bucket:*>.addAdvancedTooltip(function(item){
    val modes as string[int] = {0:"none",1:"water",2:"lava"};
    val mode = getMode(item);
    return ITextComponent.fromTranslation("item.description.hallowium_bucket.liquidmode",ITextComponent.fromTranslation("item.description.hallowium_bucket."~modes[getMode(item)]).formattedText).formattedText;
});
<contenttweaker:hallowium_bucket:*>.addAdvancedTooltip(function(item){
    val modes as string[int] = {0:"none",1:"water",2:"lava"};
    val mode = getMode(item);
    var amount = "0";
    if(mode!=0){
        amount = (mode==1)?"§b∞§r":"§6"~getLava(item)~"mB§r";
    }
    return ITextComponent.fromTranslation("item.description.hallowium_bucket.amount",amount).formattedText;
});

<contenttweaker:hallowium_bucket:*>.modifyTooltip(function(item, tooltip, shiftPressed, advanced){
    if(isNull(client))return;
    var index = 0;
    var string_stored as string[] = [];
    var index_stored = -2147483647;
    for i in tooltip{
        index+=1;
        if(i.equalsIgnoreCase(ITextComponent.fromTranslation("item.modifiers.head").unformattedComponentText)){
            index_stored = index;
            continue;
        }
        if(index == index_stored+1){
            string_stored+=ITextComponent.fromTranslation("item.description.hallowium_bucket.0").unformattedText;
            string_stored+=ITextComponent.fromTranslation("item.description.hallowium_bucket.1").unformattedText;
            string_stored+=ITextComponent.fromTranslation("item.description.hallowium_bucket.2").unformattedText;
            continue;
        }
        string_stored+=i;
    }
    tooltip.clear();
    for i in string_stored{
        tooltip.add(i);
    }
});

events.onPlayerTick(function(event as crafttweaker.event.PlayerTickEvent){
    if(event.player.world.remote)return;
    if(event.phase=="START")return;
    var player = event.player;
    if(player.world.time%20!=0)return;
    val bucket = player.getItemInSlot(crafttweaker.entity.IEntityEquipmentSlot.head());
    // (bucket.isDamageable as string).say();
    if(!ItemMatcher.ItemMatcher("contenttweaker:hallowium_bucket").check(bucket))return;
    val mode = getMode(bucket);
    if(mode==1){
        player.attackEntityFrom(<damageSource:DROWN>,2);
        player.extinguish();
    }
    if(mode==2){
        player.setFire(60);
        player.attackEntityFrom(<damageSource:LAVA>,2);
    }
    NetworkHandler.sendTo("HallowiumBucketWearing",player,function(b){});
});