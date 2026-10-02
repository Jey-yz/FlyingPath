#loader preinit
import native.net.minecraft.block.Block;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.block.state.BlockFaceShape;
import native.net.minecraft.block.state.BlockStateContainer;
import native.net.minecraft.block.material.Material;
import native.net.minecraft.block.properties.IProperty;
import native.net.minecraft.block.properties.PropertyBool;
import native.net.minecraft.creativetab.CreativeTabs;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.entity.item.EntityItem;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemBlock;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.world.IBlockAccess;
import native.net.minecraft.world.World;
import native.net.minecraft.util.NonNullList;
import native.net.minecraft.util.math.AxisAlignedBB;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.util.EnumFacing;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.util.BlockRenderLayer;
import native.net.minecraftforge.event.RegistryEvent;

zenClass BlockRitualDust extends Block{
    static ADVANCED as PropertyBool = PropertyBool.create("advanced");

    zenConstructor(){
        super(Material.CIRCUITS);
        super.setDefaultState(super.getDefaultState().withProperty(ADVANCED, false));
    }

    //getSubBlocks
    function func_149666_a(itemIn as CreativeTabs, items as NonNullList)as void{
        items.add(ItemStack(this as Block, 1, 0));
        items.add(ItemStack(this as Block, 1, 1));
    }

    //getItem
    function func_185473_a(world as World, pos as BlockPos, state as IBlockState)as ItemStack{
        var meta as int = 0;
        if(!isNull(state.getValue(ADVANCED)) && (toString(state.getValue(ADVANCED))=="true"))meta = 1;
        return ItemStack(this as Block, 1 ,meta);
    }

    //getStateFromMeta
    function func_176203_a(meta as int) as IBlockState{
        return super.getDefaultState().withProperty(ADVANCED, (meta==1));
    }

    //getMetaFromState
    function func_176201_c(state as IBlockState)as int{
        var i = 0;
        if(isNull(state))return i;
        if(!isNull(state.getValue(ADVANCED)) && (toString(state.getValue(ADVANCED))=="true"))i= i|1;
        return i;
    }

    //createBlockState
    function func_180661_e()as BlockStateContainer{
        val properties as [IProperty] = [ADVANCED] as [IProperty];
        return BlockStateContainer(this as Block, properties);
    }

    //damageDropped
    function func_180651_a(state as IBlockState)as int{
        return func_176201_c(state);
    }

    //getBoundingBox
    function func_185496_a(state as IBlockState, source as IBlockAccess, pos as BlockPos)as AxisAlignedBB{
        return AxisAlignedBB(0.0, 0.0, 0.0, 1.0, 0.0625, 1.0);
    }

    //getCollisionBoundingBox
    function func_180646_a(state as IBlockState, source as IBlockAccess, pos as BlockPos)as AxisAlignedBB{
        return AxisAlignedBB(0.0, 0.0, 0.0, 1.0, 0.0, 1.0);
    }

    //isOpaqueCube
    function func_149662_c(state as IBlockState)as bool{
        return false;
    }

    //isFullBlock
    function func_149686_d(state as IBlockState)as bool{
        return false;
    }

    //getBlockLayer
    function func_180664_k()as BlockRenderLayer{
        return BlockRenderLayer.TRANSLUCENT;
    }

    //canPlaceBlockAt
    function func_176196_c(world as World, pos as BlockPos)as bool{
        val downState = world.getBlockState(pos.down());
        if(Block.isEqualTo(Block.getBlockFromName("contenttweaker:demon_core"),downState.getBlock()))return false;
        return downState.isTopSolid() || downState.getBlockFaceShape(world, pos.down(), EnumFacing.UP) == BlockFaceShape.SOLID;
    }

    //isTranslucent
    function func_149751_l(state as IBlockState)as bool{
        return true;
    }

    //getBlockFaceShape
    function func_193383_a(world as IBlockAccess,state as IBlockState, pos as BlockPos, face as EnumFacing)as BlockFaceShape{
        return BlockFaceShape.UNDEFINED;
    }

    // neighborChanged
    function func_189540_a(state as IBlockState, world as World, pos as BlockPos, block as Block, fromPos as BlockPos)as void{
        if (!world.isRemote)
        {
            if (!this.func_176196_c(world, pos))
            {
                world.destroyBlock(pos,true);
            }
        }
    }
}

zenClass ItemRitualDust extends ItemBlock{
    zenConstructor(block as Block){
        super(block);
        this.setHasSubtypes(true);
    }

    //getUnlocalizedName
    function func_77667_c(item as ItemStack)as string{
        if(item.getMetadata()==1)return "item.contenttweaker.ritual_dust.advanced";
        return "item.contenttweaker.ritual_dust.normal";
    }

    //getMetadata
    function func_77647_b(meta as int)as int{
        if(meta>1)return 0;
        return meta;
    }
}

static dust as Block = BlockRitualDust().setTranslationKey("contenttweaker.ritual_dust").setRegistryName("contenttweaker", "ritual_dust");
dust.setCreativeTab(CreativeTabs.MISC);
static dustItem as ItemBlock = ItemRitualDust(dust).setRegistryName("contenttweaker", "ritual_dust");

events.register(function(event as RegistryEvent.Register) {
    val registryName = event.name.toString();
    if (registryName == "minecraft:blocks") {
        event.registry.register(dust);
    }else if (registryName == "minecraft:items") {
        event.registry.register(dustItem);
    }
});
