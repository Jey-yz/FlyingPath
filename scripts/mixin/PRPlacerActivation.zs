#loader mixin
import native.net.minecraft.tileentity.TileEntity;
import native.mrtjp.projectred.expansion.TActiveDevice;

#mixin Mixin
#{targets: "mrtjp.projectred.expansion.TActiveDevice$class"}
zenClass MixinPRConstantlyActive{
    #mixin Static
    #mixin Redirect{method: "onNeighborBlockChange", at: {value: "INVOKE", target: "mrtjp/projectred/expansion/TActiveDevice.powered()Z"}}
    function alwaysNotPowered(machine as TActiveDevice)as bool{
        return false;
    }

    #mixin Static
    #mixin Redirect{method: "onNeighborBlockChange", at: {value: "INVOKE", target: "mrtjp/projectred/expansion/TActiveDevice.active()Z"}}
    function alwaysNotActived(machine as TActiveDevice)as bool{
        return false;
    }
}