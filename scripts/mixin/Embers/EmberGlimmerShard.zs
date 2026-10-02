#loader mixin
import native.net.minecraft.world.World;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.entity.player.EntityPlayer;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "teamroots.embers.item.ItemGlimmerShard"}
zenClass MixinGlimmerShard{

    #mixin ModifyConstant{method: func_180614_a, constant: {intValue: 10}}
    function HigherDurabilityCost(value as int)as int{
        return 100 as int;
    }

    #mixin Redirect{method: func_77663_a, at: {value: "INVOKE", target: "net/minecraft/world/World.func_175724_o(Lnet/minecraft/util/math/BlockPos;)F"}}
    function NoSelfRepairing(world as World, pos as BlockPos)as float{
        return 0.0 as float;
    }

    #mixin Redirect{method: func_180614_a, at = {value: "INVOKE", target: "net/minecraft/entity/player/EntityPlayer.func_184586_b(Lnet/minecraft/util/EnumHand;)Lnet/minecraft/item/ItemStack;"}}
    function NotSneaking(player as EntityPlayer, hand as EnumHand)as ItemStack{
        if(!player.isSneaking())return player.getHeldItem(hand) as ItemStack;
        return ItemStack.EMPTY as ItemStack;
    }
}