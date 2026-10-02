#loader mixin
import native.com.brandon3055.draconicevolution.DEConfig;
import mixin.CallbackInfo;

#mixin Mixin
#{targets: "com.brandon3055.draconicevolution.blocks.tileentity.TileEntityDetector"}
zenClass MixinEntityDetector{
    #mixin ModifyConstant{method: "receivePacketFromClient", constant: {intValue: 1, ordinal: 2}}
    function modifyMinRange(value as int)as int{
        return 0 as int;
    }
}