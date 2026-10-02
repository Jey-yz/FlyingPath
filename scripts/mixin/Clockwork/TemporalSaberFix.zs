#loader mixin 
import native.net.minecraft.item.ItemStack;
import native.net.minecraftforge.event.entity.living.LivingAttackEvent;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.entity.player.EntityPlayer;
import native.lumaceon.mods.clockworkphase.item.construct.clockwork.ItemTemporalClockworkSaber;
import native.lumaceon.mods.clockworkphase.lib.MechanicTweaker;
import mixin.CallbackInfo;
import mixin.CallbackInfoReturnable;

#mixin {targets: "lumaceon.mods.clockworkphase.handler.EntityHandler"}
zenClass MixinTemporalSaberNuggetDrop{
    #mixin Inject{method:"onEntityAttacked",at:{value:"INVOKE",target:"net/minecraft/world/World.func_72838_d(Lnet/minecraft/entity/Entity;)Z"}}
    function removeTimeSand(event as LivingAttackEvent, ci as CallbackInfo)as void{
        val player = event.getSource().getTrueSource() as EntityPlayer;
        val saber = player.inventory.getCurrentItem().getItem() as ItemTemporalClockworkSaber;
        var amountToRemove = MechanicTweaker.TIME_SAND_PER_ENTITY_HIT;
        amountToRemove -= saber.removeTimeSandFromInventory(player.inventory, amountToRemove);
        amountToRemove -= saber.removeTimeSand(player.inventory.getCurrentItem(), amountToRemove);
        // if(amountToRemove > 0){
        //     val newItem = ItemStack(saber.getItemChangeTo());
        //     newItem.setTagCompound(player.inventory.getCurrentItem().getTagCompound());
        //     newItem.setItemDamage(player.inventory.getCurrentItem().getItemDamage());
        //     // player.inventory.setInventorySlotContents(player.inventory.currentItem as int, newItem as ItemStack);
        // }
    }
}

#mixin {targets: "lumaceon.mods.clockworkphase.item.construct.clockwork.ItemTemporalClockworkSaber"}
zenClass MixinTemporalSaberTimeSand{
    #mixin Redirect{method:"func_77644_a",at:{value:"FIELD",target:"lumaceon/mods/clockworkphase/lib/MechanicTweaker.TIME_SAND_PER_ENTITY_HIT", opcode:178}}
    function dontRemoveTimeSandHere()as int{
        return 0;
    }
}