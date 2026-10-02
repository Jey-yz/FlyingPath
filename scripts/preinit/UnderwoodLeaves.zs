#loader preinit
import native.java.util.Random;
import native.net.minecraft.init.Items;
import native.net.minecraft.block.Block;
import native.net.minecraft.block.BlockLeaves;
import native.net.minecraft.block.properties.IProperty;
import native.net.minecraft.block.properties.PropertyBool;
import native.net.minecraft.block.state.BlockStateContainer;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.world.IBlockAccess;
import native.net.minecraft.world.World;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemBlock;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.util.EnumFacing;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraftforge.event.RegistryEvent;

zenClass UnderwoodLeaves extends BlockLeaves{
    static DECAYABLE as PropertyBool = PropertyBool.create("decayable");
    static CHECK_DECAY as PropertyBool = PropertyBool.create("check_decay");

    zenConstructor(){
        super();
        super.setDefaultState(super.getDefaultState()
				.withProperty(CHECK_DECAY, true)
				.withProperty(DECAYABLE, true));
    }

    //getItemDropped
    function func_180660_a(state as IBlockState, rand as Random, fortune as int)as Item{
        return Item.getByNameOrId("minecraft:deadbush");
    }

    //createBlockState
    function func_180661_e()as BlockStateContainer{
        val properties as [IProperty] = [CHECK_DECAY, DECAYABLE] as [IProperty];
        return BlockStateContainer(this as Block, properties);
    }

    //getStateFromMeta
    function func_176203_a(meta as int) as IBlockState{
        return super.getDefaultState()
        		.withProperty(DECAYABLE, ((meta & 2) > 0))
        		.withProperty(CHECK_DECAY, ((meta & 4) > 0));
    }

    //getMetaFromState
    function func_176201_c(state as IBlockState)as int{
        var i = 0;
        if(isNull(state))return i;
        if(!isNull(state.getValue(DECAYABLE)) && (toString(state.getValue(DECAYABLE))=="true"))i= i|2;
        if(!isNull(state.getValue(CHECK_DECAY)) && (toString(state.getValue(CHECK_DECAY))=="true"))i= i|4;
        return i;
    }

    function getStateForPlacement(world as World, pos as BlockPos, facing as EnumFacing, hitx as float, hity as float, hitz as float, meta as int, player as EntityLivingBase, hand as EnumHand)as IBlockState{
        return super.getDefaultState().withProperty(DECAYABLE, false);
    }

    function onSheared(item as ItemStack, world as IBlockAccess, pos as BlockPos, fortune as int)as [ItemStack]{
        return [ItemStack(this as Block)]as [ItemStack];
    }
}

static leaves as Block = UnderwoodLeaves().setTranslationKey("lightningcraft.wood_leaves").setRegistryName("lightningcraft", "wood_leaves");
static leavesItem as ItemBlock = ItemBlock(leaves).setTranslationKey("lightningcraft.wood_leaves").setRegistryName("lightningcraft", "wood_leaves");

events.register(function(event as RegistryEvent.Register) {
    val registryName = event.name.toString();
    if (registryName == "minecraft:blocks") {
        event.registry.register(leaves);
    }else if (registryName == "minecraft:items") {
        event.registry.register(leavesItem);
    }
});
