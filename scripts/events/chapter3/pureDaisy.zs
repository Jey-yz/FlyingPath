#reloadable
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onBlockUpdate;
import scripts.events.onItemUpdate;
import crafttweaker.player.IPlayer;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.block.IBlock;
import crafttweaker.data.IData;
import mods.zenutils.NetworkHandler;
import native.teamroots.embers.particle.ParticleUtil;

val positions as int[][] = [[-1, 0, -1],[-1, 0, 0],[-1, 0, 1],[0, 0, 1],[1, 0, 1],[1, 0, 0],[1, 0, -1],[0, 0, -1]];

onBlockUpdate.onBlockUpdate(function(world as IWorld, pos as IBlockPos)as bool{
    if(!BlockMatcher.BlockMatcher(["botania:floatingspecialflower","botania:specialflower"]).check(world,pos))return false;
    val data = world.getBlock(pos).data;
    if(isNull(data)||isNull(data.dataGet("subTileName"))||data.dataGet("subTileName")!="puredaisy")return false;
    return true;
},function(world as IWorld, pos as IBlockPos)as void{
    val data = world.getBlock(pos).data;
    if(isNull(data)||isNull(data.dataGet("subTileCmp.position")))return;
    val pos1 = positions[data.dataGet("subTileCmp.position").asInt()];
    NetworkHandler.sendToAllAround("pureDaisyParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,20,world.dimension,function(b){
        b.writeBlockPos(pos.add(pos1[0],pos1[1],pos1[2]));
    });
},false,"pureDaisy");

NetworkHandler.registerServer2ClientMessage("pureDaisyParticle",function(player,b){
    if(!onItemUpdate.isHolding(player,ItemMatcher.ItemMatcher("botania:twigwand").matcher()))return;
    val pos = b.readBlockPos();
    ParticleUtil.spawnParticleGlow(player.world,
        0.5+pos.x,0.5+pos.y,0.5+pos.z,0,0,0,
        1.0,1.0,1.0,2.5,2
    );
});