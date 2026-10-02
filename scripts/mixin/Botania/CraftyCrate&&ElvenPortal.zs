#loader mixin
import native.net.minecraft.item.ItemStack;
import native.vazkii.botania.api.recipe.IElvenItem;

#mixin Mixin
#{targets: "vazkii.botania.common.block.tile.TileCraftCrate"}
zenClass MixinCraftCrate{

    #mixin ModifyConstant{method: "<init>", constant: {intValue: -1}}
    function ModifyDefaultPattern(value as int)as int{
        return 0 as int;
    }

}

#mixin Mixin
#{targets: "vazkii.botania.common.block.tile.TileAlfPortal"}
zenClass MixinAlfPortal{

    #mixin Redirect{method: "func_73660_a", at: {value:"INVOKE", target: "vazkii/botania/api/recipe/IElvenItem.isElvenItem(Lnet/minecraft/item/ItemStack;)Z"}}
    function AllowElvenItem(item0 as IElvenItem, item1 as ItemStack)as bool{
        return false as bool;
    }

}