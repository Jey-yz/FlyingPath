#reloadable
import scripts.libs.BlockMatcher;
import scripts.preinit.RedstoneCrop.RedstoneWeed;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockState;
import crafttweaker.block.IBlockStateMatcher;
import native.net.minecraft.util.EnumParticleTypes;
import native.net.minecraft.block.BlockCrops;
import native.net.minecraft.block.BlockVine;
import native.net.minecraft.block.BlockMelon;
import native.net.minecraft.block.BlockCocoa;
import native.net.minecraft.block.BlockNetherWart;
import mods.zenutils.NetworkHandler;
import mods.randomtweaker.botania.IBotaniaFXHelper;

<cotSubTile:marired>.onUpdate = function(tile,w,pos){
    if(w.remote)return;
    val world = IWorld.getFromID(w.dimension);
    val range as int = 2;
    val redstoneCropCost = 30;
    val poolPos = tile.getBindingForCrT();
    if(isNull(poolPos))return;
    val storage = world.getEnergyStorage(poolPos.add(0,-1,0),up);
    for z in (-range) to (range+1){
        for x in (-range) to (range+1){
            if(x==0 && z==0)continue;
            val pos0 = pos.add(x,0,z);
            val pos1 = pos.add(x,-1,z);
            if(world.time%10==0){
                if(tile.getMana()>=5 && world.native.isBlockPowered(pos1.native)){
                    if(harvest(world,pos0)){
                        tile.consumeMana(5);
                    }
                }
                if(world.time%100==0 && world.isAirBlock(pos0)&&BlockMatcher.BlockMatcher(IBlockStateMatcher.create(<blockstate:botania:quartztypered:variant=pillar_x>,<blockstate:botania:quartztypered:variant=pillar_y>,<blockstate:botania:quartztypered:variant=pillar_z>)).matcher()(world,pos1)){
                    if(!isNull(storage) && storage.extractEnergy(redstoneCropCost,true)==redstoneCropCost){
                        world.setBlockState(<blockstate:contenttweaker:redstone_weed:age=0>,pos0);
                        storage.extractEnergy(redstoneCropCost,false);
                        return;
                    }
                }
            }
            if(BlockMatcher.BlockMatcher("contenttweaker:redstone_weed").matcher()(world,pos0)){
                if(!isNull(storage) && storage.extractEnergy(redstoneCropCost,true)==redstoneCropCost){
                    storage.extractEnergy(redstoneCropCost,false);
                    if(world.random.nextInt(500)==100){
                        val crop as RedstoneWeed = world.getBlock(pos0).native as RedstoneWeed;
                        crop.grow(world.native, pos0.native, world.getBlockState(pos0).native); 
                    }
                    if(world.random.nextInt(30)==15){
                        NetworkHandler.sendToAllAround("RedstoneWeedParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,32.0,world.dimension,function(b){
                            b.writeBlockPos(pos0);
                        });
                    }
                }else{
                    world.destroyBlock(pos0,true);
                }
            }

        }
    }
    if(world.time%10==3){
        for z in (-2*range) to (2*range+1){
            for x in (-2*range) to (2*range+1){
                if(x==0&&z==0)continue;
                val pos0 = pos.add(x,0,z);
                if(BlockMatcher.or(BlockMatcher.BlockMatcher("botania:specialflower"),BlockMatcher.BlockMatcher("botania:floatingspecialflower")).matcher()(world,pos0)){
                    val name = world.getBlock(pos0).data.dataGet("subTileName");
                    if(!isNull(name) && name=="marired"){
                        NetworkHandler.sendToAllAround("MariredDestroy",0.5+pos.x,0.5+pos.y,0.5+pos.z,32.0,world.dimension,function(b){
                            b.writeBlockPos(pos);
                            b.writeBlockPos(pos0);
                        });
                        world.catenation().sleep(5).run(function(w,c){
                            world.destroyBlock(pos0,true);                        
                        }).start();
                    }
                }
            }
        }
    }
};

function harvest(world as IWorld, pos as IBlockPos)as bool{
    if(world.getBlock(pos).native instanceof BlockCrops){
        val crop as BlockCrops = world.getBlock(pos).native as BlockCrops;
        if(crop.isMaxAge(world.getBlockState(pos).native)){
            world.destroyBlock(pos,true);
            return true;
        }
    }else if(BlockMatcher.BlockMatcher(["incorporeal:natural_repeater","incorporeal:natural_comparator"]).check(world,pos)){
        world.destroyBlock(pos,true);
        return true;
    }else if(world.getBlock(pos).native instanceof BlockVine){
        val vine = world.getBlock(pos).native as BlockVine;
        for item in vine.onSheared(<minecraft:shears>.native,world.native,pos.native,0){
            val vine = item.wrapper.createEntityItem(world,pos);
            world.spawnEntity(vine);
        }
        world.destroyBlock(pos,false);
        return true;
    }else if(world.getBlock(pos).native instanceof BlockMelon){
        world.destroyBlock(pos,true);
        return true;
    }else if(BlockMatcher.BlockMatcher("minecraft:pumpkin").check(world,pos)){
        world.destroyBlock(pos,true);
        return true;
    }else if(world.getBlock(pos).native instanceof BlockCocoa){
        val cocoa = world.getBlock(pos).native as BlockCocoa;
        if(!cocoa.canGrow(world.native,pos.native,world.getBlockState(pos).native,false)){
            world.destroyBlock(pos,true);
            return true;
        }
    }else if(world.getBlock(pos).native instanceof BlockNetherWart){
        val wart = world.getBlock(pos).native as BlockNetherWart;
        if(wart.getMetaFromState(world.getBlockState(pos).native)==3){
            world.destroyBlock(pos,true);
            return true;
        }
    }
    return false;
}

NetworkHandler.registerServer2ClientMessage("RedstoneWeedParticle",function(player,b){
    val world = player.world;
    val pos = b.readBlockPos();
    world.native.spawnParticle(EnumParticleTypes.REDSTONE, world.random.nextDouble()+pos.x,0.3*world.random.nextDouble()+pos.y,world.random.nextDouble()+pos.z, 0.0, 0.0, 0.0, 0.0);
});
NetworkHandler.registerServer2ClientMessage("MariredDestroy",function(player,b){
    val pos = b.readBlockPos();
    val pos0 = b.readBlockPos();
    for i in 1 to 11{
        IBotaniaFXHelper.wispFX(0.5+pos.x,0.5+pos.y,0.5+pos.z,1.0,0,0,0.2,0.05*i/10*(-pos.x+pos0.x),0,0.05*i/10*(-pos.z+pos0.z),1.0);
    }
});

mods.jei.JEI.hide(<contenttweaker:redstone_seeds>);