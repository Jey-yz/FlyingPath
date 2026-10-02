#loader preinit
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.item.IItemPropertyGetter;
import native.net.minecraftforge.event.RegistryEvent;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.util.ResourceLocation;
import native.net.minecraft.util.text.translation.I18n;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.world.World;

zenClass EasterEgg extends Item{
    zenConstructor(){
        super();
        this.addPropertyOverride(ResourceLocation("variant"),(function(item as ItemStack, world as World, entity as EntityLivingBase)as float{
            if(item.hasTagCompound() && !isNull(item.getTagCompound().getString("variant"))){
                val variant = item.getTagCompound().getString("variant");
                if(variant=="youyihj")return 1.0 as float;
                if(variant=="doremyswee")return 2.0 as float;
                if(variant=="raa")return 3.0 as float;
                if(variant=="darkmatterz")return 4.0 as float;
            }
            return 0.0 as float;
        })as IItemPropertyGetter);
    }

    //getItemStackDisplayName
    function func_77653_i(item as ItemStack)as string{
        var key as string = "item.contenttweaker.easter_egg.name";
        if(item.hasTagCompound() && !isNull(item.getTagCompound().getString("variant"))){
            val variant = item.getTagCompound().getString("variant");
            if(variant=="youyihj")key = "item.contenttweaker.easter_egg_1.name";
            if(variant=="doremyswee")key = "item.contenttweaker.easter_egg_2.name";
            if(variant=="raa")key = "item.contenttweaker.easter_egg_3.name";
            if(variant=="darkmatterz")key = "item.contenttweaker.easter_egg_4.name";
        }
        return I18n.translateToLocal(key).trim();
    }

}


static easter_egg as Item=EasterEgg().setTranslationKey("contenttweaker.easter_egg").setRegistryName("contenttweaker","easter_egg");

events.register(function(event as RegistryEvent.Register){
    val registryName=event.name.toString();
    if(registryName == "minecraft:items"){
        event.registry.register(easter_egg);
    }
});