#loader preinit
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.item.ItemPickaxe;
import native.net.minecraft.item.Item.ToolMaterial;
import native.net.minecraftforge.event.RegistryEvent;
import native.net.minecraft.creativetab.CreativeTabs;
import native.net.minecraftforge.common.util.EnumHelper;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.entity.Entity;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.world.World;

zenClass DicePickaxe extends ItemPickaxe{
    zenConstructor(material as ToolMaterial){
        super(material);
    }

    //onBlockDestroyed
    function func_179218_a(stack as ItemStack, worldIn as World, state as IBlockState, pos as BlockPos, entityLiving as EntityLivingBase)as bool{
        return true;
    }

    //hitEntity
    function func_77644_a(stack as ItemStack, target as EntityLivingBase, attacker as EntityLivingBase)as bool{
        return true;
    }

}

static pickaxeMaterialDice as ToolMaterial=EnumHelper.addToolMaterial(
    "DICE",
    3,
    1024,
    20.0f,
    1.0f,
    1
);

static pickaxe as Item=DicePickaxe(pickaxeMaterialDice).setTranslationKey("contenttweaker.dice_pickaxe").setRegistryName("contenttweaker","dice_pickaxe");

events.register(function(event as RegistryEvent.Register){
    val registryName=event.name.toString();
    if(registryName == "minecraft:items"){
        event.registry.register(pickaxe);
    }
});