#loader mixin
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.world.World;
import native.net.minecraft.block.state.IBlockState;

#mixin Mixin
#{targets: "quaternary.incorporeal.feature.naturaldevices.block.AbstractBlockNaturalDevice"}
zenClass MixinNaturalRedstoneDevice{
    #mixin Overwrite
    function canStay(world as World, pos as BlockPos)as bool{
        return world.getBlockState(pos.down()).isTopSolid();//Same as repeater
    }
}

#mixin Mixin
#{targets: "quaternary.incorporeal.feature.naturaldevices.block.BlockNaturalDeviceCrop"}
zenClass MixinRedstoneRootCrop{
    function func_180671_f(world as World, pos as BlockPos, state as IBlockState)as bool{
        return true;
    }
}