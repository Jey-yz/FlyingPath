#reloadable
import scripts.libs.BlockMatcher;
import scripts.events.onBlockPlace;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import native.net.minecraft.util.EnumFacing;
import native.net.minecraft.util.EnumParticleTypes;
import native.net.minecraft.block.state.BlockFaceShape;
import mods.zenutils.NetworkHandler;

onBlockPlace.onBlockPlace(BlockMatcher.BlockMatcher(<blockstate:botania:altar:variant=taiga>).matcher(),
    function(world as IWorld, pos as IBlockPos, player as IPlayer)as bool{
        world.catenation()
        .repeat(2147483647,function(builder){
            builder.run(function(w,c){
                if(!c.hasData()){
                    c.data = {onFireTime:0,timeRequirement:1200+world.random.nextInt(600)};
                    return;
                }
                if(!BlockMatcher.BlockMatcher("minecraft:fire").matcher()(world,pos.add(0,-1,0)))return;
                if(!BlockMatcher.BlockMatcher("minecraft:air").matcher()(world,pos.add(0,1,0)))return;
                if(!(world.native.getBlockState(pos.add(0,2,0).native).getBlock().getBlockFaceShape(world.native, world.native.getBlockState(pos.add(0,2,0).native), pos.add(0,2,0).native, EnumFacing.DOWN)==BlockFaceShape.SOLID))return;
                if(world.random.nextInt(12)==1){
                    NetworkHandler.sendToAllAround("PetalApothecaryWaterDrip",0.5+pos.x,0.5+pos.y,0.5+pos.z,32.0,world.dimension,function(b){
                        b.writeBlockPos(pos);
                    });
                }
                c.data = c.data.dataSet((c.data.dataGet("onFireTime")??0)+1,"onFireTime");
            });
        })
        .stopWhen(function(w,c){
            if(!BlockMatcher.BlockMatcher(<blockstate:botania:altar:variant=taiga>).matcher()(world,pos)){
                return true;
            }
            if(c.hasData()){
                if((c.data.onFireTime??0).asInt()>c.data.timeRequirement.asInt()){
                    val variant as string = ["forest","plains","mountain"][world.random.nextInt(3)];
                    w.setBlockState(<blockstate:botania:altar:variant=${variant}>,world.getBlock(pos).data.dataSet(true,"hasWater"),pos);
                    return true;
                }
            }
            return false;
        })
        .start();
        return true;
    }
);

NetworkHandler.registerServer2ClientMessage("PetalApothecaryWaterDrip",function(player,b){
    val world = player.world;
    val pos = b.readBlockPos();
    world.native.spawnParticle(EnumParticleTypes.getByName("dripWater"), 0.3+pos.x+0.4*world.random.nextDouble(),2.0+pos.y,0.3+pos.z+0.4*world.random.nextDouble(),0,-0.2,0,0.2);
});

<botania:altar:7>.addJEIDes("petal_apothecary_water");