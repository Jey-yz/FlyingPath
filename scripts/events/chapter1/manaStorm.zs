#reloadable
import scripts.libs.BlockMatcher;
import crafttweaker.world.IBlockPos;
import native.net.minecraft.block.Block;
import native.vazkii.botania.common.entity.EntityManaStorm;
import native.vazkii.botania.common.block.BlockManaBomb;

events.onExplosionDetonate(function(event as crafttweaker.event.ExplosionDetonateEvent){
    if(event.world.remote)return;
    var explosion = event.explosion;
    for i in explosion.affectedBlockPositions{
        if(BlockMatcher.BlockMatcher(<botania:manabomb>).matcher()(event.world,i)){
            // (event.world.getBlock(i).native as BlockManaBomb).onBurstCollision(EntityManaBurst(event.world.native),event.world.native,i.native);
            event.world.native.playEvent(2001, i.native, Block.getStateId(<blockstate:botania:manabomb>.native));
			event.world.setBlockState(<blockstate:minecraft:air>,i);
			val storm as EntityManaStorm = EntityManaStorm(event.world.native);
			storm.setPosition(0.5+i.x, 0.5+i.y, 0.5+i.z);
			event.world.native.spawnEntity(storm);
        }
    }
});

<botania:manabomb>.addJEIDes("manabomb");