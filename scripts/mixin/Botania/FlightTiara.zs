#loader mixin
import native.net.minecraft.item.ItemStack;
import mixin.CallbackInfo;

#mixin Mixin
#{targets: "vazkii.botania.common.item.equipment.bauble.ItemFlightTiara"}
zenClass MixinFlightTiara{

    #mixin ModifyConstant{method: "*", constant: {intValue: 1200}}
    function LongerFlyingTime(value as int)as int{
        return 1200000 as int;
    }
    #mixin ModifyConstant{method: "*", constant: {intValue: 120}}
    function LongerFlyingTimeScaled(value as int)as int{
        return 120000 as int;
    }

    #mixin Overwrite
    function getCost(item as ItemStack, time as int)as int{
        return (time<=0)?3:1;
    }
    
}