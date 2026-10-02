#loader mixin
import native.net.minecraft.entity.Entity;
import native.net.minecraft.entity.EntityLiving;
import native.net.minecraft.world.World;

#mixin Mixin
#{targets: "vazkii.botania.common.entity.EntityDoppleganger"}
zenClass MixinEntityDoppleganger{
    #mixin Redirect{method: "spawnMobs", at = {value: "INVOKE", target: "net/minecraft/world/World.func_72838_d(Lnet/minecraft/entity/Entity;)Z"}}
    function tagEntity(world as World, entity as Entity) as bool {
        entity.addTag("gaiaSpawned");
        return world.spawnEntity(entity);
    }
}