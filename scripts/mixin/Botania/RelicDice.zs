#loader mixin
import native.net.minecraft.entity.player.EntityPlayer;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.util.ActionResult;
import native.net.minecraft.util.EnumActionResult;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.world.World;
import native.vazkii.botania.common.item.relic.ItemDice;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "vazkii.botania.common.item.relic.ItemDice"}
zenClass MixinRelicDice{

    #mixin ModifyConstant{method: "func_77659_a", constant: {stringValue: "botaniamisc.dudDiceRoll"}}
    function modifyFailMessage(key as string)as string{
        return "botaniamisc.diceRoll" as string;
    }
    
    #mixin Inject{method: "func_77659_a",at: {value: "RETURN", ordinal:1}, cancellable:true}
    function randomRelic(world as World, player as EntityPlayer, hand as EnumHand, cir as CallbackInfoReturnable)as void{
        cir.setReturnValue(ActionResult.newResult(EnumActionResult.SUCCESS,ItemDice.relicStacks[world.rand.nextInt(6)].copy()));
    }
}