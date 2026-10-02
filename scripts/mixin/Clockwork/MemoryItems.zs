#loader mixin
import native.net.minecraft.item.ItemStack;
import native.java.util.Random;

#mixin {targets: "lumaceon.mods.clockworkphase.handler.EntityHandler"}
zenClass MixinMemoryItemDrop{
    #mixin Redirect{method:"onEntityItemDrop",at:{value:"INVOKE",target:"java/util/Random.nextInt(I)I", ordinal=0}}
    function noDrop(random as Random, max as int)as int{
        return 1;
    }
}

#mixin {targets: "lumaceon.mods.clockworkphase.item.component.base.ItemGearChronosphere"}
zenClass MixinGearChronosphere{
    #mixin Overwrite
    function getMemoryValue(is as ItemStack)as int{
        return 75;
    }
}