#loader mixin
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.entity.Entity;
import native.net.minecraft.entity.item.EntityItem;
import native.vazkii.botania.common.entity.EntityPoolMinecart;

#mixin Mixin
#{targets: "vazkii.botania.common.entity.EntityPoolMinecart"}
zenClass MixinPoolMinecartDrop{

    #mixin Redirect{method: "func_94095_a", at: {value:"INVOKE", target: "vazkii/botania/common/entity/EntityPoolMinecart.func_145778_a(Lnet/minecraft/item/Item;IF)Lnet/minecraft/entity/item/EntityItem;"}}
    function DropFabulousPool(minecart as EntityPoolMinecart, item as Item, size as int, offsetY as float)as EntityItem{
        return minecart.entityDropItem(ItemStack(Item.getByNameOrId("botania:pool"),1,3),0.0 as float);
    }
}