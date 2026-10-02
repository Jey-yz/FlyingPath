#loader mixin
import native.net.minecraft.entity.player.PlayerCapabilities;

#mixin Mixin
#{targets: "moze_intel.projecte.gameObjs.items.rings.SWRG"}
zenClass MixinSWRG{
    #mixin ModifyConstant{method: "tick", constant: {intValue: 3, ordinal: 0}}
    function modifyMode3(value as int)as int{
        return 2 as int;
    }
    #mixin ModifyConstant{method: "tick", constant: {intValue: 1, ordinal: 2}}
    function modifyMode1(value as int)as int{
        return 0 as int;
    }
    #mixin ModifyConstant{method: "tick", constant: {floatValue: 0.32F, ordinal: 0}}
    function noCostWhenFlying(value as float)as float{
        return 0.0 as float;
    }
    #mixin Redirect{method: "tick", at: {value: "FIELD", target: "net/minecraft/entity/player/PlayerCapabilities.field_75101_c", opcode: 180}}
    function AlwaysUnflyable(cap as PlayerCapabilities)as bool{
        return true as bool;
    }
}