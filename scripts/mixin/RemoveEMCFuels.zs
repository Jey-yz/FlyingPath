#loader mixin
import native.net.minecraft.item.ItemStack;

#mixin Mixin
#{targets: "moze_intel.projecte.emc.FuelMapper"}
zenClass MixinEMCFuelMap{
    #mixin Static
    #mixin Redirect{method: "loadMap", at: {value: "INVOKE", target: "moze_intel/projecte/emc/FuelMapper.addToMap(Lnet/minecraft/item/ItemStack;)V", ordinal=2}}
    function removeRedstoneBlock(item as ItemStack)as void{
        // NO-OP
    }

    #mixin Static
    #mixin Redirect{method: "loadMap", at: {value: "INVOKE", target: "moze_intel/projecte/emc/FuelMapper.addToMap(Lnet/minecraft/item/ItemStack;)V", ordinal=4}}
    function removeCoalBlock(item as ItemStack)as void{
        // NO-OP
    }
}