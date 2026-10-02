#loader mixin
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.init.Blocks;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.world.IBlockAccess;
import native.java.util.List;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "net.minecraft.entity.monster.EntitySnowman"}
zenClass MixinSnowmanPumpkin{
    // #mixin Inject{method: "onSheared", at = {value: "HEAD"}, cancellable:true}
    // function dropPumpkin(item as ItemStack, world as IBlockAccess, pos as BlockPos, fortune as int, cir as CallbackInfoReturnable)as void{
    //     if(this0.isPumpkinEquipped()){
    //         this0.func_184747_a(false);
    //         cir.setReturnValue([ItemStack(Blocks.PUMPKIN,1,0)] as [ItemStack]);
    //     }
    // }

    #mixin Inject{method: "onSheared", at = {value: "TAIL"}, cancellable:true}
    function dropPumpkin(item as ItemStack, world as IBlockAccess, pos as BlockPos, fortune as int, cir as CallbackInfoReturnable)as void{
        cir.setReturnValue([ItemStack(Blocks.PUMPKIN,1,0)] as [ItemStack]);
    }
}