#loader mixin
import native.net.minecraft.init.Items;
import native.net.minecraft.item.ItemStack;
import native.java.util.List;

#mixin Mixin
#{targets: "sblectric.lightningcraft.recipes.LightningTransformRecipes"}
zenClass  MixinLightningTransform{

    #mixin Overwrite
    function getTransformResult(input as [ItemStack])as ItemStack{
        for ingredients, out in this0.recipeList{
            if(input.length!=ingredients.length)continue;
            var existed = [] as [ItemStack];
            for iIn in input{
                for rIn in ingredients{
                    if(ItemStack.areItemStacksEqual(rIn, iIn)){
                        var flag = 0;
                        // for e in existed{
                        //     if(ItemStack.areItemStacksEqual(rIn, e)){
                        //         flag = 1;
                        //         break;
                        //     }
                        // }
                        if(flag==0){
                            existed += rIn;
                            break;
                        }
                    }
                }
            }
            if(existed.length==ingredients.length)return out;
        }
        return ItemStack.EMPTY;
    }
}