#loader mixin
#sideonly client
import native.net.minecraft.item.ItemStack;
import mixin.CallbackInfo;

#mixin Mixin
#{targets: "vazkii.botania.common.item.equipment.bauble.ItemFlightTiara"}
zenClass MixinFlightTiara{

    #mixin Static
    #mixin ModifyConstant{method: "renderHUD", constant: {intValue: 1200}}
    function LongerFlyingTime(value as int)as int{
        return 1200000 as int;
    }
    #mixin Static
    #mixin ModifyConstant{method: "renderHUD", constant: {intValue: 120}}
    function LongerFlyingTimeScaled(value as int)as int{
        return 120000 as int;
    }
    
}