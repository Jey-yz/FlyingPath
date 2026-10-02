#loader mixin
import mixin.CallbackInfo;

#mixin Mixin
#{targets: "vazkii.botania.common.entity.EntityManaStorm"}
zenClass MixinEntityManaStorm{
    #mixin ModifyConstant{method: spawnBurst, constant: {intValue: 120}}
    function ModifyManaAmount(value as int)as int{
        return 2000 as int;
    }
    #mixin ModifyConstant{method: spawnBurst, constant: {intValue: 340}}
    function ModifyStartMana(value as int)as int{
        return 5600 as int;
    }

    #mixin Inject{method: "func_70071_h_", at = {value: "INVOKE", target: "net/minecraft/world/World.func_72885_a(Lnet/minecraft/entity/Entity;DDDFZZ)Lnet/minecraft/world/Explosion;"}, cancellable: true}
    function removeLastExplosion(ci as CallbackInfo) as void {
        ci.cancel();
    }
}