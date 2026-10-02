#loader preinit
import scripts.preinit.HallowiumBucketModel;
import native.java.util.Random;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.item.ItemArmor;
import native.net.minecraft.item.IItemPropertyGetter;
import native.net.minecraft.entity.Entity;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.entity.player.EntityPlayer;
import native.net.minecraft.entity.player.EntityPlayerMP;
import native.net.minecraft.inventory.EntityEquipmentSlot;
import native.net.minecraft.creativetab.CreativeTabs;
import native.net.minecraft.client.model.ModelBiped;
import native.net.minecraft.init.SoundEvents;
import native.net.minecraft.util.ActionResult;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.util.EnumFacing;
import native.net.minecraft.util.EnumActionResult;
import native.net.minecraft.util.ResourceLocation;
import native.net.minecraft.world.World;
import native.net.minecraftforge.common.util.EnumHelper;
import native.net.minecraftforge.event.RegistryEvent;

zenClass HallowiumBucket extends ItemArmor{
    zenConstructor(materialIn as ItemArmor.ArmorMaterial, renderIndexIn as int, equipmentSlotIn as EntityEquipmentSlot){
        super(materialIn, renderIndexIn, equipmentSlotIn);
        this.setCreativeTab(CreativeTabs.TOOLS);
        this.addPropertyOverride(ResourceLocation("variant"),(function(item as ItemStack, world as World, entity as EntityLivingBase)as float{
            if(item.hasTagCompound() && !isNull(item.getTagCompound().getString("mode"))){
                val mode = item.getTagCompound().getString("mode");
                if(mode=="lava")return 1.0 as float;
                if(mode=="water")return 2.0 as float;
            }
            return 0.0 as float;
        })as IItemPropertyGetter);
    }

    //This should be ClientOnly. However...let's just put it here anyway.
    function getArmorModel(entity as EntityLivingBase, stack as ItemStack, slot as EntityEquipmentSlot, original as ModelBiped)as ModelBiped{
        return HallowiumBucketModel.HallowiumBucketModel();
    }

    //onItemRightClick
    function func_77659_a(world as World, player as EntityPlayer, hand as EnumHand)as ActionResult{
        //Let's do it with crt
        val item = player.getHeldItem(hand);
        return ActionResult(EnumActionResult.SUCCESS,item);
    }

    //onUpdate
    function func_77663_a(item as ItemStack, world as World, entity as Entity, slot as int, selected as bool)as void{
        if(item.getItem()==Item.getByNameOrId("contenttweaker:hallowium_bucket")&&item.isItemDamaged()){
            item.setItemDamage(0);
        }
    }
}

static helmetMaterialHallowium as ItemArmor.ArmorMaterial=EnumHelper.addArmorMaterial(
    "HALLOWIUM",
    "hallowium",
    128,
    [1,1,1,1] as [int],
    0,
    SoundEvents.ITEM_ARMOR_EQUIP_IRON,
    0.0f
);

static bucket as Item=HallowiumBucket(helmetMaterialHallowium,0,EntityEquipmentSlot.HEAD).setTranslationKey("contenttweaker.hallowium_bucket").setRegistryName("contenttweaker","hallowium_bucket");

events.register(function(event as RegistryEvent.Register){
    val registryName=event.name.toString();
    if(registryName == "minecraft:items"){
        event.registry.register(bucket);
    }
});