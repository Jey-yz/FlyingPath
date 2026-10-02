#reloadable
import scripts.libs.BlockMatcher;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import mods.zenutils.NetworkHandler;
import mods.zenutils.CatenationPersistence;
import native.teamroots.embers.particle.ParticleUtil;

CatenationPersistence.registerPersistedCatenation("pureHallow")
    .setCatenationFactory(function(world) {
        return world.catenation()
        .repeat(10,function(builder){
            builder.run(function(w,c){
                val pos = c.getPosition();
                NetworkHandler.sendToAllAround("PureHallowParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,32,world.dimension,function(b){
                    b.writeBlockPos(pos);
                });
            });
        })
        .stopWhen(function(w,c){
            if(!BlockMatcher.BlockMatcher("contenttweaker:pure_hallow").matcher()(world,c.getPosition())){
                return true;
            }
            return false;
        })
        .run(function(w,c){
            if(BlockMatcher.BlockMatcher("contenttweaker:pure_hallow").matcher()(world,c.getPosition())){
                world.setBlockState(<blockstate:minecraft:air>,c.getPosition());
            }
        })
        .start();
    })
    .addPositionHolder()
    .register();

events.onBlockNeighborNotify(function(event as crafttweaker.event.BlockNeighborNotifyEvent){
    val world = event.world;
    if(world.remote)return;
    val pos = event.position;
    if(BlockMatcher.BlockMatcher("contenttweaker:pure_hallow").matcher()(world,pos)){
        CatenationPersistence.startPersistedCatenation("pureHallow", world)
            .withPosition(pos)
            .start();
    }
});

function getGreen(world as IWorld)as double{
    return 0.95+0.05*world.random.nextDouble();
}
function getBlue(world as IWorld)as double{
    return 0.5+0.5*world.random.nextDouble();
}

NetworkHandler.registerServer2ClientMessage("PureHallowParticle",function(player,b){
    val world = player.world;
    val pos = b.readBlockPos();
    val n = 10;
    val length = 1.0/n;
    val size = 0.6;
    for i in 0 to n+1{
        ParticleUtil.spawnParticleStar(world,length*i+pos.x,1.0+pos.y,pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,length*i+pos.x,pos.y,pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,length*i+pos.x,1.0+pos.y,1.0+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,length*i+pos.x,pos.y,1.0+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,pos.x,length*i+pos.y,pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,1.0+pos.x,length*i+pos.y,pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,pos.x,length*i+pos.y,1.0+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,1.0+pos.x,length*i+pos.y,1.0+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,pos.x,pos.y,length*i+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,1.0+pos.x,pos.y,length*i+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,pos.x,1.0+pos.y,length*i+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
        ParticleUtil.spawnParticleStar(world,1.0+pos.x,1.0+pos.y,length*i+pos.z,0,0,0,1.0,getGreen(world),getBlue(world),size,1);
    }
});